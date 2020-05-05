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

#if !__has_feature(objc_arc)
#error "This file needs to be compiled with ARC enabled."
#endif

#import <objc/runtime.h>

#import "SGUtils.h"
#import "GTLRUtilities.h"

@interface SGUtils ()
+ (NSString *)stringOfLinesFromString:(NSString *)str
                      firstLinePrefix:(NSString *)firstLinePrefix
                     extraLinesPrefix:(NSString *)extraLinesPrefix
                          linesSuffix:(NSString *)linesSuffix
                       lastLineSuffix:(NSString *)lastLineSuffix
                        elementJoiner:(NSString *)elementJoiner
                       handleHTMLTags:(BOOL)handleHTMLTags;
@end

static const NSUInteger kMaxWidth = 80;

@implementation SGHeaderDoc {
  NSMutableString *_builder;
  NSString *_pending;
  NSString *_asOneLine;
  NSString *_atCMarker;
  BOOL _autoOneLine;

  SGHeaderDoc *_shadow;
}

- (instancetype)init {
  return [self initWithAutoOneLine:NO];
}

- (instancetype)initWithAutoOneLine:(BOOL)autoOneLine {
  self = [super init];
  if (self) {
    _autoOneLine = autoOneLine;
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  SGHeaderDoc *newObject = [[SGHeaderDoc alloc] initWithAutoOneLine:_autoOneLine];
  if (newObject) {
    newObject->_builder = [_builder mutableCopyWithZone:zone];
    newObject->_pending = [_pending copyWithZone:zone];
    newObject->_atCMarker = [_atCMarker copyWithZone:zone];
    newObject->_asOneLine = [_asOneLine copyWithZone:zone];
  }
  return newObject;
}

// Public methods

- (void)append:(NSString *)str {
  [self appendFirstIndent:@"" indent:@"" string:str];
}

- (void)appendFormat:(NSString *)format, ... {
  va_list args;
  va_start(args, format);

  NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
  [self append:str];

  va_end(args);
}

- (void)appendUnwrapped:(NSString *)str {
  if (str.length > 0) {
    NSString *escapedStr = [self escape:str];
    NSString *line = [NSString stringWithFormat:@" *  %@\n", escapedStr];
    [self internalAppend:line];
  }
}

- (void)appendUnwrappedFormat:(NSString *)format, ... {
  va_list args;
  va_start(args, format);

  NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
  [self appendUnwrapped:str];

  va_end(args);
}

- (void)appendBlankLine {
  [self internalAppend:@" *\n"];
}

- (void)queueAppend:(NSString *)str {
  NSAssert(_pending == nil, @"Attempting to queue twice");
  _pending = [self escape:str];
}

- (NSString *)string {
  if (_asOneLine) {
    return _asOneLine;
  }
  // This will still return nil if there was nothing added.
  return [_builder stringByAppendingString:@" */\n"];
}

- (BOOL)hasText {
  return (_builder.length > 0);
}

- (BOOL)isEmpty {
  return (_builder.length == 0);
}

- (NSString *)atC {
  if (_atCMarker == nil) {
    // Hopefully this will never appear in the markup from discovery.
    _atCMarker = @"__ServiceGeneratorAtCMarker__";
  }
  return _atCMarker;
}

- (void)appendNote:(NSString *)str {
  [self appendFirstIndent:@"@note " indent:@"      " string:str];
}

- (void)appendNoteFormat:(NSString *)format, ... {
  va_list args;
  va_start(args, format);

  NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
  [self appendNote:str];

  va_end(args);
}

- (void)appendParam:(NSString *)param string:(NSString *)str {
  NSString *fullStr = [NSString stringWithFormat:@"%@ %@", param, str];
  [self appendFirstIndent:@"@param " indent:@"  " string:fullStr];
}

- (void)appendParam:(NSString *)param format:(NSString *)format, ... {
  va_list args;
  va_start(args, format);

  NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
  [self appendParam:param string:str];

  va_end(args);
}

- (void)appendReturns:(NSString *)str {
  [self appendFirstIndent:@"@return " indent:@"  " string:str];
}

- (void)appendArg:(NSString *)name string:(NSString *)str {
  NSString *fullStr = [NSString stringWithFormat:@"%@ %@", name, str];
  [self appendFirstIndent:@"  @arg @c " indent:@"      " string:fullStr];
}

- (void)appendArg:(NSString *)name format:(NSString *)format, ... {
  va_list args;
  va_start(args, format);

  NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
  [self appendArg:name string:str];

  va_end(args);
}

- (SGHeaderDoc *)shadow {
  return _shadow;
}

- (void)setShadow:(SGHeaderDoc *)shadow {
  NSAssert((shadow == nil) || (_shadow == nil), @"Shadow already set");
  _shadow = shadow;
}

// Internal methods

- (NSString *)escape:(NSString *)str {
  // Since the class uses the C Style comments, there can't be "/*" or "*/"
  // within a comment. So add spaces to those patterns to break them up.
  str = [str stringByReplacingOccurrencesOfString:@"*/" withString:@"* /"];
  str = [str stringByReplacingOccurrencesOfString:@"/*" withString:@"/ *"];

  // Escape '\' and '@' so they don't become HeaderDoc directives within the
  // comments.
  str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
  str = [str stringByReplacingOccurrencesOfString:@"@" withString:@"\\@"];

  // If the atC marker was fetched, replace it.
  if (_atCMarker) {
    str = [str stringByReplacingOccurrencesOfString:_atCMarker
                                         withString:@"@c"];
  }

  return str;
}

- (void)appendFirstIndent:(NSString *)firstIndent
                   indent:(NSString *)indent
                   string:(NSString *)str {
  NSString *firstLinePrefix = [NSString stringWithFormat:@" *  %@", firstIndent];
  NSString *extraLinePrefix = [NSString stringWithFormat:@" *  %@", indent];

  NSString *escapedStr = [self escape:str];

  NSString *wrapped = [SGUtils stringOfLinesFromString:escapedStr
                                       firstLinePrefix:firstLinePrefix
                                      extraLinesPrefix:extraLinePrefix
                                           linesSuffix:@""
                                        lastLineSuffix:@""
                                         elementJoiner:@" "
                                        handleHTMLTags:YES];
  [self internalAppend:wrapped];
}

- (void)internalAppend:(NSString *)str {
  if (str.length == 0) return;

  BOOL isFirstLine = (_builder == nil);
  if (_builder == nil) {
    _builder = [NSMutableString stringWithString:@"/**\n"];
  }

  if (_pending.length > 0) {
    [_builder appendFormat:@" *  %@\n", _pending];
    _pending = nil;
    isFirstLine = NO;
  }

  // Must fit if on one line if we swap the prefix (change to "/** " (same
  // length), and add the " */" on the end.
  if (isFirstLine && _autoOneLine && (str.length < (kMaxWidth - 3))) {
    NSAssert([str hasPrefix:@" *  "] && [str hasSuffix:@"\n"],
             @"str wasn't formatted as expected: %@", str);
    NSRange range = NSMakeRange(4, str.length - 5);
    NSString *content = [str substringWithRange:range];
    // Can't have a newline in the middle.
    if ([content rangeOfString:@"\n"].location == NSNotFound) {
      _asOneLine = [NSString stringWithFormat:@"/** %@ */\n", content];
    }
  } else {
    _asOneLine = nil;
  }

  [_builder appendString:str];
  [_shadow internalAppend:str];
}

@end


@implementation SGUtils

+ (NSString *)objcName:(NSString *)str shouldCapitalize:(BOOL)shouldCapitalize {
  return [self objcName:str
       shouldCapitalize:shouldCapitalize
     allowLeadingDigits:NO];
}

+ (NSString *)objcName:(NSString *)str
      shouldCapitalize:(BOOL)shouldCapitalize
    allowLeadingDigits:(BOOL)allowLeadingDigits {
  // Cache the character sets because this is done a lot...
  static NSCharacterSet *letterSet = nil;
  if (!letterSet) {
    // Just want a-zA-Z
    NSMutableCharacterSet *setBuilder =
        [NSMutableCharacterSet characterSetWithRange:NSMakeRange('a', 26)];
    [setBuilder addCharactersInRange:NSMakeRange('A', 26)];
    // Use immutable versions for speed in our checks.
    letterSet = [setBuilder copy];
  }
  static NSCharacterSet *letterNumSet = nil;
  if (!letterNumSet) {
    // Add 0-9 to our letterSet.
    NSMutableCharacterSet *setBuilder = [letterSet mutableCopy];
    [setBuilder addCharactersInRange:NSMakeRange('0', 10)];
    // Use immutable versions for speed in our checks.
    letterNumSet = [setBuilder copy];
  }

  if (str.length == 0) {
    return nil;
  }

  // Do the transform...

  NSMutableString *worker = [NSMutableString string];

  BOOL isNewWord = shouldCapitalize;

  // If it doesn't start with a letter, put 'x' on the front.
  if (!allowLeadingDigits
      && ![letterSet characterIsMember:[str characterAtIndex:0]]) {
    [worker appendString:(isNewWord ? @"X" : @"x")];
    isNewWord = NO;
  }

  for (NSUInteger len = str.length, idx = 0; idx < len; ++idx ) {
    unichar curChar = [str characterAtIndex:idx];
    if ([letterNumSet characterIsMember:curChar]) {
      NSString *curCharStr = [NSString stringWithFormat:@"%C", curChar];
      if (isNewWord) {
        curCharStr = [curCharStr uppercaseString];
        isNewWord = NO;
      }
      [worker appendString:curCharStr];
    } else {
      isNewWord = YES;
    }

  }

  return worker;
}

#pragma mark -

+ (NSString *)stringOfLinesFromStrings:(NSArray *)arrayOfStrings
                       firstLinePrefix:(NSString *)firstLinePrefix
                      extraLinesPrefix:(NSString *)extraLinesPrefix
                           linesSuffix:(NSString *)linesSuffix
                        lastLineSuffix:(NSString *)lastLineSuffix
                         elementJoiner:(NSString *)elementJoiner {
  if (arrayOfStrings.count == 0) return nil;

  NSMutableArray *lines = [NSMutableArray array];

  // NOTE: This can trip up if it ever gets an element in arrayOfStrings that
  // is too long to fit on a line.

  NSUInteger linesSuffixLen = linesSuffix.length;
  NSUInteger lastLineSuffixLen = lastLineSuffix.length;
  NSUInteger suffixLen = MAX(linesSuffixLen, lastLineSuffixLen);
  NSUInteger elementJoinerLen = elementJoiner.length;

  NSMutableString *currentLine = [NSMutableString stringWithString:firstLinePrefix];
  BOOL needsJoiner = NO;

  for (NSString *element in arrayOfStrings) {
    BOOL elementIsNewline = [element isEqual:@"\n"];
    // Is this a newline or does it not fit?
    if (elementIsNewline ||
        ((currentLine.length + (needsJoiner ? elementJoinerLen : 0) + element.length) > (kMaxWidth - suffixLen))) {
      // Add the current line to the result (but watch out for duplicate
      // newlines for leading newlines).
      if (![currentLine isEqual:extraLinesPrefix] &&
          ![currentLine isEqual:firstLinePrefix]) {
        // Add it.
        [lines addObject:currentLine];

        // Start a new line.
        currentLine = [NSMutableString stringWithString:extraLinesPrefix];
      }

      // New line is empty, no joiner needed.
      needsJoiner = NO;
    }
    if (!elementIsNewline) {
      if (needsJoiner) {
        [currentLine appendString:elementJoiner];
      }
      [currentLine appendString:element];
      needsJoiner = YES;
    }
  }
  // If we need a joiner, it means something got added to the last line, so
  // add it into the result.
  if (needsJoiner) {
    [lines addObject:currentLine];
  }

  // Result now has all of the mutable strings, so we join by the suffix and
  // a new line to glue all the lines together, and then we stick the final
  // line suffix onto the end.
  NSString *lineJoiner = [linesSuffix stringByAppendingString:@"\n"];
  NSString *allLinesStr = [lines componentsJoinedByString:lineJoiner];
  NSString *result = [allLinesStr stringByAppendingString:lastLineSuffix];
  return [result stringByAppendingString:@"\n"];
}

+ (NSString *)stringOfLinesFromString:(NSString *)str
                      firstLinePrefix:(NSString *)firstLinePrefix
                     extraLinesPrefix:(NSString *)extraLinesPrefix
                          linesSuffix:(NSString *)linesSuffix
                       lastLineSuffix:(NSString *)lastLineSuffix
                        elementJoiner:(NSString *)elementJoiner {
  return [self stringOfLinesFromString:str
                       firstLinePrefix:firstLinePrefix
                      extraLinesPrefix:extraLinesPrefix
                           linesSuffix:linesSuffix
                        lastLineSuffix:lastLineSuffix
                         elementJoiner:elementJoiner
                        handleHTMLTags:NO];
}

+ (NSString *)stringOfLinesFromString:(NSString *)str
                      firstLinePrefix:(NSString *)firstLinePrefix
                     extraLinesPrefix:(NSString *)extraLinesPrefix
                          linesSuffix:(NSString *)linesSuffix
                       lastLineSuffix:(NSString *)lastLineSuffix
                        elementJoiner:(NSString *)elementJoiner
                       handleHTMLTags:(BOOL)handleHTMLTags {
  if (str.length == 0) return nil;

  NSCharacterSet *nlSet = [NSCharacterSet newlineCharacterSet];
  NSCharacterSet *wsSet = [NSCharacterSet whitespaceCharacterSet];

  NSMutableArray *words = [NSMutableArray array];

  // Helpper to add a chunk to the words list.
  void (^addToWords)(NSString *) = ^(NSString *s) {
    // Support forced new line by letting them through as words. The strings
    // from discovery likely contain something like "foo\n- bar", we want to
    // tokenize to words, so we mainly use a split on spaces for that. So we
    // first split on newlines, and manually carry those newlines over so they
    // can cause the desired breaks (ie- ["foo", "\n", "-", "bar"]).
    NSArray *paragraphs = [s componentsSeparatedByCharactersInSet:nlSet];
    BOOL addBreak = NO;
    for (NSString *paragraph in paragraphs) {
      if (addBreak) {
        [words addObject:@"\n"];
      } else {
        addBreak = YES;
      }
      // Split on whitespace and add to words.
      [words addObjectsFromArray:[paragraph componentsSeparatedByCharactersInSet:wsSet]];
    }
  };

  if (handleHTMLTags) {
    // Clang's -Wdocumentation doesn't like word wrapping within an html tag.
    // Xcode also seems to get confused by it when providing the contextual
    // help. So this option looks for HTML tags and keeps them as a single item
    // to wordwrap.
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      // Match anything that isn't whitespace, '<', a letter, anything but '>',
      // anything that isn't whitespace.  This gets us anything before a tag and
      // attached to the tag, and anything attached after it.
      // NOTES:
      //   - This is a little fragile, in that we don't want to catch things
      //     like "<= 12" or "<10".
      //   - This doesn't deal with '<' or '>' within tag attribute values, that
      //     requires a more stateful parse than a regex.
      //   - It also matches non spaces before/after the tag so if the tag was
      //     "against" something, it stays connected to it instead of inserting
      //     a space and allowing a break. This is added safety for when things
      //     weren't really a tag and/or when a space around the tag looks odd.
      regex = [NSRegularExpression regularExpressionWithPattern:@"\\S*<[a-zA-Z][^<>]*>\\S*"
                                                        options:0
                                                          error:NULL];
      NSAssert(regex != nil, @"Ooops?");
    });
    __block NSUInteger lastOffset = 0;
    [regex enumerateMatchesInString:str
                            options:0
                              range:NSMakeRange(0, str.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
      if (lastOffset != result.range.location) {
        // Everything before this match.
        NSRange prevRange = NSMakeRange(lastOffset, result.range.location - lastOffset);
        addToWords([str substringWithRange:prevRange]);
      }
      // Add this tag match so it will be wrapped as one chunk. Except, some of
      // the time the data from discovery already had newlines within the tags,
      // so replace them with spaces.
      NSString *tagBlock = [str substringWithRange:result.range];
      tagBlock =
          [[tagBlock componentsSeparatedByCharactersInSet:nlSet] componentsJoinedByString:@" "];
      [words addObject:tagBlock];
      lastOffset = NSMaxRange(result.range);
    }];
    addToWords([str substringFromIndex:lastOffset]);
  } else {
    addToWords(str);
  }

  // componentsSeparatedByCharactersInSet (and componentsSeparatedByString) is
  // documented to take adjacent occurrences of the separator and produce empty
  // strings in the result; remove those empty strings.
  [words removeObject:@""];

  // Now word wrap it.
  return [self stringOfLinesFromStrings:words
                        firstLinePrefix:firstLinePrefix
                       extraLinesPrefix:extraLinesPrefix
                            linesSuffix:linesSuffix
                         lastLineSuffix:lastLineSuffix
                          elementJoiner:elementJoiner];
}

