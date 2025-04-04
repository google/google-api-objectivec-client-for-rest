// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Rapid Migration Assessment API (rapidmigrationassessment/v1)
// Description:
//   The Rapid Migration Assessment service is our first-party migration
//   assessment and planning tool.
// Documentation:
//   https://cloud.google.com/migration-center

#import <GoogleAPIClientForREST/GTLRRapidMigrationAssessmentQuery.h>

@implementation GTLRRapidMigrationAssessmentQuery

@dynamic fields;

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsAnnotationsCreate

@dynamic parent, requestId;

+ (instancetype)queryWithObject:(GTLRRapidMigrationAssessment_Annotation *)object
                         parent:(NSString *)parent {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v1/{+parent}/annotations";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsAnnotationsCreate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.parent = parent;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_Operation class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.annotations.create";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsAnnotationsGet

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsAnnotationsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_Annotation class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.annotations.get";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsCreate

@dynamic collectorId, parent, requestId;

+ (instancetype)queryWithObject:(GTLRRapidMigrationAssessment_Collector *)object
                         parent:(NSString *)parent {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v1/{+parent}/collectors";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsCreate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.parent = parent;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_Operation class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.collectors.create";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsDelete

@dynamic name, requestId;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_Operation class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.collectors.delete";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsGet

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_Collector class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.collectors.get";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsList

@dynamic filter, orderBy, pageSize, pageToken, parent;

+ (instancetype)queryWithParent:(NSString *)parent {
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v1/{+parent}/collectors";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.parent = parent;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_ListCollectorsResponse class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.collectors.list";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsPatch

@dynamic name, requestId, updateMask;

+ (instancetype)queryWithObject:(GTLRRapidMigrationAssessment_Collector *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsPatch *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PATCH"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_Operation class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.collectors.patch";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsPause

@dynamic name;

+ (instancetype)queryWithObject:(GTLRRapidMigrationAssessment_PauseCollectorRequest *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}:pause";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsPause *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_Operation class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.collectors.pause";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsRegister

@dynamic name;

+ (instancetype)queryWithObject:(GTLRRapidMigrationAssessment_RegisterCollectorRequest *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}:register";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsRegister *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_Operation class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.collectors.register";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsResume

@dynamic name;

+ (instancetype)queryWithObject:(GTLRRapidMigrationAssessment_ResumeCollectorRequest *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}:resume";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsCollectorsResume *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_Operation class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.collectors.resume";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsGet

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_Location class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.get";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsList

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
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_ListLocationsResponse class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.list";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsOperationsCancel

@dynamic name;

+ (instancetype)queryWithObject:(GTLRRapidMigrationAssessment_CancelOperationRequest *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}:cancel";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsOperationsCancel *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_Empty class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.operations.cancel";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsOperationsDelete

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsOperationsDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_Empty class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.operations.delete";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsOperationsGet

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsOperationsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_Operation class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.operations.get";
  return query;
}

@end

@implementation GTLRRapidMigrationAssessmentQuery_ProjectsLocationsOperationsList

@dynamic filter, name, pageSize, pageToken;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1/{+name}/operations";
  GTLRRapidMigrationAssessmentQuery_ProjectsLocationsOperationsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRRapidMigrationAssessment_ListOperationsResponse class];
  query.loggingName = @"rapidmigrationassessment.projects.locations.operations.list";
  return query;
}

@end
