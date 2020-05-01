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

#if SWIFT_PACKAGE
@import GoogleAPIClientForRESTCore;
#else
#import "GTLRDuration.h"
#endif

#define ARRAY_SIZE(a) ((sizeof(a) / sizeof((a[0]))))

@interface GTLRDurationTest : XCTestCase
@end

@implementation GTLRDurationTest

- (void)testInvalidWithSecondsNanos {
  struct TestRecord {
    int64_t seconds;
    int32_t nanos;
  };

  // Success cases are covered in -testJSONString.

  struct TestRecord tests[] = {
    {  1, -1 },
    { -1, 1 },
    {  0, 1000000000 },
    {  0, -1000000000 },
    {  0, INT32_MAX },
    {  0, INT32_MIN },
    {  INT64_MAX, INT32_MAX },
    {  INT64_MIN, INT32_MIN },
  };

  for (size_t i = 0; i < ARRAY_SIZE(tests); ++i) {
    GTLRDuration *duration = [GTLRDuration durationWithSeconds:tests[i].seconds
                                                         nanos:tests[i].nanos];
    XCTAssertNil(duration, @"Loop %zd", i);
  }
}

- (void)testJSONString {
  struct TestRecord {
    int64_t seconds;
    int32_t nanos;
    __unsafe_unretained NSString *expected;
  };

  struct TestRecord tests[] = {
    // 3 digits for nanos
    {  0, 0, @"0.000s" },
    {  1, 0, @"1.000s" },
    { -1, 0, @"-1.000s" },
    {  123456789, 0, @"123456789.000s" },
    { -123456789, 0, @"-123456789.000s" },
    {  0,  100000000, @"0.100s" },
    {  0, -100000000, @"-0.100s" },
    {  0,  101000000, @"0.101s" },
    {  0, -101000000, @"-0.101s" },
    // 6 digits for nanos
    {  0,     100000, @"0.000100s" },
    {  0,    -100000, @"-0.000100s" },
    {  0,       1000, @"0.000001s" },
    {  0,      -1000, @"-0.000001s" },
    // 9 digits for nanos
    {  0,        100, @"0.000000100s" },
    {  0,       -100, @"-0.000000100s" },
    {  0,          1, @"0.000000001s" },
    {  0,         -1, @"-0.000000001s" },
    // Some random ones.
    {  12345, 987654321, @"12345.987654321s" },
    {  -987654321, -123000000, @"-987654321.123s" },
  };

  for (size_t i = 0; i < ARRAY_SIZE(tests); ++i) {
    GTLRDuration *duration = [GTLRDuration durationWithSeconds:tests[i].seconds
                                                         nanos:tests[i].nanos];
    XCTAssertNotNil(duration, @"Loop %zd", i);
    XCTAssertEqual(duration.seconds, tests[i].seconds, @"Loop %zd", i);
    XCTAssertEqual(duration.nanos, tests[i].nanos, @"Loop %zd", i);
    XCTAssertEqualObjects(duration.jsonString, tests[i].expected,
                          @"Loop %zd", i);
  }
}

- (void)testWithJsonString {

  NSArray<NSString *> *invalidInputs = @[
    @"",
    @"s",
    @"garbage",
    @"12x.4",
    // no 's'
    @"10.100",
    @"1",
    // Double -
    @"--10s",
    @"--10.1s",
    // Extra - in the middle
    @"10.-1s",
    @"-10.-1s",
    // Too many decimal digits
    @"1.1234567890s",
    @"-1.1234567890s",
  ];
  for (NSString *input in invalidInputs) {
    GTLRDuration *duration = [GTLRDuration durationWithJSONString:input];
    XCTAssertNil(duration, @"Input was \"%@\"", input);
  }

  struct TestRecord {
    __unsafe_unretained NSString *input;
    int64_t expectedSeconds;
    int32_t expectedNanos;
  };

  struct TestRecord tests[] = {
    // 3 digits for nanos
    { @"0.000s", 0, 0 },
    { @"1.000s", 1, 0 },
    { @"-1.000s", -1, 0 },
    { @"123456789.000s", 123456789, 0 },
    { @"-123456789.000s", -123456789, 0 },
    { @"0.100s", 0, 100000000 },
    { @"-0.100s", 0, -100000000 },
    { @"0.101s", 0, 101000000 },
    { @"-0.101s", 0, -101000000 },
    // 6 digits for nanos
    { @"0.000100s", 0, 100000 },
    { @"-0.000100s", 0, -100000 },
    { @"0.000001s", 0, 1000 },
    { @"-0.000001s", 0, -1000 },
    // 9 digits for nanos
    { @"0.000000100s", 0, 100 },
    { @"-0.000000100s", 0, -100 },
    { @"0.000000001s", 0, 1 },
    { @"-0.000000001s", 0, -1 },
    // Some random ones.
    { @"12345.987654321s", 12345, 987654321 },
    { @"-987654321.123s", -987654321, -123000000 },
    // No nanos
    { @"12345s", 12345, 0 },
    { @"-987654321s", -987654321, 0 },
    // Non stardard nano digit counts.
    { @"0.1s", 0, 100000000 },
    { @"-0.10s", 0, -100000000 },
  };

  for (size_t i = 0; i < ARRAY_SIZE(tests); ++i) {
    GTLRDuration *duration =
        [GTLRDuration durationWithJSONString:tests[i].input];
    XCTAssertNotNil(duration, @"Loop %zd", i);
    XCTAssertEqual(duration.seconds, tests[i].expectedSeconds, @"Loop %zd", i);
    XCTAssertEqual(duration.nanos, tests[i].expectedNanos, @"Loop %zd", i);
    // Should get the input back no matter what.
    XCTAssertEqualObjects(duration.jsonString, tests[i].input,
                          @"Loop %zd", i);
  }
}

- (void)testNSTimeInterval {
  struct TestRecord {
    NSTimeInterval interval;
    int64_t expectedSeconds;
    int32_t expectedNanos;

    // Accuracy for the nanos compare, needed because of floating point
    // rounding.
    int32_t nanosAccuracy;
  };


  struct TestRecord tests[] = {
    {  0.0, 0, 0, 0},
    {  10.0, 10, 0, 0 },
    { -10.0, -10, 0, 0 },
    {  100.1, 100, 100000000, 1 },
    { -100.1, -100, -100000000, 1 },
    {  0.999999999, 0, 999999999, 0 },
    { -0.999999999, 0, -999999999, 0 },
  };

  const NSTimeInterval kTimeIntervalAccuracy = 1e-9;

  for (size_t i = 0; i < ARRAY_SIZE(tests); ++i) {
    GTLRDuration *duration =
        [GTLRDuration durationWithTimeInterval:tests[i].interval];
    XCTAssertEqual(duration.seconds, tests[i].expectedSeconds, @"Loop %zd", i);
    XCTAssertEqualWithAccuracy(duration.nanos, tests[i].expectedNanos,
                               tests[i].nanosAccuracy, @"Loop %zd", i);

    // And back to a NSTimeInterval
    XCTAssertEqualWithAccuracy(duration.timeInterval, tests[i].interval,
                               kTimeIntervalAccuracy, @"Loop %zd", i);
  }
}

@end
