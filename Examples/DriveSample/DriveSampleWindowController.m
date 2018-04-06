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
//  DriveSampleWindowController.m
//

#import "DriveSampleWindowController.h"

#import <AppAuth/AppAuth.h>
#import <GTMAppAuth/GTMAppAuth.h>
#import <GTMSessionFetcher/GTMSessionFetcherService.h>
#import <GTMSessionFetcher/GTMSessionFetcherLogging.h>
#import <GoogleAPIClientForREST/GTLRUtilities.h>

// Segmented control indices.
enum {
  kRevisionsSegment = 0,
  kPermissionsSegment,
  kChildrenSegment,
  kParentsSegment
};

// This is the URL shown users after completing the OAuth flow. This is an information page only and
// is not part of the authorization protocol. You can replace it with any URL you like.
// We recommend at a minimum that the page displayed instructs users to return to the app.
static NSString *const kSuccessURLString = @"http://openid.github.io/AppAuth-iOS/redirect/";

// Keychain item name for saving the user's authentication information.
NSString *const kGTMAppAuthKeychainItemName = @"DriveSample: Google Drive. GTMAppAuth.";

@interface DriveSampleWindowController ()
@property (nonatomic, readonly) GTLRDriveService *driveService;
@end

@implementation DriveSampleWindowController {
  GTLRDrive_FileList *_fileList;
  GTLRServiceTicket *_fileListTicket;
  NSError *_fileListFetchError;
  GTLRServiceTicket *_editFileListTicket;
  GTLRServiceTicket *_uploadFileTicket;

  // Details
  GTLRDrive_RevisionList *_revisionList;
  NSError *_revisionListFetchError;

  GTLRDrive_PermissionList *_permissionList;
  NSError *_permissionListFetchError;

  GTLRDrive_FileList *_childList;
  NSError *_childListFetchError;

  NSArray *_parentsList;
  NSError *_parentsListFetchError;

  GTLRServiceTicket *_detailsTicket;
  NSError *_detailsFetchError;

  OIDRedirectHTTPHandler *_redirectHTTPHandler;
}

+ (DriveSampleWindowController *)sharedWindowController {
  static DriveSampleWindowController* gWindowController = nil;
  if (!gWindowController) {
    gWindowController = [[DriveSampleWindowController alloc] init];
  }
  return gWindowController;
}

- (id)init {
  return [self initWithWindowNibName:@"DriveSampleWindow"];
}

- (void)awakeFromNib {
  // Attempts to deserialize authorization from keychain in GTMAppAuth format.
  id<GTMFetcherAuthorizationProtocol> authorization =
      [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kGTMAppAuthKeychainItemName];
  self.driveService.authorizer = authorization;

  // Set the result text fields to have a distinctive color and mono-spaced font.
  _fileListResultTextField.textColor = [NSColor darkGrayColor];
  _detailResultTextField.textColor = [NSColor darkGrayColor];

  NSFont *resultTextFont = [NSFont fontWithName:@"Monaco" size:9];
  _fileListResultTextField.font = resultTextFont;
  _detailResultTextField.font = resultTextFont;

  [self updateUI];
}

#pragma mark -

- (NSString *)signedInUsername {
  // Get the email address of the signed-in user.
  id<GTMFetcherAuthorizationProtocol> auth = self.driveService.authorizer;
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
    [self runSigninThenHandler:^{
      [self updateUI];
    }];
  } else {
    // Sign out
    GTLRDriveService *service = self.driveService;

    [GTMAppAuthFetcherAuthorization
        removeAuthorizationFromKeychainForName:kGTMAppAuthKeychainItemName];
    service.authorizer = nil;
    [self updateUI];
  }
}

- (IBAction)segmentedControlClicked:(id)sender {
  [self updateUI];
}

- (IBAction)getFileList:(id)sender {
  if (![self isSignedIn]) {
    [self runSigninThenHandler:^{
      [self fetchFileList];
    }];
  } else {
    [self fetchFileList];
  }
}

- (IBAction)cancelFileListFetch:(id)sender {
  [_fileListTicket cancelTicket];
  _fileListTicket = nil;

  [_editFileListTicket cancelTicket];
  _editFileListTicket = nil;

  [self updateUI];
}

