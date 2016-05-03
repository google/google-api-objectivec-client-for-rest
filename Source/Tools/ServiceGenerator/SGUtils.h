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

#import <Foundation/Foundation.h>


// Find the number of items in an inlined array.
#define ARRAY_COUNT(a) (sizeof(a) / sizeof(*(a)))

// Helper for building HeaderDoc comments.
@interface SGHeaderDoc : NSObject<NSCopying>

// The currently built up comment as one large string. Always includes the
// comment ender.
@property(readonly) NSString *string;

@property(readonly) BOOL hasText;
@property(readonly) BOOL isEmpty;

// A string that will become "@c" in the final comment. This is needed because
// any use of '@' has to be escape show it shows up in the help.
@property(readonly) NSString *atC;

// if autoOneLine is true, then if there is a single line, it will be
// generated as a oneline comment instead.
- (instancetype)initWithAutoOneLine:(BOOL)autoOneLine;

// Adds the text, wrapping as needed.
- (void)append:(NSString *)str;
- (void)appendFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

// Appending without wrapping.
- (void)appendUnwrapped:(NSString *)str;
- (void)appendUnwrappedFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

// Adds a comment line with nothing on it.
- (void)appendBlankLine;

// Helpers to add specific directives, wrapping is always done.
- (void)appendNote:(NSString *)str;
- (void)appendNoteFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (void)appendParam:(NSString *)param string:(NSString *)str;
- (void)appendParam:(NSString *)param format:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);
- (void)appendReturns:(NSString *)str;
- (void)appendArg:(NSString *)name string:(NSString *)str;
- (void)appendArg:(NSString *)name format:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);

// Queues up a text to add before anything else gets appended. Useful when
// you need a default description if anything else gets added.
- (void)queueAppend:(NSString *)str;

// A shadow HeaderDoc will get everything appended to it also (but not the text
// from a queueAppend). Useful when you have two things needing the same basic
// docs.
@property(strong) SGHeaderDoc *shadow;

@end


@interface SGUtils : NSObject

// This does its best to convert the strings (from discovery) into usable
// Objective-C names.  It filters out all non letter/number characters and
// uses those as markers to capitalize the next character to make CamelCase
// names. i.e. -
//     "max-results"  -> "maxResults"
//     "foo_bar"      -> "fooBar"
//     "userID"       -> "userID" (no change)
//     "800_number"   -> "x800Number" (ensure it starts with a letter)
+ (NSString *)objcName:(NSString *)str shouldCapitalize:(BOOL)shouldCapitalize;
+ (NSString *)objcName:(NSString *)str
      shouldCapitalize:(BOOL)shouldCapitalize
    allowLeadingDigits:(BOOL)allowLeadingDigits;

// Helper that takes all the elements in an array, and breaks them into lines
// word wrapped at 80 columns using the requested prefix/suffixes on the lines.
// Returns the resulting lines as a string.  A string in the array that is
// just a newline ('\n') will force the wrapping to start a new line.
+ (NSString *)stringOfLinesFromStrings:(NSArray<NSString *> *)arrayOfStrings
                       firstLinePrefix:(NSString *)firstLinePrefix
                      extraLinesPrefix:(NSString *)extraLinesPrefix
                           linesSuffix:(NSString *)linesSuffix
                        lastLineSuffix:(NSString *)lastLineSuffix
                         elementJoiner:(NSString *)elementJoiner;

// Helper to word wrap a string giving its specific prefix, suffix, and joiner.
// Newlines within str are honored.
+ (NSString *)stringOfLinesFromString:(NSString *)str
                      firstLinePrefix:(NSString *)firstLinePrefix
                     extraLinesPrefix:(NSString *)extraLinesPrefix
                          linesSuffix:(NSString *)linesSuffix
                       lastLineSuffix:(NSString *)lastLineSuffix
                        elementJoiner:(NSString *)elementJoiner;

// Helper to word wrap a string into a few lines when only needing a prefix and
// joined by spaces.  Newlines within str are honored.
+ (NSString *)stringOfLinesFromString:(NSString *)str
                           linePrefix:(NSString *)linePrefix;

// Helper to generate a class method that returns a mapping (dictionary).
+ (NSString *)classMapForMethodNamed:(NSString *)methodName
                               pairs:(NSDictionary *)pairs
                         quoteValues:(BOOL)quoteValues
                        valueTypeStr:(NSString *)valueTypeStr;

// Helper to wrap a bunch of strings with a suffix and/or prefix.
+ (NSArray<NSString *> *)wrapStrings:(NSArray<NSString *> *)arrayOfString
                              prefix:(NSString *)prefixStr
                              suffix:(NSString *)suffixStr;

// Helper to check if a string ends in a number.
+ (BOOL)stringEndsInNumber:(NSString *)str;

// Makes path into a full path handling relative or absolute paths.
+ (NSString *)fullPathWithPath:(NSString *)path;

// Looks for "yes" or "y", everything else is NO.
+ (BOOL)boolFromArg:(const char *)arg;

// Turns a BOOL into a string.
+ (const char *)strFromBool:(BOOL)val;

// Creates a directory and any intermediates.
+ (BOOL)createDir:(NSString *)fullPath error:(NSError **)err;

// Escapes \t,\n,\r, etc.
+ (NSString *)escapeString:(NSString *)str;

// Returns the list of selector names for the given class that take no args and
// don't appear to be private (i.e. - they could collide with properties on
// subclasses).
+ (NSArray<NSString *> *)publicNoArgSelectorsForClass:(Class)aClass;

@end

@interface NSMutableString (SGUtils)
// Helper to call +[SGUtils stringOfLinesFromString:linePrefix:] and append
// the result.
- (void)sg_appendWrappedLinesFromString:(NSString *)str
                             linePrefix:(NSString *)linePrefix;
@end

@interface NSMutableArray (SGUtils)
// Helper to call +[SGUtils stringOfLinesFromString:linePrefix:] and append
// the single string.
- (void)sg_addStringOfWrappedLinesFromString:(NSString *)str
                                  linePrefix:(NSString *)linePrefix;
@end
