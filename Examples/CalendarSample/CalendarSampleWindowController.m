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
//  CalendarSampleWindowController.m
//

#import "CalendarSampleWindowController.h"
#import "EditEventWindowController.h"
#import "EditACLWindowController.h"

#import <AppAuth/AppAuth.h>
#import <GTMAppAuth/GTMAppAuth.h>
#import <GTMSessionFetcher/GTMSessionFetcherLogging.h>
#import <GoogleAPIClientForREST/GTLRUtilities.h>

enum {
  kEventsSegment = 0,
  kAccessControlSegment = 1,
  kSettingsSegment = 2
};

@interface CalendarSampleWindowController ()

@property(readonly) GTLRCalendarService *calendarService;

@property(strong) GTLRCalendar_CalendarList *calendarList;
@property(strong) GTLRServiceTicket *calendarListTicket;
@property(strong) NSError *calendarListFetchError;

@property(strong) GTLRServiceTicket *editCalendarListTicket;

@property(strong) GTLRCalendar_Events *events;
@property(strong) GTLRServiceTicket *eventsTicket;
@property(strong) NSError *eventsFetchError;

@property(strong) GTLRCalendar_Acl *ACLs;
@property(strong) NSError *ACLsFetchError;

@property(strong) GTLRCalendar_Settings *settings;
@property(strong) NSError *settingsFetchError;

@property(strong) GTLRServiceTicket *editEventTicket;

@end

// This is the URL shown users after completing the OAuth flow. This is an information page only and
// is not part of the authorization protocol. You can replace it with any URL you like.
// We recommend at a minimum that the page displayed instructs users to return to the app.
static NSString *const kSuccessURLString = @"http://openid.github.io/AppAuth-iOS/redirect/";

// Keychain item name for saving the user's authentication information
NSString *const kGTMAppAuthKeychainItemName = @"CalendarSample: Google Calendar. GTMAppAuth";

@implementation CalendarSampleWindowController {
  OIDRedirectHTTPHandler *_redirectHTTPHandler;
}

@synthesize calendarList = _calendarList,
            calendarListTicket = _calendarListTicket,
            calendarListFetchError = _calendarFetchError,
            editCalendarListTicket = _editCalendarListTicket,
            events = _events,
            eventsTicket = _eventTicket,
            eventsFetchError = _eventsFetchError,
            ACLs = _calendarACLs,
            ACLsFetchError = _calendarACLsFetchError,
            settings = _settings,
            settingsFetchError = _settingsFetchError,
            editEventTicket = _editEventTicket;

+ (CalendarSampleWindowController *)sharedWindowController {
  static CalendarSampleWindowController* gWindowController = nil;
  if (!gWindowController) {
    gWindowController = [[CalendarSampleWindowController alloc] init];
  }
  return gWindowController;
}

- (id)init {
  return [self initWithWindowNibName:@"CalendarSampleWindow"];
}

- (void)awakeFromNib {
  // Attempts to deserialize authorization from keychain in GTMAppAuth format.
  id<GTMFetcherAuthorizationProtocol> authorization =
      [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kGTMAppAuthKeychainItemName];
  self.calendarService.authorizer = authorization;

  // Set the result text fields to have a distinctive color and mono-spaced font
  _calendarResultTextField.textColor = [NSColor darkGrayColor];
  _eventResultTextField.textColor = [NSColor darkGrayColor];

  NSFont *resultTextFont = [NSFont fontWithName:@"Monaco" size:9];
  _calendarResultTextField.font = resultTextFont;
  _eventResultTextField.font = resultTextFont;

  [self updateUI];
}

#pragma mark -

- (NSString *)signedInUsername {
  // Get the email address of the signed-in user
  id<GTMFetcherAuthorizationProtocol> auth = self.calendarService.authorizer;
  BOOL isSignedIn = auth.canAuthorize;
  if (isSignedIn) {
    return auth.userEmail;
  } else {
    return nil;
  }
}

- (BOOL)isSignedIn {
  NSString *name = [self signedInUsername];
  return (name != nil);
}

#pragma mark IBActions

- (IBAction)signInClicked:(id)sender {
  if (![self isSignedIn]) {
    // Sign in
    [self runSigninThenInvokeSelector:@selector(updateUI)];
  } else {
    // Sign out
    GTLRCalendarService *service = self.calendarService;

   [GTMAppAuthFetcherAuthorization
        removeAuthorizationFromKeychainForName:kGTMAppAuthKeychainItemName];
    service.authorizer = nil;
    [self updateUI];
  }
}

- (IBAction)getCalendarList:(id)sender {
  if (![self isSignedIn]) {
    [self runSigninThenInvokeSelector:@selector(fetchCalendarList)];
  } else {
    [self fetchCalendarList];
  }
}

- (IBAction)cancelCalendarFetch:(id)sender {
  [self.calendarListTicket cancelTicket];
  self.calendarListTicket = nil;

  [self.editCalendarListTicket cancelTicket];
  self.editCalendarListTicket = nil;

  [self updateUI];
}

- (IBAction)cancelEventsFetch:(id)sender {
  [self.eventsTicket cancelTicket];
  self.eventsTicket = nil;

  [self.editEventTicket cancelTicket];
  self.editEventTicket = nil;

  [self updateUI];
}

- (IBAction)entrySegmentClicked:(id)sender {
  [self updateUI];
}

- (IBAction)addCalendar:(id)sender {
  [self addACalendar];
}

- (IBAction)renameCalendar:(id)sender {
  [self renameSelectedCalendar];
}

