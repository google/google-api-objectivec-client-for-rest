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
//  YouTubeSampleWindowController.m
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "YouTubeSampleWindowController.h"

#import <AppAuth/AppAuth.h>
#import <GTMAppAuth/GTMAppAuth.h>
#import <GTMSessionFetcher/GTMSessionUploadFetcher.h>
#import <GTMSessionFetcher/GTMSessionFetcherLogging.h>
#import <GoogleAPIClientForREST/GTLRUtilities.h>

enum {
  // Playlist pop-up menu item tags.
  kUploadsTag = 0,
  kLikesTag = 1,
  kFavoritesTag = 2,
  kWatchHistoryTag = 3,
  kWatchLaterTag = 4
};

// This is the URL shown users after completing the OAuth flow. This is an information page only and
// is not part of the authorization protocol. You can replace it with any URL you like.
// We recommend at a minimum that the page displayed instructs users to return to the app.
static NSString *const kSuccessURLString = @"http://openid.github.io/AppAuth-iOS/redirect/";

// Keychain item name for saving the user's authentication information.
NSString *const kGTMAppAuthKeychainItemName = @"YouTubeSample: YouTube. GTMAppAuth";

@interface YouTubeSampleWindowController ()
// Accessor for the app's single instance of the service object.
@property (nonatomic, readonly) GTLRYouTubeService *youTubeService;
@end

@implementation YouTubeSampleWindowController {
  GTLRYouTube_ChannelContentDetails_RelatedPlaylists *_myPlaylists;
  GTLRServiceTicket *_channelListTicket;
  NSError *_channelListFetchError;

  GTLRYouTube_PlaylistItemListResponse *_playlistItemList;
  GTLRServiceTicket *_playlistItemListTicket;
  NSError *_playlistFetchError;

  GTLRServiceTicket *_uploadFileTicket;
  NSURL *_uploadLocationURL;  // URL for restarting an upload.

  OIDRedirectHTTPHandler *_redirectHTTPHandler;
}

+ (YouTubeSampleWindowController *)sharedWindowController {
  static YouTubeSampleWindowController* gWindowController = nil;
  if (!gWindowController) {
    gWindowController = [[YouTubeSampleWindowController alloc] init];
  }
  return gWindowController;
}

- (id)init {
  return [self initWithWindowNibName:@"YouTubeSampleWindow"];
}

- (void)awakeFromNib {
  // Attempts to deserialize authorization from keychain in GTMAppAuth format.
  id<GTMFetcherAuthorizationProtocol> authorization =
      [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kGTMAppAuthKeychainItemName];
  self.youTubeService.authorizer = authorization;

  // Set the result text fields to have a distinctive color and mono-spaced font.
  _playlistResultTextField.textColor = [NSColor darkGrayColor];

  NSFont *resultTextFont = [NSFont fontWithName:@"Monaco" size:9];
  _playlistResultTextField.font = resultTextFont;

  _uploadPathField.stringValue = @"";

  // Fetch the list of categories for video uploads.
  _uploadCategoryPopup.enabled = NO;

  [self updateUI];
}

#pragma mark -

- (NSString *)signedInUsername {
  // Get the email address of the signed-in user.
  id<GTMFetcherAuthorizationProtocol> auth = self.youTubeService.authorizer;
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
    // Sign in.
    [self runSigninThenHandler:^{
      [self updateUI];
    }];
  } else {
    // Sign out.
    GTLRYouTubeService *service = self.youTubeService;

    [GTMAppAuthFetcherAuthorization
        removeAuthorizationFromKeychainForName:kGTMAppAuthKeychainItemName];
    service.authorizer = nil;
    [self updateUI];
  }
}

- (IBAction)getPlaylist:(id)sender {
  void (^getPlaylist)(void) = ^{
    if (self->_myPlaylists == nil) {
      [self fetchMyChannelList];
    } else {
      [self fetchSelectedPlaylist];
    }
  };

  if (![self isSignedIn]) {
    [self runSigninThenHandler:getPlaylist];
  } else {
    getPlaylist();
  }
}

