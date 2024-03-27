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

//
//  StorageSampleWindowController.h
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import <Cocoa/Cocoa.h>

#import <GoogleAPIClientForREST/GTLRStorage.h>

@interface StorageSampleWindowController : NSWindowController {
 @private
  IBOutlet NSTextField *_signedInField;
  IBOutlet NSButton *_signedInButton;

  IBOutlet NSTextField *_projectField;
  IBOutlet NSButton *_bucketListButton;
  IBOutlet NSTableView *_bucketListTable;
  IBOutlet NSProgressIndicator *_bucketListProgressIndicator;
  IBOutlet NSTextView *_bucketListResultTextField;
  IBOutlet NSButton *_bucketListCancelButton;

  IBOutlet NSButton *_bucketAddButton;
  IBOutlet NSWindow *_bucketAddSheet;
  IBOutlet NSTextField *_bucketAddName;
  IBOutlet NSButton *_bucketDeleteButton;

  IBOutlet NSButtonCell *_downloadButton;

  IBOutlet NSButton *_uploadButton;
  IBOutlet NSProgressIndicator *_uploadProgressIndicator;
  IBOutlet NSButton *_pauseUploadButton;
  IBOutlet NSButton *_stopUploadButton;

  IBOutlet NSSegmentedControl *_segmentedControl;
  IBOutlet NSTableView *_detailTable;
  IBOutlet NSProgressIndicator *_detailProgressIndicator;
  IBOutlet NSTextView *_detailResultTextField;
  IBOutlet NSButton *_detailCancelButton;

  // Client ID Sheet (Not needed by real applications)
  IBOutlet NSButton *_clientIDButton;
  IBOutlet NSTextField *_clientIDRequiredTextField;
  IBOutlet NSWindow *_clientIDSheet;
  IBOutlet NSTextField *_clientIDField;
  IBOutlet NSTextField *_clientSecretField;
}

+ (StorageSampleWindowController *)sharedWindowController;

- (IBAction)signInClicked:(id)sender;

- (IBAction)addBucketClicked:(id)sender;
- (IBAction)addBucketCancelClicked:(id)sender;
- (IBAction)addBucketAddClicked:(id)sender;
- (IBAction)deleteBucketClicked:(id)sender;

- (IBAction)uploadFileClicked:(id)sender;
- (IBAction)pauseUploadClicked:(id)sender;
- (IBAction)stopUploadClicked:(id)sender;
- (IBAction)downloadFileClicked:(id)sender;

- (IBAction)segmentedControlClicked:(id)sender;

- (IBAction)loggingCheckboxClicked:(id)sender;

// Client ID Sheet
- (IBAction)clientIDClicked:(id)sender;
- (IBAction)clientIDDoneClicked:(id)sender;
- (IBAction)APIConsoleClicked:(id)sender;

@end
