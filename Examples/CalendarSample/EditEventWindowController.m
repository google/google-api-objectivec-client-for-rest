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
//  EditEventWindowController.m
//

#import "EditEventWindowController.h"

@implementation EditEventWindowController {
  void (^completionHandler_)(NSInteger returnCode, GTLRCalendar_Event *event);

  GTLRCalendar_Event *_event;
}

- (id)init {
  return [self initWithWindowNibName:@"EditEventWindow"];
}

- (void)awakeFromNib {
  if (_event) {
    // Copy data from the event to our dialog's controls
    NSString *title = _event.summary;
    NSString *desc = _event.descriptionProperty;

    // The Calendar API may provide a date-time with time value in the dateTime property,
    // or a date only in the date property.
    GTLRDateTime *startTime = _event.start.dateTime ?: _event.start.date;
    GTLRDateTime *endTime = _event.end.dateTime ?: _event.end.date;

    // Events may provide a list of reminders to override the calendar's
    // default reminders
    BOOL shouldUseDefaultReminders = _event.reminders.useDefault.boolValue;

    NSString *reminderMinutesStr = @"";
    NSString *reminderMethod = nil;
    if (!shouldUseDefaultReminders) {
      NSArray *reminders = _event.reminders.overrides;
      GTLRCalendar_EventReminder *reminder = reminders.firstObject;
      if (reminder) {
        reminderMinutesStr = reminder.minutes.stringValue;
        reminderMethod = reminder.method;
      }
    }

    if (title) _titleField.stringValue = title;
    if (desc) _descriptionField.stringValue = desc;

    if (startTime) {
      _startDatePicker.dateValue = startTime.date;
      _startDatePicker.timeZone =
          [NSTimeZone timeZoneForSecondsFromGMT:(startTime.offsetMinutes.integerValue * 60)];
    }
    if (endTime) {
      _endDatePicker.dateValue = endTime.date;
      _endDatePicker.timeZone =
          [NSTimeZone timeZoneForSecondsFromGMT:(endTime.offsetMinutes.integerValue * 60)];
    }

    [_reminderMatrix selectCellWithTag:(shouldUseDefaultReminders ? 0 : 1)];
    _reminderMinutesField.stringValue = reminderMinutesStr;
    [_reminderMethodPopup selectItemWithTitle:reminderMethod];
  }
}

#pragma mark -

- (GTLRCalendar_Event *)event {
  // Copy from our dialog's controls into a copy of the original event
  NSString *title = _titleField.stringValue;
  NSString *desc = _descriptionField.stringValue;
  NSString *reminderMinStr = _reminderMinutesField.stringValue;
  NSString *reminderMethod = _reminderMethodPopup.selectedItem.title;
  BOOL shouldUseDefaultReminders = (_reminderMatrix.selectedCell.tag == 0);

  GTLRCalendar_Event *newEvent;
  if (_event) {
    newEvent = [_event copy];
  } else {
    newEvent = [GTLRCalendar_Event object];
  }

  newEvent.summary = title;
  newEvent.descriptionProperty = desc;

  // Times
  //
  // For all-day events, use the GTLRDateTime method +dateTimeForAllDayWithDate:
  GTLRDateTime *startDateTime =
      [GTLRDateTime dateTimeWithDate:_startDatePicker.dateValue
                       offsetMinutes:(_startDatePicker.timeZone.secondsFromGMT / 60)];
  GTLRDateTime *endDateTime =
      [GTLRDateTime dateTimeWithDate:_endDatePicker.dateValue
                       offsetMinutes:(_endDatePicker.timeZone.secondsFromGMT / 60)];
  newEvent.start.dateTime = startDateTime;
  newEvent.end.dateTime = endDateTime;

  // Reminders
  newEvent.reminders = [GTLRCalendar_Event_Reminders object];
  newEvent.reminders.useDefault = @(shouldUseDefaultReminders);
  if (!shouldUseDefaultReminders) {
    GTLRCalendar_EventReminder *reminder = [GTLRCalendar_EventReminder object];
    reminder.minutes = @(reminderMinStr.intValue);
    reminder.method = reminderMethod;

    newEvent.reminders.overrides = [NSArray arrayWithObject:reminder];
  }
  return newEvent;
}

- (void)runModalForWindow:(NSWindow *)window
                    event:(GTLRCalendar_Event *)event
        completionHandler:(void (^)(NSInteger returnCode, GTLRCalendar_Event *event))handler {
  completionHandler_ = [handler copy];
  _event = event;
  __block id holdSelf = self;

  [window beginSheet:self.window completionHandler:^(NSModalResponse returnCode) {
    holdSelf = nil;
  }];
}

- (void)closeDialogWithReturnCode:(NSInteger)returnCode {
  // Call the handler to say we're done
  if (completionHandler_) {
    completionHandler_(returnCode, [self event]);
    completionHandler_ = nil;
  }

  NSWindow *sheet = self.window;
  NSWindow *parent = sheet.sheetParent;
  [parent endSheet:sheet];
}

- (IBAction)saveButtonClicked:(id)sender {
  [self closeDialogWithReturnCode:NSModalResponseOK];
}

- (IBAction)cancelButtonClicked:(id)sender {
  [self closeDialogWithReturnCode:NSModalResponseCancel];
}

@end
