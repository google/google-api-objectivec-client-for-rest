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

#import <GoogleAPIClientForREST/GTLRURITemplate.h>

#define ARRAY_SIZE(a) ((sizeof(a) / sizeof((a[0]))))

struct TestRecord {
  __unsafe_unretained NSString *template;
  __unsafe_unretained NSString *expected;
};

@interface GTLRURITemplateTest : XCTestCase
@end

@implementation GTLRURITemplateTest

- (void)testRFCSuite1 {
  // Examples from the RFC.
  NSDictionary *vars = @{
    @"var"   : @"value",
    @"hello" : @"Hello World!",
    @"empty" : @"",
    @"list"  : @[ @"val1", @"val2", @"val3" ],
    @"keys"  : @{ @"key1": @"val1", @"key2": @"val2"},
    @"path"  : @"/foo/bar",
    @"x"     : @"1024",
    @"y"     : @"768",
  };
  struct TestRecord testCases[] = {
    { @"{var}", @"value" },
    { @"{hello}", @"Hello%20World%21" },
    { @"{path}/here", @"%2Ffoo%2Fbar/here" },
    { @"{x,y}", @"1024,768" },
    { @"{var=default}", @"value" },
    { @"{undef=default}", @"default" },
    { @"{list}", @"val1,val2,val3" },
    { @"{list*}", @"val1,val2,val3" },
    { @"{list+}", @"list.val1,list.val2,list.val3" },
    { @"{keys}", @"key1,val1,key2,val2" },
    { @"{keys*}", @"key1,val1,key2,val2" },
    { @"{keys+}", @"keys.key1,val1,keys.key2,val2" },
    { @"{+var}", @"value" },
    { @"{+hello}", @"Hello%20World!" },
    { @"{+path}/here", @"/foo/bar/here" },
    { @"{+path,x}/here", @"/foo/bar,1024/here" },
    { @"{+path}{x}/here", @"/foo/bar1024/here" },
    { @"{+empty}/here", @"/here" },
    { @"{+undef}/here", @"/here" },
    { @"{+list}", @"val1,val2,val3" },
    { @"{+list*}", @"val1,val2,val3" },
    { @"{+list+}", @"list.val1,list.val2,list.val3" },
    { @"{+keys}", @"key1,val1,key2,val2" },
    { @"{+keys*}", @"key1,val1,key2,val2" },
    { @"{+keys+}", @"keys.key1,val1,keys.key2,val2" },
    { @"{;x,y}", @";x=1024;y=768" },
    { @"{;x,y,empty}", @";x=1024;y=768;empty" },
    { @"{;x,y,undef}", @";x=1024;y=768" },
    { @"{;list}", @";val1,val2,val3" },
    { @"{;list*}", @";val1;val2;val3" },
    { @"{;list+}", @";list=val1;list=val2;list=val3" },
    { @"{;keys}", @";key1,val1,key2,val2" },
    { @"{;keys*}", @";key1=val1;key2=val2" },
    { @"{;keys+}", @";keys.key1=val1;keys.key2=val2" },
    { @"{?x,y}", @"?x=1024&y=768" },
    { @"{?x,y,empty}", @"?x=1024&y=768&empty" },
    { @"{?x,y,undef}", @"?x=1024&y=768" },
    { @"{?list}", @"?list=val1,val2,val3" },
    { @"{?list*}", @"?val1&val2&val3" },
    { @"{?list+}", @"?list=val1&list=val2&list=val3" },
    { @"{?keys}", @"?keys=key1,val1,key2,val2" },
    { @"{?keys*}", @"?key1=val1&key2=val2" },
    { @"{?keys+}", @"?keys.key1=val1&keys.key2=val2" },
    { @"{/var}", @"/value" },
    { @"{/var,empty}", @"/value/" },
    { @"{/var,undef}", @"/value" },
    { @"{/list}", @"/val1,val2,val3" },
    { @"{/list*}", @"/val1/val2/val3" },
    { @"{/list*,x}", @"/val1/val2/val3/1024" },
    { @"{/list+}", @"/list.val1/list.val2/list.val3" },
    { @"{/keys}", @"/key1,val1,key2,val2" },
    { @"{/keys*}", @"/key1/val1/key2/val2" },
    { @"{/keys+}", @"/keys.key1/val1/keys.key2/val2" },
    { @"X{.var}", @"X.value" },
    { @"X{.empty}", @"X" },
    { @"X{.undef}", @"X" },
    { @"X{.list}", @"X.val1,val2,val3" },
    { @"X{.list*}", @"X.val1.val2.val3" },
    { @"X{.list*,x}", @"X.val1.val2.val3.1024" },
    { @"X{.list+}", @"X.list.val1.list.val2.list.val3" },
    { @"X{.keys}", @"X.key1,val1,key2,val2" },
    { @"X{.keys*}", @"X.key1.val1.key2.val2" },
    { @"X{.keys+}", @"X.keys.key1.val1.keys.key2.val2" },
  };

  XCTAssertTrue(ARRAY_SIZE(testCases) > 0);
  for (size_t idx = 0; idx < ARRAY_SIZE(testCases); ++idx) {
    NSString *result = [GTLRURITemplate expandTemplate:testCases[idx].template
                                                values:vars];
    XCTAssertEqualObjects(result, testCases[idx].expected,
                          @"template was '%@' (index %lu)",
                          testCases[idx].template, (unsigned long)idx);
  }
}