- (IBAction)deleteCalendar:(id)sender {
  GTLRCalendar_CalendarListEntry *calendar = [self selectedCalendarListEntry];
  NSString *title = calendar.summary;

  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText = [NSString stringWithFormat:@"Delete \"%@\"?", title];
  [alert addButtonWithTitle:@"Delete"];
  [alert addButtonWithTitle:@"Cancel"];
  [alert beginSheetModalForWindow:self.window
                completionHandler:^(NSModalResponse returnCode) {
    if (returnCode == NSAlertFirstButtonReturn) {
      [self deleteSelectedCalendar];
    }
  }];
}

- (IBAction)addEntry:(id)sender {
  NSInteger segment = _entrySegmentedControl.selectedSegment;
  if (segment == kEventsSegment) {
    [self addAnEvent];
  } else {
    [self addAnACLRule];
  }
}

- (IBAction)editEntry:(id)sender {
  NSInteger segment = _entrySegmentedControl.selectedSegment;
  if (segment == kEventsSegment) {
    [self editSelectedEvent];
  } else {
    [self editSelectedACLRule];
  }
}

- (IBAction)deleteEntries:(id)sender {
  NSInteger segment = _entrySegmentedControl.selectedSegment;
  if (segment == kEventsSegment) {
    [self deleteSelectedEvent];
  } else {
    [self deleteSelectedACLRule];
  }
}

- (IBAction)queryTodayClicked:(id)sender {
  [self queryTodaysEvents];
}

- (IBAction)queryFreeBusyClicked:(id)sender {
  [self queryFreeBusy];
}

- (IBAction)APIConsoleClicked:(id)sender {
  NSURL *url = [NSURL URLWithString:@"https://console.developers.google.com/"];
  [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)loggingCheckboxClicked:(NSButton *)sender {
  [GTMSessionFetcher setLoggingEnabled:[sender state]];
}

#pragma mark -

// Get a service object with the current username/password
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information (such as cookies and the "last modified" date for
// fetched data.)

- (GTLRCalendarService *)calendarService {
  static GTLRCalendarService *service = nil;

  if (!service) {
    service = [[GTLRCalendarService alloc] init];

    // Have the service object set tickets to fetch consecutive pages
    // of the feed so we do not need to manually fetch them
    service.shouldFetchNextPages = YES;

    // Have the service object set tickets to retry temporary error conditions
    // automatically
    service.retryEnabled = YES;
  }
  return service;
}

- (GTLRCalendar_CalendarListEntry *)selectedCalendarListEntry {
  NSInteger rowIndex = _calendarTable.selectedRow;
  if (rowIndex > -1) {
    GTLRCalendar_CalendarListEntry *item = self.calendarList[rowIndex];
    return item;
  }
  return nil;
}

- (GTLRCalendar_Event *)selectedEvent {
  if (_entrySegmentedControl.selectedSegment == kEventsSegment) {
    NSInteger rowIndex = _eventTable.selectedRow;
    if (rowIndex > -1) {
      GTLRCalendar_Event *item = self.events[rowIndex];
      return item;
    }
  }
  return nil;
}

- (GTLRCalendar_AclRule *)selectedACLRule {
  if (_entrySegmentedControl.selectedSegment == kAccessControlSegment) {
    NSInteger rowIndex = _eventTable.selectedRow;
    if (rowIndex > -1) {
      GTLRCalendar_AclRule *item = self.ACLs[rowIndex];
      return item;
    }
  }
  return nil;
}

- (GTLRCalendar_Setting *)selectedSetting {
  if (_entrySegmentedControl.selectedSegment == kSettingsSegment) {
    NSInteger rowIndex = _eventTable.selectedRow;
    if (rowIndex > -1) {
      GTLRCalendar_Setting *item = self.settings[rowIndex];
      return item;
    }
  }
  return nil;
}

#pragma mark Fetch Calendar List

- (void)fetchCalendarList {
  self.calendarList = nil;
  self.calendarListFetchError = nil;

  GTLRCalendarService *service = self.calendarService;

  GTLRCalendarQuery_CalendarListList *query = [GTLRCalendarQuery_CalendarListList query];

  BOOL shouldFetchedOwned = (_calendarSegmentedControl.selectedSegment == 1);
  if (shouldFetchedOwned) {
    query.minAccessRole = kGTLRCalendarMinAccessRoleOwner;
  }

  self.calendarListTicket = [service executeQuery:query
                                completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                    id calendarList,
                                                    NSError *callbackError) {
    // Callback
    self.calendarList = calendarList;
    self.calendarListFetchError = callbackError;
    self.calendarListTicket = nil;

    [self updateUI];
  }];
  [self updateUI];
}

#pragma mark Fetch Selected Calendar

- (void)fetchSelectedCalendar {
  self.events = nil;
  self.eventsFetchError = nil;

  self.ACLs = nil;
  self.ACLsFetchError = nil;

  self.settings = nil;
  self.settingsFetchError = nil;

  GTLRCalendarService *service = self.calendarService;

  GTLRCalendar_CalendarListEntry *selectedCalendar = [self selectedCalendarListEntry];
  if (selectedCalendar) {
    NSString *calendarID = selectedCalendar.identifier;

    // We will fetch the events for this calendar, the ACLs for this calendar,
    // and the user's settings, together in a single batch.
    GTLRBatchQuery *batch = [GTLRBatchQuery batchQuery];

    GTLRCalendarQuery_EventsList *eventsQuery =
        [GTLRCalendarQuery_EventsList queryWithCalendarId:calendarID];
    eventsQuery.completionBlock = ^(GTLRServiceTicket *callbackTicket,
                                    GTLRCalendar_Events *events, NSError *callbackError) {
      self.events = events;
      self.eventsFetchError = callbackError;
    };
    [batch addQuery:eventsQuery];

    GTLRCalendarQuery_AclList *aclQuery = [GTLRCalendarQuery_AclList queryWithCalendarId:calendarID];
    aclQuery.completionBlock = ^(GTLRServiceTicket *callbackTicket, GTLRCalendar_Acl *acls,
                                 NSError *callbackError) {
      self.ACLs = acls;
      self.ACLsFetchError = callbackError;
    };
    [batch addQuery:aclQuery];

    GTLRCalendarQuery_SettingsList *settingsQuery = [GTLRCalendarQuery_SettingsList query];
    settingsQuery.completionBlock = ^(GTLRServiceTicket *callbackTicket,
                                      GTLRCalendar_Settings *settings, NSError *callbackError) {
      self.settings = settings;
      self.settingsFetchError = callbackError;
    };
    [batch addQuery:settingsQuery];

    self.eventsTicket = [service executeQuery:batch
                            completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                GTLRBatchResult *batchResult,
                                                NSError *callbackError) {
      // Callback
      //
      // For batch queries with successful execution,
      // the result is a GTLRBatchResult object
      //
      // At this point, the query completion blocks
      // have already been called
      self.eventsTicket = nil;

      [self updateUI];
    }];
    [self updateUI];
  }
}