- (IBAction)viewClicked:(id)sender {
  GTLRDrive_File *selectedFile = [self selectedFileListEntry];
  NSString *viewURLString = selectedFile.webViewLink;
  if (viewURLString.length > 0) {
    NSURL *url = [NSURL URLWithString:viewURLString];
    [[NSWorkspace sharedWorkspace] openURL:url];
  }
}

- (IBAction)duplicateClicked:(id)sender {
  [self duplicateSelectedFile];
}

- (IBAction)trashClicked:(id)sender {
  [self changeTrashStateForSelectedFile];
}

- (IBAction)deleteClicked:(id)sender {
  GTLRDrive_File *file = [self selectedFileListEntry];
  NSString *title = file.name;

  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText = [NSString stringWithFormat:@"Delete \"%@\"?", title];
  [alert addButtonWithTitle:@"Delete"];
  [alert addButtonWithTitle:@"Cancel"];
  [alert beginSheetModalForWindow:[self window]
                completionHandler:^(NSModalResponse returnCode) {
    if (returnCode == NSAlertFirstButtonReturn) {
      [self deleteSelectedFile];
    }
  }];
}

- (IBAction)downloadClicked:(id)sender {
  [self showDownloadSavePanelExportingToPDF:NO];
}

- (IBAction)exportAsPDFClicked:(id)sender {
  [self showDownloadSavePanelExportingToPDF:YES];
}

- (void)showDownloadSavePanelExportingToPDF:(BOOL)isExportingToPDF {
  GTLRDrive_File *file = [self selectedFileListEntry];

  NSString *suggestedName = file.originalFilename;
  if (suggestedName.length == 0) {
    suggestedName = file.name;
  }

  NSString *likelyExtension;
  if (isExportingToPDF) {
    likelyExtension = @"pdf";
  } else {
    // If the Mac can tell us the likely extension for the file based on the content type,
    // add that extension.
    //
    // Note that MIME types of Google Drive native formats won't be known to the Mac.
    // See https://developers.google.com/drive/v3/web/mime-types
    likelyExtension = [self extensionForMIMEType:file.mimeType];
  }
  if (likelyExtension.length > 0 && ![suggestedName.pathExtension isEqual:likelyExtension]) {
    suggestedName = [suggestedName stringByAppendingPathExtension:likelyExtension];
  }

  NSSavePanel *savePanel = [NSSavePanel savePanel];
  savePanel.extensionHidden = NO;
  savePanel.nameFieldStringValue = suggestedName;
  [savePanel beginSheetModalForWindow:[self window]
                    completionHandler:^(NSInteger result) {
    if (result == NSFileHandlingPanelOKButton) {
      [self downloadFile:file
        isExportingToPDF:isExportingToPDF
        toDestinationURL:savePanel.URL];
    }
  }];
}

- (void)downloadFile:(GTLRDrive_File *)file
    isExportingToPDF:(BOOL)isExporting
    toDestinationURL:(NSURL *)destinationURL {
  GTLRDriveService *service = self.driveService;

  GTLRQuery *query;
  if (isExporting) {
    // Note: this will fail if the file type cannot be converted to PDF.
    query = [GTLRDriveQuery_FilesExport queryForMediaWithFileId:file.identifier
                                                       mimeType:@"application/pdf"];
  } else {
    // Download original file.  This will fail if the file type
    // cannot be downloaded in its native server format.
    query = [GTLRDriveQuery_FilesGet queryForMediaWithFileId:file.identifier];
  }

  // GTLR queries are suitable for downloading and exporting small files.
  //
  // For large files, apps typically will want to monitor the progress of a download
  // or to download with a Range request header to specify a subset of bytes.
  //
  // To download large files, get the full NSURLRequest from the GTLR query instead of
  // executing the query.
  //
  // Here's how to download with a GTMSessionFetcher. The fetcher will use the authorizer that's
  // attached to the GTLR service's fetcherService.
  //
  //  NSURLRequest *downloadRequest = [service requestForQuery:query];
  //  GTMSessionFetcher *fetcher = [service.fetcherService fetcherWithRequest:downloadRequest];
  //
  //  [fetcher setCommentWithFormat:@"Downloading %@", file.name];
  //  fetcher.destinationFileURL = destinationURL;
  //
  //  [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
  //    if (error == nil) {
  //      NSLog(@"Download succeeded.");
  //
  //      // With a destinationFileURL property set, the fetcher's callback
  //      // data parameter here will be nil.
  //    }
  //  }];

  [service executeQuery:query
      completionHandler:^(GTLRServiceTicket *callbackTicket,
                          GTLRDataObject *object,
                          NSError *callbackError) {
    NSError *errorToReport = callbackError;
    NSError *writeError;
    if (callbackError == nil) {
      BOOL didSave = [object.data writeToURL:destinationURL
                                     options:NSDataWritingAtomic
                                       error:&writeError];
      if (!didSave) {
        errorToReport = writeError;
      }
    }
    if (errorToReport == nil) {
      // Successfully saved the file.
      //
      // Since a downloadPath property was specified, the data argument is
      // nil, and the file data has been written to disk.
      [self displayAlert:@"Downloaded"
                  format:@"%@", destinationURL.path];
    } else {
      [self displayAlert:@"Error Downloading File"
                  format:@"%@", errorToReport];
    }
  }];
}