- (void)testRFCSuite2 {
  // More examples from the RFC.
  NSDictionary *vars = @{
    @"var"        : @"value",
    @"empty"      : @"",
    @"name"       : @[ @"Fred", @"Wilma", @"Pebbles" ],
    @"favs"       : @{ @"color":@"red", @"volume":@"high"},
    @"empty_list" : @[],
    @"empty_keys" : @{},
  };
  struct TestRecord testCases[] = {
    { @"{var=default}", @"value" },
    { @"{undef=default}", @"default" },
    { @"x{empty}y", @"xy" },
    { @"x{empty=_}y", @"xy" },
    { @"x{undef}y", @"xy" },
    { @"x{undef=_}y", @"x_y" },
    { @"x{empty_list}y", @"xy" },
    { @"x{empty_list=_}y", @"x_y" },
    { @"x{empty_list*}y", @"xy" },
    { @"x{empty_list*=_}y", @"x_y" },
    { @"x{empty_list+}y", @"xy" },
    { @"x{empty_list+=_}y", @"x_y" },
    { @"x{empty_keys}y", @"xy" },
    { @"x{empty_keys=_}y", @"x_y" },
    { @"x{empty_keys*}y", @"xy" },
    { @"x{empty_keys*=_}y", @"x_y" },
    { @"x{empty_keys+}y", @"xy" },
    { @"x{empty_keys+=_}y", @"x_y" },
    { @"x{?name=none}", @"x?name=Fred,Wilma,Pebbles" },
    { @"x{?favs=none}", @"x?favs=color,red,volume,high" },
    { @"x{?favs*=none}", @"x?color=red&volume=high" },
    { @"x{?favs+=none}", @"x?favs.color=red&favs.volume=high" },
    { @"x{?undef}", @"x" },
    { @"x{?undef=none}", @"x?undef=none" },
    { @"x{?empty}", @"x?empty" },
    { @"x{?empty=none}", @"x?empty" },
    { @"x{?empty_list}", @"x" },
    { @"x{?empty_list=none}", @"x?empty_list=none" },
    { @"x{?empty_list*}", @"x" },
    { @"x{?empty_list*=none}", @"x?empty_list=none" },
    { @"x{?empty_list+}", @"x" },
    { @"x{?empty_list+=none}", @"x?empty_list=none" },
    { @"x{?empty_keys}", @"x" },
    { @"x{?empty_keys=none}", @"x?empty_keys=none" },
    { @"x{?empty_keys*}", @"x" },
    { @"x{?empty_keys*=none}", @"x?empty_keys=none" },
    { @"x{?empty_keys+}", @"x" },
    { @"x{?empty_keys+=none}", @"x?empty_keys=none" },
  };

  XCTAssertTrue(ARRAY_SIZE(testCases) > 0);
  for (size_t idx = 0; idx < ARRAY_SIZE(testCases); ++idx) {
    NSString *result = [GTLRURITemplate expandTemplate:testCases[idx].template
                                                values:vars];
    XCTAssertEqualObjects(result, testCases[idx].expected,
                          @"template was '%@' (index %lu)",
                          testCases[idx].template, (unsigned long)idx);
  }
}