#pragma mark Add, Rename, and Delete a Calendar

- (void)addACalendar {
  NSString *newCalendarName = _calendarNameField.stringValue;

  GTLRCalendarService *service = self.calendarService;

  GTLRCalendar_Calendar *newEntry = [GTLRCalendar_Calendar object];
  newEntry.summary = newCalendarName;
  newEntry.timeZone = [[NSTimeZone localTimeZone] name];

  GTLRCalendarQuery_CalendarsInsert *query =
      [GTLRCalendarQuery_CalendarsInsert queryWithObject:newEntry];
  self.editCalendarListTicket = [service executeQuery:query
                                    completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                        GTLRCalendar_Calendar *calendar,
                                                        NSError *callbackError) {
    // Callback
    self.editCalendarListTicket = nil;
    if (callbackError == nil) {
      self->_calendarNameField.stringValue = @"";
      [self fetchCalendarList];
    } else {
      [self displayAlert:@"Add failed"
                  format:@"Calendar add failed: %@", callbackError];
    }
    [self updateUI];
  }];
  [self updateUI];
}

- (void)renameSelectedCalendar {
  GTLRCalendar_CalendarListEntry *selectedCalendarListEntry = [self selectedCalendarListEntry];
  if (selectedCalendarListEntry) {
    GTLRCalendarService *service = self.calendarService;

    NSString *newCalendarName = _calendarNameField.stringValue;

    // Modify a copy of the selected calendar, not the existing one in memory
    GTLRCalendar_Calendar *patchObject = [GTLRCalendar_Calendar object];
    patchObject.summary = newCalendarName;

    NSString *calendarID = selectedCalendarListEntry.identifier;
    GTLRCalendarQuery_CalendarsPatch *query =
        [GTLRCalendarQuery_CalendarsPatch queryWithObject:patchObject
                                               calendarId:calendarID];
    self.editCalendarListTicket = [service executeQuery:query
                                      completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                          GTLRCalendar_Calendar *calendar,
                                                          NSError *callbackError) {
      // Callback
      self.editCalendarListTicket = nil;
      if (callbackError == nil) {
        [self displayAlert:@"Renamed"
                    format:@"Renamed calendar \"%@\" as \"%@\"",
         selectedCalendarListEntry.summary,
         calendar.summary];

        self->_calendarNameField.stringValue = @"";

        [self fetchCalendarList];
      } else {
        [self displayAlert:@"Update failed"
                    format:@"Calendar update failed: %@", callbackError];
      }
      [self updateUI];
    }];
    [self updateUI];
  }
}

- (void)deleteSelectedCalendar {
  GTLRCalendar_CalendarListEntry *selectedCalendarListEntry = [self selectedCalendarListEntry];
  if (selectedCalendarListEntry) {
    GTLRCalendarService *service = self.calendarService;

    NSString *calendarID = selectedCalendarListEntry.identifier;
    GTLRCalendarQuery_CalendarsDelete *query =
        [GTLRCalendarQuery_CalendarsDelete queryWithCalendarId:calendarID];

    self.editCalendarListTicket = [service executeQuery:query
                                      completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                          id nilObject, NSError *callbackError) {
      // Callback
      self.editCalendarListTicket = nil;
      if (callbackError == nil) {
        [self displayAlert:@"Deleted"
                    format:@"Deleted \"%@\"",
         selectedCalendarListEntry.summary];
        [self fetchCalendarList];
        [self updateUI];
      } else {
        [self displayAlert:@"Delete failed"
                    format:@"Delete failed: %@", callbackError];
      }
    }];
  }
}

#pragma mark Add, Edit, and Delete an Event

