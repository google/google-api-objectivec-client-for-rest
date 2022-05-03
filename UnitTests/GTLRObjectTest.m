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

#if SWIFT_PACKAGE
@import GoogleAPIClientForRESTCore;
#else
#import "GTLRObject.h"
#import "GTLRBatchResult.h"
#import "GTLRDateTime.h"
#import "GTLRDuration.h"
#import "GTLRErrorObject.h"
#endif

@interface GTLRObject (ExposedForTesting)
- (NSString *)JSONDescription;
@end

// Custom subclass for testing the property handling.
@class GTLRTestingObject;
@interface GTLRTestingObject : GTLRObject
// Basic types
@property(nonatomic, copy) NSString *aStr;
@property(nonatomic, copy) NSString *str2;
@property(nonatomic, copy) NSString *identifier;
@property(nonatomic, retain) NSNumber *aNum;
@property(nonatomic, retain) NSNumber *aBool;
@property(nonatomic, retain) GTLRDateTime *aDate;
@property(nonatomic, retain) GTLRDateTime *date2;
@property(nonatomic, retain) GTLRDuration *aDuration;
@property(nonatomic, retain) GTLRDuration *duration2;
// Object
@property(nonatomic, retain) GTLRTestingObject *child;
// Anything
@property(nonatomic, retain) id anything;
// Arrays
@property(nonatomic, retain) NSArray<NSString *> *arrayString;
@property(nonatomic, retain) NSArray<NSNumber *> *arrayNumber;
@property(nonatomic, retain) NSArray<NSNumber *> *arrayBool;
@property(nonatomic, retain) NSArray<GTLRDateTime *> *arrayDate;
@property(nonatomic, retain) NSArray<GTLRDuration *> *arrayDuration;
@property(nonatomic, retain) NSArray<GTLRTestingObject *> *arrayKids;
@property(nonatomic, retain) NSArray *arrayAnything;
// Use of getter= for Xcode 5's ARC treatment of init*.
@property(nonatomic, retain, getter=valueOf_initFoo) NSNumber *initFoo;
@end

@implementation GTLRTestingObject
@dynamic aStr, str2, identifier, aNum, aBool, aDate, date2, aDuration, duration2, child, anything;
@dynamic arrayString, arrayNumber, arrayBool, arrayDate, arrayDuration, arrayKids, arrayAnything;
@dynamic initFoo;
+ (NSDictionary *)propertyToJSONKeyMap {
  // Use the name mapping on a few...
  return @{ @"aStr" : @"a_str",
            @"aNum" : @"a.num",  // Test property names with '.' to be safe.
            @"aBool" : @"a_bool",
            @"aDate" : @"a_date",
            @"aDuration" : @"a_duration" };
}
+ (NSDictionary *)arrayPropertyToClassMap {
  return @{ @"arrayString" : [NSString class],
            @"arrayNumber" : [NSNumber class],
            @"arrayBool" : [NSNumber class],
            @"arrayDate" : [GTLRDateTime class],
            @"arrayDuration" : [GTLRDuration class],
            @"arrayKids" : [GTLRTestingObject class],
            @"arrayAnything" : [NSObject class] };
}
@end

@interface GTLRTestingObjectWithPrimeKey : GTLRTestingObject
@property(nonatomic, copy) NSString *str2Prime;
@end

@implementation GTLRTestingObjectWithPrimeKey
@dynamic str2Prime;
@end

@interface GTLRTestingCollection : GTLRCollectionObject
@property(nonatomic, retain) NSArray<GTLRTestingObject *> *items;  // of GTLRTestingObject
@end

@implementation GTLRTestingCollection
@dynamic items;
@end

// Subclass we can change the default type for additonal properies to make
// testing easier.
@interface GTLRTestingAdditionalPropertiesObject : GTLRObject
+ (void)setAdditionalPropsClass:(Class)aClass;
@end

@implementation GTLRTestingAdditionalPropertiesObject
static Class gAdditionalPropsClass = Nil;
+ (void)setAdditionalPropsClass:(Class)aClass {
  gAdditionalPropsClass = aClass;
}
// Override the call needed by GTLRObject subclasses and return the class
// currently being tested.
+ (Class)classForAdditionalProperties {
  return gAdditionalPropsClass;
}
@end

@interface GTLRTestingResultArray : GTLRResultArray
@property(nonatomic, retain, readonly) NSArray<GTLRTestingObject *> *items;
@end

@implementation GTLRTestingResultArray
- (NSArray *)items {
  return [self itemsWithItemClass:[GTLRTestingObject class]];
}
@end

@interface GTLRTestingResultArray2 : GTLRResultArray
@property(nonatomic, retain, readonly) NSArray<NSString *> *items;
@end

@implementation GTLRTestingResultArray2
- (NSArray *)items {
  return [self itemsWithItemClass:[NSString class]];
}
@end

@interface GTLRObjectTest : XCTestCase
@end

@implementation GTLRObjectTest

- (NSMutableDictionary *)objectWithString:(NSString *)jsonStr error:(NSError **)error {
  // Convert the string to NSData, and the data to a JSON dictionary.
  NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
  NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingMutableContainers
                                                                error:error];
  return dict;
}

- (void)testCreation {
  GTLRTestingObject *obj;

  obj = [GTLRTestingObject object];
  XCTAssertNotNil(obj);

  obj = [GTLRTestingObject objectWithJSON:nil];
  XCTAssertNotNil(obj);

  obj = [GTLRTestingObject objectWithJSON:[NSMutableDictionary dictionary]];
  XCTAssertNotNil(obj);
}

- (void)testCopy {
  BOOL (^canCopyAsPlist)(NSDictionary *) = ^(NSDictionary *json) {
    CFPropertyListRef ref = CFPropertyListCreateDeepCopy(kCFAllocatorDefault,
                                                         (__bridge CFPropertyListRef)(json),
                                                         kCFPropertyListMutableContainers);
    BOOL canCopy = (ref != nil);
    if (ref) CFRelease(ref);
    return canCopy;
  };

  // Test an empty object.
  GTLRTestingObject *obj;
  GTLRTestingObject *dupe;

  obj = [GTLRTestingObject object];
  dupe = [obj copy];
  XCTAssertTrue(dupe != obj);
  XCTAssertNil(dupe.JSON);

  // Test an object representable as a plist.
  NSString *jsonStr = @"{\"a_date\":\"2011-01-14T15:00:00Z\",\"a.num\":1234}";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr error:&err];
  XCTAssertEqual(json.count, 2U);
  XCTAssertTrue(canCopyAsPlist(json));

  obj = [GTLRTestingObject objectWithJSON:json];
  obj.userProperties = @{ @"fish" : @"bass" };
  dupe = [obj copy];
  XCTAssertTrue(dupe != obj);
  XCTAssertTrue(dupe.JSON != obj.JSON);
  XCTAssertEqualObjects(dupe.JSON, json);
  XCTAssertNil(dupe.userProperties);  // userProperties are not copied.

  // Test an object not representable as a plist (due to a null).
  jsonStr = @"{\"a_date\":\"2011-01-14T15:00:00Z\",\"a.num\":null}";
  json = [self objectWithString:jsonStr error:&err];
  XCTAssertEqual(json.count, 2U);
  XCTAssertFalse(canCopyAsPlist(json), @"CFPropertyListCreateDeepCopy can now copy NSNull;"
                 @" perhaps DeepMutableCopyOfJSONDictionary can be simplified");

  obj = [GTLRTestingObject objectWithJSON:json];
  obj.userProperties = @{ @"fish" : @"bass" };
  dupe = [obj copy];
  XCTAssertTrue(dupe != obj);
  XCTAssertTrue(dupe.JSON != obj.JSON);
  XCTAssertEqualObjects(dupe.JSON, json);
  XCTAssertNil(dupe.userProperties);  // userProperties are not copied.

  // Test a sub object.
  jsonStr = @"{\"a_date\":\"2011-01-14T15:00:00Z\",\"child\":{\"a.num\":1234}}";
  json = [self objectWithString:jsonStr error:&err];
  XCTAssertEqual(json.count, 2U);
  XCTAssertTrue(canCopyAsPlist(json));

  obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj.child);
  obj.child.userProperties = @{ @"fish" : @"bass" };
  dupe = [obj copy];
  XCTAssertTrue(dupe != obj);
  XCTAssertTrue(dupe.JSON != obj.JSON);
  XCTAssertEqualObjects(dupe.JSON, json);
  XCTAssertNotNil(dupe.child);
  XCTAssertTrue(dupe.child != obj.child);
  XCTAssertTrue(dupe.child.JSON != obj.child.JSON);
  XCTAssertEqualObjects(dupe.JSON, json);
  XCTAssertNil(dupe.child.userProperties);  // userProperties are not copied.

  // Test a sub object not representable as a plist (due to a null).
  jsonStr = @"{\"a_date\":\"2011-01-14T15:00:00Z\",\"child\":{\"a.num\":null}}";
  json = [self objectWithString:jsonStr error:&err];
  XCTAssertEqual(json.count, 2U);
  XCTAssertFalse(canCopyAsPlist(json));

  obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj.child);
  obj.child.userProperties = @{ @"fish" : @"bass" };
  dupe = [obj copy];
  XCTAssertTrue(dupe != obj);
  XCTAssertTrue(dupe.JSON != obj.JSON);
  XCTAssertEqualObjects(dupe.JSON, json);
  XCTAssertNotNil(dupe.child);
  XCTAssertTrue(dupe.child != obj.child);
  XCTAssertTrue(dupe.child.JSON != obj.child.JSON);
  XCTAssertEqualObjects(dupe.JSON, json);
  XCTAssertNil(dupe.child.userProperties);  // userProperties are not copied.
}

