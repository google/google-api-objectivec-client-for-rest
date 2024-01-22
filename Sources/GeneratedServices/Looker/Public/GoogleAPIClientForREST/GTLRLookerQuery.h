// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Looker (Google Cloud core) API (looker/v1)
// Documentation:
//   https://cloud.google.com/looker/docs/reference/rest/

#import <GoogleAPIClientForREST/GTLRQuery.h>

#if GTLR_RUNTIME_VERSION != 3000
#error This file was generated by a different version of ServiceGenerator which is incompatible with this GTLR library source.
#endif

#import "GTLRLookerObjects.h"

// Generated comments include content from the discovery document; avoid them
// causing warnings since clang's checks are some what arbitrary.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Parent class for other Looker query classes.
 */
@interface GTLRLookerQuery : GTLRQuery

/** Selector specifying which fields to include in a partial response. */
@property(nonatomic, copy, nullable) NSString *fields;

@end

/**
 *  Gets information about a location.
 *
 *  Method: looker.projects.locations.get
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsGet : GTLRLookerQuery

/** Resource name for the location. */
@property(nonatomic, copy, nullable) NSString *name;

/**
 *  Fetches a @c GTLRLooker_Location.
 *
 *  Gets information about a location.
 *
 *  @param name Resource name for the location.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsGet
 */
+ (instancetype)queryWithName:(NSString *)name;

@end

/**
 *  Gets the access control policy for a resource. Returns an empty policy if
 *  the resource exists and does not have a policy set.
 *
 *  Method: looker.projects.locations.instances.backups.getIamPolicy
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsInstancesBackupsGetIamPolicy : GTLRLookerQuery

/**
 *  Optional. The maximum policy version that will be used to format the policy.
 *  Valid values are 0, 1, and 3. Requests specifying an invalid value will be
 *  rejected. Requests for policies with any conditional role bindings must
 *  specify version 3. Policies with no conditional role bindings may specify
 *  any valid value or leave the field unset. The policy in the response might
 *  use the policy version that you specified, or it might use a lower policy
 *  version. For example, if you specify version 3, but the policy has no
 *  conditional role bindings, the response uses version 1. To learn which
 *  resources support conditions in their IAM policies, see the [IAM
 *  documentation](https://cloud.google.com/iam/help/conditions/resource-policies).
 */
@property(nonatomic, assign) NSInteger optionsRequestedPolicyVersion;

/**
 *  REQUIRED: The resource for which the policy is being requested. See
 *  [Resource names](https://cloud.google.com/apis/design/resource_names) for
 *  the appropriate value for this field.
 */
@property(nonatomic, copy, nullable) NSString *resource;

/**
 *  Fetches a @c GTLRLooker_Policy.
 *
 *  Gets the access control policy for a resource. Returns an empty policy if
 *  the resource exists and does not have a policy set.
 *
 *  @param resource REQUIRED: The resource for which the policy is being
 *    requested. See [Resource
 *    names](https://cloud.google.com/apis/design/resource_names) for the
 *    appropriate value for this field.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsInstancesBackupsGetIamPolicy
 */
+ (instancetype)queryWithResource:(NSString *)resource;

@end

/**
 *  Sets the access control policy on the specified resource. Replaces any
 *  existing policy. Can return `NOT_FOUND`, `INVALID_ARGUMENT`, and
 *  `PERMISSION_DENIED` errors.
 *
 *  Method: looker.projects.locations.instances.backups.setIamPolicy
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsInstancesBackupsSetIamPolicy : GTLRLookerQuery

/**
 *  REQUIRED: The resource for which the policy is being specified. See
 *  [Resource names](https://cloud.google.com/apis/design/resource_names) for
 *  the appropriate value for this field.
 */
@property(nonatomic, copy, nullable) NSString *resource;