- (void)addAnEvent {
  // Make a new event, and show it to the user to edit
  GTLRCalendar_Event *newEvent = [GTLRCalendar_Event object];
  newEvent.summary = @"Sample Added Event";
  newEvent.descriptionProperty = @"Description of sample added event";

  // We'll set the start time to now, and the end time to an hour from now,
  // with a reminder 10 minutes before
  NSDate *anHourFromNow = [NSDate dateWithTimeIntervalSinceNow:(60 * 60)];

  // Include an offset minutes that tells Google Calendar that these dates
  // are for the local time zone.
  NSInteger offsetMinutes = [NSTimeZone localTimeZone].secondsFromGMT / 60;

  GTLRDateTime *startDateTime = [GTLRDateTime dateTimeWithDate:[NSDate date]
                                                 offsetMinutes:offsetMinutes];
  GTLRDateTime *endDateTime = [GTLRDateTime dateTimeWithDate:anHourFromNow
                                               offsetMinutes:offsetMinutes];

  newEvent.start = [GTLRCalendar_EventDateTime object];
  newEvent.start.dateTime = startDateTime;

  newEvent.end = [GTLRCalendar_EventDateTime object];
  newEvent.end.dateTime = endDateTime;

  GTLRCalendar_EventReminder *reminder = [GTLRCalendar_EventReminder object];
  reminder.minutes = @10;
  reminder.method = @"email";

  newEvent.reminders = [GTLRCalendar_Event_Reminders object];
  newEvent.reminders.overrides = @[ reminder ];
  newEvent.reminders.useDefault = @NO;

  // Display the event edit dialog
  EditEventWindowController *controller = [[EditEventWindowController alloc] init];
  [controller runModalForWindow:self.window
                          event:newEvent
              completionHandler:^(NSInteger returnCode, GTLRCalendar_Event *event) {
                // Callback
                if (returnCode == NSModalResponseOK) {
                  [self addEvent:event];
                }
              }];
}

- (void)addEvent:(GTLRCalendar_Event *)event {
  GTLRCalendarService *service = self.calendarService;
  GTLRCalendar_CalendarListEntry *selectedCalendar = [self selectedCalendarListEntry];
  NSString *calendarID = selectedCalendar.identifier;

  GTLRCalendarQuery_EventsInsert *query =
      [GTLRCalendarQuery_EventsInsert queryWithObject:event
                                           calendarId:calendarID];
  self.editEventTicket = [service executeQuery:query
                             completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                 GTLRCalendar_Event *event,
                                                 NSError *callbackError) {
     // Callback
     self.editEventTicket = nil;
     if (callbackError == nil) {
       [self displayAlert:@"Event Added"
                   format:@"Added event \"%@\"",
        event.summary];
       [self fetchSelectedCalendar];
     } else {
       [self displayAlert:@"Add failed"
                   format:@"Event add failed: %@", callbackError];
     }
     [self updateUI];
   }];
  [self updateUI];
}

- (void)editSelectedEvent {
  // Show the selected event to the user to edit
  GTLRCalendar_Event *eventToEdit = [self selectedEvent];
  if (eventToEdit) {
    EditEventWindowController *controller = [[EditEventWindowController alloc] init];
    [controller runModalForWindow:self.window
                            event:eventToEdit
                completionHandler:^(NSInteger returnCode, GTLRCalendar_Event *event) {
                  // Callback
                  if (returnCode == NSModalResponseOK) {
                    [self editSelectedEventWithEvent:event];
                  }
                }];
  }
}

- (void)editSelectedEventWithEvent:(GTLRCalendar_Event *)revisedEvent {
  GTLRCalendarService *service = self.calendarService;
  GTLRCalendar_CalendarListEntry *selectedCalendarListEntry = [self selectedCalendarListEntry];

  GTLRCalendar_Event *originalEvent = [self selectedEvent];
  GTLRCalendar_Event *patchEvent = [revisedEvent patchObjectFromOriginal:originalEvent];
  if (patchEvent) {
    NSString *calendarID = selectedCalendarListEntry.identifier;
    NSString *eventID = originalEvent.identifier;
    GTLRCalendarQuery_EventsPatch *query = [GTLRCalendarQuery_EventsPatch queryWithObject:patchEvent
                                                                               calendarId:calendarID
                                                                                  eventId:eventID];
    self.editEventTicket = [service executeQuery:query
                               completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                   GTLRCalendar_Event *event,
                                                   NSError *callbackError) {
       // Callback
       self.editEventTicket = nil;
       if (callbackError == nil) {
         [self displayAlert:@"Event Updated"
                     format:@"Patched event \"%@\"",
          event.summary];
         [self fetchSelectedCalendar];
       } else {
         [self displayAlert:@"Update failed"
                     format:@"Event patch failed: %@", callbackError];
       }
       [self updateUI];
     }];
    [self updateUI];
  }
}

- (void)deleteSelectedEvent {
  GTLRCalendarService *service = self.calendarService;

  GTLRCalendar_CalendarListEntry *selectedCalendarListEntry = [self selectedCalendarListEntry];
  NSString *calendarID = selectedCalendarListEntry.identifier;

  GTLRCalendar_Event *selectedEvent = [self selectedEvent];
  NSString *eventID = selectedEvent.identifier;

  if (calendarID && eventID) {
    GTLRCalendarQuery_EventsDelete *query =
        [GTLRCalendarQuery_EventsDelete queryWithCalendarId:calendarID
                                                    eventId:eventID];
    self.editEventTicket = [service executeQuery:query
                                      completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                          id nilObject,
                                                          NSError *callbackError) {
      // Callback
      self.editEventTicket = nil;
      if (callbackError == nil) {
        [self displayAlert:@"Event deleted"
                    format:@"Deleted \"%@\"",
         selectedEvent.summary];
        [self fetchSelectedCalendar];
      } else {
        [self displayAlert:@"Delete failed"
                    format:@"Event delete failed: %@", callbackError];
      }
      [self updateUI];
    }];
    [self updateUI];
  }
}

#pragma mark Query Events