#pragma mark Getters and Setters

- (void)testSetBasicTypes {
  GTLRTestingObject *obj = [GTLRTestingObject object];
  XCTAssertNotNil(obj);
  NSMutableDictionary *expected;

  // test setting basic types

  // string
  obj.aStr = @"foo bar";
  obj.str2 = @"mumble";
  expected = [@{ @"a_str" : @"foo bar",
                  @"str2" : @"mumble" } mutableCopy];
  XCTAssertEqualObjects(obj.JSON, expected);

  // number
  obj.aNum = @1234;
  expected[@"a.num"] = @1234;
  XCTAssertEqualObjects(obj.JSON, expected);

  // number
  obj.aBool = @YES;
  expected[@"a_bool"] = @YES;
  XCTAssertEqualObjects(obj.JSON, expected);

  // date
  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  obj.aDate = [GTLRDateTime dateTimeWithRFC3339String:dateStr];
  expected[@"a_date"] = dateStr;
  XCTAssertEqualObjects(obj.JSON, expected);

  // google-duration
  NSString * const durationStr = @"123.100s";
  obj.aDuration = [GTLRDuration durationWithJSONString:durationStr];
  expected[@"a_duration"] = durationStr;
  XCTAssertEqualObjects(obj.JSON, expected);
}

- (GTLRTestingObject *)objectFromRoundTripArchiveDearchiveWithObject:(GTLRTestingObject *)obj {
  if (@available(macOS 10.13, iOS 11.0, tvOS 11.0, *)) {
    NSError *err;
    NSData *data =
        [NSKeyedArchiver archivedDataWithRootObject:obj
                              requiringSecureCoding:YES
                                              error:&err];
    XCTAssertNil(err);
    GTLRTestingObject *obj2 =
        [NSKeyedUnarchiver unarchivedObjectOfClass:[obj class]
                                          fromData:data
                                             error:&err];
    XCTAssertNil(err);
    return obj2;
  } else {
    XCTFail("use a newer test device");
    return nil;
  }
}

- (void)testSecureCodingEmptyObject {
  GTLRTestingObject *obj = [GTLRTestingObject object];
  XCTAssertNotNil(obj);
  XCTAssertNil(obj.JSON);

  GTLRTestingObject *obj2 = [self objectFromRoundTripArchiveDearchiveWithObject:obj];
  XCTAssertNotNil(obj2);

  XCTAssertEqualObjects(obj2.JSON, obj.JSON);
  XCTAssertNotEqual(obj2, obj);
  XCTAssertNil(obj2.JSON);
}

- (void)testSecureCoding {
  NSString * const jsonStr =
      @"{\"a_date\":\"2011-01-14T15:00:00Z\",\"a.num\":1234,\"a_str\":\"foo bar\","
      @"\"arrayString\":null}";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNotNil(json);
  GTLRTestingObject *obj = [GTLRTestingObject objectWithJSON:json];
  obj.userProperties = @{ @"A" : @1 };
  XCTAssertNotNil(obj);
  XCTAssertEqual((id)obj.arrayString, (id)[NSNull null]); // pointer comparision

  GTLRTestingObject *obj2 = [self objectFromRoundTripArchiveDearchiveWithObject:obj];
  XCTAssertNotNil(obj2);

  XCTAssertEqualObjects(obj2.JSON, obj.JSON);
  XCTAssertNotEqual(obj2.JSON, obj.JSON);
  XCTAssertNil(obj2.userProperties);  // userProperties are not encoded.
  XCTAssert([obj2.JSON isKindOfClass:[NSMutableDictionary class]]);
  XCTAssertEqual((id)obj2.arrayString, (id)[NSNull null]); // pointer comparision
}

- (void)testSecureCodingMutability {
  NSString * const jsonStr =
      @"{\"arrayDate\":[\"2011-01-14T15:00:00Z\"],\"arrayNumber\":[1234],\"arrayBool\":[true],\""
      @"arrayString\":[\"foo bar\"],\"arrayAnything\":[789]}";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNotNil(json);

  GTLRTestingObject *obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  GTLRTestingObject *child = [GTLRTestingObject object];
  child.aStr = @"I'm a kid";

  GTLRTestingObject *grandchild = [GTLRTestingObject object];
  grandchild.aStr = @"I'm a grandchild";
  child.arrayKids = @[ grandchild ];

  obj.arrayKids = @[ child ];

  GTLRTestingObject *obj2 = [self objectFromRoundTripArchiveDearchiveWithObject:obj];
  XCTAssertNotNil(obj2);

  XCTAssertEqualObjects(obj2.arrayString, @[ @"foo bar" ]);
  XCTAssertEqualObjects(obj2.arrayNumber, @[ @1234 ]);
  XCTAssertEqualObjects(obj2.arrayBool, @[ @YES ]);
  XCTAssertEqualObjects(obj2.arrayAnything, @[ @789 ]);
  XCTAssertEqualObjects(obj2.arrayKids, @[ child ]);
  XCTAssertEqualObjects(obj2.arrayKids[0].arrayKids, @[ grandchild ]);

  XCTAssertTrue([obj2.arrayDate isKindOfClass:[NSMutableArray class]]);
  XCTAssertTrue([obj2.arrayString isKindOfClass:[NSMutableArray class]]);
  XCTAssertTrue([obj2.arrayNumber isKindOfClass:[NSMutableArray class]]);
  XCTAssertTrue([obj2.arrayBool isKindOfClass:[NSMutableArray class]]);
  XCTAssertTrue([obj2.arrayAnything isKindOfClass:[NSMutableArray class]]);
  XCTAssertTrue([obj2.arrayKids isKindOfClass:[NSMutableArray class]]);
  XCTAssertTrue([obj2.arrayKids[0].arrayKids isKindOfClass:[NSMutableArray class]]);

  XCTAssertTrue([obj2.JSON isKindOfClass:[NSMutableDictionary class]]);
  XCTAssertTrue([obj2.arrayKids[0].JSON isKindOfClass:[NSMutableDictionary class]]);
  XCTAssertTrue([obj2.arrayKids[0].arrayKids[0].JSON isKindOfClass:[NSMutableDictionary class]]);
}

- (void)testGetBasicTypes {
  NSString * const jsonStr =
    @"{\"a_date\":\"2011-01-14T15:00:00Z\",\"a_duration\":\"123.000s\",\"a.num\":1234,\"a_bool\":true,\"a_str\":\"foo bar\"}";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  GTLRTestingObject *obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  // test getting basic types

  // string
  XCTAssertEqualObjects(obj.aStr, @"foo bar");
  XCTAssertNil(obj.str2);

  // number
  XCTAssertEqualObjects(obj.aNum, @1234);

  // bool
  XCTAssertEqualObjects(obj.aBool, @YES);

  // date
  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  XCTAssertEqualObjects(obj.aDate,
                       [GTLRDateTime dateTimeWithRFC3339String:dateStr]);
  XCTAssertNil(obj.date2, @"unexpected dateTime: %@", obj.date2);

  // google-duration
  NSString * const durationStr = @"123.000s";
  XCTAssertEqualObjects(obj.aDuration,
                        [GTLRDuration durationWithJSONString:durationStr]);
  XCTAssertNil(obj.duration2, @"unexpected duration: %@", obj.duration2);
}

