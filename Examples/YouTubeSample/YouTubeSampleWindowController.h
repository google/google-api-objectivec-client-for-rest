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
//  YouTubeSampleWindowController.h
//

// The sample app controllers are built with ARC, though the sources of
// the GTLR library should be built without ARC using the compiler flag
// -fno-objc-arc in the Compile Sources build phase of the application
// target.

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import <Cocoa/Cocoa.h>

#import "GTLRYouTube.h"


@interface YouTubeSampleWindowController : NSWindowController {
 @private
  IBOutlet NSTextField *_signedInField;
  IBOutlet NSButton *_signedInButton;

  IBOutlet NSButton *_fetchPlaylistButton;
  IBOutlet NSPopUpButton *_playlistPopup;
  IBOutlet NSTableView *_playlistItemTable;
  IBOutlet NSProgressIndicator *_playlistProgressIndicator;
  IBOutlet NSTextView *_playlistResultTextField;
  IBOutlet NSButton *_playlistCancelButton;
  IBOutlet NSImageView *_thumbnailView;

  IBOutlet NSTextField *_uploadPathField;
  IBOutlet NSTextField *_uploadTitleField;
  IBOutlet NSTextField *_uploadDescriptionField;
  IBOutlet NSTextField *_uploadTagsField;
  IBOutlet NSPopUpButton *_uploadPrivacyPopup;
  IBOutlet NSPopUpButton *_uploadCategoryPopup;
  IBOutlet NSButton *_uploadButton;
  IBOutlet NSButton *_pauseUploadButton;
  IBOutlet NSButton *_stopUploadButton;
  IBOutlet NSButton *_restartUploadButton;
  IBOutlet NSProgressIndicator *_uploadProgressIndicator;

  // Client ID Sheet (Not needed by real applications)
  IBOutlet NSButton *_clientIDButton;
  IBOutlet NSTextField *_clientIDRequiredTextField;
  IBOutlet NSWindow *_clientIDSheet;
  IBOutlet NSTextField *_clientIDField;
  IBOutlet NSTextField *_clientSecretField;
}

+ (YouTubeSampleWindowController *)sharedWindowController;

- (IBAction)signInClicked:(id)sender;

- (IBAction)getPlaylist:(id)sender;
- (IBAction)cancelPlaylistFetch:(id)sender;
- (IBAction)playlistPopupClicked:(id)sender;

- (IBAction)chooseFileClicked:(id)sender;
- (IBAction)uploadClicked:(id)sender;
- (IBAction)pauseUploadClicked:(id)sender;
- (IBAction)stopUploadClicked:(id)sender;
- (IBAction)restartUploadClicked:(id)sender;

- (IBAction)loggingCheckboxClicked:(id)sender;

// Client ID Sheet
- (IBAction)clientIDClicked:(id)sender;
- (IBAction)clientIDDoneClicked:(id)sender;
- (IBAction)APIConsoleClicked:(id)sender;

@end