+ (NSString *)stringOfLinesFromString:(NSString *)str
                           linePrefix:(NSString *)linePrefix {
  return [self stringOfLinesFromString:str
                       firstLinePrefix:linePrefix
                      extraLinesPrefix:linePrefix
                           linesSuffix:@""
                        lastLineSuffix:@""
                         elementJoiner:@" "];
}

#pragma mark -

+ (NSString *)classMapForMethodNamed:(NSString *)methodName
                               pairs:(NSDictionary *)pairs
                         quoteValues:(BOOL)quoteValues
                        valueTypeStr:(NSString *)valueTypeStr {
  if (pairs.count == 0) {
    return nil;
  }

  NSArray *sortedKeys =
    [pairs.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];

  NSString *valueBefore = @"";
  NSString *valueAfter = @"";
  if (quoteValues) {
    valueBefore = @"@\"";
    valueAfter = @"\"";
  }

  NSString *genericsInfo;
  if (valueTypeStr.length > 0) {
    genericsInfo = [NSString stringWithFormat:@"<NSString *, %@>", valueTypeStr];
  } else {
    genericsInfo = @"";
  }

  NSMutableString *result = [NSMutableString string];
  [result appendFormat:@"+ (NSDictionary%@ *)%@ {\n", genericsInfo, methodName];
  if (quoteValues && (sortedKeys.count == 1)) {
    NSString *key = sortedKeys[0];
    NSString *value = [pairs objectForKey:key];
    [result appendFormat:@"  return @{ @\"%@\" : %@%@%@ };\n",
     key, valueBefore, value, valueAfter];
  } else {
    [result appendFormat:@"  NSDictionary%@ *map = @{\n", genericsInfo];
    NSString *lastKey = sortedKeys.lastObject;
    for (NSString *key in sortedKeys) {
      NSString *value = [pairs objectForKey:key];
      [result appendFormat:@"    @\"%@\" : %@%@%@%@\n",
       key, valueBefore, value, valueAfter, (key == lastKey ? @"" : @",")];
    }
    [result appendString:@"  };\n"];
    [result appendString:@"  return map;\n"];
  }
  [result appendString:@"}\n"];
  return result;
}