- (void)testSetArrayBasicTypes {
  GTLRTestingObject *obj = [GTLRTestingObject object];
  XCTAssertNotNil(obj);
  NSMutableDictionary *expected = [NSMutableDictionary dictionary];

  // test setting array of basic types

  // string
  obj.arrayString = @[ @"foo bar" ];
  expected[@"arrayString"] = @[ @"foo bar" ];
  XCTAssertEqualObjects(obj.JSON, expected);

  // number
  obj.arrayNumber = @[ @1234 ];
  expected[@"arrayNumber"] = @[ @1234 ];
  XCTAssertEqualObjects(obj.JSON, expected);

  // bool
  obj.arrayBool = @[ @YES ];
  expected[@"arrayBool"] = @[ @YES ];
  XCTAssertEqualObjects(obj.JSON, expected);

  // date
  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  GTLRDateTime *dateTime = [GTLRDateTime dateTimeWithRFC3339String:dateStr];
  obj.arrayDate = @[ dateTime ];
  expected[@"arrayDate"] = @[ dateStr ];
  XCTAssertEqualObjects(obj.JSON, expected);

  // google-duration
  NSString * const durationStr = @"456.789s";
  GTLRDuration *duration = [GTLRDuration durationWithJSONString:durationStr];
  obj.arrayDuration = @[ duration ];
  expected[@"arrayDuration"] = @[ durationStr ];
  XCTAssertEqualObjects(obj.JSON, expected);
}

- (void)testGetArrayBasicTypes {
  NSString * const jsonStr =
    @"{\"arrayDate\":[\"2011-01-14T15:00:00Z\"],\"arrayDuration\":[\"234.678s\"],\"arrayNumber\":[1234],\"arrayBool\":[true],\"arrayString\":[\"foo bar\"]}";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  GTLRTestingObject *obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  // test getting basic types

  // string
  XCTAssertEqualObjects(obj.arrayString, @[ @"foo bar" ]);

  // number
  XCTAssertEqualObjects(obj.arrayNumber, @[ @1234 ]);

  // number
  XCTAssertEqualObjects(obj.arrayBool, @[ @YES ]);

  // date
  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  GTLRDateTime *dateTime = [GTLRDateTime dateTimeWithRFC3339String:dateStr];
  XCTAssertEqualObjects(obj.arrayDate, @[ dateTime ]);

  // google-duration
  NSString * const durationStr = @"234.678s";
  GTLRDuration *duration = [GTLRDuration durationWithJSONString:durationStr];
  XCTAssertEqualObjects(obj.arrayDuration, @[ duration ]);
}

- (void)testSetAnyTypeProperty {
  GTLRTestingObject *obj = [GTLRTestingObject object];
  XCTAssertNotNil(obj);
  NSMutableDictionary *expected = [NSMutableDictionary dictionary];

  NSString *anythingStr = @"as string";
  NSNumber *anythingNumber = @9876;
  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  GTLRDateTime *anythingDate = [GTLRDateTime dateTimeWithRFC3339String:dateStr];
  NSString * const durationStr = @"234.567s";
  GTLRDuration *anythingDuration = [GTLRDuration durationWithJSONString:durationStr];
  NSArray *anythingArray = @[ @"array of string" ];

  // string

  obj.anything = anythingStr;
  expected[@"anything"] = anythingStr;
  XCTAssertEqualObjects(obj.JSON, expected);

  // number

  obj.anything = anythingNumber;
  expected[@"anything"] = anythingNumber;
  XCTAssertEqualObjects(obj.JSON, expected);

  // date

  obj.anything = anythingDate;
  expected[@"anything"] = dateStr;
  XCTAssertEqualObjects(obj.JSON, expected);

  // google-duration

  obj.anything = anythingDuration;
  expected[@"anything"] = durationStr;
  XCTAssertEqualObjects(obj.JSON, expected);

  // GTLRObject support tested in the SubObjectSupport test.

  // array (just test of string as plumbing is generic)

  obj.anything = anythingArray;
  expected[@"anything"] = anythingArray;
  XCTAssertEqualObjects(obj.JSON, expected);
}

