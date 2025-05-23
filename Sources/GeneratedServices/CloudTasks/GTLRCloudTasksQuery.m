// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Cloud Tasks API (cloudtasks/v2)
// Description:
//   Manages the execution of large numbers of distributed requests.
// Documentation:
//   https://cloud.google.com/tasks/

#import <GoogleAPIClientForREST/GTLRCloudTasksQuery.h>

// ----------------------------------------------------------------------------
// Constants

// responseView
NSString * const kGTLRCloudTasksResponseViewBasic           = @"BASIC";
NSString * const kGTLRCloudTasksResponseViewFull            = @"FULL";
NSString * const kGTLRCloudTasksResponseViewViewUnspecified = @"VIEW_UNSPECIFIED";

// ----------------------------------------------------------------------------
// Query Classes
//

@implementation GTLRCloudTasksQuery

@dynamic fields;

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsGet

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v2/{+name}";
  GTLRCloudTasksQuery_ProjectsLocationsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRCloudTasks_Location class];
  query.loggingName = @"cloudtasks.projects.locations.get";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsGetCmekConfig

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v2/{+name}";
  GTLRCloudTasksQuery_ProjectsLocationsGetCmekConfig *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRCloudTasks_CmekConfig class];
  query.loggingName = @"cloudtasks.projects.locations.getCmekConfig";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsList

@dynamic extraLocationTypes, filter, name, pageSize, pageToken;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"extraLocationTypes" : [NSString class]
  };
  return map;
}

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v2/{+name}/locations";
  GTLRCloudTasksQuery_ProjectsLocationsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRCloudTasks_ListLocationsResponse class];
  query.loggingName = @"cloudtasks.projects.locations.list";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesCreate

@dynamic parent;

