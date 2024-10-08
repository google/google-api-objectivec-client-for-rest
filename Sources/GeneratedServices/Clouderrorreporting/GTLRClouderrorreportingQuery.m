// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Error Reporting API (clouderrorreporting/v1beta1)
// Description:
//   Groups and counts similar errors from cloud services and applications,
//   reports new errors, and provides access to error groups and their
//   associated errors.
// Documentation:
//   https://cloud.google.com/error-reporting/

#import <GoogleAPIClientForREST/GTLRClouderrorreportingQuery.h>

// ----------------------------------------------------------------------------
// Constants

// alignment
NSString * const kGTLRClouderrorreportingAlignmentAlignmentEqualAtEnd = @"ALIGNMENT_EQUAL_AT_END";
NSString * const kGTLRClouderrorreportingAlignmentAlignmentEqualRounded = @"ALIGNMENT_EQUAL_ROUNDED";
NSString * const kGTLRClouderrorreportingAlignmentErrorCountAlignmentUnspecified = @"ERROR_COUNT_ALIGNMENT_UNSPECIFIED";

// order
NSString * const kGTLRClouderrorreportingOrderAffectedUsersDesc = @"AFFECTED_USERS_DESC";
NSString * const kGTLRClouderrorreportingOrderCountDesc        = @"COUNT_DESC";
NSString * const kGTLRClouderrorreportingOrderCreatedDesc      = @"CREATED_DESC";
NSString * const kGTLRClouderrorreportingOrderGroupOrderUnspecified = @"GROUP_ORDER_UNSPECIFIED";
NSString * const kGTLRClouderrorreportingOrderLastSeenDesc     = @"LAST_SEEN_DESC";

// timeRangePeriod
NSString * const kGTLRClouderrorreportingTimeRangePeriodPeriod1Day = @"PERIOD_1_DAY";
NSString * const kGTLRClouderrorreportingTimeRangePeriodPeriod1Hour = @"PERIOD_1_HOUR";
NSString * const kGTLRClouderrorreportingTimeRangePeriodPeriod1Week = @"PERIOD_1_WEEK";
NSString * const kGTLRClouderrorreportingTimeRangePeriodPeriod30Days = @"PERIOD_30_DAYS";
NSString * const kGTLRClouderrorreportingTimeRangePeriodPeriod6Hours = @"PERIOD_6_HOURS";
NSString * const kGTLRClouderrorreportingTimeRangePeriodPeriodUnspecified = @"PERIOD_UNSPECIFIED";

// ----------------------------------------------------------------------------
// Query Classes
//

@implementation GTLRClouderrorreportingQuery

@dynamic fields;

@end

@implementation GTLRClouderrorreportingQuery_ProjectsDeleteEvents

@dynamic projectName;

+ (instancetype)queryWithProjectName:(NSString *)projectName {
  NSArray *pathParams = @[ @"projectName" ];
  NSString *pathURITemplate = @"v1beta1/{+projectName}/events";
  GTLRClouderrorreportingQuery_ProjectsDeleteEvents *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.projectName = projectName;
  query.expectedObjectClass = [GTLRClouderrorreporting_DeleteEventsResponse class];
  query.loggingName = @"clouderrorreporting.projects.deleteEvents";
  return query;
}

@end

@implementation GTLRClouderrorreportingQuery_ProjectsEventsList

@dynamic groupId, pageSize, pageToken, projectName, serviceFilterResourceType,
         serviceFilterService, serviceFilterVersion, timeRangePeriod;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  NSDictionary<NSString *, NSString *> *map = @{
    @"serviceFilterResourceType" : @"serviceFilter.resourceType",
    @"serviceFilterService" : @"serviceFilter.service",
    @"serviceFilterVersion" : @"serviceFilter.version",
    @"timeRangePeriod" : @"timeRange.period"
  };
  return map;
}

+ (instancetype)queryWithProjectName:(NSString *)projectName {
  NSArray *pathParams = @[ @"projectName" ];
  NSString *pathURITemplate = @"v1beta1/{+projectName}/events";
  GTLRClouderrorreportingQuery_ProjectsEventsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.projectName = projectName;
  query.expectedObjectClass = [GTLRClouderrorreporting_ListEventsResponse class];
  query.loggingName = @"clouderrorreporting.projects.events.list";
  return query;
}

@end

@implementation GTLRClouderrorreportingQuery_ProjectsEventsReport

@dynamic projectName;

+ (instancetype)queryWithObject:(GTLRClouderrorreporting_ReportedErrorEvent *)object
                    projectName:(NSString *)projectName {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"projectName" ];
  NSString *pathURITemplate = @"v1beta1/{+projectName}/events:report";
  GTLRClouderrorreportingQuery_ProjectsEventsReport *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.projectName = projectName;
  query.expectedObjectClass = [GTLRClouderrorreporting_ReportErrorEventResponse class];
  query.loggingName = @"clouderrorreporting.projects.events.report";
  return query;
}

@end

@implementation GTLRClouderrorreportingQuery_ProjectsGroupsGet

@dynamic groupName;

+ (instancetype)queryWithGroupName:(NSString *)groupName {
  NSArray *pathParams = @[ @"groupName" ];
  NSString *pathURITemplate = @"v1beta1/{+groupName}";
  GTLRClouderrorreportingQuery_ProjectsGroupsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.groupName = groupName;
  query.expectedObjectClass = [GTLRClouderrorreporting_ErrorGroup class];
  query.loggingName = @"clouderrorreporting.projects.groups.get";
  return query;
}

@end

@implementation GTLRClouderrorreportingQuery_ProjectsGroupStatsList

