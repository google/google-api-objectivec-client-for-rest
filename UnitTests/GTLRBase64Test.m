/* Copyright (c) 2012 Google Inc.
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

#import <GoogleAPIClientForREST/GTLRBase64.h>

@interface GTLRBase64Test : XCTestCase
@end

@implementation GTLRBase64Test

- (void)testBase64Conversion {
  NSMutableString *testStr = [NSMutableString string];
  for (unichar idx = 1; idx < 500; idx += 15) {
    [testStr appendFormat:@"%C", idx];
  }
  NSString *testEncodedStd = @"ARAfLj1MW2p5wojCl8KmwrXDhMOTw6LDscSAxI/EnsStxLzF"
                             @"i8WaxanFuMaHxpbGpca0x4PHksehx7A=";
  NSString *testEncodedWeb = @"ARAfLj1MW2p5wojCl8KmwrXDhMOTw6LDscSAxI_EnsStxLzF"
                             @"i8WaxanFuMaHxpbGpca0x4PHksehx7A=";
  NSString *testEncodedWebNoPadding =
      [testEncodedWeb stringByTrimmingCharactersInSet:
         [NSCharacterSet characterSetWithCharactersInString:@"="]];
  XCTAssertNotEqualObjects(testEncodedWeb, testEncodedWebNoPadding);

  // Encoding
  NSData *data = nil;
  NSString *result = GTLREncodeBase64(data);
  XCTAssertNil(result, @"nil base64 data");

  data = [NSData data];
  result = GTLREncodeBase64(data);
  NSString *expected = @"";
  XCTAssertEqualObjects(result, expected, @"empty base64 data");

  NSString *str = testStr;
  data = [testStr dataUsingEncoding:NSUTF8StringEncoding];

  result = GTLREncodeBase64(data);
  expected = testEncodedStd;
  XCTAssertEqualObjects(result, expected, @"test data");

  result = GTLREncodeWebSafeBase64(data);
  expected = testEncodedWeb;
  XCTAssertEqualObjects(result, expected, @"test data ws");

  // Decoding
  str = nil;
  data = GTLRDecodeBase64(str);
  XCTAssertNil(data, @"nil string");

  str = @"kjh"; // not valid base64 (not padded correctly)
  data = GTLRDecodeBase64(str);
  XCTAssertNil(data, @"invalid string");

  str = @"";
  data = GTLRDecodeBase64(str);
  XCTAssertEqualObjects(data, [NSData data], @"empty string");

  str = testEncodedStd;
  data = GTLRDecodeBase64(str);
  NSData *expectedData = [testStr dataUsingEncoding:NSUTF8StringEncoding];
  XCTAssertEqualObjects(data, expectedData, @"test string");

  str = testEncodedWeb;
  data = GTLRDecodeWebSafeBase64(str);
  expectedData = [testStr dataUsingEncoding:NSUTF8StringEncoding];
  XCTAssertEqualObjects(data, expectedData, @"test string ws");

  str = testEncodedWebNoPadding;
  data = GTLRDecodeWebSafeBase64(str);
  expectedData = [testStr dataUsingEncoding:NSUTF8StringEncoding];
  XCTAssertEqualObjects(data, expectedData);

  str = @"YQ==";  // A string with two equals to ensure that is counted as valid.
  data = GTLRDecodeBase64(str);
  expectedData = [@"a" dataUsingEncoding:NSUTF8StringEncoding];
  XCTAssertEqualObjects(data, expectedData, @"two equals");

  str = @"a===";  // invalid base64 encoding, no valid encoding can have 3 '='s.
  data = GTLRDecodeBase64(str);
  XCTAssertNil(data, @"invalid base64 encoding");
}

- (void)testQuantumLengthsAndMalformedInputs {
  XCTAssertNil(GTLREncodeWebSafeBase64(nil));
  XCTAssertNil(GTLRDecodeWebSafeBase64(nil));

  // Round-trip payloads of lengths 0..8 across standard and web-safe (padded
  // and unpadded) to cover all valid final-quantum sizes (0, 2, 3, and 4 chars)
  // as well as table indices 62 ('+'/'-') and 63 ('/'/'_').
  const uint8_t sampleBytes[] = { 0xFB, 0xFF, 0x00, 0x12, 0x34, 0x56, 0x78, 0x9A };
  NSCharacterSet *equalsSet =
      [NSCharacterSet characterSetWithCharactersInString:@"="];
  for (NSUInteger len = 0; len <= sizeof(sampleBytes); ++len) {
    NSData *expected = [NSData dataWithBytes:sampleBytes length:len];

    NSString *stdEncoded = GTLREncodeBase64(expected);
    XCTAssertEqualObjects(GTLRDecodeBase64(stdEncoded), expected,
                          @"std len %lu", (unsigned long)len);

    NSString *webEncoded = GTLREncodeWebSafeBase64(expected);
    XCTAssertEqualObjects(GTLRDecodeWebSafeBase64(webEncoded), expected,
                          @"web padded len %lu", (unsigned long)len);

    NSString *webUnpadded =
        [webEncoded stringByTrimmingCharactersInSet:equalsSet];
    XCTAssertEqualObjects(GTLRDecodeWebSafeBase64(webUnpadded), expected,
                          @"web unpadded len %lu", (unsigned long)len);
  }

  NSString *len65 = [@"" stringByPaddingToLength:65
                                      withString:@"A"
                                 startingAtIndex:0];
  NSString *embeddedNul = [NSString stringWithFormat:@"YWJj%C", (unichar)0];
  NSString *nonASCII1 = [NSString stringWithFormat:@"%C", (unichar)0x80];
  NSString *nonASCII2 = [NSString stringWithFormat:@"YWJj%C", (unichar)0x80];

  NSArray<NSString *> *invalidStdInputs = @[
    // Unpadded non-multiples of 4
    @"A",
    @"YQ",
    @"YQo",
    @"AAAAA",
    @"YWFhYQ",
    @"YWFhYQo",
    len65,
    // Invalid or unaligned '=' padding
    @"=",
    @"==",
    @"===",
    @"====",
    @"A=",
    @"A==",
    @"A===",
    @"YQ=",
    @"YQ===",
    @"YQo==",
    @"YWJj=",
    @"YWJj==",
    @"YWJj===",
    @"YWJj====",
    @"AAAAA=",
    @"AAAAA==",
    @"AAAAA===",
    // Embedded NUL and non-ASCII
    embeddedNul,
    nonASCII1,
    nonASCII2,
  ];
  for (NSString *input in invalidStdInputs) {
    XCTAssertNil(GTLRDecodeBase64(input), @"Std input was \"%@\"", input);
  }

  NSArray<NSString *> *invalidWebSafeInputs = @[
    // Unpadded length % 4 == 1 (1, 5, 9, 13, 65)
    @"A",
    @"AAAAA",
    @"AAAAAAAAA",
    @"AAAAAAAAAAAAA",
    len65,
    // Invalid or unaligned '=' padding
    @"=",
    @"==",
    @"===",
    @"====",
    @"A=",
    @"A==",
    @"A===",
    @"YQ=",
    @"YQ===",
    @"YQo==",
    @"YWJj=",
    @"YWJj==",
    @"YWJj===",
    @"YWJj====",
    @"AAAAA=",
    @"AAAAA==",
    @"AAAAA===",
    // Embedded NUL and non-ASCII
    embeddedNul,
    nonASCII1,
    nonASCII2,
  ];
  for (NSString *input in invalidWebSafeInputs) {
    XCTAssertNil(GTLRDecodeWebSafeBase64(input),
                 @"WebSafe input was \"%@\"", input);
  }
}

@end
