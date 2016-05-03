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

//
//  CalendarSampleWindowController.h
//

#import <Cocoa/Cocoa.h>

#import "GTLRCalendar.h"
#import "GTLR/GTMOAuth2WindowController.h"

@interface CalendarSampleWindowController : NSWindowController {
 @private
  IBOutlet NSTextField *_signedInField;
  IBOutlet NSButton *_signedInButton;

  IBOutlet NSTableView *_calendarTable;
  IBOutlet NSProgressIndicator *_calendarProgressIndicator;
  IBOutlet NSTextView *_calendarResultTextField;
  IBOutlet NSButton *_calendarCancelButton;

  IBOutlet NSSegmentedControl *_calendarSegmentedControl;
  IBOutlet NSButton *_addCalendarButton;
  IBOutlet NSButton *_renameCalendarButton;
  IBOutlet NSButton *_deleteCalendarButton;
  IBOutlet NSTextField *_calendarNameField;

  IBOutlet NSTableView *_eventTable;
  IBOutlet NSProgressIndicator *_eventProgressIndicator;
  IBOutlet NSTextView *_eventResultTextField;
  IBOutlet NSButton *_eventCancelButton;

  IBOutlet NSButton *_addEntryButton;
  IBOutlet NSButton *_editEntryButton;
  IBOutlet NSButton *_deleteEntriesButton;
  IBOutlet NSButton *_queryTodaysEventsButton;
  IBOutlet NSButton *_queryFreeBusyButton;

  IBOutlet NSSegmentedControl *_entrySegmentedControl;

  IBOutlet NSButton *_clientIDButton;
  IBOutlet NSTextField *_clientIDRequiredTextField;
  IBOutlet NSWindow *_clientIDSheet;
  IBOutlet NSTextField *_clientIDField;
  IBOutlet NSTextField *_clientSecretField;
}

+ (CalendarSampleWindowController *)sharedWindowController;

- (IBAction)signInClicked:(id)sender;

- (IBAction)getCalendarList:(id)sender;

- (IBAction)cancelCalendarFetch:(id)sender;
- (IBAction)cancelEventsFetch:(id)sender;

- (IBAction)addCalendar:(id)sender;
- (IBAction)renameCalendar:(id)sender;
- (IBAction)deleteCalendar:(id)sender;

- (IBAction)entrySegmentClicked:(id)sender;

- (IBAction)addEntry:(id)sender;
- (IBAction)editEntry:(id)sender;
- (IBAction)deleteEntries:(id)sender;

- (IBAction)queryTodayClicked:(id)sender;
- (IBAction)queryFreeBusyClicked:(id)sender;

- (IBAction)loggingCheckboxClicked:(id)sender;

// Client ID sheet
- (IBAction)clientIDClicked:(id)sender;
- (IBAction)clientIDDoneClicked:(id)sender;
- (IBAction)APIConsoleClicked:(id)sender;

@end