@dynamic alignment, alignmentTime, groupId, order, pageSize, pageToken,
         projectName, serviceFilterResourceType, serviceFilterService,
         serviceFilterVersion, timedCountDuration, timeRangePeriod;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  NSDictionary<NSString *, NSString *> *map = @{
    @"serviceFilterResourceType" : @"serviceFilter.resourceType",
    @"serviceFilterService" : @"serviceFilter.service",
    @"serviceFilterVersion" : @"serviceFilter.version",
    @"timeRangePeriod" : @"timeRange.period"
  };
  return map;
}

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"groupId" : [NSString class]
  };
  return map;
}

+ (instancetype)queryWithProjectName:(NSString *)projectName {
  NSArray *pathParams = @[ @"projectName" ];
  NSString *pathURITemplate = @"v1beta1/{+projectName}/groupStats";
  GTLRClouderrorreportingQuery_ProjectsGroupStatsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.projectName = projectName;
  query.expectedObjectClass = [GTLRClouderrorreporting_ListGroupStatsResponse class];
  query.loggingName = @"clouderrorreporting.projects.groupStats.list";
  return query;
}

@end

@implementation GTLRClouderrorreportingQuery_ProjectsGroupsUpdate

@dynamic name;

+ (instancetype)queryWithObject:(GTLRClouderrorreporting_ErrorGroup *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1beta1/{+name}";
  GTLRClouderrorreportingQuery_ProjectsGroupsUpdate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PUT"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRClouderrorreporting_ErrorGroup class];
  query.loggingName = @"clouderrorreporting.projects.groups.update";
  return query;
}

@end

@implementation GTLRClouderrorreportingQuery_ProjectsLocationsDeleteEvents

@dynamic projectName;

+ (instancetype)queryWithProjectName:(NSString *)projectName {
  NSArray *pathParams = @[ @"projectName" ];
  NSString *pathURITemplate = @"v1beta1/{+projectName}/events";
  GTLRClouderrorreportingQuery_ProjectsLocationsDeleteEvents *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.projectName = projectName;
  query.expectedObjectClass = [GTLRClouderrorreporting_DeleteEventsResponse class];
  query.loggingName = @"clouderrorreporting.projects.locations.deleteEvents";
  return query;
}

@end

@implementation GTLRClouderrorreportingQuery_ProjectsLocationsEventsList

@dynamic groupId, pageSize, pageToken, projectName, serviceFilterResourceType,
         serviceFilterService, serviceFilterVersion, timeRangePeriod;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  NSDictionary<NSString *, NSString *> *map = @{
    @"serviceFilterResourceType" : @"serviceFilter.resourceType",
    @"serviceFilterService" : @"serviceFilter.service",
    @"serviceFilterVersion" : @"serviceFilter.version",
    @"timeRangePeriod" : @"timeRange.period"
  };
  return map;
}

+ (instancetype)queryWithProjectName:(NSString *)projectName {
  NSArray *pathParams = @[ @"projectName" ];
  NSString *pathURITemplate = @"v1beta1/{+projectName}/events";
  GTLRClouderrorreportingQuery_ProjectsLocationsEventsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.projectName = projectName;
  query.expectedObjectClass = [GTLRClouderrorreporting_ListEventsResponse class];
  query.loggingName = @"clouderrorreporting.projects.locations.events.list";
  return query;
}

@end

@implementation GTLRClouderrorreportingQuery_ProjectsLocationsGroupsGet

@dynamic groupName;

+ (instancetype)queryWithGroupName:(NSString *)groupName {
  NSArray *pathParams = @[ @"groupName" ];
  NSString *pathURITemplate = @"v1beta1/{+groupName}";
  GTLRClouderrorreportingQuery_ProjectsLocationsGroupsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.groupName = groupName;
  query.expectedObjectClass = [GTLRClouderrorreporting_ErrorGroup class];
  query.loggingName = @"clouderrorreporting.projects.locations.groups.get";
  return query;
}

@end

@implementation GTLRClouderrorreportingQuery_ProjectsLocationsGroupStatsList

@dynamic alignment, alignmentTime, groupId, order, pageSize, pageToken,
         projectName, serviceFilterResourceType, serviceFilterService,
         serviceFilterVersion, timedCountDuration, timeRangePeriod;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  NSDictionary<NSString *, NSString *> *map = @{
    @"serviceFilterResourceType" : @"serviceFilter.resourceType",
    @"serviceFilterService" : @"serviceFilter.service",
    @"serviceFilterVersion" : @"serviceFilter.version",
    @"timeRangePeriod" : @"timeRange.period"
  };
  return map;
}

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"groupId" : [NSString class]
  };
  return map;
}

+ (instancetype)queryWithProjectName:(NSString *)projectName {
  NSArray *pathParams = @[ @"projectName" ];
  NSString *pathURITemplate = @"v1beta1/{+projectName}/groupStats";
  GTLRClouderrorreportingQuery_ProjectsLocationsGroupStatsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.projectName = projectName;
  query.expectedObjectClass = [GTLRClouderrorreporting_ListGroupStatsResponse class];
  query.loggingName = @"clouderrorreporting.projects.locations.groupStats.list";
  return query;
}

@end

@implementation GTLRClouderrorreportingQuery_ProjectsLocationsGroupsUpdate

@dynamic name;

+ (instancetype)queryWithObject:(GTLRClouderrorreporting_ErrorGroup *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v1beta1/{+name}";
  GTLRClouderrorreportingQuery_ProjectsLocationsGroupsUpdate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PUT"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRClouderrorreporting_ErrorGroup class];
  query.loggingName = @"clouderrorreporting.projects.locations.groups.update";
  return query;
}

@end