- (NSString *)extensionForMIMEType:(NSString *)mimeType {
  // Try to convert a MIME type to an extension using the Mac's type identifiers.
  NSString *result = nil;
  CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType,
                                                          (__bridge CFStringRef)mimeType, NULL);
  if (uti) {
    CFStringRef cfExtn = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassFilenameExtension);
    if (cfExtn) {
      result = CFBridgingRelease(cfExtn);
    }
    CFRelease(uti);
  }
  return result;
}

- (IBAction)uploadFileClicked:(id)sender {
  // Ask the user to choose a file.
  NSOpenPanel *openPanel = [NSOpenPanel openPanel];
  openPanel.prompt = @"Upload";
  openPanel.canChooseDirectories = NO;
  [openPanel beginSheetModalForWindow:[self window]
                    completionHandler:^(NSInteger result) {
    // Callback.
    if (result == NSFileHandlingPanelOKButton) {
      // The user chose a file and clicked OK.
      //
      // Start uploading (deferred briefly since
      // we currently have a sheet displayed).
      NSString *path = [[openPanel URL] path];
      [self performSelector:@selector(uploadFileAtPath:)
                 withObject:path
                 afterDelay:0.1];
    }
  }];
}

- (IBAction)pauseUploadClicked:(id)sender {
  if ([_uploadFileTicket isUploadPaused]) {
    [_uploadFileTicket resumeUpload];
  } else {
    [_uploadFileTicket pauseUpload];
  }
  [self updateUI];
}

- (IBAction)stopUploadClicked:(id)sender {
  [_uploadFileTicket cancelTicket];
  _uploadFileTicket = nil;

  [self updateUI];
}

- (IBAction)createFolderClicked:(id)sender {
  [self createAFolder];
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

- (GTLRDriveService *)driveService {
  static GTLRDriveService *service;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service = [[GTLRDriveService alloc] init];

    // Turn on the library's shouldFetchNextPages feature to ensure that all items
    // are fetched.  This applies to queries which return an object derived from
    // GTLRCollectionObject.
    service.shouldFetchNextPages = YES;

    // Have the service object set tickets to retry temporary error conditions
    // automatically
    service.retryEnabled = YES;
  });
  return service;
}

- (GTLRDrive_File *)selectedFileListEntry {
  NSInteger rowIndex = [_fileListTable selectedRow];
  if (rowIndex > -1) {
    GTLRDrive_File *item = _fileList.files[rowIndex];
    return item;
  }
  return nil;
}

- (id)detailCollectionArray {
  NSInteger segment = [_segmentedControl selectedSegment];
  switch (segment) {
    case kRevisionsSegment:
      return _revisionList.revisions;
    case kPermissionsSegment:
      return _permissionList.permissions;
    case kChildrenSegment:
      return _childList.files;
    case kParentsSegment:
      return _parentsList;
    default:
      return nil;
  }
}

- (id)selectedDetailItem {
  NSInteger rowIndex = [_detailTable selectedRow];
  if (rowIndex > -1) {
    NSArray *array = [self detailCollectionArray];
    GTLRObject *item = array[rowIndex];
    return item;
  }
  return nil;
}

- (NSError *)detailsError {
  // First, check if the query execution succeeded.
  NSError *error = _detailsFetchError;
  if (error == nil) {
    // Next, check if there was an error for the selected detail.
    NSInteger segment = [_segmentedControl selectedSegment];
    switch (segment) {
      case kRevisionsSegment:
        return _revisionListFetchError;
      case kPermissionsSegment:
        return _permissionListFetchError;
      case kChildrenSegment:
        return _childListFetchError;
      case kParentsSegment:
        return _parentsListFetchError;
      default:
        return nil;
    }
  }
  return nil;
}