#pragma mark -

// These are follow up cases not explictly listed in the spec, but does
// as cases to confirm behaviors.  The list was sent to the w3c uri list
// for confirmation:
//   http://lists.w3.org/Archives/Public/uri/2010Sep/thread.html

- (void)testExtraSuite1 {
  // No varspec (section 3.3, paragraph 3)
  NSDictionary *vars = @{
    @"var"   : @"value",
  };
  struct TestRecord testCases[] = {
    { @"{}", @"{}" },
    { @"{,}", @"{,}" },
    { @"{,,}", @"{,,}" },
  };

  XCTAssertTrue(ARRAY_SIZE(testCases) > 0);
  for (size_t idx = 0; idx < ARRAY_SIZE(testCases); ++idx) {
    NSString *result = [GTLRURITemplate expandTemplate:testCases[idx].template
                                                values:vars];
    XCTAssertEqualObjects(result, testCases[idx].expected,
                          @"template was '%@' (index %lu)",
                          testCases[idx].template, (unsigned long)idx);
  }
}

- (void)testExtraSuite2 {
  // Missing closing brace (section 3.3 paragraph 4)
  NSDictionary *vars = @{
    @"var"   : @"value",
    @"hello" : @"Hello World!",
    @"list"  : @[ @"val1", @"val2", @"val3" ],
    @"keys"  : @{ @"key1": @"val1", @"key2": @"val2" },
    @"x"     : @"1024",
    @"y"     : @"768",
  };
  struct TestRecord testCases[] = {
    { @"{var", @"value" },
    { @"{hello", @"Hello%20World%21" },
    { @"{x,y", @"1024,768" },
    { @"{var=default", @"value" },
    { @"{undef=default", @"default" },
    { @"{list", @"val1,val2,val3" },
    { @"{list*", @"val1,val2,val3" },
    { @"{list+", @"list.val1,list.val2,list.val3" },
    { @"{keys", @"key1,val1,key2,val2" },
    { @"{keys*", @"key1,val1,key2,val2" },
    { @"{keys+", @"keys.key1,val1,keys.key2,val2" },
  };

  XCTAssertTrue(ARRAY_SIZE(testCases) > 0);
  for (size_t idx = 0; idx < ARRAY_SIZE(testCases); ++idx) {
    NSString *result = [GTLRURITemplate expandTemplate:testCases[idx].template
                                                values:vars];
    XCTAssertEqualObjects(result, testCases[idx].expected,
                          @"template was '%@' (index %lu)",
                          testCases[idx].template, (unsigned long)idx);
  }
}