/**
 *  Fetches a @c GTLRLooker_Policy.
 *
 *  Sets the access control policy on the specified resource. Replaces any
 *  existing policy. Can return `NOT_FOUND`, `INVALID_ARGUMENT`, and
 *  `PERMISSION_DENIED` errors.
 *
 *  @param object The @c GTLRLooker_SetIamPolicyRequest to include in the query.
 *  @param resource REQUIRED: The resource for which the policy is being
 *    specified. See [Resource
 *    names](https://cloud.google.com/apis/design/resource_names) for the
 *    appropriate value for this field.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsInstancesBackupsSetIamPolicy
 */
+ (instancetype)queryWithObject:(GTLRLooker_SetIamPolicyRequest *)object
                       resource:(NSString *)resource;

@end

/**
 *  Returns permissions that a caller has on the specified resource. If the
 *  resource does not exist, this will return an empty set of permissions, not a
 *  `NOT_FOUND` error. Note: This operation is designed to be used for building
 *  permission-aware UIs and command-line tools, not for authorization checking.
 *  This operation may "fail open" without warning.
 *
 *  Method: looker.projects.locations.instances.backups.testIamPermissions
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsInstancesBackupsTestIamPermissions : GTLRLookerQuery

/**
 *  REQUIRED: The resource for which the policy detail is being requested. See
 *  [Resource names](https://cloud.google.com/apis/design/resource_names) for
 *  the appropriate value for this field.
 */
@property(nonatomic, copy, nullable) NSString *resource;

/**
 *  Fetches a @c GTLRLooker_TestIamPermissionsResponse.
 *
 *  Returns permissions that a caller has on the specified resource. If the
 *  resource does not exist, this will return an empty set of permissions, not a
 *  `NOT_FOUND` error. Note: This operation is designed to be used for building
 *  permission-aware UIs and command-line tools, not for authorization checking.
 *  This operation may "fail open" without warning.
 *
 *  @param object The @c GTLRLooker_TestIamPermissionsRequest to include in the
 *    query.
 *  @param resource REQUIRED: The resource for which the policy detail is being
 *    requested. See [Resource
 *    names](https://cloud.google.com/apis/design/resource_names) for the
 *    appropriate value for this field.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsInstancesBackupsTestIamPermissions
 */
+ (instancetype)queryWithObject:(GTLRLooker_TestIamPermissionsRequest *)object
                       resource:(NSString *)resource;

@end

/**
 *  Creates a new Instance in a given project and location.
 *
 *  Method: looker.projects.locations.instances.create
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsInstancesCreate : GTLRLookerQuery

/**
 *  Required. The unique instance identifier. Must contain only lowercase
 *  letters, numbers, or hyphens, with the first character a letter and the last
 *  a letter or a number. 63 characters maximum.
 */
@property(nonatomic, copy, nullable) NSString *instanceId;

/** Required. Format: `projects/{project}/locations/{location}`. */
@property(nonatomic, copy, nullable) NSString *parent;

/**
 *  Fetches a @c GTLRLooker_Operation.
 *
 *  Creates a new Instance in a given project and location.
 *
 *  @param object The @c GTLRLooker_Instance to include in the query.
 *  @param parent Required. Format: `projects/{project}/locations/{location}`.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsInstancesCreate
 */
+ (instancetype)queryWithObject:(GTLRLooker_Instance *)object
                         parent:(NSString *)parent;

@end

/**
 *  Delete instance.
 *
 *  Method: looker.projects.locations.instances.delete
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsInstancesDelete : GTLRLookerQuery

/** Whether to force cascading delete. */
@property(nonatomic, assign) BOOL force;

/**
 *  Required. Format:
 *  `projects/{project}/locations/{location}/instances/{instance}`.
 */
@property(nonatomic, copy, nullable) NSString *name;

/**
 *  Fetches a @c GTLRLooker_Operation.
 *
 *  Delete instance.
 *
 *  @param name Required. Format:
 *    `projects/{project}/locations/{location}/instances/{instance}`.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsInstancesDelete
 */
+ (instancetype)queryWithName:(NSString *)name;

@end