- (IBAction)playlistPopupClicked:(id)sender {
  [self getPlaylist:sender];
}

- (IBAction)cancelPlaylistFetch:(id)sender {
  [_channelListTicket cancelTicket];
  _channelListTicket = nil;

  [_playlistItemListTicket cancelTicket];
  _playlistItemListTicket = nil;

  [self updateUI];
}

- (IBAction)chooseFileClicked:(id)sender {
  // Ask the user to choose a video file for uploading.
  NSOpenPanel *openPanel = [NSOpenPanel openPanel];
  openPanel.prompt = @"Choose";

  openPanel.allowedFileTypes = @[ @"mov", @"mp4" ];
  [openPanel beginSheetModalForWindow:self.window
                    completionHandler:^(NSInteger result) {
    // Callback
    if (result == NSFileHandlingPanelOKButton) {
      // The user chose a file.
      NSString *path = openPanel.URL.path;
      self->_uploadPathField.stringValue = path;

      if (self->_uploadTitleField.stringValue.length == 0) {
        self->_uploadTitleField.stringValue = path.lastPathComponent;
      }

      [self updateUI]; // Update UI in case we need to enable the upload button.
    }
  }];
}

- (IBAction)uploadClicked:(id)sender {
  [self uploadVideoFile];
}

- (IBAction)pauseUploadClicked:(id)sender {
  if ([_uploadFileTicket isUploadPaused]) {
    // Resume from pause.
    [_uploadFileTicket resumeUpload];
  } else {
    // Pause.
    [_uploadFileTicket pauseUpload];
  }

  [self updateUI];
}

- (IBAction)stopUploadClicked:(id)sender {
  [_uploadFileTicket cancelTicket];
  _uploadFileTicket = nil;

  _uploadProgressIndicator.doubleValue = 0.0;
  [self updateUI];
}

- (IBAction)restartUploadClicked:(id)sender {
  [self restartUpload];
}

- (IBAction)APIConsoleClicked:(id)sender {
  NSURL *url = [NSURL URLWithString:@"https://console.developers.google.com/"];
  [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)loggingCheckboxClicked:(NSButton *)sender {
  [GTMSessionFetcher setLoggingEnabled:[sender state]];
}

#pragma mark -

// Get a service object with the current username/password.
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information such as cookies set by the server in response
// to queries.

- (GTLRYouTubeService *)youTubeService {
  static GTLRYouTubeService *service;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service = [[GTLRYouTubeService alloc] init];

    // Have the service object set tickets to fetch consecutive pages
    // of the feed so we do not need to manually fetch them.
    service.shouldFetchNextPages = YES;

    // Have the service object set tickets to retry temporary error conditions
    // automatically.
    service.retryEnabled = YES;
  });
  return service;
}

- (GTLRYouTube_PlaylistItem *)selectedPlaylistItem {
  NSInteger row = [_playlistItemTable selectedRow];
  if (row < 0) return nil;

  GTLRYouTube_PlaylistItem *item = _playlistItemList[row];
  return item;
}

#pragma mark - Fetch Playlist

- (void)fetchMyChannelList {
  _myPlaylists = nil;
  _channelListFetchError = nil;

  GTLRYouTubeService *service = self.youTubeService;

  GTLRYouTubeQuery_ChannelsList *query =
      [GTLRYouTubeQuery_ChannelsList queryWithPart:@[@"contentDetails"]];
  query.mine = YES;

  // maxResults specifies the number of results per page.  Since we earlier
  // specified shouldFetchNextPages=YES and this query fetches an object
  // class derived from GTLRCollectionObject, all results should be fetched,
  // though specifying a larger maxResults will reduce the number of fetches
  // needed to retrieve all pages.
  query.maxResults = 50;

  // We can specify the fields we want here to reduce the network
  // bandwidth and memory needed for the fetched collection.
  //
  // For example, leave query.fields as nil during development.
  // When ready to test and optimize your app, specify just the fields needed.
  // For example, this sample app might use
  //
  // query.fields = @"kind,etag,items(id,etag,kind,contentDetails)";

  _channelListTicket = [service executeQuery:query
                           completionHandler:^(GTLRServiceTicket *callbackTicket,
                                               GTLRYouTube_ChannelListResponse *channelList,
                                               NSError *callbackError) {
    // Callback

    // The contentDetails of the response has the playlists available for
    // "my channel".
    if (channelList.items.count > 0) {
      GTLRYouTube_Channel *channel = channelList[0];
      self->_myPlaylists = channel.contentDetails.relatedPlaylists;
    }
    self->_channelListFetchError = callbackError;
    self->_channelListTicket = nil;

    if (self->_myPlaylists) {
      [self fetchSelectedPlaylist];
    }

    [self fetchVideoCategories];
  }];

  [self updateUI];
}