- (NSString *)descriptionForFileID:(NSString *)fileID {
  NSArray *files = _fileList.files;
  GTLRDrive_File *file = [GTLRUtilities firstObjectFromArray:files
                                                   withValue:fileID
                                                  forKeyPath:@"identifier"];
  if (file) {
    return file.name;
  } else {
    // Can't find the file by its identifier.
    return [NSString stringWithFormat:@"<%@>", fileID];
  }
}

- (NSString *)descriptionForDetailItem:(id)item {
  if ([item isKindOfClass:[GTLRDrive_Revision class]]) {
    return ((GTLRDrive_Revision *)item).modifiedTime.stringValue;
  } else if ([item isKindOfClass:[GTLRDrive_Permission class]]) {
    return ((GTLRDrive_Permission *)item).displayName;
  } else if ([item isKindOfClass:[GTLRDrive_File class]]) {
    NSString *fileID = ((GTLRDrive_File *)item).identifier;
    return [self descriptionForFileID:fileID];
  } else if ([item isKindOfClass:[NSString class]]) {
    // item is probably a file ID
    return [self descriptionForFileID:item];
  }
  return nil;
}

#pragma mark -
#pragma mark Fetch File List

- (void)fetchFileList {
  _fileList = nil;
  _fileListFetchError = nil;

  GTLRDriveService *service = self.driveService;

  GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];

  // Because GTLRDrive_FileList is derived from GTLCollectionObject and the service
  // property shouldFetchNextPages is enabled, this may do multiple fetches to
  // retrieve all items in the file list.

  // Google APIs typically allow the fields returned to be limited by the "fields" property.
  // The Drive API uses the "fields" property differently by not sending most of the requested
  // resource's fields unless they are explicitly specified.
  query.fields = @"kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,trashed)";

  _fileListTicket = [service executeQuery:query
                        completionHandler:^(GTLRServiceTicket *callbackTicket,
                                            GTLRDrive_FileList *fileList,
                                            NSError *callbackError) {
    // Callback
    self->_fileList = fileList;
    self->_fileListFetchError = callbackError;
    self->_fileListTicket = nil;

    [self updateUI];
  }];

  [self updateUI];
}

#pragma mark Fetch File Details

- (void)fetchSelectedFileDetails {
  _revisionList = nil;
  _revisionListFetchError = nil;
  _permissionList = nil;
  _permissionListFetchError = nil;
  _childList = nil;
  _childListFetchError = nil;
  _parentsList = nil;
  _parentsListFetchError = nil;

  _detailsFetchError = nil;

  GTLRDriveService *service = self.driveService;

  GTLRDrive_File *selectedFile = [self selectedFileListEntry];
  NSString *fileID = selectedFile.identifier;
  if (fileID) {
    // Rather than make separate fetches for each kind of detail for the
    // selected file, we'll make a single batch query to etch the various
    // details.  Each query in the batch will have its own result or error,
    // and the batch query execution itself may fail with an error.
    GTLRDriveQuery_RevisionsList *revisionQuery = [GTLRDriveQuery_RevisionsList queryWithFileId:fileID];
    revisionQuery.completionBlock = ^(GTLRServiceTicket *callbackTicket,
                                      GTLRDrive_RevisionList *obj,
                                      NSError *callbackError) {
      self->_revisionList = obj;
      self->_revisionListFetchError = callbackError;
    };

    GTLRDriveQuery_PermissionsList *permissionQuery =
        [GTLRDriveQuery_PermissionsList queryWithFileId:fileID];
    permissionQuery.completionBlock = ^(GTLRServiceTicket *callbackTicket,
                                        GTLRDrive_PermissionList *obj,
                                        NSError *callbackError) {
      self->_permissionList = obj;
      self->_permissionListFetchError = callbackError;
    };

    GTLRDriveQuery_FilesList *childQuery = [GTLRDriveQuery_FilesList query];
    childQuery.q = [NSString stringWithFormat:@"'%@' in parents", fileID];
    // Accumulate additional pages of results for this query, if necessary.
    childQuery.completionBlock = ^(GTLRServiceTicket *callbackTicket, GTLRDrive_FileList *obj,
                                   NSError *callbackError) {
      self->_childList = obj;
      self->_childListFetchError = callbackError;
    };

    // Note: The fields property in Google APIs is supposed to restrict
    // the fields returned for a partial query, though in the v3 Drive API
    // it is required here to return the parents field.
    GTLRDriveQuery_FilesGet *parentsQuery = [GTLRDriveQuery_FilesGet queryWithFileId:fileID];
    parentsQuery.fields = @"parents";
    parentsQuery.completionBlock = ^(GTLRServiceTicket *callbackTicket, GTLRDrive_File *obj,
                                     NSError *callbackError) {
      self->_parentsList = obj.parents;
      self->_parentsListFetchError = callbackError;
    };

    // Combine the separate queries into one batch.
    GTLRBatchQuery *batchQuery = [GTLRBatchQuery batchQuery];
    [batchQuery addQuery:revisionQuery];
    [batchQuery addQuery:permissionQuery];
    [batchQuery addQuery:childQuery];
    [batchQuery addQuery:parentsQuery];

    _detailsTicket = [service executeQuery:batchQuery
                         completionHandler:^(GTLRServiceTicket *callbackTicket,
                                             GTLRBatchResult *batchResult,
                                             NSError *callbackError) {
       // Callback
       //
       // The batch query execution completionHandler runs after the individual
       // query completion handlers have been called.
       self->_detailsTicket = nil;
       self->_detailsFetchError = callbackError;

       [self updateUI];
     }];
    [self updateUI];
  }
}