- (void)testGetAnyPropertyType {
  NSError *err = nil;
  NSMutableDictionary *json;
  GTLRTestingObject *obj;

  NSString * const jsonStrAnyString =
    @"{\"anything\":\"as string\"}";
  NSString * const jsonStrAnyNumber =
    @"{\"anything\":9876}";
  NSString * const jsonStrAnyDate =
    @"{\"anything\":\"2011-01-14T15:00:00Z\"}";
  NSString * const jsonStrAnyArray =
    @"{\"anything\":[\"array of string\"]}";

  // string

  json = [self objectWithString:jsonStrAnyString
                          error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  XCTAssertEqualObjects(obj.anything, @"as string");

  // number

  json = [self objectWithString:jsonStrAnyNumber
                          error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  XCTAssertEqualObjects(obj.anything, @9876);

  // date (there is nothing in the JSON to know it's a date, so it comes
  // back as a string.

  json = [self objectWithString:jsonStrAnyDate
                          error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  XCTAssertEqualObjects(obj.anything, dateStr);

  // GTLRObject support tested in the SubObjectSupport test.

  // array (just test of string as plumbing is generic)

  json = [self objectWithString:jsonStrAnyArray
                          error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  XCTAssertEqualObjects(obj.anything, @[ @"array of string" ]);
}

- (void)testSetArrayAnyTypeProperty {
  GTLRTestingObject *obj = [GTLRTestingObject object];
  XCTAssertNotNil(obj);
  NSMutableDictionary *expected = [NSMutableDictionary dictionary];

  NSArray *arrayAnythingStr = @[ @"as string" ];
  NSArray *arrayAnythingNumber = @[ @9876 ];
  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  GTLRDateTime *dateTime = [GTLRDateTime dateTimeWithRFC3339String:dateStr];
  NSArray *arrayAnythingDate = @[ dateTime ];
  NSString * const durationStr = @"369.963s";
  GTLRDuration *duration = [GTLRDuration durationWithJSONString:durationStr];
  NSArray *arrayAnythingDuration = @[ duration ];

  // string

  obj.arrayAnything = arrayAnythingStr;
  expected[@"arrayAnything"] = arrayAnythingStr;
  XCTAssertEqualObjects(obj.JSON, expected);

  // number

  obj.arrayAnything = arrayAnythingNumber;
  expected[@"arrayAnything"] = arrayAnythingNumber;
  XCTAssertEqualObjects(obj.JSON, expected);

  // date

  obj.arrayAnything = arrayAnythingDate;
  expected[@"arrayAnything"] = @[ dateStr ];
  XCTAssertEqualObjects(obj.JSON, expected);

  // google-duration

  obj.arrayAnything = arrayAnythingDuration;
  expected[@"arrayAnything"] = @[ durationStr ];
  XCTAssertEqualObjects(obj.JSON, expected);

  // GTLRObject support tested in the ArraySubObjectSupport test.
}

- (void)testGetArrayAnyPropertyType {
  NSError *err = nil;
  NSMutableDictionary *json;
  GTLRTestingObject *obj;

  NSString * const jsonStrArrayAnyString =
    @"{\"anything\":[\"as string\"]}";
  NSString * const jsonStrArrayAnyNumber =
    @"{\"anything\":[9876]}";
  NSString * const jsonStrArrayAnyDate =
    @"{\"anything\":[\"2011-01-14T15:00:00Z\"]}";
  NSString * const jsonStrArrayAnyDuration =
    @"{\"anything\":[\"111.222s\"]}";

  // string

  json = [self objectWithString:jsonStrArrayAnyString
                          error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  XCTAssertEqualObjects(obj.anything, @[ @"as string" ]);

  // number

  json = [self objectWithString:jsonStrArrayAnyNumber
                          error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  XCTAssertEqualObjects(obj.anything, @[ @9876 ]);

  // date (there is nothing in the JSON to know it's a date, so it comes
  // back as a string.

  json = [self objectWithString:jsonStrArrayAnyDate
                          error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  XCTAssertEqualObjects(obj.anything, @[ dateStr ]);

  // google-duration (there is nothing in the JSON to know it's a
  // google-duration, so it comes back as a string.

  json = [self objectWithString:jsonStrArrayAnyDuration
                          error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  NSString * const durationStr = @"111.222s";
  XCTAssertEqualObjects(obj.anything, @[ durationStr ]);

  // GTLRObject support tested in the ArraySubObjectSupport test.
}

- (void)testSubObjectSupport {

  // test sub (child) objects

  GTLRTestingObject *obj = [GTLRTestingObject object];
  XCTAssertNotNil(obj);
  GTLRTestingObject *child = [GTLRTestingObject object];
  XCTAssertNotNil(child);
  GTLRTestingObject *child2 = [GTLRTestingObject object];
  XCTAssertNotNil(child2);

  child.aStr = @"I'm the kid";
  child2.aStr = @"I'm the any kid";
  obj.child = child;
  obj.anything = child2;
  XCTAssertNotNil(obj.child);

  NSString *jsonStr = obj.JSONString;
  XCTAssertNotNil(jsonStr);
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  GTLRTestingObject *obj2 = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj2);

  // object matches (including kids)
  XCTAssertEqualObjects(obj, obj2);
  XCTAssertEqualObjects(obj.JSON, obj2.JSON);

  // new object also has kids
  XCTAssertNotNil(obj2.child);
  XCTAssertNotNil(obj2.anything);

  // kids match and wasn't same pointer
  XCTAssertTrue(obj2.child != child);
  XCTAssertEqualObjects(obj2.child, child);
  XCTAssertTrue(obj2.anything != child2);
  XCTAssertEqualObjects(obj2.anything, child2);
}

- (void)testNestedSetters {
  // ensure that adding an empty object to an empty object doesn't leave the
  // internal JSON tree unbuilt
  GTLRTestingObject *obj = [GTLRTestingObject object];

  obj.child = [GTLRTestingObject object];
  obj.child.child = [GTLRTestingObject object];
  obj.child.child.aStr = @"froglegs";

  NSMutableDictionary *json = obj.JSON;
  XCTAssertNotNil(json);

  GTLRTestingObject *obj2 = [GTLRTestingObject objectWithJSON:json];
  XCTAssertEqualObjects(obj2.child.child.aStr, @"froglegs");

  // ensure that the internal JSON tree is built even when adding to an
  // object of ambiguous type
  obj = [GTLRTestingObject object];

  obj2 = [GTLRTestingObject object];
  obj.anything = obj2;
  obj2.child = [GTLRTestingObject object];
  obj2.child.aStr = @"froglegs";

  json = obj.JSON;
  XCTAssertNotNil(json);
}

- (void)testArraySubObjectSupport {

  // test array of sub (child) objects

  GTLRTestingObject *obj = [GTLRTestingObject object];
  XCTAssertNotNil(obj);
  GTLRTestingObject *child = [GTLRTestingObject object];
  XCTAssertNotNil(child);
  GTLRTestingObject *child2 = [GTLRTestingObject object];
  XCTAssertNotNil(child2);

  child.aStr = @"I'm a kid";
  child2.aStr = @"I'm a any kid";
  obj.arrayKids = @[ child ];
  obj.arrayAnything = @[ child2 ];

  NSString *jsonStr = obj.JSONString;
  XCTAssertNotNil(jsonStr);
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  GTLRTestingObject *obj2 = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj2);

  // object matches (including kids)
  XCTAssertEqualObjects(obj, obj2);
  XCTAssertEqualObjects(obj.JSON, obj2.JSON);

  // new object also has kids
  XCTAssertNotNil(obj2.arrayKids);
  XCTAssertNotNil(obj2.arrayAnything);

  // kids match and wasn't same pointer
  XCTAssertTrue(obj2.arrayKids[0] != child);
  XCTAssertEqualObjects(obj2.arrayKids[0], child);
  XCTAssertTrue(obj2.arrayAnything[0] != child2);
  XCTAssertEqualObjects(obj2.arrayAnything[0], child2);
}

- (void)testPropertyNameSubStrings {
  // We had a bug where if there were two properties, one a proper substring
  // of the other, we'd match wrong.  This test makes sure we don't regress
  // that.

  GTLRTestingObjectWithPrimeKey *obj = [GTLRTestingObjectWithPrimeKey object];

  // Test lookup for a setter.

  XCTAssertNotNil(obj);
  obj.str2 = @"for base class";
  obj.str2Prime = @"for subclass";
  NSDictionary *expected = [@{ @"str2" : @"for base class",
                               @"str2Prime" : @"for subclass" } mutableCopy];
  XCTAssertEqualObjects(obj.JSON, expected);

  // Test lookup for a getter.

  XCTAssertEqualObjects(obj.str2, @"for base class");
  XCTAssertEqualObjects(obj.str2Prime, @"for subclass");
}

- (void)testSetArrayOfArrayOfDotDotDot {
  GTLRTestingObject *obj = [GTLRTestingObject object];
  XCTAssertNotNil(obj);
  NSMutableDictionary *expected = [NSMutableDictionary dictionary];

  // test setting arrays of arrays of...

  obj.arrayString = (id)@[ @[ @"foo" ] ];
  expected[@"arrayString"] = @[ @[ @"foo" ] ];
  XCTAssertEqualObjects(obj.JSON, expected);

  obj.arrayNumber = (id)@[ @[ @[ @987 ] ] ];
  expected[@"arrayNumber"] = @[ @[ @[ @987 ] ] ];
  XCTAssertEqualObjects(obj.JSON, expected);

  obj.arrayBool = (id)@[ @[ @[ @YES ] ] ];
  expected[@"arrayBool"] = @[ @[ @[ @YES ] ] ];
  XCTAssertEqualObjects(obj.JSON, expected);

  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  GTLRDateTime *dateTime = [GTLRDateTime dateTimeWithRFC3339String:dateStr];
  obj.arrayDate = @[ @[ dateTime ] ];
  expected[@"arrayDate"] = @[ @[ dateStr ] ];
  XCTAssertEqualObjects(obj.JSON, expected);

  NSString * const durationStr = @"123.456s";
  GTLRDuration *duration = [GTLRDuration durationWithJSONString:durationStr];
  obj.arrayDuration = @[ @[ duration ] ];
  expected[@"arrayDuration"] = @[ @[ durationStr ] ];
  XCTAssertEqualObjects(obj.JSON, expected);

  GTLRTestingObject *child = [GTLRTestingObject object];
  XCTAssertNotNil(child);
  child.aStr = @"I'm a kid";

  obj.arrayKids = @[ @[ child ] ];
  NSMutableDictionary *childJSON = child.JSON;
  expected[@"arrayKids"] = @[ @[ childJSON ] ];
  XCTAssertEqualObjects(obj.JSON, expected);

  // Array of anything as a string.
  obj.arrayAnything = @[ @[ @"a string" ] ];
  expected[@"arrayAnything"] = @[ @[ @"a string" ] ];
  XCTAssertEqualObjects(obj.JSON, expected);

  GTLRTestingObject *child2 = [GTLRTestingObject object];
  XCTAssertNotNil(child2);
  child2.aStr = @"I'm a any kid";

  // Array of anything as an object.
  obj.arrayAnything = @[ @[ child2 ] ];
  NSMutableDictionary *child2JSON = child2.JSON;
  expected[@"arrayAnything"] = @[ @[ child2JSON ] ];
  XCTAssertEqualObjects(obj.JSON, expected);
}

- (void)testGetArrayOfArrayOfDotDotDot {
  NSString * const jsonStr =
    @"{\"arrayString\" : [[\"foo\"]],"
    @" \"arrayNumber\" : [[[987]]],"
    @" \"arrayBool\" : [[[true]]],"
    @" \"arrayDate\" : [[\"2011-01-14T15:00:00Z\"]],"
    @" \"arrayDuration\" : [[\"987.654s\"]],"
    @" \"arrayKids\" : [[{\"a_str\" : \"I'm a kid\"}]],"
    @" \"arrayAnything\" : [[\"a string\"]]"
    @"}";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNil(err, @"got error parsing: %@", err);
  XCTAssertNotNil(json);

  GTLRTestingObject *obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  // test getting arrays of arrays of...

  XCTAssertEqualObjects(obj.arrayString, @[ @[ @"foo" ] ],
                        @"array of array of string");

  XCTAssertEqualObjects(obj.arrayNumber, @[ @[ @[ @987 ] ] ],
                        @"array of array of array of number");

  XCTAssertEqualObjects(obj.arrayBool, @[ @[ @[ @YES ] ] ],
                        @"array of array of array of number(bool)");

  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  GTLRDateTime *dateTime = [GTLRDateTime dateTimeWithRFC3339String:dateStr];
  XCTAssertEqualObjects(obj.arrayDate,
                        @[ @[ dateTime ] ],
                        @"array of array of datetime");

  NSString *const durationStr = @"987.654s";
  GTLRDuration *duration = [GTLRDuration durationWithJSONString:durationStr];
  XCTAssertEqualObjects(obj.arrayDuration,
                        @[ @[ duration ] ],
                        @"array of array of duration");

  // Kid in array of array.
  NSArray *aArray = obj.arrayKids;
  XCTAssertEqual(aArray.count, (NSUInteger)1);
  aArray = aArray[0];
  XCTAssertEqual(aArray.count, (NSUInteger)1);
  GTLRTestingObject *child = aArray[0];
  XCTAssertEqualObjects(child.aStr, @"I'm a kid");

  // Anything (string) in array of array.
  XCTAssertEqualObjects(obj.arrayAnything,
                       @[ @[ @"a string" ] ],
                       @"array of array of anything as string");

  // anything (kid) in array of array.

  NSString * const jsonStr2 =
    @"{\"arrayAnything\" : [[{\"a_str\" : \"I'm a any kid\"}]]}";
  err = nil;
  json = [self objectWithString:jsonStr2 error:&err];
  XCTAssertNil(err, @"got error parsing: %@", err);
  XCTAssertNotNil(json);
  obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  aArray = obj.arrayAnything;
  XCTAssertEqual(aArray.count, (NSUInteger)1);
  aArray = aArray[0];
  XCTAssertEqual(aArray.count, (NSUInteger)1);
  // Test doesn't use kinds, so this comes in as a generic object.
  GTLRObject *anyChild = aArray[0];
  XCTAssertEqualObjects([anyChild additionalPropertyForName:@"a_str"],
                       @"I'm a any kid");
}

- (void)testInitFoo {

  // Set/Get it.
  GTLRTestingObject *obj = [GTLRTestingObject object];
  XCTAssertNotNil(obj);
  obj.initFoo = @7;
  NSDictionary *expected = @{ @"initFoo" : @7 };
  XCTAssertEqualObjects(obj.JSON, expected);
  XCTAssertEqualObjects(obj.initFoo, @7);

  // Decode from string and get it.
  NSString * const jsonStr = @"{\"initFoo\":1234}";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  obj = [GTLRTestingObject objectWithJSON:json];
  XCTAssertNotNil(obj);
  XCTAssertEqualObjects(obj.initFoo, @1234);
}

- (void)testJSONString {
  // Test an obect with nil JSON.
  GTLRTestingObject *obj = [GTLRTestingObject object];
  XCTAssertEqualObjects(obj.JSONString, @"");

  // Test an object with valid JSON.
  obj.aStr = @"catbird";
  NSString *expected = @"{\n  \"a_str\" : \"catbird\"\n}";
  XCTAssertEqualObjects(obj.JSONString, expected);
}

#pragma mark Additional Properties

- (void)testSetAdditionalPropertiesBasicTypes {
  GTLRTestingAdditionalPropertiesObject *obj =
    [GTLRTestingAdditionalPropertiesObject object];
  XCTAssertNotNil(obj);
  NSMutableDictionary *expected;

  // test setting basic types

  // string
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[NSString class]];
  [obj setAdditionalProperty:@"foo bar" forName:@"ap1"];
  expected = [@{ @"ap1" : @"foo bar" } mutableCopy];
  XCTAssertEqualObjects(obj.JSON, expected);

  // number
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[NSNumber class]];
  [obj setAdditionalProperty:@987
                     forName:@"ap2"];
  expected[@"ap2"] = @987;
  XCTAssertEqualObjects(obj.JSON, expected);

  // date
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[GTLRDateTime class]];
  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  GTLRDateTime *dateTime = [GTLRDateTime dateTimeWithRFC3339String:dateStr];
  [obj setAdditionalProperty:dateTime
                     forName:@"ap3"];
  expected[@"ap3"] = dateStr;
  XCTAssertEqualObjects(obj.JSON, expected);

  // google-duration
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[GTLRDuration class]];
  NSString * const durationStr = @"876.543s";
  GTLRDuration *duration = [GTLRDuration durationWithJSONString:durationStr];
  [obj setAdditionalProperty:duration
                     forName:@"ap4"];
  expected[@"ap4"] = durationStr;
  XCTAssertEqualObjects(obj.JSON, expected);
}

- (void)testGetAdditionalPropertiesBasicTypes {
  NSString * const jsonStr =
    @"{\"ap4\":\"765.432s\",\"ap3\":\"2011-01-14T15:00:00Z\",\"ap2\":1234,\"ap1\":\"foo bar\"}";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  GTLRTestingAdditionalPropertiesObject *obj =
      [GTLRTestingAdditionalPropertiesObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  // test getting basic types

  // string
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[NSString class]];
  XCTAssertEqualObjects([obj additionalPropertyForName:@"ap1"],
                       @"foo bar");

  // number
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[NSNumber class]];
  XCTAssertEqualObjects([obj additionalPropertyForName:@"ap2"],
                       @1234);

  // date
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[GTLRDateTime class]];
  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  XCTAssertEqualObjects([obj additionalPropertyForName:@"ap3"],
                        [GTLRDateTime dateTimeWithRFC3339String:dateStr]);

  // google-duration
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[GTLRDuration class]];
  NSString * const durationStr = @"765.432s";
  XCTAssertEqualObjects([obj additionalPropertyForName:@"ap4"],
                        [GTLRDuration durationWithJSONString:durationStr]);
}