// Utility routine to make a GTLRDateTime object for sometime today
- (GTLRDateTime *)dateTimeForTodayAtHour:(int)hour
                                 minute:(int)minute
                                 second:(int)second {

  NSUInteger const kComponentBits = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
      | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);

  NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

  NSDateComponents *dateComponents = [cal components:kComponentBits
                                            fromDate:[NSDate date]];
  dateComponents.hour = hour;
  dateComponents.minute = minute;
  dateComponents.second = second;
  dateComponents.timeZone = [NSTimeZone localTimeZone];

  GTLRDateTime *dateTime = [GTLRDateTime dateTimeWithDateComponents:dateComponents];
  return dateTime;
}

- (void)queryTodaysEvents {
  GTLRCalendar_CalendarListEntry *selectedCalendar = [self selectedCalendarListEntry];
  if (selectedCalendar) {
    NSString *calendarID = selectedCalendar.identifier;

    GTLRDateTime *startOfDay = [self dateTimeForTodayAtHour:0 minute:0 second:0];
    GTLRDateTime *endOfDay = [self dateTimeForTodayAtHour:23 minute:59 second:59];

    GTLRCalendarQuery_EventsList *query =
        [GTLRCalendarQuery_EventsList queryWithCalendarId:calendarID];
    query.maxResults = 10;
    query.timeMin = startOfDay;
    query.timeMax = endOfDay;

    // The service is set to fetch all pages, but for querying today's events,
    // we only want the first 10 results
    query.executionParameters.shouldFetchNextPages = @NO;

    GTLRCalendarService *service = self.calendarService;
    [service executeQuery:query
        completionHandler:^(GTLRServiceTicket *callbackTicket, GTLRCalendar_Acl *events,
                            NSError *callbackError) {
       // Callback
       if (callbackError == nil) {
         // Make a comma-separated list of event titles
         NSArray *titles = [events.items valueForKey:@"summary"];
         NSString *joined = [titles componentsJoinedByString:@", "];
         [self displayAlert:@"Today's Events"
                     format:@"Query result: %@", joined];
       } else {
         [self displayAlert:@"Query failed"
                     format:@"%@", callbackError];
       }
       [self updateUI];
     }];
  }
}

- (void)queryFreeBusy {
  GTLRCalendar_CalendarListEntry *selectedCalendar = [self selectedCalendarListEntry];
  if (selectedCalendar) {
    NSString *calendarID = selectedCalendar.identifier;

    GTLRDateTime *startOfDay = [self dateTimeForTodayAtHour:0 minute:0 second:0];
    GTLRDateTime *endOfDay = [self dateTimeForTodayAtHour:23 minute:59 second:59];

    GTLRCalendar_FreeBusyRequestItem *requestItem = [GTLRCalendar_FreeBusyRequestItem object];
    requestItem.identifier = calendarID;

    GTLRCalendar_FreeBusyRequest *freeBusyRequest = [GTLRCalendar_FreeBusyRequest object];
    freeBusyRequest.items = @[ requestItem ];
    freeBusyRequest.timeMin = startOfDay;
    freeBusyRequest.timeMax = endOfDay;

    GTLRCalendarQuery_FreebusyQuery *query =
        [GTLRCalendarQuery_FreebusyQuery queryWithObject:freeBusyRequest];

    // The service is set to fetch all pages, but for querying today's busy
    // periods, we only want the first 10 results
    query.executionParameters.shouldFetchNextPages = @NO;

    GTLRCalendarService *service = self.calendarService;
    [service executeQuery:query
        completionHandler:^(GTLRServiceTicket *callbackTicket,
                            GTLRCalendar_FreeBusyResponse *response,
                            NSError *callbackError) {
      // Callback
      if (callbackError == nil) {
        // Display a list of busy periods for the calendar account
        NSMutableString *displayStr = [NSMutableString string];

        GTLRCalendar_FreeBusyResponse_Calendars *responseCals = response.calendars;
        NSDictionary *props = responseCals.additionalProperties;

        // Step through the free-busy calendar IDs, and display each calendar
        // name (the summary field) and free/busy times
        for (NSString *calendarID in props) {
          GTLRCalendar_CalendarListEntry *calendar;
          calendar = [GTLRUtilities firstObjectFromArray:self.calendarList.items
                                               withValue:calendarID
                                              forKeyPath:@"identifier"];
          [displayStr appendFormat:@"%@: ", calendar.summary];

          GTLRCalendar_FreeBusyCalendar *calResponse = [props objectForKey:calendarID];
          NSArray *busyArray = calResponse.busy;
          for (GTLRCalendar_TimePeriod *period in busyArray) {
            GTLRDateTime *startTime = period.start;
            GTLRDateTime *endTime = period.end;
            NSString *startStr = [NSDateFormatter localizedStringFromDate:startTime.date
                                                                dateStyle:NSDateFormatterNoStyle
                                                                timeStyle:NSDateFormatterShortStyle];
            NSString *endStr = [NSDateFormatter localizedStringFromDate:endTime.date
                                                              dateStyle:NSDateFormatterNoStyle
                                                              timeStyle:NSDateFormatterShortStyle];
            [displayStr appendFormat:@"(%@-%@) ", startStr, endStr];
          }
        }

        [self displayAlert:@"Today's Busy Periods"
                    format:@"%@", displayStr];
      } else {
        [self displayAlert:@"Query failed"
                    format:@"%@", callbackError];
      }
      [self updateUI];
    }];
  }
}

#pragma mark Add, Edit, and Delete an ACL Rule