#pragma mark Delete a File

- (void)deleteSelectedFile {
  GTLRDriveService *service = self.driveService;

  GTLRDrive_File *selectedFile = [self selectedFileListEntry];
  NSString *fileID = selectedFile.identifier;
  if (fileID) {
    GTLRDriveQuery_FilesDelete *query = [GTLRDriveQuery_FilesDelete queryWithFileId:fileID];
    _editFileListTicket = [service executeQuery:query
                              completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                  id nilObject,
                                                  NSError *callbackError) {
      // Callback
      self->_editFileListTicket = nil;
      if (callbackError == nil) {
        [self displayAlert:@"Deleted"
                    format:@"Deleted \"%@\"",
         selectedFile.name];
        [self updateUI];
        [self fetchFileList];
      } else {
        [self displayAlert:@"Delete Failed"
                    format:@"%@", callbackError];
      }
    }];
  }
}

#pragma mark Toggle Trash State

- (void)changeTrashStateForSelectedFile {
  GTLRDriveService *service = self.driveService;

  GTLRDrive_File *selectedFile = [self selectedFileListEntry];
  NSString *fileID = selectedFile.identifier;
  if (fileID) {
    GTLRDriveQuery *query;
    BOOL isInTrash = selectedFile.trashed.boolValue;

    GTLRDrive_File *updateFile = [GTLRDrive_File object];
    updateFile.trashed = isInTrash ? @NO : @YES;

    query = [GTLRDriveQuery_FilesUpdate queryWithObject:updateFile
                                                 fileId:fileID
                                       uploadParameters:nil];
    _editFileListTicket = [service executeQuery:query
                              completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                  GTLRDrive_File *updatedObject,
                                                  NSError *callbackError) {
                                // Callback
      self->_editFileListTicket = nil;
      if (callbackError == nil) {
        NSString *fmt = (isInTrash ? @"Moved \"%@\" out of trash" : @"Moved \"%@\" to trash");
        [self displayAlert:@"Updated"
                    format:fmt, selectedFile.name];
        [self updateUI];
        [self fetchFileList];
      } else {
        [self displayAlert:@"Trash Change Failed"
                    format:@"%@", callbackError];
      }
    }];
  }
}

#pragma mark Duplicate a File