#pragma mark -

+ (NSArray *)wrapStrings:(NSArray *)arrayOfString
                  prefix:(NSString *)prefixStr
                  suffix:(NSString *)suffixStr {
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:arrayOfString.count];

  if (prefixStr == nil) prefixStr = @"";
  if (suffixStr == nil) suffixStr = @"";

  for (NSString *str in arrayOfString) {
    NSString *newStr = [NSString stringWithFormat:@"%@%@%@",
                        prefixStr, str, suffixStr];
    [result addObject:newStr];
  }

  return result;
}

+ (BOOL)stringEndsInNumber:(NSString *)str {
  if (str.length == 0) {
    return NO;
  }

  unichar lastChar = [str characterAtIndex:str.length - 1];
  BOOL result = (lastChar >= '0') && (lastChar <= '9');
  return result;
}

#pragma mark -

+ (NSString *)fullPathWithPath:(NSString *)path {
  if (![path hasPrefix:@"/"]) {
    NSFileManager *fm = [NSFileManager defaultManager];
    path = [[fm currentDirectoryPath] stringByAppendingPathComponent:path];
  }
  return [path stringByStandardizingPath];
}

+ (BOOL)boolFromArg:(const char *)arg {
  BOOL result = NO;
  if (strcasecmp(arg, "y") == 0 || strcasecmp(arg, "yes") == 0) {
    result = YES;
  }
  return result;
}