- (void)testSetAdditionalPropertiesObject {
  GTLRTestingAdditionalPropertiesObject *obj =
    [GTLRTestingAdditionalPropertiesObject object];
  XCTAssertNotNil(obj);
  NSMutableDictionary *expected;

  GTLRTestingObject *child = [GTLRTestingObject object];
  XCTAssertNotNil(child);

  child.aStr = @"I'm a kid";

  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[GTLRTestingObject class]];
  [obj setAdditionalProperty:child forName:@"aKid"];
  NSMutableDictionary *childJSON = child.JSON;
  expected = [@{ @"aKid" : childJSON } mutableCopy];
  XCTAssertEqualObjects(obj.JSON, expected);
}

- (void)testGetAdditionalPropertiesObject {
  NSString * const jsonStr =
    @"{\"aKid\":{ \"a_str\": \"I'm a kid\" } }";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  GTLRTestingAdditionalPropertiesObject *obj =
      [GTLRTestingAdditionalPropertiesObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[GTLRTestingObject class]];
  GTLRTestingObject *child = [obj additionalPropertyForName:@"aKid"];
  XCTAssertNotNil(child);
  XCTAssertTrue([child isKindOfClass:[GTLRTestingObject class]]);
  XCTAssertEqualObjects(child.aStr, @"I'm a kid");
}

- (void)testSetAdditionalPropertiesAnything {
  GTLRTestingAdditionalPropertiesObject *obj =
    [GTLRTestingAdditionalPropertiesObject object];
  XCTAssertNotNil(obj);
  NSMutableDictionary *expected;

  // test setting when it can be anything
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[NSObject class]];

  // string
  [obj setAdditionalProperty:@"foo bar" forName:@"ap1"];
  expected = [@{ @"ap1": @"foo bar" } mutableCopy];
  XCTAssertEqualObjects(obj.JSON, expected);

  // number
  [obj setAdditionalProperty:@987
                     forName:@"ap2"];
  expected[@"ap2"] = @987;
  XCTAssertEqualObjects(obj.JSON, expected);

  // date
  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  GTLRDateTime *dateTime = [GTLRDateTime dateTimeWithRFC3339String:dateStr];
  [obj setAdditionalProperty:dateTime
                     forName:@"ap3"];
  expected[@"ap3"] = dateStr;
  XCTAssertEqualObjects(obj.JSON, expected);

  // google-duration
  NSString * const durationStr = @"876.543s";
  GTLRDuration *duration = [GTLRDuration durationWithJSONString:durationStr];
  [obj setAdditionalProperty:duration
                     forName:@"ap4"];
  expected[@"ap4"] = durationStr;
  XCTAssertEqualObjects(obj.JSON, expected);

  // object
  GTLRTestingObject *child = [GTLRTestingObject object];
  XCTAssertNotNil(child);

  child.aStr = @"I'm a kid";

  [obj setAdditionalProperty:child forName:@"aKid"];
  expected[@"aKid"] = child.JSON;
  XCTAssertEqualObjects(obj.JSON, expected);
}

