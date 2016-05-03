/* Copyright (c) 2016 Google Inc.
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

#import "GTLRService.h"

@interface Test_GTLRDrive_File : GTLRObject

@property(copy) NSString *kind;
@property(strong) NSArray <NSString *>*parents;
@property(copy) NSString *name;
@property(copy) NSString *identifier;


@property(copy) NSString *ETag;

@end

@interface Test_GTLRDrive_File_Surrogate : Test_GTLRDrive_File
@end

#pragma mark Test Object Classes

@interface Test_GTLRDrive_FileList : GTLRCollectionObject
@property(strong) NSArray<Test_GTLRDrive_File *> *files;
@property(copy) NSString *kind;
@property(copy) NSString *nextPageToken;

@property(copy) GTLRDateTime *timeFieldForTesting;

@end

@interface Test_GTLRDrive_FileList_Surrogate : Test_GTLRDrive_FileList
@end

@interface Test_GTLRDrive_FileList_Surrogate2 : Test_GTLRDrive_FileList
@end

@interface Test_GTLRDrive_Permission : GTLRObject
@property(strong) NSNumber *allowFileDiscovery;  // boolValue
@property(copy) NSString *displayName;
@property(copy) NSString *domain;
@property(copy) NSString *emailAddress;
@property(copy) NSString *identifier;
@property(copy) NSString *kind;
@property(copy) NSString *photoLink;
@property(copy) NSString *role;
@property(copy) NSString *type;
@end

@interface Test_GTLRDrive_PermissionList : GTLRObject
@property(copy) NSString *kind;
@property(strong) NSArray<Test_GTLRDrive_Permission *> *permissions;
@end


#pragma mark Test Query Classes

@interface Test_GTLRDriveQuery : GTLRQuery
@property(copy) NSString *fields;
@end


@interface Test_GTLRDriveQuery_FilesGet : Test_GTLRDriveQuery
@property(assign) BOOL acknowledgeAbuse;
@property(copy) NSString *fileId;
+ (instancetype)queryWithFileId:(NSString *)fileId;
+ (instancetype)queryForMediaWithFileId:(NSString *)fileId;
@end


@interface Test_GTLRDriveQuery_FilesList : Test_GTLRDriveQuery
@property(copy) NSString *corpus;
@property(copy) NSString *orderBy;
@property(assign) NSInteger pageSize;
@property(copy) NSString *pageToken;
@property(copy) NSString *q;
@property(copy) NSString *spaces;

@property(strong) GTLRDateTime *timeParamForTesting;

+ (instancetype)query;
@end


@interface Test_GTLRDriveQuery_FilesDelete : Test_GTLRDriveQuery
@property(copy) NSString *fileId;
+ (instancetype)queryWithFileId:(NSString *)fileId;
@end



@interface Test_GTLRDriveQuery_PermissionsList : Test_GTLRDriveQuery
@property(copy) NSString *fileId;
+ (instancetype)queryWithFileId:(NSString *)fileId;
@end

@interface Test_GTLRDriveQuery_FilesCreate : Test_GTLRDriveQuery

@property(assign) BOOL ignoreDefaultVisibility;
@property(assign) BOOL keepRevisionForever;
@property(copy) NSString *ocrLanguage;
@property(assign) BOOL useContentAsIndexableText;

+ (instancetype)queryWithObject:(Test_GTLRDrive_File *)object
               uploadParameters:(GTLRUploadParameters *)uploadParametersOrNil;
@end

@interface Test_GTLRDriveQuery_PermissionsCreate : Test_GTLRDriveQuery

@property(copy) NSString *emailMessage;
@property(copy) NSString *fileId;
@property(assign) BOOL sendNotificationEmail;
@property(assign) BOOL transferOwnership;

+ (instancetype)queryWithObject:(Test_GTLRDrive_Permission *)object
                         fileId:(NSString *)fileId;

@end