/**
 *  Export instance.
 *
 *  Method: looker.projects.locations.instances.export
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsInstancesExport : GTLRLookerQuery

/**
 *  Required. Format:
 *  `projects/{project}/locations/{location}/instances/{instance}`.
 */
@property(nonatomic, copy, nullable) NSString *name;

/**
 *  Fetches a @c GTLRLooker_Operation.
 *
 *  Export instance.
 *
 *  @param object The @c GTLRLooker_ExportInstanceRequest to include in the
 *    query.
 *  @param name Required. Format:
 *    `projects/{project}/locations/{location}/instances/{instance}`.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsInstancesExport
 */
+ (instancetype)queryWithObject:(GTLRLooker_ExportInstanceRequest *)object
                           name:(NSString *)name;

@end

/**
 *  Gets details of a single Instance.
 *
 *  Method: looker.projects.locations.instances.get
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsInstancesGet : GTLRLookerQuery

/**
 *  Required. Format:
 *  `projects/{project}/locations/{location}/instances/{instance}`.
 */
@property(nonatomic, copy, nullable) NSString *name;

/**
 *  Fetches a @c GTLRLooker_Instance.
 *
 *  Gets details of a single Instance.
 *
 *  @param name Required. Format:
 *    `projects/{project}/locations/{location}/instances/{instance}`.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsInstancesGet
 */
+ (instancetype)queryWithName:(NSString *)name;

@end

/**
 *  Gets the access control policy for a resource. Returns an empty policy if
 *  the resource exists and does not have a policy set.
 *
 *  Method: looker.projects.locations.instances.getIamPolicy
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsInstancesGetIamPolicy : GTLRLookerQuery

/**
 *  Optional. The maximum policy version that will be used to format the policy.
 *  Valid values are 0, 1, and 3. Requests specifying an invalid value will be
 *  rejected. Requests for policies with any conditional role bindings must
 *  specify version 3. Policies with no conditional role bindings may specify
 *  any valid value or leave the field unset. The policy in the response might
 *  use the policy version that you specified, or it might use a lower policy
 *  version. For example, if you specify version 3, but the policy has no
 *  conditional role bindings, the response uses version 1. To learn which
 *  resources support conditions in their IAM policies, see the [IAM
 *  documentation](https://cloud.google.com/iam/help/conditions/resource-policies).
 */
@property(nonatomic, assign) NSInteger optionsRequestedPolicyVersion;

/**
 *  REQUIRED: The resource for which the policy is being requested. See
 *  [Resource names](https://cloud.google.com/apis/design/resource_names) for
 *  the appropriate value for this field.
 */
@property(nonatomic, copy, nullable) NSString *resource;

/**
 *  Fetches a @c GTLRLooker_Policy.
 *
 *  Gets the access control policy for a resource. Returns an empty policy if
 *  the resource exists and does not have a policy set.
 *
 *  @param resource REQUIRED: The resource for which the policy is being
 *    requested. See [Resource
 *    names](https://cloud.google.com/apis/design/resource_names) for the
 *    appropriate value for this field.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsInstancesGetIamPolicy
 */
+ (instancetype)queryWithResource:(NSString *)resource;

@end

/**
 *  Import instance.
 *
 *  Method: looker.projects.locations.instances.import
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsInstancesImport : GTLRLookerQuery

/**
 *  Required. Format:
 *  `projects/{project}/locations/{location}/instances/{instance}`.
 */
@property(nonatomic, copy, nullable) NSString *name;

/**
 *  Fetches a @c GTLRLooker_Operation.
 *
 *  Import instance.
 *
 *  @param object The @c GTLRLooker_ImportInstanceRequest to include in the
 *    query.
 *  @param name Required. Format:
 *    `projects/{project}/locations/{location}/instances/{instance}`.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsInstancesImport
 */
+ (instancetype)queryWithObject:(GTLRLooker_ImportInstanceRequest *)object
                           name:(NSString *)name;

@end