+ (instancetype)queryWithObject:(GTLRCloudTasks_Queue *)object
                         parent:(NSString *)parent {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v2/{+parent}/queues";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesCreate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.parent = parent;
  query.expectedObjectClass = [GTLRCloudTasks_Queue class];
  query.loggingName = @"cloudtasks.projects.locations.queues.create";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesDelete

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v2/{+name}";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRCloudTasks_Empty class];
  query.loggingName = @"cloudtasks.projects.locations.queues.delete";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesGet

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v2/{+name}";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRCloudTasks_Queue class];
  query.loggingName = @"cloudtasks.projects.locations.queues.get";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesGetIamPolicy

@dynamic resource;

+ (instancetype)queryWithObject:(GTLRCloudTasks_GetIamPolicyRequest *)object
                       resource:(NSString *)resource {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"resource" ];
  NSString *pathURITemplate = @"v2/{+resource}:getIamPolicy";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesGetIamPolicy *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.resource = resource;
  query.expectedObjectClass = [GTLRCloudTasks_Policy class];
  query.loggingName = @"cloudtasks.projects.locations.queues.getIamPolicy";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesList

@dynamic filter, pageSize, pageToken, parent;

+ (instancetype)queryWithParent:(NSString *)parent {
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v2/{+parent}/queues";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.parent = parent;
  query.expectedObjectClass = [GTLRCloudTasks_ListQueuesResponse class];
  query.loggingName = @"cloudtasks.projects.locations.queues.list";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesPatch

@dynamic name, updateMask;

+ (instancetype)queryWithObject:(GTLRCloudTasks_Queue *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v2/{+name}";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesPatch *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PATCH"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRCloudTasks_Queue class];
  query.loggingName = @"cloudtasks.projects.locations.queues.patch";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesPause

@dynamic name;

+ (instancetype)queryWithObject:(GTLRCloudTasks_PauseQueueRequest *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v2/{+name}:pause";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesPause *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRCloudTasks_Queue class];
  query.loggingName = @"cloudtasks.projects.locations.queues.pause";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesPurge

@dynamic name;

+ (instancetype)queryWithObject:(GTLRCloudTasks_PurgeQueueRequest *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v2/{+name}:purge";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesPurge *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRCloudTasks_Queue class];
  query.loggingName = @"cloudtasks.projects.locations.queues.purge";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesResume

@dynamic name;

+ (instancetype)queryWithObject:(GTLRCloudTasks_ResumeQueueRequest *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v2/{+name}:resume";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesResume *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRCloudTasks_Queue class];
  query.loggingName = @"cloudtasks.projects.locations.queues.resume";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesSetIamPolicy

@dynamic resource;

+ (instancetype)queryWithObject:(GTLRCloudTasks_SetIamPolicyRequest *)object
                       resource:(NSString *)resource {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"resource" ];
  NSString *pathURITemplate = @"v2/{+resource}:setIamPolicy";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesSetIamPolicy *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.resource = resource;
  query.expectedObjectClass = [GTLRCloudTasks_Policy class];
  query.loggingName = @"cloudtasks.projects.locations.queues.setIamPolicy";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesTasksBuffer

@dynamic queue, taskId;

+ (instancetype)queryWithObject:(GTLRCloudTasks_BufferTaskRequest *)object
                          queue:(NSString *)queue
                         taskId:(NSString *)taskId {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[
    @"queue", @"taskId"
  ];
  NSString *pathURITemplate = @"v2/{+queue}/tasks/{taskId}:buffer";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesTasksBuffer *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.queue = queue;
  query.taskId = taskId;
  query.expectedObjectClass = [GTLRCloudTasks_BufferTaskResponse class];
  query.loggingName = @"cloudtasks.projects.locations.queues.tasks.buffer";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesTasksCreate

@dynamic parent;

+ (instancetype)queryWithObject:(GTLRCloudTasks_CreateTaskRequest *)object
                         parent:(NSString *)parent {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v2/{+parent}/tasks";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesTasksCreate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.parent = parent;
  query.expectedObjectClass = [GTLRCloudTasks_Task class];
  query.loggingName = @"cloudtasks.projects.locations.queues.tasks.create";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesTasksDelete

@dynamic name;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v2/{+name}";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesTasksDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRCloudTasks_Empty class];
  query.loggingName = @"cloudtasks.projects.locations.queues.tasks.delete";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesTasksGet

@dynamic name, responseView;

+ (instancetype)queryWithName:(NSString *)name {
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v2/{+name}";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesTasksGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.name = name;
  query.expectedObjectClass = [GTLRCloudTasks_Task class];
  query.loggingName = @"cloudtasks.projects.locations.queues.tasks.get";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesTasksList

@dynamic pageSize, pageToken, parent, responseView;

+ (instancetype)queryWithParent:(NSString *)parent {
  NSArray *pathParams = @[ @"parent" ];
  NSString *pathURITemplate = @"v2/{+parent}/tasks";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesTasksList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.parent = parent;
  query.expectedObjectClass = [GTLRCloudTasks_ListTasksResponse class];
  query.loggingName = @"cloudtasks.projects.locations.queues.tasks.list";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesTasksRun

@dynamic name;

+ (instancetype)queryWithObject:(GTLRCloudTasks_RunTaskRequest *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v2/{+name}:run";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesTasksRun *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRCloudTasks_Task class];
  query.loggingName = @"cloudtasks.projects.locations.queues.tasks.run";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsQueuesTestIamPermissions

@dynamic resource;

+ (instancetype)queryWithObject:(GTLRCloudTasks_TestIamPermissionsRequest *)object
                       resource:(NSString *)resource {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"resource" ];
  NSString *pathURITemplate = @"v2/{+resource}:testIamPermissions";
  GTLRCloudTasksQuery_ProjectsLocationsQueuesTestIamPermissions *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.resource = resource;
  query.expectedObjectClass = [GTLRCloudTasks_TestIamPermissionsResponse class];
  query.loggingName = @"cloudtasks.projects.locations.queues.testIamPermissions";
  return query;
}

@end

@implementation GTLRCloudTasksQuery_ProjectsLocationsUpdateCmekConfig

@dynamic name, updateMask;

+ (instancetype)queryWithObject:(GTLRCloudTasks_CmekConfig *)object
                           name:(NSString *)name {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSArray *pathParams = @[ @"name" ];
  NSString *pathURITemplate = @"v2/{+name}";
  GTLRCloudTasksQuery_ProjectsLocationsUpdateCmekConfig *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PATCH"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.name = name;
  query.expectedObjectClass = [GTLRCloudTasks_CmekConfig class];
  query.loggingName = @"cloudtasks.projects.locations.updateCmekConfig";
  return query;
}

@end
