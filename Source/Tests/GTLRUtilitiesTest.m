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

#import "GTLRUtilities.h"

@interface GTLRUtilitiesTest : XCTestCase
@end

@implementation GTLRUtilitiesTest

- (void)testEnsureNSNumber {
  NSNumber *num;
  NSNumber *result;

  // Give it a number, get the same thing back
  num = @12;
  result = GTLR_EnsureNSNumber(num);
  XCTAssertEqualObjects(result, num);
  XCTAssertEqual(result, num);

  // Give it a string, and it converts...
  num = @0;
  result = GTLR_EnsureNSNumber((NSNumber*)@"");
  XCTAssertEqualObjects(result, num);

  num = @0;
  result = GTLR_EnsureNSNumber((NSNumber*)@"0");
  XCTAssertEqualObjects(result, num);

  num = @1000.01;
  result = GTLR_EnsureNSNumber((NSNumber*)@"1000.01");
  XCTAssertEqualObjects(result, num);

  num = @-1000.01;
  result = GTLR_EnsureNSNumber((NSNumber*)@"-1000.01");
  XCTAssertEqualObjects(result, num);

  // Check the values of the NSNumber objects created from strings.
  result = GTLR_EnsureNSNumber((NSNumber*)@"1");
  XCTAssertEqual([result longLongValue], 1LL);

  result = GTLR_EnsureNSNumber((NSNumber*)@"-1");
  XCTAssertEqual([result longLongValue], -1LL);

  result = GTLR_EnsureNSNumber((NSNumber*)@"71100000000007780");
  XCTAssertEqual([result longLongValue], 71100000000007780LL);

  result = GTLR_EnsureNSNumber((NSNumber*)@"-71100000000007780");
  XCTAssertEqual([result longLongValue], -71100000000007780LL);

  NSString *ullongmaxStr = [@(ULLONG_MAX) stringValue];
  result = GTLR_EnsureNSNumber((NSNumber*)ullongmaxStr);
  XCTAssertEqual([result unsignedLongLongValue], ULLONG_MAX);

  NSString *llongminStr = [@(LLONG_MIN) stringValue];
  result = GTLR_EnsureNSNumber((NSNumber*)llongminStr);
  XCTAssertEqual([result longLongValue], LLONG_MIN);
}

@end