/**
 *  Lists Instances in a given project and location.
 *
 *  Method: looker.projects.locations.instances.list
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsInstancesList : GTLRLookerQuery

/**
 *  The maximum number of instances to return. If unspecified at most 256 will
 *  be returned. The maximum possible value is 2048.
 */
@property(nonatomic, assign) NSInteger pageSize;

/** A page token received from a previous ListInstancesRequest. */
@property(nonatomic, copy, nullable) NSString *pageToken;

/** Required. Format: `projects/{project}/locations/{location}`. */
@property(nonatomic, copy, nullable) NSString *parent;

/**
 *  Fetches a @c GTLRLooker_ListInstancesResponse.
 *
 *  Lists Instances in a given project and location.
 *
 *  @param parent Required. Format: `projects/{project}/locations/{location}`.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsInstancesList
 *
 *  @note Automatic pagination will be done when @c shouldFetchNextPages is
 *        enabled. See @c shouldFetchNextPages on @c GTLRService for more
 *        information.
 */
+ (instancetype)queryWithParent:(NSString *)parent;

@end

/**
 *  Update Instance.
 *
 *  Method: looker.projects.locations.instances.patch
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsInstancesPatch : GTLRLookerQuery

/**
 *  Output only. Format:
 *  `projects/{project}/locations/{location}/instances/{instance}`.
 */
@property(nonatomic, copy, nullable) NSString *name;

/**
 *  Required. Field mask used to specify the fields to be overwritten in the
 *  Instance resource by the update. The fields specified in the mask are
 *  relative to the resource, not the full request. A field will be overwritten
 *  if it is in the mask.
 *
 *  String format is a comma-separated list of fields.
 */
@property(nonatomic, copy, nullable) NSString *updateMask;

/**
 *  Fetches a @c GTLRLooker_Operation.
 *
 *  Update Instance.
 *
 *  @param object The @c GTLRLooker_Instance to include in the query.
 *  @param name Output only. Format:
 *    `projects/{project}/locations/{location}/instances/{instance}`.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsInstancesPatch
 */
+ (instancetype)queryWithObject:(GTLRLooker_Instance *)object
                           name:(NSString *)name;

@end

/**
 *  Restart instance.
 *
 *  Method: looker.projects.locations.instances.restart
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsInstancesRestart : GTLRLookerQuery

/**
 *  Required. Format:
 *  `projects/{project}/locations/{location}/instances/{instance}`.
 */
@property(nonatomic, copy, nullable) NSString *name;

/**
 *  Fetches a @c GTLRLooker_Operation.
 *
 *  Restart instance.
 *
 *  @param object The @c GTLRLooker_RestartInstanceRequest to include in the
 *    query.
 *  @param name Required. Format:
 *    `projects/{project}/locations/{location}/instances/{instance}`.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsInstancesRestart
 */
+ (instancetype)queryWithObject:(GTLRLooker_RestartInstanceRequest *)object
                           name:(NSString *)name;

@end

/**
 *  Sets the access control policy on the specified resource. Replaces any
 *  existing policy. Can return `NOT_FOUND`, `INVALID_ARGUMENT`, and
 *  `PERMISSION_DENIED` errors.
 *
 *  Method: looker.projects.locations.instances.setIamPolicy
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsInstancesSetIamPolicy : GTLRLookerQuery

/**
 *  REQUIRED: The resource for which the policy is being specified. See
 *  [Resource names](https://cloud.google.com/apis/design/resource_names) for
 *  the appropriate value for this field.
 */
@property(nonatomic, copy, nullable) NSString *resource;

/**
 *  Fetches a @c GTLRLooker_Policy.
 *
 *  Sets the access control policy on the specified resource. Replaces any
 *  existing policy. Can return `NOT_FOUND`, `INVALID_ARGUMENT`, and
 *  `PERMISSION_DENIED` errors.
 *
 *  @param object The @c GTLRLooker_SetIamPolicyRequest to include in the query.
 *  @param resource REQUIRED: The resource for which the policy is being
 *    specified. See [Resource
 *    names](https://cloud.google.com/apis/design/resource_names) for the
 *    appropriate value for this field.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsInstancesSetIamPolicy
 */