- (void)testExtraSuite3 {
  // varspec of only operator and explodes (section 3.3?)
  NSDictionary *vars = @{
    @"var"   : @"value",
  };
  struct TestRecord testCases[] = {
    { @"{+}", @"{+}" },
    { @"{;}", @"{;}" },
    { @"{?}", @"{?}" },
    { @"{/}", @"{/}" },
    { @"{.}", @"{.}" },
    { @"{+,}", @"{+,}" },
    { @"{;,}", @"{;,}" },
    { @"{?,}", @"{?,}" },
    { @"{/,}", @"{/,}" },
    { @"{.,}", @"{.,}" },
    { @"{++}", @"{++}" },
    { @"{;+}", @"{;+}" },
    { @"{?+}", @"{?+}" },
    { @"{/+}", @"{/+}" },
    { @"{.+}", @"{.+}" },
    { @"{+*}", @"{+*}" },
    { @"{;*}", @"{;*}" },
    { @"{?*}", @"{?*}" },
    { @"{/*}", @"{/*}" },
    { @"{.*}", @"{.*}" },
  };

  XCTAssertTrue(ARRAY_SIZE(testCases) > 0);
  for (size_t idx = 0; idx < ARRAY_SIZE(testCases); ++idx) {
    NSString *result = [GTLRURITemplate expandTemplate:testCases[idx].template
                                                values:vars];
    XCTAssertEqualObjects(result, testCases[idx].expected,
                          @"template was '%@' (index %lu)",
                          testCases[idx].template, (unsigned long)idx);
  }
}

- (void)testExtraSuite4 {
  // One good varspec and bad varspecs (section 3.3, paragraph 3?)
  NSDictionary *vars = @{
    @"var"   : @"value",
  };
  struct TestRecord testCases[] = {
    { @"{var,}", @"value" },
    { @"{,var}", @"value" },
    { @"{,var,,}", @"value" },
    { @"{+var,,}", @"value" },
    { @"{;var,,}", @";var=value" },
    { @"{?var,,}", @"?var=value" },
    { @"{/var,,}", @"/value" },
    { @"{.var,,}", @".value" },
    { @"{+,var,}", @"value" },
    { @"{;,var,}", @";var=value" },
    { @"{?,var,}", @"?var=value" },
    { @"{/,var,}", @"/value" },
    { @"{.,var,}", @".value" },
    { @"{+,,var}", @"value" },
    { @"{;,,var}", @";var=value" },
    { @"{?,,var}", @"?var=value" },
    { @"{/,,var}", @"/value" },
    { @"{.,,var}", @".value" },
  };

  XCTAssertTrue(ARRAY_SIZE(testCases) > 0);
  for (size_t idx = 0; idx < ARRAY_SIZE(testCases); ++idx) {
    NSString *result = [GTLRURITemplate expandTemplate:testCases[idx].template
                                                values:vars];
    XCTAssertEqualObjects(result, testCases[idx].expected,
                          @"template was '%@' (index %lu)",
                          testCases[idx].template, (unsigned long)idx);
  }
}

- (void)testExtraSuite5 {
  // Multiple undefined variables (section 3.4)
  NSDictionary *vars = @{
    @"var"   : @"value",
  };
  struct TestRecord testCases[] = {
    { @"{undef1,undef2}", @"" },
    { @"{+undef1,undef2}", @"" },
    { @"{;undef1,undef2}", @"" },
    { @"{?undef1,undef2}", @"" },
    { @"{/undef1,undef2}", @"" },
    { @"{.undef1,undef2}", @"" },
  };

  XCTAssertTrue(ARRAY_SIZE(testCases) > 0);
  for (size_t idx = 0; idx < ARRAY_SIZE(testCases); ++idx) {
    NSString *result = [GTLRURITemplate expandTemplate:testCases[idx].template
                                                values:vars];
    XCTAssertEqualObjects(result, testCases[idx].expected,
                          @"template was '%@' (index %lu)",
                          testCases[idx].template, (unsigned long)idx);
  }
}

- (void)testExtraSuite6 {
  // Default with variable in varspec (just reported like above cases)
  NSDictionary *vars = @{
    @"var"   : @"value",
  };
  struct TestRecord testCases[] = {
    { @"{=foo}", @"{=foo}" },
  };

  XCTAssertTrue(ARRAY_SIZE(testCases) > 0);
  for (size_t idx = 0; idx < ARRAY_SIZE(testCases); ++idx) {
    NSString *result = [GTLRURITemplate expandTemplate:testCases[idx].template
                                                values:vars];
    XCTAssertEqualObjects(result, testCases[idx].expected,
                          @"template was '%@' (index %lu)",
                          testCases[idx].template, (unsigned long)idx);
  }
}