+ (const char *)strFromBool:(BOOL)val {
  return (val ? "YES" : "NO");
}

#pragma  mark -

+ (BOOL)createDir:(NSString *)fullPath error:(NSError **)err {
  NSFileManager *fm = [NSFileManager defaultManager];
  return [fm createDirectoryAtPath:fullPath
       withIntermediateDirectories:YES
                        attributes:nil
                             error:err];
}

#pragma mark -

+ (NSString *)escapeString:(NSString *)str {
  str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
  str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
  str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
  str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
  str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
  return str;
}

#pragma mark -

+ (NSArray *)publicNoArgSelectorsForClass:(Class)aClass {
  unsigned int count;
  Method *methodList = class_copyMethodList(aClass, &count);

  NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];

  for (unsigned int i = 0; i < count; ++i) {
    SEL sel = method_getName(methodList[i]);
    NSString *str = NSStringFromSelector(sel);
    if ([str hasSuffix:@":"]) {
      // takes arg, skip it.
    } else if ([str hasPrefix:@"_"] || [str hasSuffix:@"_"]) {
      // starts with/ends with underscore, internal.
    } else if ([str hasPrefix:@"."]) {
      // starts with period, also internal.
    } else {
      [result addObject:str];
    }
  }
  free(methodList);

  return result;
}

@end

@implementation NSMutableString (SGUtils)

- (void)sg_appendWrappedLinesFromString:(NSString *)str
                             linePrefix:(NSString *)linePrefix {
  NSString *wrapped = [SGUtils stringOfLinesFromString:str linePrefix:linePrefix];
  if (wrapped.length > 0) {
    [self appendString:wrapped];
  }
}

@end

@implementation NSMutableArray (SGUtils)

- (void)sg_addStringOfWrappedLinesFromString:(NSString *)str
                                  linePrefix:(NSString *)linePrefix {
  NSString *wrapped = [SGUtils stringOfLinesFromString:str linePrefix:linePrefix];
  if (wrapped.length > 0) {
    [self addObject:wrapped];
  }
}

@end