- (void)fetchSelectedPlaylist {
  NSString *playlistID = nil;
  NSInteger tag = _playlistPopup.selectedTag;
  switch(tag) {
    case kUploadsTag:      playlistID = _myPlaylists.uploads; break;
    case kLikesTag:        playlistID = _myPlaylists.likes; break;
    case kFavoritesTag:    playlistID = _myPlaylists.favorites; break;
    case kWatchHistoryTag: playlistID = _myPlaylists.watchHistory; break;
    case kWatchLaterTag:   playlistID = _myPlaylists.watchLater; break;
    default: NSAssert(0, @"Unexpected tag: %ld", tag);
  }

  if (playlistID.length > 0) {
    GTLRYouTubeService *service = self.youTubeService;

    GTLRYouTubeQuery_PlaylistItemsList *query =
        [GTLRYouTubeQuery_PlaylistItemsList queryWithPart:@[@"snippet", @"contentDetails"]];
    query.playlistId = playlistID;
    query.maxResults = 50;

    _playlistItemListTicket =
        [service executeQuery:query
            completionHandler:^(GTLRServiceTicket *callbackTicket,
                                GTLRYouTube_PlaylistItemListResponse *playlistItemList,
                                NSError *callbackError) {
       // Callback
       self->_playlistItemList = playlistItemList;
       self->_playlistFetchError = callbackError;
       self->_playlistItemListTicket = nil;

       [self updateUI];
     }];
  }
  [self updateUI];
}

- (void)fetchVideoCategories {
  // For uploading, we want the category popup to have a list of all categories
  // that may be assigned to a video.
  GTLRYouTubeService *service = self.youTubeService;

  GTLRYouTubeQuery_VideoCategoriesList *query =
      [GTLRYouTubeQuery_VideoCategoriesList queryWithPart:@[@"snippet", @"id"]];
  query.regionCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];

  [service executeQuery:query
      completionHandler:^(GTLRServiceTicket *callbackTicket,
                          GTLRYouTube_VideoCategoryListResponse *categoryList,
                          NSError *callbackError) {
      if (callbackError) {
        NSLog(@"Could not fetch video category list: %@", callbackError);
      } else {
        // We will build a menu with the category names as menu item titles,
        // and category ID strings as the menu item represented
        // objects.
        NSMenu *categoryMenu = [[NSMenu alloc] init];
        for (GTLRYouTube_VideoCategory *category in categoryList) {
          NSString *title = category.snippet.title;
          NSString *categoryID = category.identifier;
          NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:title
                                                        action:NULL
                                                 keyEquivalent:@""];
          item.representedObject = categoryID;
          [categoryMenu addItem:item];
        }
        self->_uploadCategoryPopup.menu = categoryMenu;
        self->_uploadCategoryPopup.enabled = YES;
      }
      [self updateUI];
   }];
}

#pragma mark - Upload