- (void)duplicateSelectedFile {
  GTLRDriveService *service = self.driveService;

  GTLRDrive_File *selectedFile = [self selectedFileListEntry];
  NSString *fileID = selectedFile.identifier;
  if (fileID) {
    // Make a file object with the title to use for the duplicate.
    GTLRDrive_File *fileObj = [GTLRDrive_File object];
    fileObj.name = [NSString stringWithFormat:@"%@ copy", selectedFile.name];

    GTLRDriveQuery_FilesCopy *query = [GTLRDriveQuery_FilesCopy queryWithObject:fileObj
                                                                         fileId:fileID];
    _editFileListTicket = [service executeQuery:query
                              completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                  GTLRDrive_File *copiedFile,
                                                  NSError *callbackError) {
      // Callback
      self->_editFileListTicket = nil;
      if (callbackError == nil) {
        [self displayAlert:@"Copied"
                    format:@"Created copy \"%@\"",
         copiedFile.name];
        [self updateUI];
        [self fetchFileList];
      } else {
        [self displayAlert:@"Copy failed"
                    format:@"%@", callbackError];
      }
    }];
  }
}

#pragma mark New Folder

- (void)createAFolder {
  GTLRDriveService *service = self.driveService;

  GTLRDrive_File *folderObj = [GTLRDrive_File object];
  folderObj.name = [NSString stringWithFormat:@"New Folder %@", [NSDate date]];
  folderObj.mimeType = @"application/vnd.google-apps.folder";

  // To create a folder in a specific parent folder, specify the addParents property
  // for the query.

  GTLRDriveQuery_FilesCreate *query = [GTLRDriveQuery_FilesCreate queryWithObject:folderObj
                                                                 uploadParameters:nil];
  _editFileListTicket = [service executeQuery:query
                            completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                GTLRDrive_File *folderItem,
                                                NSError *callbackError) {
                              // Callback
    self->_editFileListTicket = nil;
    if (callbackError == nil) {
      [self displayAlert:@"Created"
                  format:@"Created folder \"%@\"",
       folderItem.name];
      [self updateUI];
      [self fetchFileList];
    } else {
      [self displayAlert:@"Create Folder Failed"
                  format:@"%@", callbackError];
    }
  }];
}

#pragma mark Uploading

- (void)uploadFileAtPath:(NSString *)path {
  NSURL *fileToUploadURL = [NSURL fileURLWithPath:path];
  NSError *fileError;
  if (![fileToUploadURL checkPromisedItemIsReachableAndReturnError:&fileError]) {
    // Could not read file data.
    [self displayAlert:@"No Upload File Found"
                format:@"Path: %@", path];
    return;
  }

  // Queries that support file uploads take an uploadParameters object.
  // The uploadParameters include the MIME type of the file being uploaded,
  // and either an NSData with the file contents, or a URL for
  // the file path.
  GTLRDriveService *service = self.driveService;

  NSString *filename = [path lastPathComponent];
  NSString *mimeType = [self MIMETypeFileName:filename
                              defaultMIMEType:@"binary/octet-stream"];
  GTLRUploadParameters *uploadParameters =
      [GTLRUploadParameters uploadParametersWithFileURL:fileToUploadURL
                                               MIMEType:mimeType];
  GTLRDrive_File *newFile = [GTLRDrive_File object];
  newFile.name = filename;

  GTLRDriveQuery_FilesCreate *query = [GTLRDriveQuery_FilesCreate queryWithObject:newFile
                                                                 uploadParameters:uploadParameters];

  NSProgressIndicator *uploadProgressIndicator = _uploadProgressIndicator;
  query.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *callbackTicket,
                                                    unsigned long long numberOfBytesRead,
                                                    unsigned long long dataLength) {
    uploadProgressIndicator.maxValue = (double)dataLength;
    uploadProgressIndicator.doubleValue = (double)numberOfBytesRead;
  };

  _uploadFileTicket = [service executeQuery:query
                          completionHandler:^(GTLRServiceTicket *callbackTicket,
                                              GTLRDrive_File *uploadedFile,
                                              NSError *callbackError) {
    // Callback
    self->_uploadFileTicket = nil;
    if (callbackError == nil) {
      [self displayAlert:@"Created"
                  format:@"Uploaded file \"%@\"",
       uploadedFile.name];
      [self fetchFileList];
    } else {
      [self displayAlert:@"Upload Failed"
                  format:@"%@", callbackError];
    }
    self->_uploadProgressIndicator.doubleValue = 0.0;
    [self updateUI];
  }];

  [self updateUI];
}