- (void)testGetAdditionalPropertiesAnything {
  NSString * const jsonStr =
    @"{\"ap3\":\"2011-01-14T15:00:00Z\",\"ap2\":1234,\"ap1\":\"foo bar\", \"aKid\":{ \"a_str\": \"I'm a kid\" } }";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  GTLRTestingAdditionalPropertiesObject *obj =
      [GTLRTestingAdditionalPropertiesObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  // test getting when it can be anything
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[NSObject class]];

  // string
  XCTAssertEqualObjects([obj additionalPropertyForName:@"ap1"],
                       @"foo bar");

  // number
  XCTAssertEqualObjects([obj additionalPropertyForName:@"ap2"],
                       @1234);

  // date - just get the string back, nothing tells it to conver to a date.
  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  XCTAssertEqualObjects([obj additionalPropertyForName:@"ap3"],
                       dateStr);

  GTLRObject *child = [obj additionalPropertyForName:@"aKid"];
  XCTAssertNotNil(child);
  XCTAssertTrue([child isMemberOfClass:[GTLRObject class]]);
  XCTAssertEqualObjects([child additionalPropertyForName:@"a_str"],
                       @"I'm a kid");
}

- (void)testSetAdditionalPropertiesArraysOfBasicTypes {
  GTLRTestingAdditionalPropertiesObject *obj =
    [GTLRTestingAdditionalPropertiesObject object];
  XCTAssertNotNil(obj);
  NSMutableDictionary *expected;

  // test setting arrays of basic types

  // string
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[NSString class]];
  [obj setAdditionalProperty:@[ @"foo bar" ]
                     forName:@"apArray1"];
  expected = [@{ @"apArray1": @[ @"foo bar" ] } mutableCopy];
  XCTAssertEqualObjects(obj.JSON, expected);

  // number
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[NSNumber class]];
  [obj setAdditionalProperty:@[ @987 ]
                     forName:@"apArray2"];
  expected[@"apArray2"] = @[ @987 ];
  XCTAssertEqualObjects(obj.JSON, expected);

  // date
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[GTLRDateTime class]];
  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  GTLRDateTime *dateTime = [GTLRDateTime dateTimeWithRFC3339String:dateStr];
  [obj setAdditionalProperty:@[ dateTime ] forName:@"apArray3"];
  expected[@"apArray3"] = @[ dateStr ];
  XCTAssertEqualObjects(obj.JSON, expected);

  // google-duration
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[GTLRDuration class]];
  NSString * const durationStr = @"246.800s";
  GTLRDuration *duration = [GTLRDuration durationWithJSONString:durationStr];
  [obj setAdditionalProperty:@[ duration ]
                     forName:@"apArray4"];
  expected[@"apArray4"] = @[ durationStr ];
  XCTAssertEqualObjects(obj.JSON, expected);
}

- (void)testGetAdditionalPropertiesArraysOfBasicTypes {
  NSString * const jsonStr =
    @"{\"apArray4\":[\"135.975s\"],\"apArray3\":[\"2011-01-14T15:00:00Z\"],\"apArray2\":[1234],\"apArray1\":[\"foo bar\"]}";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  GTLRTestingAdditionalPropertiesObject *obj =
      [GTLRTestingAdditionalPropertiesObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  // test getting arrays of basic types

  // string
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[NSString class]];
  XCTAssertEqualObjects([obj additionalPropertyForName:@"apArray1"],
                       @[ @"foo bar" ]);

  // number
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[NSNumber class]];
  XCTAssertEqualObjects([obj additionalPropertyForName:@"apArray2"],
                       @[ @1234 ]);

  // date
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[GTLRDateTime class]];
  NSString * const dateStr = @"2011-01-14T15:00:00Z";
  GTLRDateTime *dateTime = [GTLRDateTime dateTimeWithRFC3339String:dateStr];
  XCTAssertEqualObjects([obj additionalPropertyForName:@"apArray3"], @[ dateTime ]);

  // google-duration
  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[GTLRDuration class]];
  NSString * const durationStr = @"135.975s";
  GTLRDuration *duration = [GTLRDuration durationWithJSONString:durationStr];
  XCTAssertEqualObjects([obj additionalPropertyForName:@"apArray4"], @[ duration ]);
}

- (void)testSetAdditionalPropertiesArraysOfObject {
  GTLRTestingAdditionalPropertiesObject *obj =
    [GTLRTestingAdditionalPropertiesObject object];
  XCTAssertNotNil(obj);
  NSMutableDictionary *expected;

  GTLRTestingObject *child = [GTLRTestingObject object];
  XCTAssertNotNil(child);

  child.aStr = @"I'm a kid";

  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[GTLRTestingObject class]];
  [obj setAdditionalProperty:@[ child ]
                     forName:@"aKidArray"];
  NSMutableDictionary *childJSON = child.JSON;
  expected = [@{ @"aKidArray": @[ childJSON ] } mutableCopy];
  XCTAssertEqualObjects(obj.JSON, expected);
}

- (void)testGetAdditionalPropertiesArraysOfObject {
  NSString * const jsonStr =
    @"{\"aKidArray\":[ { \"a_str\": \"I'm a kid\" } ] }";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  GTLRTestingAdditionalPropertiesObject *obj =
      [GTLRTestingAdditionalPropertiesObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[GTLRTestingObject class]];
  NSArray *kidArray = [obj additionalPropertyForName:@"aKidArray"];
  XCTAssertNotNil(kidArray);
  XCTAssertTrue([kidArray isKindOfClass:[NSArray class]]);
  XCTAssertEqual(kidArray.count, (NSUInteger)1);

  GTLRTestingObject *child = kidArray[0];
  XCTAssertNotNil(child);
  XCTAssertTrue([child isKindOfClass:[GTLRTestingObject class]]);
  XCTAssertEqualObjects(child.aStr, @"I'm a kid");
}

- (void)testSetAdditionalPropertiesArraysOfArrayOfDotDotDot {
  GTLRTestingAdditionalPropertiesObject *obj =
    [GTLRTestingAdditionalPropertiesObject object];
  XCTAssertNotNil(obj);
  NSMutableDictionary *expected;

  // test setting arrays of arrays of...

  // NOTE: We only test with strings, because at this point the plumbing no
  // matter what type the property is.

  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[NSString class]];

  [obj setAdditionalProperty:@[ @[ @"foo" ] ]
                     forName:@"apArray1"];
  expected = [@{ @"apArray1": @[ @[ @"foo" ] ] } mutableCopy];
  XCTAssertEqualObjects(obj.JSON, expected);

  [obj setAdditionalProperty:@[ @[ @[ @"bar" ] ] ]
                     forName:@"apArray2"];
  expected[@"apArray2"] = @[ @[ @[ @"bar" ] ] ];
  XCTAssertEqualObjects(obj.JSON, expected);
}

- (void)testGetAdditionalPropertiesArraysOfArraysOfDotDotDot {
  NSString * const jsonStr =
    @"{\"apArray2\":[[[\"bar\"]]],\"apArray1\":[[\"foo\"]]}";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  GTLRTestingAdditionalPropertiesObject *obj =
      [GTLRTestingAdditionalPropertiesObject objectWithJSON:json];
  XCTAssertNotNil(obj);

  // test getting arrays of arrays of...

  // NOTE: We only test with strings, because at this point the plumbing no
  // matter what type the property is.

  [GTLRTestingAdditionalPropertiesObject setAdditionalPropsClass:[NSString class]];
  XCTAssertEqualObjects([obj additionalPropertyForName:@"apArray1"],
                       @[ @[ @"foo" ] ],
                       @"array of array of string");

  XCTAssertEqualObjects([obj additionalPropertyForName:@"apArray2"],
                       @[ @[ @[ @"bar" ] ] ],
                       @"array of array of array of string");
}