- (void)uploadVideoFile {
  // Collect the metadata for the upload from the user interface.

  // Status.
  GTLRYouTube_VideoStatus *status = [GTLRYouTube_VideoStatus object];
  status.privacyStatus = _uploadPrivacyPopup.titleOfSelectedItem;

  // Snippet.
  GTLRYouTube_VideoSnippet *snippet = [GTLRYouTube_VideoSnippet object];
  snippet.title = _uploadTitleField.stringValue;
  NSString *desc = _uploadDescriptionField.stringValue;
  if (desc.length > 0) {
    snippet.descriptionProperty = desc;
  }
  NSString *tagsStr = _uploadTagsField.stringValue;
  if (tagsStr.length > 0) {
    snippet.tags = [tagsStr componentsSeparatedByString:@","];
  }
  if ([_uploadCategoryPopup isEnabled]) {
    NSMenuItem *selectedCategory = _uploadCategoryPopup.selectedItem;
    snippet.categoryId = selectedCategory.representedObject;
  }

  GTLRYouTube_Video *video = [GTLRYouTube_Video object];
  video.status = status;
  video.snippet = snippet;

  [self uploadVideoWithVideoObject:video
           resumeUploadLocationURL:nil];
}

- (void)restartUpload {
  // Restart a stopped upload, using the location URL from the previous
  // upload attempt
  if (_uploadLocationURL == nil) return;

  // Since we are restarting an upload, we do not need to add metadata to the
  // video object.
  GTLRYouTube_Video *video = [GTLRYouTube_Video object];

  [self uploadVideoWithVideoObject:video
           resumeUploadLocationURL:_uploadLocationURL];
}

- (void)uploadVideoWithVideoObject:(GTLRYouTube_Video *)video
           resumeUploadLocationURL:(NSURL *)locationURL {
  NSURL *fileToUploadURL = [NSURL fileURLWithPath:_uploadPathField.stringValue];
  NSError *fileError;
  if (![fileToUploadURL checkPromisedItemIsReachableAndReturnError:&fileError]) {
    [self displayAlert:@"No Upload File Found"
                format:@"Path: %@", fileToUploadURL.path];
    return;
  }

  // Get a file handle for the upload data.
  NSString *filename = [fileToUploadURL lastPathComponent];
  NSString *mimeType = [self MIMETypeForFilename:filename
                                 defaultMIMEType:@"video/mp4"];
  GTLRUploadParameters *uploadParameters =
      [GTLRUploadParameters uploadParametersWithFileURL:fileToUploadURL
                                              MIMEType:mimeType];
  uploadParameters.uploadLocationURL = locationURL;

  GTLRYouTubeQuery_VideosInsert *query =
      [GTLRYouTubeQuery_VideosInsert queryWithObject:video
                                               part:@[@"snippet,status"]
                                   uploadParameters:uploadParameters];

  NSProgressIndicator *progressIndicator = _uploadProgressIndicator;

  query.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *ticket,
                                                    unsigned long long numberOfBytesRead,
                                                    unsigned long long dataLength) {
    progressIndicator.maxValue = (double)dataLength;
    progressIndicator.doubleValue = (double)numberOfBytesRead;
  };

  GTLRYouTubeService *service = self.youTubeService;
  _uploadFileTicket = [service executeQuery:query
                          completionHandler:^(GTLRServiceTicket *callbackTicket,
                                              GTLRYouTube_Video *uploadedVideo,
                                              NSError *callbackError) {
      // Callback
      self->_uploadFileTicket = nil;
      if (callbackError == nil) {
        [self displayAlert:@"Uploaded"
                    format:@"Uploaded file \"%@\"",
         uploadedVideo.snippet.title];

        if (self->_playlistPopup.selectedTag == kUploadsTag) {
          // Refresh the displayed uploads playlist.
          [self fetchSelectedPlaylist];
        }
      } else {
        [self displayAlert:@"Upload Failed"
                    format:@"%@", callbackError];
      }

      self->_uploadProgressIndicator.doubleValue = 0.0;
      self->_uploadLocationURL = nil;
      [self updateUI];
    }];

  [self updateUI];
}

- (NSString *)MIMETypeForFilename:(NSString *)filename
                  defaultMIMEType:(NSString *)defaultType {
  NSString *result = defaultType;
  NSString *extension = [filename pathExtension];
  CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
      (__bridge CFStringRef)extension, NULL);
  if (uti) {
    CFStringRef cfMIMEType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType);
    if (cfMIMEType) {
      result = CFBridgingRelease(cfMIMEType);
    }
    CFRelease(uti);
  }
  return result;
}

