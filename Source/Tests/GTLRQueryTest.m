/* Copyright (c) 2011 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <XCTest/XCTest.h>

#import <objc/runtime.h>

#import "GTLRQuery.h"

// Custom subclass for testing the property handling.
@interface GTLRTestingQuery : GTLRQuery
@property(copy) NSString *userId;
@property(copy) NSString *msgId;
@property(copy) NSString *alt;
@property(copy) NSString *qS;
@property(assign) NSUInteger maxResults;
@property(assign) NSInteger aNumber;
@property(assign) long long aLongLong;
@property(assign) unsigned long long aULongLong;
@property(assign) float cost;
@property(assign) double minValue;
@property(assign) BOOL preferred;
@property(retain) NSArray<NSString *> *arrayString;
@property(retain) NSArray<NSNumber *> *arrayNumber;
@property(retain) NSArray<GTLRDateTime *> *arrayDate;
@end

@implementation GTLRTestingQuery
@dynamic userId, msgId, alt, qS, maxResults, aNumber, aLongLong, aULongLong;
@dynamic cost, minValue, preferred, arrayString, arrayNumber, arrayDate;
+ (NSDictionary *)parameterNameMap {
  return @{ @"userId": @"user-id",
            @"qS": @"q.s",  // Test parameter names with '.' to be safe.
            @"maxResults": @"max_results" };
}
+ (NSDictionary *)arrayPropertyToClassMap {
  return @{ @"arrayString": [NSString class],
            @"arrayNumber": [NSNumber class],
            @"arrayDate": [GTLRDateTime class] };
}
@end

@interface GTLRTestingQueryWithPrimeKey : GTLRTestingQuery
@property(copy) NSString *altPrime;
@end

@implementation GTLRTestingQueryWithPrimeKey
@dynamic altPrime;
@end

@interface GTLRQueryTest : XCTestCase
@end

@implementation GTLRQueryTest

- (void)testBasics {
  GTLRTestingQuery *query;

  query = [[GTLRTestingQuery alloc] initWithPathURITemplate:@""
                                                 HTTPMethod:@"POST"
                                         pathParameterNames:@[ @"baz" ]];
  XCTAssertNil(query, @"empty URI template");

  query = [[GTLRTestingQuery alloc] initWithPathURITemplate:@"foo/bar/{baz}"
                                                 HTTPMethod:@"POST"
                                         pathParameterNames:@[ @"baz" ]];
  XCTAssertNotNil(query, @"failed to make query");

  NSMutableDictionary *expected;

  // test query parameter-setting/getting

  query.userId = @"test user";
  query.msgId = @"12345";
  expected = [NSMutableDictionary dictionaryWithObjectsAndKeys:
              @"test user", @"user-id",
              @"12345", @"msgId",
              nil];
  XCTAssertEqualObjects(query.JSON, expected);

  query.alt = @"simple";
  expected[@"alt"] = @"simple";
  XCTAssertEqualObjects(query.JSON, expected);

  query.qS = @"foo bar baz";
  expected[@"q.s"] = @"foo bar baz";
  XCTAssertEqualObjects(query.JSON, expected);

  query.maxResults = 15;
  expected[@"max_results"] = @15U;
  XCTAssertEqualObjects(query.JSON, expected);
  XCTAssertEqual(query.maxResults, (NSUInteger)15);

  query.aNumber = -10;
  expected[@"aNumber"] = @-10;
  XCTAssertEqualObjects(query.JSON, expected);
  XCTAssertEqual(query.aNumber, (NSInteger)-10);

  query.aLongLong = -1000000000;
  expected[@"aLongLong"] = @-1000000000LL;
  XCTAssertEqualObjects(query.JSON, expected);
  XCTAssertEqual(query.aLongLong, (long long)-1000000000);

  query.aULongLong = 1000000000;
  expected[@"aULongLong"] = @1000000000ULL;
  XCTAssertEqualObjects(query.JSON, expected);
#if __LP64__
  // For reasons I can't currently explain, this fails in 32bit release only.
  // Debug 32bit passes.  So it has to be something about how things expand
  // and compiler settings.
  XCTAssertEqual((unsigned long long)query.aULongLong, (unsigned long long)1000000000);
#endif

  query.cost = 123.4f;
  expected[@"cost"] = @123.4f;
  XCTAssertEqualObjects(query.JSON, expected);
  XCTAssertEqualWithAccuracy(query.cost, 123.4f, 0.001);

  query.minValue = 20.0;
  expected[@"minValue"] = @20.0;
  XCTAssertEqualObjects(query.JSON, expected);
  XCTAssertEqualWithAccuracy(query.minValue, 20.0, 0.001);

  query.preferred = YES;
  expected[@"preferred"] = @YES;
  XCTAssertEqualObjects(query.JSON, expected);
  XCTAssertTrue(query.preferred);

  // test setting array of basic types

  // string
  query.arrayString = @[@"foo bar"];
  expected[@"arrayString"] = @[@"foo bar"];
  XCTAssertEqualObjects(query.JSON, expected);

  // number
  query.arrayNumber = @[@1234];
  expected[@"arrayNumber"] = @[@1234];
  XCTAssertEqualObjects(query.JSON, expected);

  // date
  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  query.arrayDate = @[ [GTLRDateTime dateTimeWithRFC3339String:dateStr] ];
  expected[@"arrayDate"] = @[dateStr];
  XCTAssertEqualObjects(query.JSON, expected);
}

- (void)testParameterNameSubStrings {
  // We had a bug where if there were two properties, one a proper substring
  // of the other, we'd match wrong.  This test makes sure we don't regress
  // that.

  GTLRTestingQueryWithPrimeKey *obj =
  [[GTLRTestingQueryWithPrimeKey alloc] initWithPathURITemplate:@"foo/bar"
                                                     HTTPMethod:nil
                                             pathParameterNames:nil];
  XCTAssertNotNil(obj, @"failed to make query");

  // Test lookup for a setter.

  obj.alt = @"for base class";
  obj.altPrime = @"for subclass";
  NSDictionary *expected = @{ @"alt": @"for base class",
                              @"altPrime": @"for subclass" };
  XCTAssertEqualObjects(obj.JSON, expected);

  // Test lookup for a getter.

  XCTAssertEqualObjects(obj.alt, @"for base class");
  XCTAssertEqualObjects(obj.altPrime, @"for subclass");
}


@end