- (NSString *)MIMETypeFileName:(NSString *)path
                    defaultMIMEType:(NSString *)defaultType {
  NSString *result = defaultType;
  NSString *extension = [path pathExtension];
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

#pragma mark -
#pragma mark Sign In

- (void)runSigninThenHandler:(void (^)(void))handler {
    // Applications should have client ID hardcoded into the source
    // but the sample application asks the developer for the strings.
    // Client secret is now left blank.
  NSString *clientID = [_clientIDField stringValue];
  NSString *clientSecret = [_clientSecretField stringValue];

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
  // Applications that only need to access files created by this app should
  // use the kGTLRAuthScopeDriveFile scope.
  NSArray<NSString *> *scopes = @[ kGTLRAuthScopeDrive, OIDScopeEmail ];
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
      strongSelf.driveService.authorizer = gtmAuthorization;

      // Serializes authorization to keychain in GTMAppAuth format.
      [GTMAppAuthFetcherAuthorization saveAuthorization:gtmAuthorization
                                      toKeychainForName:kGTMAppAuthKeychainItemName];

      // Executes post sign-in handler.
      if (handler) handler();
    } else {
      strongSelf->_fileListFetchError = error;
      [strongSelf updateUI];
    }
  }];
}

#pragma mark -
#pragma mark UI

- (void)updateUI {
  BOOL isSignedIn = [self isSignedIn];
  NSString *username = [self signedInUsername];
  _signedInButton.title = (isSignedIn ? @"Sign Out" : @"Sign In");
  _signedInField.stringValue = (isSignedIn ? username : @"No");

  //
  // File list table
  //
  [_fileListTable reloadData];

  if (_fileListTicket != nil || _editFileListTicket != nil) {
    [_fileListProgressIndicator startAnimation:self];
  } else {
    [_fileListProgressIndicator stopAnimation:self];
  }

  // Get the description of the selected item, or the feed fetch error
  NSString *resultStr = @"";

  if (_fileListFetchError) {
    // Display the error
    resultStr = [_fileListFetchError description];

    // Also display any server data present
    NSDictionary *errorInfo = [_fileListFetchError userInfo];
    NSData *errData = errorInfo[kGTMSessionFetcherStatusDataKey];
    if (errData) {
      NSString *dataStr = [[NSString alloc] initWithData:errData
                                                encoding:NSUTF8StringEncoding];
      resultStr = [resultStr stringByAppendingFormat:@"\n%@", dataStr];
    }
  } else {
    // Display the selected item
    GTLRDrive_File *item = [self selectedFileListEntry];
    if (item) {
      resultStr = [item description];
    }
  }
  _fileListResultTextField.string = resultStr;

  [self updateThumbnailImage];

  //
  // Details table
  //

  [_detailTable reloadData];

  if (_detailsTicket != nil) {
    [_detailProgressIndicator startAnimation:self];
  } else {
    [_detailProgressIndicator stopAnimation:self];
  }

  // Get the description of the selected item, or the feed fetch error
  resultStr = @"";

  NSError *error = [self detailsError];
  if (error) {
    resultStr = [error description];
  } else {
    id item = [self selectedDetailItem];
    if (item) {
      resultStr = [item description];
    }
  }

  _detailResultTextField.string = resultStr;

  // Update the counts in the segmented control
  NSUInteger numberOfRevisions = _revisionList.revisions.count;
  NSUInteger numberOfPermissions = _permissionList.permissions.count;
  NSUInteger numberOfChildren = _childList.files.count;
  NSUInteger numberOfParents = _parentsList.count;

  NSString *revisionsStr = [NSString stringWithFormat:@"Revisions %tu", numberOfRevisions];
  NSString *permissionsStr = [NSString stringWithFormat:@"Permissions %tu", numberOfPermissions];
  NSString *childrenStr = [NSString stringWithFormat:@"Children %tu", numberOfChildren];
  NSString *parentsStr = [NSString stringWithFormat:@"Parents %tu", numberOfParents];

  [_segmentedControl setLabel:revisionsStr forSegment:kRevisionsSegment];
  [_segmentedControl setLabel:permissionsStr forSegment:kPermissionsSegment];
  [_segmentedControl setLabel:childrenStr forSegment:kChildrenSegment];
  [_segmentedControl setLabel:parentsStr forSegment:kParentsSegment];

  // Enable buttons
  BOOL isFetchingFileList = (_fileListTicket != nil);
  BOOL isEditingFileList = (_editFileListTicket != nil);
  _fileListCancelButton.enabled = (isFetchingFileList || isEditingFileList);

  BOOL isFetchingDetails = (_detailsTicket != nil);
  _detailCancelButton.enabled = isFetchingDetails;

  GTLRDrive_File *selectedFile = [self selectedFileListEntry];
  NSString *webViewLink = selectedFile.webViewLink;
  BOOL isFileViewable = (webViewLink != nil);
  _viewButton.enabled = isFileViewable;

  BOOL isFileSelected = (selectedFile != nil);
  _deleteButton.enabled = isFileSelected;
  _downloadButton.enabled = isFileSelected;
  _exportAsPDFButton.enabled = isFileSelected;
  _trashButton.enabled = isFileSelected;

  BOOL isInTrash = selectedFile.trashed.boolValue;
  NSString *trashTitle = (isInTrash ? @"Untrash" : @"Trash");
  _trashButton.title = trashTitle;

  _duplicateButton.enabled = isFileSelected;

  BOOL hasFileList = (_fileList != nil);
  _newFolderButton.enabled = hasFileList;

  BOOL isUploading = (_uploadFileTicket != nil);
  _uploadButton.enabled = (hasFileList && !isUploading);
  _pauseUploadButton.enabled = isUploading;
  _stopUploadButton.enabled = isUploading;

  BOOL isUploadPaused = [_uploadFileTicket isUploadPaused];
  NSString *pauseTitle = (isUploadPaused ? @"Resume" : @"Pause");
  _pauseUploadButton.title = pauseTitle;

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
  GTLRDrive_File *selectedFile = [self selectedFileListEntry];

  NSString *thumbnailURLStr = selectedFile.thumbnailLink;

  if (!GTLR_AreEqualOrBothNil(gDisplayedURLStr, thumbnailURLStr)) {
    _thumbnailView.image = nil;

    gDisplayedURLStr = [thumbnailURLStr copy];

    if (thumbnailURLStr) {
      GTMSessionFetcher *fetcher =
          [self.driveService.fetcherService fetcherWithURLString:thumbnailURLStr];
      fetcher.authorizer = self.driveService.authorizer;
      [fetcher setCommentWithFormat:@"Thumbnail for \"%@\"", selectedFile.name];
      [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *fetchError) {
        if (data) {
          NSImage *image = [[NSImage alloc] initWithData:data];
          if (image) {
            self->_thumbnailView.image = image;
          } else {
            NSLog(@"Failed to make image from %tu bytes for \"%@\"",
                  data.length, selectedFile.name);
          }
        } else {
          NSLog(@"Failed to fetch thumbnail for \"%@\", %@",
                selectedFile.name, fetchError);
        }
      }];
    }
  }
}

