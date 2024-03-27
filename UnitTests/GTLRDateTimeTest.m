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

#import <GoogleAPIClientForREST/GTLRDateTime.h>

@interface GTLRDateTimeTest : XCTestCase
@end

@implementation GTLRDateTimeTest

- (void)testDateTime_FromString {
  const NSCalendarUnit kComponents = (NSCalendarUnitEra
                                      | NSCalendarUnitYear
                                      | NSCalendarUnitMonth
                                      | NSCalendarUnitDay
                                      | NSCalendarUnitHour
                                      | NSCalendarUnitMinute
                                      | NSCalendarUnitSecond);
  struct DateTimeTestRecord {
    __unsafe_unretained NSString *dateTimeStr;
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSInteger hour;
    NSInteger minute;
    NSInteger second;
    NSInteger offsetMinutes;
    BOOL hasTime;
    BOOL hasOffset;
  };

  struct DateTimeTestRecord tests[] = {
    { @"2006-10-14T15:00:00Z", 2006, 10, 14, 15, 0, 0, 0, 1, 0 },
    { @"2006-10-14T15:00:00+00:00", 2006, 10, 14, 15, 0, 0, 0, 1, 1 },   // GMT + 0:00
    { @"2006-10-14T15:00:00+01:00", 2006, 10, 14, 14, 0, 0, 60, 1, 1 },   // GMT - 1:00
    { @"2006-10-14T15:00:00-23:30", 2006, 10, 15, 14, 30, 0, -(23 * 60 + 30), 1, 1 }, // GMT + 23:30
    { @"2006-10-14", 2006, 10, 14, 12, 0, 0, 0, 0, 0 },
    { nil, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
  };

  GTLRDateTime *dateTimeFromNil = [GTLRDateTime dateTimeWithRFC3339String:nil];
  XCTAssertNil(dateTimeFromNil);

  GTLRDateTime *dateTimeFromEmpty = [GTLRDateTime dateTimeWithRFC3339String:@""];
  XCTAssertEqual([dateTimeFromEmpty.dateComponents year], NSDateComponentUndefined);

  NSCalendar *cal = [GTLRDateTime calendar];

  int idx;
  for (idx = 0; tests[idx].dateTimeStr != nil; idx++) {
    NSString *testString = tests[idx].dateTimeStr;
    GTLRDateTime *dateTimeOriginal = [GTLRDateTime dateTimeWithRFC3339String:testString];
    // Copy the date to make sure that works and then validate everything on
    // the copy.
    GTLRDateTime *dateTime = [dateTimeOriginal copy];
    XCTAssertEqualObjects(dateTimeOriginal, dateTime);

    // Verify the string is reconstructed correctly.
    XCTAssertEqualObjects(dateTime.RFC3339String, testString, @"idx %d", idx);

    NSDate *outputDate = dateTime.date;
    NSDateComponents *outputComponents = [cal components:kComponents
                                                fromDate:outputDate];
    XCTAssertEqual(outputComponents.year, tests[idx].year, @"idx %d: %@", idx, testString);
    XCTAssertEqual(outputComponents.month, tests[idx].month, @"idx %d: %@", idx, testString);
    XCTAssertEqual(outputComponents.day, tests[idx].day, @"idx %d: %@", idx, testString);
    XCTAssertEqual(outputComponents.hour, tests[idx].hour, @"idx %d: %@", idx, testString);
    XCTAssertEqual(outputComponents.minute, tests[idx].minute, @"idx %d: %@", idx, testString);
    XCTAssertEqual(outputComponents.second, tests[idx].second, @"idx %d: %@", idx, testString);

    XCTAssertEqual(dateTime.offsetMinutes.integerValue, tests[idx].offsetMinutes,
                   @"idx %d: %@", idx, testString);

    XCTAssertEqual(dateTime.hasTime, tests[idx].hasTime, @"%@", testString);
  }
}

- (void)testDateTime_FromDate {
  NSDateComponents *dc = [[NSDateComponents alloc] init];
  dc.year = 2015;
  dc.month = 12;
  dc.day = 31;
  dc.hour = 23;
  dc.minute = 55;
  dc.second = 0;

  // GTLRDateTime's calendar is Gregorian UTC.
  NSDate *date = [[GTLRDateTime calendar] dateFromComponents:dc];
  GTLRDateTime *dateTimeFromDate = [GTLRDateTime dateTimeWithDate:date];
  XCTAssertEqualObjects(dateTimeFromDate.RFC3339String, @"2015-12-31T23:55:00Z");

  // Test with an offset specified.  With an offset, the string represents not GMT
  // but a time in another time zone.
  NSInteger offsetMinutes = -75;
  date = [date dateByAddingTimeInterval:(-offsetMinutes * 60)];
  dateTimeFromDate = [GTLRDateTime dateTimeWithDate:date
                                      offsetMinutes:offsetMinutes];
  XCTAssertEqualObjects(dateTimeFromDate.RFC3339String, @"2015-12-31T23:55:00-01:15");
}

- (void)testDateTime_FromDateComponents {
  NSDateComponents *dc = [[NSDateComponents alloc] init];
  dc.year = 2015;
  dc.month = 12;
  dc.day = 31;
  dc.hour = 12;
  dc.minute = 23;
  dc.second = 0;

  // With no calendar in the components, GTLRDateTime uses +[GTLRDateTime calendar].
  GTLRDateTime *dateTime = [GTLRDateTime dateTimeWithDateComponents:dc];
  XCTAssertEqualObjects(dateTime.RFC3339String, @"2015-12-31T12:23:00Z");

  // With a calendar in the components GTLRDateTime uses that. We'll have the
  // calendar be Denver, GMT-7.  The string output should still be UTC
  // for the server.
  dc.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
  dc.calendar.timeZone = (NSTimeZone * _Nonnull)[NSTimeZone timeZoneWithName:@"America/Denver"];
  dateTime = [GTLRDateTime dateTimeWithDateComponents:dc];
  XCTAssertEqualObjects(dateTime.RFC3339String, @"2015-12-31T19:23:00Z");
}

- (void)testFractionalSeconds {
  // See the note at the top of GTLRDateTime for the expected behaviors.

  struct FractionalSecondsTestRecord {
    __unsafe_unretained NSString *input;
    __unsafe_unretained NSString *expected;
  };

  struct FractionalSecondsTestRecord tests[] = {
    // This was a trouble case and called for the round() usage, without round
    // and using a cast, it truncates the double to 734 even though %f prints it
    // as .735.
    { @"2011-05-03T23:14:20.735Z", @"2011-05-03T23:14:20.735Z" }, // Same in/out
    // Extra digits
    { @"2011-05-03T23:14:20.12345Z", @"2011-05-03T23:14:20.123Z" },
    // Fewer digits
    { @"2011-05-03T23:14:20.12Z", @"2011-05-03T23:14:20.120Z" },
    { @"2011-05-03T23:14:20.1Z", @"2011-05-03T23:14:20.100Z" },
    // Leading zero (make sure we never turn .001 -> .1.
    { @"2011-05-03T23:14:20.001Z", @"2011-05-03T23:14:20.001Z" }, // Same in/out
    { @"2011-05-03T23:14:20.01Z", @"2011-05-03T23:14:20.010Z" },
    // We eat (don't display) fractions of just zeros.
    { @"2011-05-03T23:14:20.000Z", @"2011-05-03T23:14:20Z" },
    { @"2011-05-03T23:14:20.00Z", @"2011-05-03T23:14:20Z" },
    { @"2011-05-03T23:14:20.0Z", @"2011-05-03T23:14:20Z" },
    // Done
    { nil, nil }
  };

  for (int idx = 0; tests[idx].input != nil; idx++) {
    NSString *testString = tests[idx].input;
    NSString *expectedString = tests[idx].expected;

    GTLRDateTime *dateTimeOriginal = [GTLRDateTime dateTimeWithRFC3339String:testString];

    // Bounce through a -copy and an NSDate to make sure the fractions of a
    // second make it all the way.
    GTLRDateTime *dateTimeCopied = [dateTimeOriginal copy];
    XCTAssertEqualObjects(dateTimeCopied, dateTimeOriginal);
    NSDate *outputDate = dateTimeCopied.date;
    GTLRDateTime *dateTimeFromDate = [GTLRDateTime dateTimeWithDate:outputDate];
    XCTAssertEqualObjects(dateTimeFromDate, dateTimeOriginal, @"idx %d", idx);

    XCTAssertEqualObjects(dateTimeFromDate.RFC3339String, expectedString);
  }
}

- (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second
                timeZone:(NSTimeZone *)tz {
  NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *components = [[NSDateComponents alloc] init];
  components.year = year;
  components.month = month;
  components.day = day;
  components.hour = hour;
  components.minute = minute;
  components.second = second;
  components.timeZone = tz;
  NSDate *result = [calendar dateFromComponents:components];
  return result;
}

@end
