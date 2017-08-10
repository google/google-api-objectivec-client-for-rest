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

@interface GTLRTestingSvc_File : GTLRObject

@property(nonatomic, copy) NSString *kind;
@property(nonatomic, strong) NSArray <NSString *>*parents;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *identifier;


@property(nonatomic, copy) NSString *ETag;

@end

@interface GTLRTestingSvc_File_Surrogate : GTLRTestingSvc_File
@end

#pragma mark Test Object Classes

@interface GTLRTestingSvc_FileList : GTLRCollectionObject
@property(nonatomic, strong) NSArray<GTLRTestingSvc_File *> *files;
@property(nonatomic, copy) NSString *kind;
@property(nonatomic, copy) NSString *nextPageToken;

@property(nonatomic, copy) GTLRDateTime *timeFieldForTesting;

@end

@interface GTLRTestingSvc_FileList_Surrogate : GTLRTestingSvc_FileList
@end

@interface GTLRTestingSvc_FileList_Surrogate2 : GTLRTestingSvc_FileList
@end

@interface GTLRTestingSvc_Permission : GTLRObject
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

@interface GTLRTestingSvc_PermissionList : GTLRObject
@property(nonatomic, copy) NSString *kind;
@property(nonatomic, strong) NSArray<GTLRTestingSvc_Permission *> *permissions;
@end


#pragma mark Test Query Classes

@interface GTLRTestingSvcQuery : GTLRQuery
@property(nonatomic, copy) NSString *fields;
@end


@interface GTLRTestingSvcQuery_FilesGet : GTLRTestingSvcQuery
@property(nonatomic, assign) BOOL acknowledgeAbuse;
@property(nonatomic, copy) NSString *fileId;
+ (instancetype)queryWithFileId:(NSString *)fileId;
+ (instancetype)queryForMediaWithFileId:(NSString *)fileId;
@end


@interface GTLRTestingSvcQuery_FilesList : GTLRTestingSvcQuery
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


@interface GTLRTestingSvcQuery_FilesDelete : GTLRTestingSvcQuery
@property(nonatomic, copy) NSString *fileId;
+ (instancetype)queryWithFileId:(NSString *)fileId;
@end



@interface GTLRTestingSvcQuery_PermissionsList : GTLRTestingSvcQuery
@property(nonatomic, copy) NSString *fileId;
+ (instancetype)queryWithFileId:(NSString *)fileId;
@end

@interface GTLRTestingSvcQuery_FilesCreate : GTLRTestingSvcQuery

@property(nonatomic, assign) BOOL ignoreDefaultVisibility;
@property(nonatomic, assign) BOOL keepRevisionForever;
@property(nonatomic, copy) NSString *ocrLanguage;
@property(nonatomic, assign) BOOL useContentAsIndexableText;

+ (instancetype)queryWithObject:(GTLRTestingSvc_File *)object
               uploadParameters:(GTLRUploadParameters *)uploadParametersOrNil;
@end

@interface GTLRTestingSvcQuery_PermissionsCreate : GTLRTestingSvcQuery

@property(nonatomic, copy) NSString *emailMessage;
@property(nonatomic, copy) NSString *fileId;
@property(nonatomic, assign) BOOL sendNotificationEmail;
@property(nonatomic, assign) BOOL transferOwnership;

+ (instancetype)queryWithObject:(GTLRTestingSvc_Permission *)object
                         fileId:(NSString *)fileId;

@end
