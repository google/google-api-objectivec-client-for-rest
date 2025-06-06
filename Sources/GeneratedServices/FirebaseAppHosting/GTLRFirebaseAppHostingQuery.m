// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Firebase App Hosting API (firebaseapphosting/v1)
// Description:
//   Firebase App Hosting streamlines the development and deployment of dynamic
//   Next.js and Angular applications, offering built-in framework support,
//   GitHub integration, and integration with other Firebase products. You can
//   use this API to intervene in the Firebase App Hosting build process and add
//   custom functionality not supported in our default Console & CLI flows,
//   including triggering builds from external CI/CD workflows or deploying from
//   pre-built container images.
// Documentation:
//   https://firebase.google.com/docs/app-hosting

#import <GoogleAPIClientForREST/GTLRFirebaseAppHostingQuery.h>

@implementation GTLRFirebaseAppHostingQuery

@dynamic fields;

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsBuildsCreate

@dynamic buildId, parent, requestId, validateOnly;

+ (instancetype)queryWithObject:(GTLRFirebaseAppHosting_Build *)object
                         parent:(NSString *)parent {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v1/{+parent}/builds";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsBuildsCreate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.parent = parent;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Operation class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.builds.create";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsBuildsDelete

@dynamic ETag, name, requestId, validateOnly;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"ETag" : @"etag" };
}

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsBuildsDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Operation class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.builds.delete";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsBuildsGet

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsBuildsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Build class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.builds.get";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsBuildsList

@dynamic filter, orderBy, pageSize, pageToken, parent, showDeleted;

+ (instancetype)queryWithParent:(NSString *)parent {
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v1/{+parent}/builds";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsBuildsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.parent = parent;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_ListBuildsResponse class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.builds.list";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsCreate

@dynamic backendId, parent, requestId, validateOnly;

+ (instancetype)queryWithObject:(GTLRFirebaseAppHosting_Backend *)object
                         parent:(NSString *)parent {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v1/{+parent}/backends";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsCreate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.parent = parent;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Operation class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.create";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsDelete

@dynamic ETag, force, name, requestId, validateOnly;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"ETag" : @"etag" };
}

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Operation class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.delete";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsDomainsCreate

@dynamic domainId, parent, requestId, validateOnly;

+ (instancetype)queryWithObject:(GTLRFirebaseAppHosting_Domain *)object
                         parent:(NSString *)parent {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v1/{+parent}/domains";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsDomainsCreate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.parent = parent;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Operation class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.domains.create";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsDomainsDelete

@dynamic ETag, name, requestId, validateOnly;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"ETag" : @"etag" };
}

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsDomainsDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Operation class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.domains.delete";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsDomainsGet

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsDomainsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Domain class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.domains.get";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsDomainsList

@dynamic filter, orderBy, pageSize, pageToken, parent, showDeleted;

+ (instancetype)queryWithParent:(NSString *)parent {
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v1/{+parent}/domains";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsDomainsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.parent = parent;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_ListDomainsResponse class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.domains.list";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsDomainsPatch

@dynamic allowMissing, name, requestId, updateMask, validateOnly;

+ (instancetype)queryWithObject:(GTLRFirebaseAppHosting_Domain *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsDomainsPatch *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PATCH"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Operation class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.domains.patch";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsGet

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Backend class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.get";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsList

@dynamic filter, orderBy, pageSize, pageToken, parent, showDeleted;

+ (instancetype)queryWithParent:(NSString *)parent {
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v1/{+parent}/backends";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.parent = parent;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_ListBackendsResponse class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.list";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsPatch

@dynamic allowMissing, name, requestId, updateMask, validateOnly;

+ (instancetype)queryWithObject:(GTLRFirebaseAppHosting_Backend *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsPatch *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PATCH"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Operation class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.patch";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsRolloutsCreate

@dynamic parent, requestId, rolloutId, validateOnly;

+ (instancetype)queryWithObject:(GTLRFirebaseAppHosting_Rollout *)object
                         parent:(NSString *)parent {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v1/{+parent}/rollouts";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsRolloutsCreate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.parent = parent;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Operation class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.rollouts.create";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsRolloutsGet

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsRolloutsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Rollout class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.rollouts.get";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsRolloutsList

@dynamic filter, orderBy, pageSize, pageToken, parent, showDeleted;

+ (instancetype)queryWithParent:(NSString *)parent {
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v1/{+parent}/rollouts";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsRolloutsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.parent = parent;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_ListRolloutsResponse class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.rollouts.list";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsTrafficGet

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsTrafficGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Traffic class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.traffic.get";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsTrafficPatch

@dynamic name, requestId, updateMask, validateOnly;

+ (instancetype)queryWithObject:(GTLRFirebaseAppHosting_Traffic *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsBackendsTrafficPatch *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PATCH"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Operation class];
  query.loggingName = @"firebaseapphosting.projects.locations.backends.traffic.patch";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsGet

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Location class];
  query.loggingName = @"firebaseapphosting.projects.locations.get";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsList

@dynamic extraLocationTypes, filter, name, pageSize, pageToken;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"extraLocationTypes" : [NSString class]
  };
  return map;
}

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}/locations";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_ListLocationsResponse class];
  query.loggingName = @"firebaseapphosting.projects.locations.list";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsOperationsCancel

@dynamic name;

+ (instancetype)queryWithObject:(GTLRFirebaseAppHosting_CancelOperationRequest *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}:cancel";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsOperationsCancel *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Empty class];
  query.loggingName = @"firebaseapphosting.projects.locations.operations.cancel";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsOperationsDelete

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsOperationsDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Empty class];
  query.loggingName = @"firebaseapphosting.projects.locations.operations.delete";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsOperationsGet

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsOperationsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_Operation class];
  query.loggingName = @"firebaseapphosting.projects.locations.operations.get";
  return query;
}

@end

@implementation GTLRFirebaseAppHostingQuery_ProjectsLocationsOperationsList

@dynamic filter, name, pageSize, pageToken;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}/operations";
  GTLRFirebaseAppHostingQuery_ProjectsLocationsOperationsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRFirebaseAppHosting_ListOperationsResponse class];
  query.loggingName = @"firebaseapphosting.projects.locations.operations.list";
  return query;
}

@end
