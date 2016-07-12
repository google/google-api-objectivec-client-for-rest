/* Copyright (c) 2010 Google Inc.
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

#import "GTLRServiceTestServiceClasses.h"

//
// Copy of needed Drive API so testing won't require that the project have the
// actual Drive interfaces.
//

@implementation Test_GTLRDrive_File

@dynamic kind, parents, name, identifier, ETag;

+ (NSDictionary<NSString *, NSString *> *)propertyToJSONKeyMap {
  NSDictionary<NSString *, NSString *> *map = @{
    @"descriptionProperty" : @"description",
    @"identifier" : @"id",
    @"ETag" : @"etag"
  };
  return map;
}

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map = @{
    @"parents" : [NSString class],
    @"permissions" : [Test_GTLRDrive_Permission class],
    @"spaces" : [NSString class]
  };
  return map;
}

@end

@implementation Test_GTLRDrive_File_Surrogate
@end

#pragma mark Test Object Classes

@implementation Test_GTLRDrive_FileList
@dynamic files, kind, nextPageToken, timeFieldForTesting;

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map = @{
    @"files" : [Test_GTLRDrive_File class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"files";
}

@end

@implementation Test_GTLRDrive_FileList_Surrogate
@end

@implementation Test_GTLRDrive_FileList_Surrogate2
@end


@implementation Test_GTLRDrive_Permission
@dynamic allowFileDiscovery, displayName, domain, emailAddress, identifier,
         kind, photoLink, role, type;
+ (NSDictionary *)propertyToJSONKeyMap {
  return @{ @"identifier" : @"id" };
}
@end


@implementation Test_GTLRDrive_PermissionList
@dynamic kind, permissions;
+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map = @{
    @"permissions" : [Test_GTLRDrive_Permission class]
  };
  return map;
}
@end

#pragma mark Test Query Classes


@implementation Test_GTLRDriveQuery
@dynamic fields;

+ (NSDictionary<NSString *, Class> *)kindStringToClassMap {
  return @{
    @"drive#file" : [Test_GTLRDrive_File class],
    @"drive#fileList" : [Test_GTLRDrive_FileList class],
    @"drive#permission" : [Test_GTLRDrive_Permission class],
    @"drive#permissionList" : [Test_GTLRDrive_PermissionList class],
  };
}
@end


@implementation Test_GTLRDriveQuery_FilesGet
@dynamic acknowledgeAbuse, fileId;
+ (instancetype)queryWithFileId:(NSString *)fileId {
  NSArray *pathParams = @[ @"fileId" ];
  NSString *pathURITemplate = @"files/{fileId}";
  Test_GTLRDriveQuery_FilesGet *query =
      [[self alloc] initWithPathURITemplate:pathURITemplate
                                 HTTPMethod:nil
                         pathParameterNames:pathParams];
  query.fileId = fileId;
  query.expectedObjectClass = [Test_GTLRDrive_File class];
  query.loggingName = @"drive.files.get";
  return query;
}
+ (instancetype)queryForMediaWithFileId:(NSString *)fileId {
  Test_GTLRDriveQuery_FilesGet *query =
    [self queryWithFileId:fileId];
  query.downloadAsDataObjectType = @"media";
  query.loggingName = @"Download drive.files.get";
  return query;
}
@end


@implementation Test_GTLRDriveQuery_FilesList
@dynamic corpus, extras, orderBy, pageSize, pageToken, q, spaces, timeParamForTesting;
+ (instancetype)query {
  NSString *pathURITemplate = @"files";
  Test_GTLRDriveQuery_FilesList *query =
      [[self alloc] initWithPathURITemplate:pathURITemplate
                                 HTTPMethod:nil
                         pathParameterNames:nil];
  query.expectedObjectClass = [Test_GTLRDrive_FileList class];
  query.loggingName = @"drive.files.list";
  return query;
}
@end


@implementation Test_GTLRDriveQuery_FilesDelete

@dynamic fileId;

+ (instancetype)queryWithFileId:(NSString *)fileId {
  NSArray *pathParams = @[ @"fileId" ];
  NSString *pathURITemplate = @"files/{fileId}";
  Test_GTLRDriveQuery_FilesDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.fileId = fileId;
  query.loggingName = @"drive.files.delete";
  return query;
}

@end


@implementation Test_GTLRDriveQuery_PermissionsList

@dynamic fileId;
+ (instancetype)queryWithFileId:(NSString *)fileId {
  NSArray *pathParams = @[ @"fileId" ];
  NSString *pathURITemplate = @"files/{fileId}/permissions";
  Test_GTLRDriveQuery_PermissionsList *query =
  [[self alloc] initWithPathURITemplate:pathURITemplate
                             HTTPMethod:nil
                     pathParameterNames:pathParams];
  query.fileId = fileId;
  query.expectedObjectClass = [Test_GTLRDrive_PermissionList class];
  query.loggingName = @"drive.permissions.list";
  return query;
}
@end

@implementation Test_GTLRDriveQuery_FilesCreate

@dynamic ignoreDefaultVisibility, keepRevisionForever, ocrLanguage, useContentAsIndexableText;

+ (instancetype)queryWithObject:(Test_GTLRDrive_File *)object
               uploadParameters:(GTLRUploadParameters *)uploadParametersOrNil {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *pathURITemplate = @"files";
  Test_GTLRDriveQuery_FilesCreate *query =
  [[self alloc] initWithPathURITemplate:pathURITemplate
                             HTTPMethod:@"POST"
                     pathParameterNames:nil];
  query.bodyObject = object;
  query.uploadParameters = uploadParametersOrNil;
  query.expectedObjectClass = [Test_GTLRDrive_File class];
  query.loggingName = @"drive.files.create";
  return query;
}

@end

@implementation Test_GTLRDriveQuery_PermissionsCreate

@dynamic emailMessage, fileId, sendNotificationEmail, transferOwnership;

+ (instancetype)queryWithObject:(Test_GTLRDrive_Permission *)object
                         fileId:(NSString *)fileId {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSArray *pathParams = @[ @"fileId" ];
  NSString *pathURITemplate = @"files/{fileId}/permissions";
  Test_GTLRDriveQuery_PermissionsCreate *query =
      [[self alloc] initWithPathURITemplate:pathURITemplate
                                 HTTPMethod:@"POST"
                         pathParameterNames:pathParams];
  query.bodyObject = object;
  query.fileId = fileId;
  query.expectedObjectClass = [Test_GTLRDrive_Permission class];
  query.loggingName = @"drive.permissions.create";
  return query;
}

@end