+ (instancetype)queryWithObject:(GTLRLooker_SetIamPolicyRequest *)object
                       resource:(NSString *)resource;

@end

/**
 *  Returns permissions that a caller has on the specified resource. If the
 *  resource does not exist, this will return an empty set of permissions, not a
 *  `NOT_FOUND` error. Note: This operation is designed to be used for building
 *  permission-aware UIs and command-line tools, not for authorization checking.
 *  This operation may "fail open" without warning.
 *
 *  Method: looker.projects.locations.instances.testIamPermissions
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsInstancesTestIamPermissions : GTLRLookerQuery

/**
 *  REQUIRED: The resource for which the policy detail is being requested. See
 *  [Resource names](https://cloud.google.com/apis/design/resource_names) for
 *  the appropriate value for this field.
 */
@property(nonatomic, copy, nullable) NSString *resource;

/**
 *  Fetches a @c GTLRLooker_TestIamPermissionsResponse.
 *
 *  Returns permissions that a caller has on the specified resource. If the
 *  resource does not exist, this will return an empty set of permissions, not a
 *  `NOT_FOUND` error. Note: This operation is designed to be used for building
 *  permission-aware UIs and command-line tools, not for authorization checking.
 *  This operation may "fail open" without warning.
 *
 *  @param object The @c GTLRLooker_TestIamPermissionsRequest to include in the
 *    query.
 *  @param resource REQUIRED: The resource for which the policy detail is being
 *    requested. See [Resource
 *    names](https://cloud.google.com/apis/design/resource_names) for the
 *    appropriate value for this field.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsInstancesTestIamPermissions
 */
+ (instancetype)queryWithObject:(GTLRLooker_TestIamPermissionsRequest *)object
                       resource:(NSString *)resource;

@end

/**
 *  Lists information about the supported locations for this service.
 *
 *  Method: looker.projects.locations.list
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsList : GTLRLookerQuery

/**
 *  A filter to narrow down results to a preferred subset. The filtering
 *  language accepts strings like `"displayName=tokyo"`, and is documented in
 *  more detail in [AIP-160](https://google.aip.dev/160).
 */
@property(nonatomic, copy, nullable) NSString *filter;

/** The resource that owns the locations collection, if applicable. */
@property(nonatomic, copy, nullable) NSString *name;

/**
 *  The maximum number of results to return. If not set, the service selects a
 *  default.
 */
@property(nonatomic, assign) NSInteger pageSize;

/**
 *  A page token received from the `next_page_token` field in the response. Send
 *  that page token to receive the subsequent page.
 */
@property(nonatomic, copy, nullable) NSString *pageToken;

/**
 *  Fetches a @c GTLRLooker_ListLocationsResponse.
 *
 *  Lists information about the supported locations for this service.
 *
 *  @param name The resource that owns the locations collection, if applicable.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsList
 *
 *  @note Automatic pagination will be done when @c shouldFetchNextPages is
 *        enabled. See @c shouldFetchNextPages on @c GTLRService for more
 *        information.
 */
+ (instancetype)queryWithName:(NSString *)name;

@end

/**
 *  Starts asynchronous cancellation on a long-running operation. The server
 *  makes a best effort to cancel the operation, but success is not guaranteed.
 *  If the server doesn't support this method, it returns
 *  `google.rpc.Code.UNIMPLEMENTED`. Clients can use Operations.GetOperation or
 *  other methods to check whether the cancellation succeeded or whether the
 *  operation completed despite cancellation. On successful cancellation, the
 *  operation is not deleted; instead, it becomes an operation with an
 *  Operation.error value with a google.rpc.Status.code of 1, corresponding to
 *  `Code.CANCELLED`.
 *
 *  Method: looker.projects.locations.operations.cancel
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsOperationsCancel : GTLRLookerQuery

/** The name of the operation resource to be cancelled. */
@property(nonatomic, copy, nullable) NSString *name;