- (void)addAnACLRule {
  // Make a new ACL rule
  GTLRCalendar_AclRule_Scope *scope = [GTLRCalendar_AclRule_Scope object];
  scope.type = @"user";
  scope.value = @"mark.twain@example.com";

  GTLRCalendar_AclRule *newRule = [GTLRCalendar_AclRule object];
  newRule.role = @"reader";
  newRule.scope = scope;

  // Display the ACL edit dialog
  EditACLWindowController *controller = [[EditACLWindowController alloc] init];
  [controller runModalForWindow:self.window
                        ACLRule:newRule
              completionHandler:^(NSInteger returnCode, GTLRCalendar_AclRule *rule) {
    // Callback
    if (returnCode == NSModalResponseOK) {
      [self addACLRule:rule];
    }
  }];
}

- (void)addACLRule:(GTLRCalendar_AclRule *)aclRule {
  GTLRCalendarService *service = self.calendarService;
  GTLRCalendar_CalendarListEntry *selectedCalendar = [self selectedCalendarListEntry];
  NSString *calendarID = selectedCalendar.identifier;

  GTLRCalendarQuery_AclInsert *query = [GTLRCalendarQuery_AclInsert queryWithObject:aclRule
                                                                         calendarId:calendarID];
  self.editEventTicket = [service executeQuery:query
                             completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                 GTLRCalendar_AclRule *rule,
                                                 NSError *callbackError) {
     // Callback
     self.editEventTicket = nil;
     if (callbackError == nil) {
       [self displayAlert:@"Added"
                   format:@"Added ACL rule: %@",
        [self displayStringForACLRule:rule]];
       [self fetchSelectedCalendar];
     } else {
       [self displayAlert:@"Add failed"
                   format:@"ACL rule add failed: %@", callbackError];
     }
     [self updateUI];
   }];
  [self updateUI];
}

- (void)editSelectedACLRule {
  // Show the selected rule to the user to edit
  GTLRCalendar_AclRule *ruleToEdit = [self selectedACLRule];
  if (ruleToEdit) {
    EditACLWindowController *controller = [[EditACLWindowController alloc] init];
    [controller runModalForWindow:self.window
                          ACLRule:ruleToEdit
                completionHandler:^(NSInteger returnCode, GTLRCalendar_AclRule *rule) {
      // Callback
      if (returnCode == NSModalResponseOK) {
        [self editSelectedACLRuleWithRule:rule];
      }
    }];
  }
}

- (void)editSelectedACLRuleWithRule:(GTLRCalendar_AclRule *)revisedRule {
  GTLRCalendarService *service = self.calendarService;
  GTLRCalendar_CalendarListEntry *selectedCalendarListEntry = [self selectedCalendarListEntry];

  // We create an object reflecting just the changes from the original rule
  // needing to be patched
  GTLRCalendar_AclRule *originalRule = [self selectedACLRule];
  GTLRCalendar_AclRule *patchRule = [revisedRule patchObjectFromOriginal:originalRule];
  if (patchRule) {
    // If patchRule is non-nil, there are some fields to be changed
    NSString *calendarID = selectedCalendarListEntry.identifier;
    NSString *ruleID = originalRule.identifier;
    GTLRCalendarQuery_AclPatch *query = [GTLRCalendarQuery_AclPatch queryWithObject:patchRule
                                                                         calendarId:calendarID
                                                                             ruleId:ruleID];
    self.editEventTicket = [service executeQuery:query
                               completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                   GTLRCalendar_AclRule *rule,
                                                   NSError *callbackError) {
       // Callback
       self.editEventTicket = nil;
       if (callbackError == nil) {
         [self displayAlert:@"Rule Updated"
                     format:@"Patched rule \"%@\"",
          [self displayStringForACLRule:rule]];
         [self fetchSelectedCalendar];
       } else {
         [self displayAlert:@"Update Failed"
                     format:@"Rule patch failed: %@", callbackError];
       }
       [self updateUI];
     }];
    [self updateUI];
  }
}

- (void)deleteSelectedACLRule {
  GTLRCalendarService *service = self.calendarService;

  GTLRCalendar_CalendarListEntry *selectedCalendarListEntry = [self selectedCalendarListEntry];
  NSString *calendarID = selectedCalendarListEntry.identifier;

  GTLRCalendar_AclRule *selectedACLRule = [self selectedACLRule];
  NSString *ruleID = selectedACLRule.identifier;

  if (calendarID && ruleID) {
    GTLRCalendarQuery_AclDelete *query = [GTLRCalendarQuery_AclDelete queryWithCalendarId:calendarID
                                                                                   ruleId:ruleID];
    self.editEventTicket = [service executeQuery:query
                               completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                   id nilObject, NSError *callbackError) {
       // Callback
       self.editEventTicket = nil;
       if (callbackError == nil) {
         [self displayAlert:@"ACL Rule Deleted"
                     format:@"Deleted \"%@\"",
          [self displayStringForACLRule:selectedACLRule]];
         [self fetchSelectedCalendar];
       } else {
         [self displayAlert:@"Delete Failed"
                     format:@"Rule delete failed: %@", callbackError];
       }
       [self updateUI];
     }];
    [self updateUI];
  }
}

#pragma mark Sign In

