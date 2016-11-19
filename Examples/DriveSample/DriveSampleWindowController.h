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
//  DriveSampleWindowController.h
//

// The sample app controllers are built with ARC, though the sources of
// the GTLR library should be built without ARC using the compiler flag
// -fno-objc-arc in the Compile Sources build phase of the application
// target.

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import <Cocoa/Cocoa.h>

#import "GTLRDrive.h"

@interface DriveSampleWindowController : NSWindowController {
 @private
  IBOutlet NSTextField *_signedInField;
  IBOutlet NSButton *_signedInButton;

  IBOutlet NSTableView *_fileListTable;
  IBOutlet NSProgressIndicator *_fileListProgressIndicator;
  IBOutlet NSTextView *_fileListResultTextField;
  IBOutlet NSButton *_fileListCancelButton;
  IBOutlet NSImageView *_thumbnailView;

  IBOutlet NSButton *_exportAsPDFButton;
  IBOutlet NSButton *_downloadButton;
  IBOutlet NSButton *_viewButton;
  IBOutlet NSButton *_duplicateButton;
  IBOutlet NSButton *_trashButton;
  IBOutlet NSButton *_deleteButton;

  IBOutlet NSButton *_uploadButton;
  IBOutlet NSProgressIndicator *_uploadProgressIndicator;
  IBOutlet NSButton *_pauseUploadButton;
  IBOutlet NSButton *_stopUploadButton;
  IBOutlet NSButton *_newFolderButton;

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

+ (DriveSampleWindowController *)sharedWindowController;

- (IBAction)signInClicked:(id)sender;

- (IBAction)getFileList:(id)sender;

- (IBAction)cancelFileListFetch:(id)sender;

- (IBAction)viewClicked:(id)sender;
- (IBAction)duplicateClicked:(id)sender;
- (IBAction)trashClicked:(id)sender;
- (IBAction)deleteClicked:(id)sender;
- (IBAction)exportAsPDFClicked:(id)sender;
- (IBAction)downloadClicked:(id)sender;

- (IBAction)uploadFileClicked:(id)sender;
- (IBAction)pauseUploadClicked:(id)sender;
- (IBAction)stopUploadClicked:(id)sender;
- (IBAction)createFolderClicked:(id)sender;

- (IBAction)segmentedControlClicked:(id)sender;

- (IBAction)loggingCheckboxClicked:(id)sender;

// Client ID Sheet
- (IBAction)clientIDClicked:(id)sender;
- (IBAction)clientIDDoneClicked:(id)sender;
- (IBAction)APIConsoleClicked:(id)sender;

@end