#pragma mark - Sign In

- (void)runSigninThenHandler:(void (^)(void))handler {
    // Applications should have client ID hardcoded into the source
    // but the sample application asks the developer for the strings.
    // Client secret is now left blank.
  NSString *clientID = _clientIDField.stringValue;
  NSString *clientSecret = _clientSecretField.stringValue;

  if (clientID.length == 0) {
    // Remind the developer that client ID is needed. Client secret is now left blank
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
  NSArray<NSString *> *scopes = @[ kGTLRAuthScopeYouTube, OIDScopeEmail ];
  OIDAuthorizationRequest *request =
      [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                    clientId:clientID
                                                clientSecret:clientSecret
                                                      scopes:scopes
                                                 redirectURL:localRedirectURI
                                                responseType:OIDResponseTypeCode
                                        additionalParameters:nil];

  // performs authentication request
  __weak __typeof(self) weakSelf = self;
  _redirectHTTPHandler.currentAuthorizationFlow =
      [OIDAuthState authStateByPresentingAuthorizationRequest:request
                          callback:^(OIDAuthState *_Nullable authState,
                                     NSError *_Nullable error) {
    // Using weakSelf/strongSelf pattern to avoid retaining self as block execution is indeterminate
    __strong __typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }

    // Brings this app to the foreground.
    [[NSRunningApplication currentApplication]
        activateWithOptions:(NSApplicationActivateAllWindows |
                             NSApplicationActivateIgnoringOtherApps)];

    if (authState) {
      // Creates a GTMAppAuthFetcherAuthorization object for authorizing requests.
      GTMAppAuthFetcherAuthorization *gtmAuthorization =
          [[GTMAppAuthFetcherAuthorization alloc] initWithAuthState:authState];

      // Sets the authorizer on the GTLRYouTubeService object so API calls will be authenticated.
      strongSelf.youTubeService.authorizer = gtmAuthorization;

      // Serializes authorization to keychain in GTMAppAuth format.
      [GTMAppAuthFetcherAuthorization saveAuthorization:gtmAuthorization
                                      toKeychainForName:kGTMAppAuthKeychainItemName];

      // Executes post sign-in handler.
      if (handler) handler();
    } else {
      strongSelf->_channelListFetchError = error;
      [strongSelf updateUI];
    }
  }];
}

#pragma mark - UI

- (void)updateUI {
  BOOL isSignedIn = [self isSignedIn];
  NSString *username = [self signedInUsername];
  _signedInButton.title = (isSignedIn ? @"Sign Out" : @"Sign In");
  _signedInField.stringValue = (isSignedIn ? username : @"No");

  //
  // Playlist table.
  //
  [_playlistItemTable reloadData];

  BOOL isFetchingPlaylist = (_channelListTicket != nil || _playlistItemListTicket != nil);
  if (isFetchingPlaylist) {
    [_playlistProgressIndicator startAnimation:self];
  } else {
    [_playlistProgressIndicator stopAnimation:self];
  }

  // Get the description of the selected item, or the feed fetch error
  NSString *resultStr = @"";
  NSError *error;

  if (_channelListFetchError) {
    error = _channelListFetchError;
  } else {
    error = _playlistFetchError;
  }

  if (error) {
    // Display the error.
    resultStr = [error description];

    // Also display any server data present
    NSDictionary *errorInfo = [error userInfo];
    NSData *errData = errorInfo[kGTMSessionFetcherStatusDataKey];
    if (errData) {
      NSString *dataStr = [[NSString alloc] initWithData:errData
                                                encoding:NSUTF8StringEncoding];
      resultStr = [resultStr stringByAppendingFormat:@"\n%@", dataStr];
    }
  } else {
    // Display the selected item.
    GTLRYouTube_PlaylistItem *item = [self selectedPlaylistItem];
    if (item) {
      resultStr = [item description];
    }
  }
  _playlistResultTextField.string = resultStr;

  [self updateThumbnailImage];

  //
  // Enable buttons
  //
  _fetchPlaylistButton.enabled = (!isFetchingPlaylist);
  _playlistPopup.enabled = (isSignedIn && !isFetchingPlaylist);
  _playlistCancelButton.enabled = isFetchingPlaylist;

  BOOL hasUploadTitle = (_uploadTitleField.stringValue.length > 0);
  BOOL hasUploadFile = (_uploadPathField.stringValue.length > 0);
  BOOL isUploading = (_uploadFileTicket != nil);
  BOOL isPaused = (isUploading && [_uploadFileTicket isUploadPaused]);
  BOOL canUpload = (isSignedIn && hasUploadFile && hasUploadTitle && !isUploading);
  BOOL canRestartUpload = (_uploadLocationURL != nil);
  _uploadButton.enabled = canUpload;
  _pauseUploadButton.enabled = isUploading;
  _pauseUploadButton.title = (isPaused ? @"Resume" : @"Pause");
  _stopUploadButton.enabled = isUploading;
  _restartUploadButton.enabled = canRestartUpload;

  // Show or hide the text indicating that the client ID or client secret are
  // needed
  BOOL hasClientIDStrings = _clientIDField.stringValue.length > 0
    && _clientSecretField.stringValue.length > 0;
  _clientIDRequiredTextField.hidden = hasClientIDStrings;
}

