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

@property(nonatomic, copy) NSString *kind;
@property(nonatomic, strong) NSArray <NSString *>*parents;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *identifier;


@property(nonatomic, copy) NSString *ETag;

@end

@interface Test_GTLRDrive_File_Surrogate : Test_GTLRDrive_File
@end

#pragma mark Test Object Classes

@interface Test_GTLRDrive_FileList : GTLRCollectionObject
@property(nonatomic, strong) NSArray<Test_GTLRDrive_File *> *files;
@property(nonatomic, copy) NSString *kind;
@property(nonatomic, copy) NSString *nextPageToken;

@property(nonatomic, copy) GTLRDateTime *timeFieldForTesting;

@end

@interface Test_GTLRDrive_FileList_Surrogate : Test_GTLRDrive_FileList
@end

@interface Test_GTLRDrive_FileList_Surrogate2 : Test_GTLRDrive_FileList
@end

@interface Test_GTLRDrive_Permission : GTLRObject
@property(nonatomic, strong) NSNumber *allowFileDiscovery;  // boolValue
@property(nonatomic, copy) NSString *displayName;
@property(nonatomic, copy) NSString *domain;
@property(nonatomic, copy) NSString *emailAddress;
@property(nonatomic, copy) NSString *identifier;
@property(nonatomic, copy) NSString *kind;
@property(nonatomic, copy) NSString *photoLink;
@property(nonatomic, copy) NSString *role;
@property(nonatomic, copy) NSString *type;
@end

@interface Test_GTLRDrive_PermissionList : GTLRObject
@property(nonatomic, copy) NSString *kind;
@property(nonatomic, strong) NSArray<Test_GTLRDrive_Permission *> *permissions;
@end


#pragma mark Test Query Classes

@interface Test_GTLRDriveQuery : GTLRQuery
@property(nonatomic, copy) NSString *fields;
@end


@interface Test_GTLRDriveQuery_FilesGet : Test_GTLRDriveQuery
@property(nonatomic, assign) BOOL acknowledgeAbuse;
@property(nonatomic, copy) NSString *fileId;
+ (instancetype)queryWithFileId:(NSString *)fileId;
+ (instancetype)queryForMediaWithFileId:(NSString *)fileId;
@end


@interface Test_GTLRDriveQuery_FilesList : Test_GTLRDriveQuery
@property(nonatomic, copy) NSString *corpus;
@property(nonatomic, copy) NSString *orderBy;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, copy) NSString *pageToken;
@property(nonatomic, copy) NSString *q;
@property(nonatomic, copy) NSString *spaces;
@property(nonatomic, strong) NSArray<NSString *> *extras;

@property(nonatomic, strong) GTLRDateTime *timeParamForTesting;

+ (instancetype)query;
@end


@interface Test_GTLRDriveQuery_FilesDelete : Test_GTLRDriveQuery
@property(nonatomic, copy) NSString *fileId;
+ (instancetype)queryWithFileId:(NSString *)fileId;
@end



@interface Test_GTLRDriveQuery_PermissionsList : Test_GTLRDriveQuery
@property(nonatomic, copy) NSString *fileId;
+ (instancetype)queryWithFileId:(NSString *)fileId;
@end

@interface Test_GTLRDriveQuery_FilesCreate : Test_GTLRDriveQuery

@property(nonatomic, assign) BOOL ignoreDefaultVisibility;
@property(nonatomic, assign) BOOL keepRevisionForever;
@property(nonatomic, copy) NSString *ocrLanguage;
@property(nonatomic, assign) BOOL useContentAsIndexableText;

+ (instancetype)queryWithObject:(Test_GTLRDrive_File *)object
               uploadParameters:(GTLRUploadParameters *)uploadParametersOrNil;
@end

@interface Test_GTLRDriveQuery_PermissionsCreate : Test_GTLRDriveQuery

@property(nonatomic, copy) NSString *emailMessage;
@property(nonatomic, copy) NSString *fileId;
@property(nonatomic, assign) BOOL sendNotificationEmail;
@property(nonatomic, assign) BOOL transferOwnership;

+ (instancetype)queryWithObject:(Test_GTLRDrive_Permission *)object
                         fileId:(NSString *)fileId;

@end
