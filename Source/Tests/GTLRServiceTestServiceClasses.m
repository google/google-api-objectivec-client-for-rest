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

@implementation GTLRTestingSvc_File

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
    @"permissions" : [GTLRTestingSvc_Permission class],
    @"spaces" : [NSString class]
  };
  return map;
}

@end

@implementation GTLRTestingSvc_File_Surrogate
@end

#pragma mark Test Object Classes

@implementation GTLRTestingSvc_FileList
@dynamic files, kind, nextPageToken, timeFieldForTesting;

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map = @{
    @"files" : [GTLRTestingSvc_File class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"files";
}

@end

@implementation GTLRTestingSvc_FileList_Surrogate
@end

@implementation GTLRTestingSvc_FileList_Surrogate2
@end


@implementation GTLRTestingSvc_Permission
@dynamic allowFileDiscovery, displayName, domain, emailAddress, identifier,
         kind, photoLink, role, type;
+ (NSDictionary *)propertyToJSONKeyMap {
  return @{ @"identifier" : @"id" };
}
@end


@implementation GTLRTestingSvc_PermissionList
@dynamic kind, permissions;
+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map = @{
    @"permissions" : [GTLRTestingSvc_Permission class]
  };
  return map;
}
@end

#pragma mark Test Query Classes


@implementation GTLRTestingSvcQuery
@dynamic fields;

+ (NSDictionary<NSString *, Class> *)kindStringToClassMap {
  return @{
    @"drive#file" : [GTLRTestingSvc_File class],
    @"drive#fileList" : [GTLRTestingSvc_FileList class],
    @"drive#permission" : [GTLRTestingSvc_Permission class],
    @"drive#permissionList" : [GTLRTestingSvc_PermissionList class],
  };
}
@end


@implementation GTLRTestingSvcQuery_FilesGet
@dynamic acknowledgeAbuse, fileId;
+ (instancetype)queryWithFileId:(NSString *)fileId {
  NSArray *pathParams = @[ @"fileId" ];
  NSString *pathURITemplate = @"files/{fileId}";
  GTLRTestingSvcQuery_FilesGet *query =
      [[self alloc] initWithPathURITemplate:pathURITemplate
                                 HTTPMethod:nil
                         pathParameterNames:pathParams];
  query.fileId = fileId;
  query.expectedObjectClass = [GTLRTestingSvc_File class];
  query.loggingName = @"drive.files.get";
  return query;
}
+ (instancetype)queryForMediaWithFileId:(NSString *)fileId {
  GTLRTestingSvcQuery_FilesGet *query =
    [self queryWithFileId:fileId];
  query.downloadAsDataObjectType = @"media";
  query.loggingName = @"Download drive.files.get";
  return query;
}
@end


@implementation GTLRTestingSvcQuery_FilesList
@dynamic corpus, extras, orderBy, pageSize, pageToken, q, spaces, timeParamForTesting;
+ (instancetype)query {
  NSString *pathURITemplate = @"files";
  GTLRTestingSvcQuery_FilesList *query =
      [[self alloc] initWithPathURITemplate:pathURITemplate
                                 HTTPMethod:nil
                         pathParameterNames:nil];
  query.expectedObjectClass = [GTLRTestingSvc_FileList class];
  query.loggingName = @"drive.files.list";
  return query;
}
@end


@implementation GTLRTestingSvcQuery_FilesDelete

@dynamic fileId;

+ (instancetype)queryWithFileId:(NSString *)fileId {
  NSArray *pathParams = @[ @"fileId" ];
  NSString *pathURITemplate = @"files/{fileId}";
  GTLRTestingSvcQuery_FilesDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.fileId = fileId;
  query.loggingName = @"drive.files.delete";
  return query;
}

@end


@implementation GTLRTestingSvcQuery_PermissionsList

@dynamic fileId;
+ (instancetype)queryWithFileId:(NSString *)fileId {
  NSArray *pathParams = @[ @"fileId" ];
  NSString *pathURITemplate = @"files/{fileId}/permissions";
  GTLRTestingSvcQuery_PermissionsList *query =
  [[self alloc] initWithPathURITemplate:pathURITemplate
                             HTTPMethod:nil
                     pathParameterNames:pathParams];
  query.fileId = fileId;
  query.expectedObjectClass = [GTLRTestingSvc_PermissionList class];
  query.loggingName = @"drive.permissions.list";
  return query;
}
@end

@implementation GTLRTestingSvcQuery_FilesCreate

@dynamic ignoreDefaultVisibility, keepRevisionForever, ocrLanguage, useContentAsIndexableText;

+ (instancetype)queryWithObject:(GTLRTestingSvc_File *)object
               uploadParameters:(GTLRUploadParameters *)uploadParametersOrNil {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *pathURITemplate = @"files";
  GTLRTestingSvcQuery_FilesCreate *query =
  [[self alloc] initWithPathURITemplate:pathURITemplate
                             HTTPMethod:@"POST"
                     pathParameterNames:nil];
  query.bodyObject = object;
  query.uploadParameters = uploadParametersOrNil;
  query.expectedObjectClass = [GTLRTestingSvc_File class];
  query.loggingName = @"drive.files.create";
  return query;
}

@end

@implementation GTLRTestingSvcQuery_PermissionsCreate

@dynamic emailMessage, fileId, sendNotificationEmail, transferOwnership;

+ (instancetype)queryWithObject:(GTLRTestingSvc_Permission *)object
                         fileId:(NSString *)fileId {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSArray *pathParams = @[ @"fileId" ];
  NSString *pathURITemplate = @"files/{fileId}/permissions";
  GTLRTestingSvcQuery_PermissionsCreate *query =
      [[self alloc] initWithPathURITemplate:pathURITemplate
                                 HTTPMethod:@"POST"
                         pathParameterNames:pathParams];
  query.bodyObject = object;
  query.fileId = fileId;
  query.expectedObjectClass = [GTLRTestingSvc_Permission class];
  query.loggingName = @"drive.permissions.create";
  return query;
}

@end