- (void)updateThumbnailImage {
  // We will fetch the thumbnail image if its URL is different from the one
  // currently displayed.
  static NSString *gDisplayedURLStr = nil;

  GTLRYouTube_PlaylistItem *playlistItem = [self selectedPlaylistItem];
  GTLRYouTube_ThumbnailDetails *thumbnails = playlistItem.snippet.thumbnails;
  GTLRYouTube_Thumbnail *thumbnail = thumbnails.defaultProperty;
  NSString *thumbnailURLStr = thumbnail.url;

  if (!GTLR_AreEqualOrBothNil(gDisplayedURLStr, thumbnailURLStr)) {
    _thumbnailView.image = nil;

    gDisplayedURLStr = [thumbnailURLStr copy];

    if (thumbnailURLStr) {
      GTMSessionFetcher *fetcher =
          [self.youTubeService.fetcherService fetcherWithURLString:thumbnailURLStr];
      fetcher.authorizer = self.youTubeService.authorizer;

      NSString *title = playlistItem.snippet.title;
      [fetcher setCommentWithFormat:@"Thumbnail for \"%@\"", title];
      [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (data) {
          NSImage *image = [[NSImage alloc] initWithData:data];
          if (image) {
            self->_thumbnailView.image = image;
          } else {
            NSLog(@"Failed to make image from %tu bytes for \"%@\"",
                  data.length, title);
          }
        } else {
          NSLog(@"Failed to fetch thumbnail for \"%@\", %@",  title, error);
        }
      }];
    }
  }
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

#pragma mark - Client ID Sheet

// Client ID and Client Secret Sheet
//
// Sample apps need this sheet to ask for the client ID and client secret
// strings.
//
// Your application will just hardcode the client ID and client secret strings
// into the source rather than ask the user for them.
//
// The string values are obtained from the API Console,
// https://console.developers.google.com/

- (IBAction)clientIDClicked:(NSButton *)sender {
  // Show the sheet for developers to enter their client ID and client secret
  [self.window beginSheet:_clientIDSheet completionHandler:nil];
}

- (IBAction)clientIDDoneClicked:(NSButton *)sender {
  [self.window endSheet:sender.window];
}

#pragma mark - Text field delegate methods

- (void)controlTextDidChange:(NSNotification *)note {
  [self updateUI];  // enable and disable buttons
}

#pragma mark - TableView delegate and data source methods

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
  [self updateUI];
}

// Table view data source methods.
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  if (tableView == _playlistItemTable) {
    return _playlistItemList.items.count;
  }
  return 0;
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row {
  if (tableView == _playlistItemTable) {
    GTLRYouTube_PlaylistItem *item = _playlistItemList[row];
    NSString *title = item.snippet.title;
    return title;
  }
  return nil;
}

@end