- (void)testExtraSuite7 {
  // varspec with bad partial (partial gets ignored)
  NSDictionary *vars = @{
    @"var"   : @"value",
  };
  struct TestRecord testCases[] = {
    { @"{var:}", @"value" },
    { @"{var^}", @"value" },
  };

  XCTAssertTrue(ARRAY_SIZE(testCases) > 0);
  for (size_t idx = 0; idx < ARRAY_SIZE(testCases); ++idx) {
    NSString *result = [GTLRURITemplate expandTemplate:testCases[idx].template
                                                values:vars];
    XCTAssertEqualObjects(result, testCases[idx].expected,
                          @"template was '%@' (index %lu)",
                          testCases[idx].template, (unsigned long)idx);
  }
}

- (void)testExtraSuite8 {
  // Default of empty string and edge cases with empty strings
  NSDictionary *vars = @{
    @"empty" : @"",
    @"x"     : @"1024",
    @"y"     : @"768",
  };
  struct TestRecord testCases[] = {
    { @"{empty}", @"" },
    { @"{;x,empty,y}", @";x=1024;empty;y=768" },
    { @"{?x,empty,y}", @"?x=1024&empty&y=768" },
    { @"{x,empty,y}", @"1024,,768" },
    { @"{+x,empty,y}", @"1024,,768" },
    { @"{/x,empty,y}", @"/1024//768" },
    { @"{.x,empty,y}", @".1024..768" },
    { @"{undef=}", @"" },
    { @"{;x,undef=,y}", @";x=1024;undef;y=768" },
    { @"{?x,undef=,y}", @"?x=1024&undef&y=768" },
    { @"{x,undef=,y}", @"1024,,768" },
    { @"{+x,undef=,y}", @"1024,,768" },
    { @"{/x,undef=,y}", @"/1024//768" },
    { @"{.x,undef=,y}", @".1024..768" },
  };

  XCTAssertTrue(ARRAY_SIZE(testCases) > 0);
  for (size_t idx = 0; idx < ARRAY_SIZE(testCases); ++idx) {
    NSString *result = [GTLRURITemplate expandTemplate:testCases[idx].template
                                                values:vars];
    XCTAssertEqualObjects(result, testCases[idx].expected,
                          @"template was '%@' (index %lu)",
                          testCases[idx].template, (unsigned long)idx);
  }
}

- (void)testExtraSuite9 {
  // Two defaults for one variable
  NSDictionary *vars = @{
    @"y"     : @"768",
  };
  struct TestRecord testCases[] = {
    { @"1{undef=a}2{undef=b}3", @"1a2b3" },
    { @"0{undef}1{undef=a}2{undef}3{undef=b}4{undef}5", @"01a2a3b4b5" },
  };

  XCTAssertTrue(ARRAY_SIZE(testCases) > 0);
  for (size_t idx = 0; idx < ARRAY_SIZE(testCases); ++idx) {
    NSString *result = [GTLRURITemplate expandTemplate:testCases[idx].template
                                                values:vars];
    XCTAssertEqualObjects(result, testCases[idx].expected,
                          @"template was '%@' (index %lu)",
                          testCases[idx].template, (unsigned long)idx);
  }
}