#pragma mark Partial

- (GTLRTestingObject *)objectForPartialTests {
  // This helper method returns a new instance of a reasonably complex
  // object for testing fields and patch
  GTLRTestingObject *obj = [GTLRTestingObject object];

  // Object hierarchy
  obj.aStr = @"green";
  obj.aNum = @123;
  obj.aDate = [GTLRDateTime dateTimeWithRFC3339String:@"2011-05-04T23:28:20.888Z"];
  obj.aDuration = [GTLRDuration durationWithJSONString:@"123.000s"];
  // Nested child object
  obj.child = [GTLRTestingObject object];
  obj.child.child = [GTLRTestingObject object];
  obj.child.child.aStr = @"blue-gold";
  // Array of objects
  GTLRTestingObject *a1 = [GTLRTestingObject object];
  a1.aStr = @"yellow-gold-aqua";
  a1.child = [GTLRTestingObject object];
  a1.child.str2 = @"brown";
  a1.str2 = @"yellow-gold-indigo";
  GTLRTestingObject *a2 = [GTLRTestingObject object];
  a2.aStr = @"yellow-gold";
  obj.child.child.arrayKids = @[ a1, a2 ];
  // Arrays of basic types
  obj.child.child.arrayString = @[ @"cat", @"dog" ];
  obj.child.child.arrayNumber = @[ @111, @222 ];
  return obj;
}

- (void)testFieldsDescription {
  // Empty object
  GTLRTestingObject *obj = [GTLRTestingObject object];
  NSString *fields = [obj fieldsDescription];
  XCTAssertEqualObjects(fields, @"");

  // Object hierarchy
  obj = [self objectForPartialTests];

  fields = [obj fieldsDescription];
  NSString *expected = @"a.num,a_date,a_duration,a_str,"
    @"child/child/a_str,"
    @"child/child/arrayKids(a_str,child/str2,str2),"
    @"child/child/arrayNumber,"
    @"child/child/arrayString";
  XCTAssertEqualObjects(fields, expected);
}

- (void)testPatchObjectGeneration {
  GTLRTestingObject *obj1 = [GTLRTestingObject object];
  GTLRTestingObject *obj2 = [GTLRTestingObject object];

  GTLRTestingObject *resultObj = [obj1 patchObjectFromOriginal:obj2];
  XCTAssertNil(resultObj);

  // Compare the testing object to an empty object; everything should be
  // marked for deletion (with NSNull)
  obj1 = [self objectForPartialTests];
  obj2 = [GTLRTestingObject object];
  resultObj = [obj2 patchObjectFromOriginal:obj1];

  NSDictionary *expected = @{ @"a_str" : [NSNull null],
                              @"a_date" : [NSNull null],
                              @"a_duration" : [NSNull null],
                              @"a.num" : [NSNull null],
                              @"child" : [NSNull null] };
  XCTAssertEqualObjects(resultObj.JSON, expected);

  // Reverse: compare an empty object to the testing object,
  // and everything should be added
  resultObj = [obj1 patchObjectFromOriginal:obj2];

  expected = obj1.JSON;
  XCTAssertEqualObjects(resultObj.JSON, expected);

  // Equal objects should return a nil result
  obj1 = [self objectForPartialTests];
  obj2 = [self objectForPartialTests];
  resultObj = [obj1 patchObjectFromOriginal:obj2];
  XCTAssertNil(resultObj);

  // Selectively add, change, and remove fields
  obj1 = [self objectForPartialTests];
  obj2 = [self objectForPartialTests];

  obj1.aNum = @9.5f;
  obj1.aStr = nil;
  obj1.str2 = @"raven";
  resultObj = [obj1 patchObjectFromOriginal:obj2];
  expected = @{ @"a.num" : @9.5f,
                @"a_str" : [NSNull null],
                @"str2" : @"raven" };

  XCTAssertEqualObjects(resultObj.JSON, expected);

  // Reverse the comparison direction
  resultObj = [obj2 patchObjectFromOriginal:obj1];
  expected = @{ @"a.num" : @123.0f,
                @"a_str" : @"green",
                @"str2" : [NSNull null] };
  XCTAssertEqualObjects(resultObj.JSON, expected);

  // Change the array of strings; we'll expect the patch to be only the new
  // array
  obj1 = [self objectForPartialTests];
  obj2 = [self objectForPartialTests];

  obj1.child.child.arrayString = @[ @"monkey" ];

  resultObj = [obj1 patchObjectFromOriginal:obj2];

  GTLRTestingObject *expectedObj = [GTLRTestingObject object];
  expectedObj.child = [GTLRTestingObject object];
  expectedObj.child.child = [GTLRTestingObject object];
  expectedObj.child.child.arrayString = @[ @"monkey" ];

  XCTAssertEqualObjects(resultObj.JSON, expectedObj.JSON);

  // Change the array of child objects by omitting the second child;
  // the result should be only an array with the first child
  obj1 = [self objectForPartialTests];
  obj2 = [self objectForPartialTests];

  GTLRObject *firstKid = obj1.child.child.arrayKids[0];
  obj1.child.child.arrayKids = @[ firstKid ];

  resultObj = [obj1 patchObjectFromOriginal:obj2];

  expectedObj = [GTLRTestingObject object];
  expectedObj.child = [GTLRTestingObject object];
  expectedObj.child.child = [GTLRTestingObject object];
  expectedObj.child.child.arrayKids = @[ firstKid ];

  XCTAssertEqualObjects(resultObj.JSON, expectedObj.JSON);
}

- (void)testNullPatchValues {
  // Ensure that we can set and get nulls for use with patch
  GTLRTestingObject *obj = [GTLRTestingObject object];
  obj.aStr = [GTLRObject nullValue];
  obj.str2 = [GTLRObject nullValue];
  obj.aNum = [GTLRObject nullValue];
  obj.aDate = [GTLRObject nullValue];
  obj.child = [GTLRObject nullValue];
  obj.arrayString = [GTLRObject nullValue];
  obj.arrayNumber = [GTLRObject nullValue];
  obj.arrayDate = [GTLRObject nullValue];
  obj.arrayKids = [GTLRObject nullValue];
  obj.arrayAnything = [GTLRObject nullValue];

  XCTAssertEqualObjects(obj.aStr, [NSNull null]);
  XCTAssertEqualObjects(obj.str2, [NSNull null]);
  XCTAssertEqualObjects(obj.aNum, [NSNull null]);
  XCTAssertEqualObjects(obj.aDate, [NSNull null]);
  XCTAssertEqualObjects(obj.child, [NSNull null]);
  XCTAssertEqualObjects(obj.arrayString, [NSNull null]);
  XCTAssertEqualObjects(obj.arrayNumber, [NSNull null]);
  XCTAssertEqualObjects(obj.arrayDate, [NSNull null]);
  XCTAssertEqualObjects(obj.arrayKids, [NSNull null]);
  XCTAssertEqualObjects(obj.arrayAnything, [NSNull null]);

  NSError *error = nil;
  NSString *jsonStr = obj.JSONString;

  XCTAssertNil(error);
  NSMutableDictionary *jsonDict = [self objectWithString:jsonStr
                                                   error:&error];
  XCTAssertNil(error);

  GTLRTestingObject *obj2 = [GTLRTestingObject objectWithJSON:jsonDict];

  XCTAssertEqualObjects(obj2.aStr, [NSNull null]);
  XCTAssertEqualObjects(obj2.str2, [NSNull null]);
  XCTAssertEqualObjects(obj2.aNum, [NSNull null]);
  XCTAssertEqualObjects(obj2.aDate, [NSNull null]);
  XCTAssertEqualObjects(obj2.child, [NSNull null]);
  XCTAssertEqualObjects(obj2.arrayString, [NSNull null]);
  XCTAssertEqualObjects(obj2.arrayNumber, [NSNull null]);
  XCTAssertEqualObjects(obj2.arrayDate, [NSNull null]);
  XCTAssertEqualObjects(obj2.arrayKids, [NSNull null]);
  XCTAssertEqualObjects(obj2.arrayAnything, [NSNull null]);
}

