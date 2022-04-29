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
//  EditACLWindowController.m
//

#import "EditACLWindowController.h"

@implementation EditACLWindowController {
  void (^completionHandler_)(NSInteger returnCode, GTLRCalendar_AclRule *rule);

  GTLRCalendar_AclRule *_rule;
}

- (id)init {
  return [self initWithWindowNibName:@"EditACLWindow"];
}

- (void)awakeFromNib {
  if (_rule) {
    // Copy data from the ACL entry to our dialog's controls
    NSString *scopeType = _rule.scope.type;
    NSString *scopeValue = _rule.scope.value;
    NSString *roleValue = _rule.role;

    if (scopeType) _scopeTypeField.stringValue = scopeType;
    if (scopeValue) _scopeValueField.stringValue = scopeValue;
    if (roleValue) _roleValueField.stringValue = roleValue;

    // Add standard calendar roles to the combo box's menu
    NSArray *items = @[
      kGTLRCalendarMinAccessRoleOwner,
      kGTLRCalendarMinAccessRoleWriter,
      kGTLRCalendarMinAccessRoleReader,
      kGTLRCalendarMinAccessRoleFreeBusyReader
    ];
    [_roleValueField addItemsWithObjectValues:items];
  }
}

- (GTLRCalendar_AclRule *)rule {
  // Copy from our dialog's controls into a copy of the original object
  NSString *scopeType = _scopeTypeField.stringValue;
  NSString *scopeValue = _scopeValueField.stringValue;
  NSString *roleValue = _roleValueField.stringValue;

  GTLRCalendar_AclRule *rule;
  if (_rule) {
    rule = [_rule copy];
  } else {
    rule = [GTLRCalendar_AclRule object];
  }

  rule.role = roleValue;
  rule.scope.value = scopeValue;
  rule.scope.type = scopeType;

  return rule;
}

#pragma mark -

- (void)runModalForWindow:(NSWindow *)window
                  ACLRule:(GTLRCalendar_AclRule *)rule
        completionHandler:(void (^)(NSInteger returnCode, GTLRCalendar_AclRule *rule))handler {
  completionHandler_ = [handler copy];
  _rule = rule;

  __block id holdSelf = self;
  [window beginSheet:self.window completionHandler:^(NSModalResponse returnCode) {
    (void)holdSelf;
    holdSelf = nil;
  }];
}

- (void)sheetDidEnd:(NSWindow *)sheet
         returnCode:(int)returnCode
        contextInfo:(void  *)contextInfo {
}

- (void)closeDialogWithReturnCode:(NSInteger)returnCode {
  // Call the handler to say we're done
  if (completionHandler_) {
    completionHandler_(returnCode, [self rule]);
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