- (void)runSigninThenInvokeSelector:(SEL)signInDoneSel {
    // Applications should have client ID hardcoded into the source
    // but the sample application asks the developer for the strings.
    // Client secret is now left blank.

  NSString *clientID = _clientIDField.stringValue;
  NSString *clientSecret = _clientSecretField.stringValue;

  if (clientID.length == 0) {
    // Remind the developer that client ID is needed.  Client Secret is now left blank
    [_clientIDButton performSelector:@selector(performClick:)
                          withObject:self
                          afterDelay:0.5];
    return;
  }

  NSURL *successURL = [NSURL URLWithString:kSuccessURLString];

  // Starts a loopback HTTP listener to receive the code, gets the redirect URI to be used.
  _redirectHTTPHandler = [[OIDRedirectHTTPHandler alloc] initWithSuccessURL:successURL];
  NSError *error;
  NSURL *localRedirectURI = [_redirectHTTPHandler startHTTPListener:&error];
  if (!localRedirectURI) {
    NSLog(@"Unexpected error starting redirect handler %@", error);
    return;
  }

  // Builds authentication request.
  OIDServiceConfiguration *configuration =
      [GTMAppAuthFetcherAuthorization configurationForGoogle];
  NSArray<NSString *> *scopes = @[ kGTLRAuthScopeCalendar, OIDScopeEmail ];
  OIDAuthorizationRequest *request =
      [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                    clientId:clientID
                                                clientSecret:clientSecret
                                                      scopes:scopes
                                                 redirectURL:localRedirectURI
                                                responseType:OIDResponseTypeCode
                                        additionalParameters:nil];

  // performs authentication request
    // Using the weakSelf pattern to avoid retaining self as block execution is indeterminate.
  __weak __typeof(self) weakSelf = self;
  _redirectHTTPHandler.currentAuthorizationFlow =
      [OIDAuthState authStateByPresentingAuthorizationRequest:request
                  presentingWindow:self.window
                          callback:^(OIDAuthState *_Nullable authState,
                                     NSError *_Nullable error) {
    // Brings this app to the foreground.
    [[NSRunningApplication currentApplication]
        activateWithOptions:(NSApplicationActivateAllWindows |
                             NSApplicationActivateIgnoringOtherApps)];

    if (authState) {
      // Creates a GTMAppAuthFetcherAuthorization object for authorizing requests.
      GTMAppAuthFetcherAuthorization *gtmAuthorization =
          [[GTMAppAuthFetcherAuthorization alloc] initWithAuthState:authState];

      // Sets the authorizer on the GTLRYouTubeService object so API calls will be authenticated.
      weakSelf.calendarService.authorizer = gtmAuthorization;

      // Serializes authorization to keychain in GTMAppAuth format.
      [GTMAppAuthFetcherAuthorization saveAuthorization:gtmAuthorization
                                      toKeychainForName:kGTMAppAuthKeychainItemName];

      // Callback
      if (signInDoneSel) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [weakSelf performSelector:signInDoneSel];
#pragma clang diagnostic pop
      }
    } else {
      weakSelf.calendarListFetchError = error;
      [weakSelf updateUI];
    }
  }];
}

#pragma mark UI

- (NSString *)displayStringForACLRule:(GTLRCalendar_AclRule *)rule  {
  // Make a concise, readable string showing the scope type, scope value,
  // and role value for an ACL entry, like:
  //
  //    scope: user "fred@flintstone.com"  role:owner

  NSMutableString *resultStr = [NSMutableString string];

  GTLRCalendar_AclRule_Scope *scope = rule.scope;
  if (scope) {
    NSString *type = (scope.type ? scope.type : @"");
    NSString *value = @"";
    if (scope.value) {
      value = [NSString stringWithFormat:@"\"%@\"", scope.value];
    }
    [resultStr appendFormat:@"scope: %@ %@  ", type, value];
  }

  NSString *role = rule.role;
  if (role) {
    [resultStr appendFormat:@"role: %@", role];
  }
  return resultStr;
}