- (void)displayAlert:(NSString *)title format:(NSString *)format, ... {
  NSString *result = @"";
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
  [alert beginSheetModalForWindow:[self window]
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

- (IBAction)clientIDClicked:(NSButton *)sender {
  // Show the sheet for developers to enter their client ID and client secret
  [self.window beginSheet:_clientIDSheet completionHandler:nil];
}

- (IBAction)clientIDDoneClicked:(NSButton *)sender {
  [self.window endSheet:sender.window];
}

#pragma mark Text field delegate methods

- (void)controlTextDidChange:(NSNotification *)note {
  [self updateUI];  // enable and disable buttons
}

#pragma mark TableView delegate and data source methods

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
  [self updateUI];
  if ([notification object] == _fileListTable) {
    [self fetchSelectedFileDetails];
  }
}

// Table view data source methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  NSArray *array;
  if (tableView == _fileListTable) {
    array = _fileList.files;
  } else {
    array = [self detailCollectionArray];
  }
  return array.count;
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row {
  if (tableView == _fileListTable) {
    GTLRDrive_File *file = _fileList.files[row];
    return [self fileTitleWithLabelsForFile:file];
  } else {
    NSArray *array = [self detailCollectionArray];
    id item = array[row];
    return [self descriptionForDetailItem:item];
  }
}

- (NSString *)fileTitleWithLabelsForFile:(GTLRDrive_File *)file {

  NSMutableString *title = [NSMutableString stringWithString:file.name];

  if (file.starred.boolValue) {
    [title appendString:@" \u2605"]; // star character
  }
  if (file.trashed.boolValue) {
    [title insertString:@"\u2717 " atIndex:0]; // X character
  }
  if (file.viewersCanCopyContent.boolValue) {
    [title appendString:@" \u21DF"]; // crossed down arrow character
  }
  return title;
}

@end