#pragma mark GTLRCollectionObject

- (void)testCollection {
  GTLRTestingCollection *collection = [GTLRTestingCollection object];

  // Test enumeration and subscripts on empty collection.
  for (id foundItem in collection) {
    XCTFail(@"Unexpected: %@", foundItem);
  }
  XCTAssertThrows(collection[0]);

  // Put two items in the collection.
  GTLRTestingObject *obj0 = [GTLRTestingObject object];
  obj0.aStr = @"aaa";
  obj0.identifier = @"obj0";
  GTLRTestingObject *obj1 = [GTLRTestingObject object];
  obj1.aStr = @"bbb";
  obj1.identifier = @"obj1";
  NSArray *items = @[ obj0, obj1 ];

  collection.items = [items copy];

  // Test fast enumeration.
  NSUInteger counter = 0;
  for (id foundItem in collection) {
    XCTAssertEqualObjects(foundItem, items[counter]);
    counter++;
  }
  XCTAssertEqual(counter, (NSUInteger)2);

  // Test indexed subscripts.
  XCTAssertEqualObjects(collection[0], items[0]);
  XCTAssertEqualObjects(collection[1], items[1]);
  XCTAssertThrows(collection[3]);
}

#pragma mark GTLRResultArray Parsing

- (void)testResultArrayParsing {

  // Of Object

  NSString * const jsonStr =
    @"[ {\"a_str\":\"obj 1\"}, {\"a_str\":\"obj 2\"} ]";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr
                                               error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  GTLRTestingResultArray *arrayResult =
    [GTLRTestingResultArray objectWithJSON:json];
  XCTAssertTrue([arrayResult isKindOfClass:[GTLRTestingResultArray class]]);
  NSArray *items = arrayResult.items;
  XCTAssertEqual(items.count, (NSUInteger)2);

  GTLRTestingObject *obj = items[0];
  XCTAssertTrue([obj isKindOfClass:[GTLRTestingObject class]]);
  XCTAssertEqualObjects(obj.aStr, @"obj 1");

  obj = items[1];
  XCTAssertTrue([obj isKindOfClass:[GTLRTestingObject class]]);
  XCTAssertEqualObjects(obj.aStr, @"obj 2");

  // Of String

  NSString * const jsonStr2 = @"[ \"str 1\", \"str 2\" ]";
  err = nil;
  json = [self objectWithString:jsonStr2 error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  GTLRTestingResultArray2 *arrayResult2 =
    [GTLRTestingResultArray2 objectWithJSON:json];
  XCTAssertTrue([arrayResult2 isKindOfClass:[GTLRTestingResultArray2 class]]);
  items = arrayResult2.items;
  XCTAssertEqual(items.count, (NSUInteger)2);

  NSString *str = items[0];
  XCTAssertTrue([str isKindOfClass:[NSString class]]);
  XCTAssertEqualObjects(str, @"str 1");

  str = items[1];
  XCTAssertTrue([str isKindOfClass:[NSString class]]);
  XCTAssertEqualObjects(str, @"str 2");
}

#pragma mark NSSecureCoding support

- (void)testObjectCoding {
  XCTAssertTrue([GTLRObject supportsSecureCoding]);
  XCTAssertTrue([GTLRTestingObject supportsSecureCoding]);

  if (@available(macOS 10.13, iOS 11.0, tvOS 11.0, *)) {
    GTLRTestingObject *obj = [GTLRTestingObject object];
    obj.aStr = @"a string";
    obj.aNum = @123;
    obj.aBool = @YES;

    NSError *err = nil;
    NSData *data =
        [NSKeyedArchiver archivedDataWithRootObject:obj
                              requiringSecureCoding:YES
                                              error:&err];
    XCTAssertNil(err);
    XCTAssertTrue(data.length > 0);

    GTLRTestingObject *obj2 =
        [NSKeyedUnarchiver unarchivedObjectOfClass:[GTLRTestingObject class]
                                          fromData:data
                                             error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(obj2);
    XCTAssertNotEqual(obj, obj2);  // Pointer compare
    XCTAssertEqualObjects(obj, obj2);
  } else {
    XCTFail("use a newer test device");
  }
}

- (void)testBatchResultCoding {
  XCTAssertTrue([GTLRBatchResult supportsSecureCoding]);

  if (@available(macOS 10.13, iOS 11.0, tvOS 11.0, *)) {
    GTLRTestingObject *obj = [GTLRTestingObject object];
    obj.aStr = @"a string";
    obj.aNum = @123;
    obj.aBool = @YES;

    GTLRErrorObject *err = [GTLRErrorObject object];
    err.code = @101;
    err.message = @"My Error";

    NSDictionary *responseHeaders = @{
        @"key1" : @{
            @"X-Header1" : @"Value1",
            @"X-Header2" : @"Value2",
        },
        @"key2" : @{
            @"X-Header3" : @"Value4",
            @"X-Header4" : @"Value3",
        },
    };

    GTLRBatchResult *result = [GTLRBatchResult object];
    result.successes = @{ @"key2" : obj };
    result.failures = @{ @"key1" : err };
    result.responseHeaders = responseHeaders;

    NSError *error = nil;
    NSData *data =
        [NSKeyedArchiver archivedDataWithRootObject:result
                              requiringSecureCoding:YES
                                              error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(data.length > 0);

    GTLRBatchResult *result2 =
        [NSKeyedUnarchiver unarchivedObjectOfClass:[GTLRBatchResult class]
                                          fromData:data
                                             error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(result2);
    XCTAssertNotEqual(result, result2);  // Pointer compare.
    XCTAssertNotEqual(result.successes, result2.successes);  // Pointer compare.
    XCTAssertNotEqual(result.failures, result2.failures);  // Pointer compare.
    XCTAssertNotEqual(result.responseHeaders, result2.responseHeaders);  // Pointer compare.
    XCTAssertNotEqual(result, result2);  // Pointer compare.
    XCTAssertEqualObjects(result, result2);
    XCTAssertEqualObjects(result.successes, result2.successes);
    XCTAssertEqualObjects(result.failures, result2.failures);
    XCTAssertEqualObjects(result.responseHeaders, result2.responseHeaders);
  } else {
    XCTFail("use a newer test device");
  }
}

#pragma mark NSObject description

- (void)testObjectDescription {
  // -description uses the internal -JSONDescription; we test that since
  // it won't include instance pointer values.

  GTLRTestingObject *obj = [GTLRTestingObject object];
  obj.aStr = @"a string";
  obj.aNum = @123;
  obj.aBool = @YES;
  obj.arrayNumber = @[ @1, @2, @3 ];
  obj.JSON[@"unknown"] = @"something";

  GTLRTestingObject *obj2 = [GTLRTestingObject object];
  obj2.aStr = @"kid";
  obj2.JSON[@"un"] = @"value";

  obj.child = obj2;

  XCTAssertEqualObjects([obj JSONDescription],
                        @"{a.num:123 a_bool:1 a_str:\"a string\" arrayNumber:[3] child:{a_str,un} unknown?:\"something\"}");
  XCTAssertEqualObjects([obj2 JSONDescription],
                        @"{a_str:\"kid\" un?:\"value\"}");

  // Test the special case wrapper for arrays: of Object

  NSString * const jsonStr = @"[ {\"a_str\":\"obj 1\"}, {\"a_str\":\"obj 2\"} ]";
  NSError *err = nil;
  NSMutableDictionary *json = [self objectWithString:jsonStr error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  GTLRTestingResultArray *arrayResult = [GTLRTestingResultArray objectWithJSON:json];
  XCTAssertNotNil(arrayResult);

  XCTAssertEqualObjects([arrayResult JSONDescription], @"[2]");

  // Test the special case wrapper for arrays: of Object

  NSString * const jsonStr2 = @"[ \"str 1\", \"str 2\" ]";
  json = [self objectWithString:jsonStr2 error:&err];
  XCTAssertNil(err);
  XCTAssertNotNil(json);

  GTLRTestingResultArray2 *arrayResult2 = [GTLRTestingResultArray2 objectWithJSON:json];
  XCTAssertNotNil(arrayResult2);

  XCTAssertEqualObjects([arrayResult2 JSONDescription], @"[2]");
}

@end