- (void)testExtraSuite10 {
  // Empty strings within arrays and associative arrays
  NSDictionary *vars = @{
    @"list"  : @[ @"val1", @"", @"val3" ],
    @"keysA" : @{ @"key1": @"", @"key2": @"val2"},
    @"keysB" : @{ @"key1": @"val1", @"": @"val2"},
  };
  struct TestRecord testCases[] = {
    { @"{list}", @"val1,,val3" },
    { @"{list*}", @"val1,,val3" },
    { @"{list+}", @"list.val1,list.,list.val3" },
    { @"{keysA}", @"key1,,key2,val2" },
    { @"{keysA*}", @"key1,,key2,val2" },
    { @"{keysA+}", @"keysA.key1,,keysA.key2,val2" },
    { @"{keysB}", @",val2,key1,val1" },
    { @"{keysB*}", @",val2,key1,val1" },
    { @"{keysB+}", @"keysB.,val2,keysB.key1,val1" },
    { @"{+list}", @"val1,,val3" },
    { @"{+list*}", @"val1,,val3" },
    { @"{+list+}", @"list.val1,list.,list.val3" },
    { @"{+keysA}", @"key1,,key2,val2" },
    { @"{+keysA*}", @"key1,,key2,val2" },
    { @"{+keysA+}", @"keysA.key1,,keysA.key2,val2" },
    { @"{+keysB}", @",val2,key1,val1" },
    { @"{+keysB*}", @",val2,key1,val1" },
    { @"{+keysB+}", @"keysB.,val2,keysB.key1,val1" },
    { @"{;list}", @";val1,,val3" },
    { @"{;list*}", @";val1;;val3" },
    { @"{;list+}", @";list=val1;list=;list=val3" },
    { @"{;keysA}", @";key1,key2,val2" },
    { @"{;keysA*}", @";key1;key2=val2" },
    { @"{;keysA+}", @";keysA.key1;keysA.key2=val2" },
    { @"{;keysB}", @";,val2,key1,val1" },
    { @"{;keysB*}", @";=val2;key1=val1" },
    { @"{;keysB+}", @";keysB.=val2;keysB.key1=val1" },
    { @"{?list}", @"?list=val1,,val3" },
    { @"{?list*}", @"?val1&&val3" },
    { @"{?list+}", @"?list=val1&list=&list=val3" },
    { @"{?keysA}", @"?keysA=key1,key2,val2" },
    { @"{?keysA*}", @"?key1&key2=val2" },
    { @"{?keysA+}", @"?keysA.key1&keysA.key2=val2" },
    { @"{?keysB}", @"?keysB=,val2,key1,val1" },
    { @"{?keysB*}", @"?=val2&key1=val1" },
    { @"{?keysB+}", @"?keysB.=val2&keysB.key1=val1" },
    { @"{/list}", @"/val1,,val3" },
    { @"{/list*}", @"/val1//val3" },
    { @"{/list+}", @"/list.val1/list./list.val3" },
    { @"{/keysA}", @"/key1,,key2,val2" },
    { @"{/keysA*}", @"/key1//key2/val2" },
    { @"{/keysA+}", @"/keysA.key1//keysA.key2/val2" },
    { @"{/keysB}", @"/,val2,key1,val1" },
    { @"{/keysB*}", @"//val2/key1/val1" },
    { @"{/keysB+}", @"/keysB./val2/keysB.key1/val1" },
    { @"X{.list}", @"X.val1,,val3" },
    { @"X{.list*}", @"X.val1..val3" },
    { @"X{.list+}", @"X.list.val1.list..list.val3" },
    { @"X{.keysA}", @"X.key1,,key2,val2" },
    { @"X{.keysA*}", @"X.key1..key2.val2" },
    { @"X{.keysA+}", @"X.keysA.key1..keysA.key2.val2" },
    { @"X{.keysB}", @"X.,val2,key1,val1" },
    { @"X{.keysB*}", @"X..val2.key1.val1" },
    { @"X{.keysB+}", @"X.keysB..val2.keysB.key1.val1" },
  };

  XCTAssertTrue(ARRAY_SIZE(testCases) > 0);
  for (size_t idx = 0; idx < ARRAY_SIZE(testCases); ++idx) {
    NSString *result = [GTLRURITemplate expandTemplate:testCases[idx].template
                                                values:vars];
    XCTAssertEqualObjects(result, testCases[idx].expected,
                          @"template was '%@' (index %lu)",
                          testCases[idx].template, (unsigned long)idx);
  }
}

@end