/**
 *  Fetches a @c GTLRLooker_Empty.
 *
 *  Starts asynchronous cancellation on a long-running operation. The server
 *  makes a best effort to cancel the operation, but success is not guaranteed.
 *  If the server doesn't support this method, it returns
 *  `google.rpc.Code.UNIMPLEMENTED`. Clients can use Operations.GetOperation or
 *  other methods to check whether the cancellation succeeded or whether the
 *  operation completed despite cancellation. On successful cancellation, the
 *  operation is not deleted; instead, it becomes an operation with an
 *  Operation.error value with a google.rpc.Status.code of 1, corresponding to
 *  `Code.CANCELLED`.
 *
 *  @param object The @c GTLRLooker_CancelOperationRequest to include in the
 *    query.
 *  @param name The name of the operation resource to be cancelled.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsOperationsCancel
 */
+ (instancetype)queryWithObject:(GTLRLooker_CancelOperationRequest *)object
                           name:(NSString *)name;

@end

/**
 *  Deletes a long-running operation. This method indicates that the client is
 *  no longer interested in the operation result. It does not cancel the
 *  operation. If the server doesn't support this method, it returns
 *  `google.rpc.Code.UNIMPLEMENTED`.
 *
 *  Method: looker.projects.locations.operations.delete
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsOperationsDelete : GTLRLookerQuery

/** The name of the operation resource to be deleted. */
@property(nonatomic, copy, nullable) NSString *name;

/**
 *  Fetches a @c GTLRLooker_Empty.
 *
 *  Deletes a long-running operation. This method indicates that the client is
 *  no longer interested in the operation result. It does not cancel the
 *  operation. If the server doesn't support this method, it returns
 *  `google.rpc.Code.UNIMPLEMENTED`.
 *
 *  @param name The name of the operation resource to be deleted.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsOperationsDelete
 */
+ (instancetype)queryWithName:(NSString *)name;

@end

/**
 *  Gets the latest state of a long-running operation. Clients can use this
 *  method to poll the operation result at intervals as recommended by the API
 *  service.
 *
 *  Method: looker.projects.locations.operations.get
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsOperationsGet : GTLRLookerQuery

/** The name of the operation resource. */
@property(nonatomic, copy, nullable) NSString *name;

/**
 *  Fetches a @c GTLRLooker_Operation.
 *
 *  Gets the latest state of a long-running operation. Clients can use this
 *  method to poll the operation result at intervals as recommended by the API
 *  service.
 *
 *  @param name The name of the operation resource.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsOperationsGet
 */
+ (instancetype)queryWithName:(NSString *)name;

@end

/**
 *  Lists operations that match the specified filter in the request. If the
 *  server doesn't support this method, it returns `UNIMPLEMENTED`.
 *
 *  Method: looker.projects.locations.operations.list
 *
 *  Authorization scope(s):
 *    @c kGTLRAuthScopeLookerCloudPlatform
 */
@interface GTLRLookerQuery_ProjectsLocationsOperationsList : GTLRLookerQuery

/** The standard list filter. */
@property(nonatomic, copy, nullable) NSString *filter;

/** The name of the operation's parent resource. */
@property(nonatomic, copy, nullable) NSString *name;

/** The standard list page size. */
@property(nonatomic, assign) NSInteger pageSize;

/** The standard list page token. */
@property(nonatomic, copy, nullable) NSString *pageToken;

/**
 *  Fetches a @c GTLRLooker_ListOperationsResponse.
 *
 *  Lists operations that match the specified filter in the request. If the
 *  server doesn't support this method, it returns `UNIMPLEMENTED`.
 *
 *  @param name The name of the operation's parent resource.
 *
 *  @return GTLRLookerQuery_ProjectsLocationsOperationsList
 *
 *  @note Automatic pagination will be done when @c shouldFetchNextPages is
 *        enabled. See @c shouldFetchNextPages on @c GTLRService for more
 *        information.
 */
+ (instancetype)queryWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop