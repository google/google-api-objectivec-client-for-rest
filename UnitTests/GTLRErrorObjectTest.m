/* Copyright (c) 2016 Google Inc.
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
#import "GTLRErrorObject.h"
#import "GTLRService.h"
#endif

// GTLRServiceTest doesn't have a header file, but we'll use its method for reading a
// test data file anyway.
@interface GTLRServiceTest
+ (NSData *)dataForTestFileName:(NSString *)fileName;
@end

@interface GTLRErrorObjectTest : XCTestCase
@end

@implementation GTLRErrorObjectTest

// Internal utility for getting a JSON dictionary from a test data file.
- (NSMutableDictionary *)JSONForTestFileName:(NSString *)testFileName {
  NSData *jsonData = [GTLRServiceTest dataForTestFileName:testFileName];
  XCTAssertNotNil(jsonData);

  NSError *parseError;
  NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&parseError];
  XCTAssertNotNil(json, @"%@", parseError);
  return json;
}

#pragma mark -

- (void)testErrorObject_v1_CreatedFromJSON {
  NSMutableDictionary *json = [self JSONForTestFileName:@"Drive1ParamError.response.txt"];
  NSMutableDictionary *jsonErrorContent = json[@"error"];
  XCTAssertNotNil(jsonErrorContent);

  GTLRErrorObject *errorObj = [GTLRErrorObject objectWithJSON:jsonErrorContent];

  // Test the error object's fields.
  XCTAssertEqualObjects(errorObj.code, @400);
  XCTAssertEqualObjects(errorObj.message, @"Invalid Value");
  XCTAssertEqual(errorObj.errors.count, (NSUInteger)1);
  XCTAssertEqualObjects(errorObj.errors[0].message, @"Invalid Value");
  XCTAssertEqualObjects(errorObj.errors[0].domain, @"global");
  XCTAssertEqualObjects(errorObj.errors[0].reason, @"invalid");
  XCTAssertEqualObjects(errorObj.errors[0].location, @"pageToken");

  // Test conversion to and from an NSError.
  NSError *fabricatedNSError = errorObj.foundationError;
  XCTAssertEqualObjects(fabricatedNSError.domain, kGTLRErrorObjectDomain);
  // We always store a string in the localizedDescription.
  NSString *errorStr = fabricatedNSError.localizedDescription;
  XCTAssertGreaterThan(errorStr.length, 0U);

  GTLRErrorObject *recoveredErrorObj = [GTLRErrorObject underlyingObjectForError:fabricatedNSError];
  XCTAssertEqualObjects(recoveredErrorObj.JSON, errorObj.JSON);
}

- (void)testErrorObject_v2_CreatedFromJSON {
  NSMutableDictionary *json = [self JSONForTestFileName:@"Classroom1NotFoundError.response.txt"];
  NSMutableDictionary *jsonErrorContent = json[@"error"];
  XCTAssertNotNil(jsonErrorContent);

  GTLRErrorObject *errorObj = [GTLRErrorObject objectWithJSON:jsonErrorContent];

  // Test the error object's fields.
  XCTAssertEqualObjects(errorObj.code, @404);
  XCTAssertEqualObjects(errorObj.message, @"Requested entity was not found.");
  XCTAssertEqualObjects(errorObj.status, @"NOT_FOUND");
  XCTAssertEqual(errorObj.details.count, (NSUInteger)1);
  XCTAssertEqualObjects(errorObj.details[0].type, @"type.googleapis.com");
  XCTAssertEqualObjects(errorObj.details[0].detail, @"[ORIGINAL ERROR] generic::not_found:");

  // Test conversion to and from an NSError.
  NSError *fabricatedNSError = errorObj.foundationError;
  XCTAssertEqualObjects(fabricatedNSError.domain, kGTLRErrorObjectDomain);
  NSString *errorStr = fabricatedNSError.localizedDescription;
  // We always store a string in the localizedDescription.
  XCTAssertGreaterThan(errorStr.length, 0U);

  GTLRErrorObject *recoveredErrorObj = [GTLRErrorObject underlyingObjectForError:fabricatedNSError];
  XCTAssertEqualObjects(recoveredErrorObj.JSON, errorObj.JSON);
}

- (void)testErrorObject_CreatedFromNSError {
  NSError *foundationError = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:NSURLErrorCannotOpenFile
                                             userInfo:@{ @"cat" : @"Abyssinian" }];

  GTLRErrorObject *errorObj = [GTLRErrorObject objectWithFoundationError:foundationError];

  XCTAssertEqualObjects(errorObj.code, @(NSURLErrorCannotOpenFile));
  XCTAssertGreaterThan(errorObj.message.length, 0U);
  XCTAssertNil(errorObj.errors);

  NSError *underlyingNSError = errorObj.foundationError;
  XCTAssertEqualObjects(underlyingNSError.domain, NSURLErrorDomain);

  GTLRErrorObject *recoveredErrorObj = [GTLRErrorObject underlyingObjectForError:underlyingNSError];
  XCTAssertEqualObjects(recoveredErrorObj.JSON, errorObj.JSON);
}

- (void)testObjectCoding {
  XCTAssertTrue([GTLRErrorObject supportsSecureCoding]);

  // Make sure the underlying JSON support didn't get busted.

  if (@available(macOS 10.13, iOS 11.0, tvOS 11.0, *)) {
    GTLRErrorObject *obj = [GTLRErrorObject object];
    obj.code = @123;
    obj.message = @"A message";

    NSError *err;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj
                                         requiringSecureCoding:YES
                                                         error:&err];
    XCTAssertNil(err);
    XCTAssertTrue(data.length > 0);

    NSSet<Class> *classes = [NSSet setWithArray:@[ [GTLRErrorObject class],
                                                   [NSString class] ]];
    GTLRErrorObject *obj2 =
        [NSKeyedUnarchiver unarchivedObjectOfClasses:classes
                                            fromData:data
                                               error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(obj2);
    XCTAssertNotEqual(obj, obj2);  // Pointer compare
    XCTAssertEqualObjects(obj, obj2);

    // Test with a foundation error.

    err = [NSError errorWithDomain:@"my.domain"
                              code:111
                          userInfo:nil];
    obj = [GTLRErrorObject objectWithFoundationError:err];

    err = nil;
    data = [NSKeyedArchiver archivedDataWithRootObject:obj
                                 requiringSecureCoding:YES
                                                 error:&err];
    XCTAssertNil(err);
    XCTAssertTrue(data.length > 0);

    err = nil;
    obj2 = [NSKeyedUnarchiver unarchivedObjectOfClass:[GTLRErrorObject class]
                                             fromData:data
                                                error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(obj2);
    XCTAssertNotEqual(obj, obj2);  // Pointer compare.
    XCTAssertEqualObjects(obj, obj2);
  } else {
    XCTFail("use a newer test device");
  }
}

@end
