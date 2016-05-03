/* Copyright (c) 2010 Google Inc.
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

#import "GTLRURITemplate.h"

@interface GTLRURITemplateTest : XCTestCase
@end

@implementation GTLRURITemplateTest

- (NSDictionary *)loadTestSuitesNamed:(NSString *)testSuitesName {
  NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
  XCTAssertNotNil(testBundle);

  NSString *testSuitesPath = [testBundle pathForResource:testSuitesName
                                                  ofType:nil];
  XCTAssertNotNil(testSuitesPath, @"%@ not found", testSuitesName);

  NSData *testSuitesData = [NSData dataWithContentsOfFile:testSuitesPath];
  XCTAssertNotNil(testSuitesData, @"Loading %@", testSuitesName);

  NSError *error = nil;
  NSDictionary *testSuites =
      [NSJSONSerialization JSONObjectWithData:testSuitesData
                                      options:0
                                        error:&error];
  XCTAssertNil(error, @"Parsing %@", testSuitesName);

  return testSuites;
}

- (void)runTestSuites:(NSDictionary *)testSuites {
  // The file holds a set of named suites...
  for (NSString *suiteName in testSuites) {
    NSDictionary *suite = [testSuites objectForKey:suiteName];
    // Each suite has variables and test cases...
    NSDictionary *vars = [suite objectForKey:@"variables"];
    NSArray *testCases = [suite objectForKey:@"testcases"];
    XCTAssertTrue(vars.count != 0, @"'%@' no variables?", suiteName);
    XCTAssertTrue(testCases.count != 0, @"'%@' no testcases?", suiteName);
    NSUInteger idx = 0;
    for (NSArray *testCase in testCases) {
      // Each case is an array of the template and value...
      XCTAssertEqual(testCase.count, (NSUInteger)2,
                     @" test index %tu of '%@'", idx, suiteName);

      NSString *testTemplate = [testCase objectAtIndex:0];
      NSString *expectedResult = [testCase objectAtIndex:1];

      NSString *result = [GTLRURITemplate expandTemplate:testTemplate
                                                  values:vars];
      XCTAssertEqualObjects(result, expectedResult,
                            @"template was '%@' (index %tu of '%@')",
                            testTemplate, idx, suiteName);
      ++idx;
    }
  }
}

- (void)testRFCSuite {
  // All of the examples from the RFC are in the python impl source as json
  // test data.  A copy is in the GTLR tree as URITemplateJSON.txt.  The orignal
  // can be found at:
  // http://code.google.com/p/uri-templates/source/browse/trunk/testdata.json
  NSDictionary *testSuites = [self loadTestSuitesNamed:@"URITemplateRFCTests.json"];
  XCTAssertNotNil(testSuites);
  [self runTestSuites:testSuites];
}

- (void)testExtraSuite {
  // These are follow up cases not explictly listed in the spec, but does
  // as cases to confirm behaviors.  The list was sent to the w3c uri list
  // for confirmation:
  //   http://lists.w3.org/Archives/Public/uri/2010Sep/thread.html
  NSDictionary *testSuites = [self loadTestSuitesNamed:@"URITemplateExtraTests.json"];
  XCTAssertNotNil(testSuites);
  [self runTestSuites:testSuites];
}

@end
