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
//  EditACLWindowController.h
//

#import <Cocoa/Cocoa.h>

#import "GTLRCalendar.h"

@interface EditACLWindowController : NSWindowController {
 @private
  IBOutlet NSComboBox *_scopeTypeField;
  IBOutlet NSTextField *_scopeValueField;
  IBOutlet NSComboBox *_roleValueField;
}

- (void)runModalForWindow:(NSWindow *)window
                  ACLRule:(GTLRCalendar_AclRule *)rule
        completionHandler:(void (^)(NSInteger returnCode, GTLRCalendar_AclRule *rule))handler;

- (IBAction)saveButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
@end