- (void)updateUI {
  BOOL isSignedIn = [self isSignedIn];
  NSString *username = [self signedInUsername];
  _signedInButton.title = (isSignedIn ? @"Sign Out" : @"Sign In");
  _signedInField.stringValue = (isSignedIn ? username : @"No");

  //
  // CalendarList table
  //
  [_calendarTable reloadData];

  if (self.calendarListTicket != nil || self.editCalendarListTicket != nil) {
    [_calendarProgressIndicator startAnimation:self];
  } else {
    [_calendarProgressIndicator stopAnimation:self];
  }

  // Get the description of the selected item, or the feed fetch error
  NSString *resultStr = @"";

  if (self.calendarListFetchError) {
    // Display the error
    resultStr = [self.calendarListFetchError description];

    // Also display any server data present
    NSData *errData =
        [[self.calendarListFetchError userInfo] objectForKey:kGTMSessionFetcherStatusDataKey];
    if (errData) {
      NSString *dataStr = [[NSString alloc] initWithData:errData
                                                encoding:NSUTF8StringEncoding];
      resultStr = [resultStr stringByAppendingFormat:@"\n%@", dataStr];
    }
  } else {
    // Display the selected item
    GTLRCalendar_CalendarListEntry *item = [self selectedCalendarListEntry];
    if (item) {
      resultStr = item.description;
    }
  }
  _calendarResultTextField.string = resultStr;

  //
  // Events list
  //
  [_eventTable reloadData];

  if (self.eventsTicket != nil || self.editEventTicket != nil) {
    [_eventProgressIndicator startAnimation:self];
  } else {
    [_eventProgressIndicator stopAnimation:self];
  }

  // Get the description of the selected item, or the feed fetch error
  resultStr = @"";
  switch (_entrySegmentedControl.selectedSegment) {
    case kEventsSegment:
      if (self.eventsFetchError) {
        resultStr = [self.eventsFetchError description];
      } else {
        GTLRCalendar_Event *item = [self selectedEvent];
        if (item) {
          resultStr = item.description;
        }
      }
      break;
    case kAccessControlSegment:
      if (self.ACLsFetchError) {
        resultStr = [self.ACLsFetchError description];
      } else {
        GTLRCalendar_AclRule *item = [self selectedACLRule];
        if (item) {
          resultStr = item.description;
        }
      }
      break;
    case kSettingsSegment:
      if (self.settingsFetchError) {
        resultStr = [self.settingsFetchError description];
      } else {
        GTLRCalendar_Setting *item = [self selectedSetting];
        if (item) {
          resultStr = item.description;
        }
      }
      break;
    default: break;
  }

  _eventResultTextField.string = resultStr;

  // Enable buttons
  BOOL isFetchingCalendars = (self.calendarListTicket != nil);
  BOOL isEditingCalendar = (self.editCalendarListTicket != nil);
  _calendarCancelButton.enabled = (isFetchingCalendars || isEditingCalendar);

  BOOL isFetchingEvents = (self.eventsTicket != nil);
  BOOL isEditingEvent = (self.editEventTicket != nil);
  _eventCancelButton.enabled = (isFetchingEvents || isEditingEvent);

  BOOL isCalendarSelected = ([self selectedCalendarListEntry] != nil);
  BOOL hasNewName = (_calendarNameField.stringValue.length > 0);
  _addCalendarButton.enabled = (isSignedIn && hasNewName);
  _renameCalendarButton.enabled = (isSignedIn && isCalendarSelected && hasNewName);
  _deleteCalendarButton.enabled = (isSignedIn && isCalendarSelected);

  NSInteger segment = _entrySegmentedControl.selectedSegment;
  BOOL isEventsSegmentSelected = (segment == kEventsSegment);
  BOOL isACLsSegmentSelected = (segment == kAccessControlSegment);

  if (isEventsSegmentSelected) {
    // Events
    BOOL isEventSelected = ([self selectedEvent] != nil);

    _addEntryButton.enabled = isCalendarSelected;
    _editEntryButton.enabled = isEventSelected;
    _deleteEntriesButton.enabled = isEventSelected;
  } else if (isACLsSegmentSelected) {
    // ACLs
    BOOL isACLSelected = ([self selectedACLRule] != nil);

    _addEntryButton.enabled = isCalendarSelected;
    _editEntryButton.enabled = isACLSelected;
    _deleteEntriesButton.enabled = isACLSelected;
  } else {
    // Settings
    _addEntryButton.enabled = NO;
    _editEntryButton.enabled = NO;
    _deleteEntriesButton.enabled = NO;
  }

  _queryTodaysEventsButton.enabled = isCalendarSelected;
  _queryFreeBusyButton.enabled = isCalendarSelected;

  // Show or hide the text indicating that the client ID or client secret are
  // needed
  BOOL hasClientIDStrings = _clientIDField.stringValue.length > 0
    && _clientSecretField.stringValue.length > 0;
   _clientIDRequiredTextField.hidden = hasClientIDStrings;
}

- (void)displayAlert:(NSString *)title format:(NSString *)format, ... {
  NSString *result = format;
  if (format) {
    va_list argList;
    va_start(argList, format);
    result = [[NSString alloc] initWithFormat:format
                                    arguments:argList];
    va_end(argList);
  }
  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText = title;
  alert.informativeText = result;
  [alert beginSheetModalForWindow:self.window
                completionHandler:nil];
}

#pragma mark Client ID Sheet

// Client ID and Client Secret Sheet
//
// Sample apps need this sheet to ask for the client ID and client secret
// strings
//
// Your application will just hardcode the client ID and client secret strings
// into the source rather than ask the user for them.
//
// The string values are obtained from the API Console,
// https://console.developers.google.com/

- (IBAction)clientIDClicked:(id)sender {
  // Show the sheet for developers to enter their client ID and client secret
  [self.window beginSheet:_clientIDSheet completionHandler:nil];
}

- (IBAction)clientIDDoneClicked:(id)sender {
  [self.window endSheet:[sender window]];
}

#pragma mark Text field delegate methods

- (void)controlTextDidChange:(NSNotification *)note {
  [self updateUI];  // enable and disable buttons
}

#pragma mark TableView delegate and data source methods

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
  if ([notification object] == _calendarTable) {
    // The calendar list selection changed
    [self fetchSelectedCalendar];
  } else {
    // The event list selection changed
    [self updateUI];
  }
}

// Table view data source methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  if (tableView == _calendarTable) {
    return self.calendarList.items.count;
  } else {
    switch (_entrySegmentedControl.selectedSegment) {
      case kEventsSegment:        return self.events.items.count;
      case kAccessControlSegment: return self.ACLs.items.count;
      case kSettingsSegment:      return self.settings.items.count;
      default: return 0;
    }
  }
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(int)row {
  if (tableView == _calendarTable) {
    // Calendar table
    GTLRCalendar_Calendar *calendar = self.calendarList[row];
    NSString *str = calendar.summary;
    return str;
  } else {
    // Events/ACLs/Settings table
    switch (_entrySegmentedControl.selectedSegment) {
      case kEventsSegment: {
        GTLRCalendar_Event *event = self.events[row];
        NSString *str = event.summary;
        return str;
      }
      case kAccessControlSegment:  {
        GTLRCalendar_AclRule *rule = self.ACLs[row];
        NSString *str = [self displayStringForACLRule:rule];
        return str;
      }
      case kSettingsSegment: {
        GTLRCalendar_Setting *setting = self.settings[row];
        NSString *str = [NSString stringWithFormat:@"%@: %@", setting.identifier, setting.value];
        return str;
      }
      default:
        return nil;
    }
  }
}

@end
