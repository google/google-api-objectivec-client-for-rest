// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   SaaS Runtime API (saasservicemgmt/v1beta1)
// Documentation:
//   https://cloud.google.com/saas-runtime/docs

#import <GoogleAPIClientForREST/GTLRSaaSServiceManagementObjects.h>

// ----------------------------------------------------------------------------
// Constants

// GTLRSaaSServiceManagement_Rollout.state
NSString * const kGTLRSaaSServiceManagement_Rollout_State_RolloutStateCancelled = @"ROLLOUT_STATE_CANCELLED";
NSString * const kGTLRSaaSServiceManagement_Rollout_State_RolloutStateCancelling = @"ROLLOUT_STATE_CANCELLING";
NSString * const kGTLRSaaSServiceManagement_Rollout_State_RolloutStateFailed = @"ROLLOUT_STATE_FAILED";
NSString * const kGTLRSaaSServiceManagement_Rollout_State_RolloutStatePaused = @"ROLLOUT_STATE_PAUSED";
NSString * const kGTLRSaaSServiceManagement_Rollout_State_RolloutStatePausing = @"ROLLOUT_STATE_PAUSING";
NSString * const kGTLRSaaSServiceManagement_Rollout_State_RolloutStateResuming = @"ROLLOUT_STATE_RESUMING";
NSString * const kGTLRSaaSServiceManagement_Rollout_State_RolloutStateRunning = @"ROLLOUT_STATE_RUNNING";
NSString * const kGTLRSaaSServiceManagement_Rollout_State_RolloutStateSucceeded = @"ROLLOUT_STATE_SUCCEEDED";
NSString * const kGTLRSaaSServiceManagement_Rollout_State_RolloutStateUnspecified = @"ROLLOUT_STATE_UNSPECIFIED";
NSString * const kGTLRSaaSServiceManagement_Rollout_State_RolloutStateWaiting = @"ROLLOUT_STATE_WAITING";

// GTLRSaaSServiceManagement_RolloutControl.action
NSString * const kGTLRSaaSServiceManagement_RolloutControl_Action_RolloutActionCancel = @"ROLLOUT_ACTION_CANCEL";
NSString * const kGTLRSaaSServiceManagement_RolloutControl_Action_RolloutActionPause = @"ROLLOUT_ACTION_PAUSE";
NSString * const kGTLRSaaSServiceManagement_RolloutControl_Action_RolloutActionRun = @"ROLLOUT_ACTION_RUN";
NSString * const kGTLRSaaSServiceManagement_RolloutControl_Action_RolloutActionUnspecified = @"ROLLOUT_ACTION_UNSPECIFIED";

// GTLRSaaSServiceManagement_RolloutKind.updateUnitKindStrategy
NSString * const kGTLRSaaSServiceManagement_RolloutKind_UpdateUnitKindStrategy_UpdateUnitKindStrategyNever = @"UPDATE_UNIT_KIND_STRATEGY_NEVER";
NSString * const kGTLRSaaSServiceManagement_RolloutKind_UpdateUnitKindStrategy_UpdateUnitKindStrategyOnStart = @"UPDATE_UNIT_KIND_STRATEGY_ON_START";
NSString * const kGTLRSaaSServiceManagement_RolloutKind_UpdateUnitKindStrategy_UpdateUnitKindStrategyUnspecified = @"UPDATE_UNIT_KIND_STRATEGY_UNSPECIFIED";

// GTLRSaaSServiceManagement_Unit.managementMode
NSString * const kGTLRSaaSServiceManagement_Unit_ManagementMode_ManagementModeSystem = @"MANAGEMENT_MODE_SYSTEM";
NSString * const kGTLRSaaSServiceManagement_Unit_ManagementMode_ManagementModeUnspecified = @"MANAGEMENT_MODE_UNSPECIFIED";
NSString * const kGTLRSaaSServiceManagement_Unit_ManagementMode_ManagementModeUser = @"MANAGEMENT_MODE_USER";

// GTLRSaaSServiceManagement_Unit.state
NSString * const kGTLRSaaSServiceManagement_Unit_State_UnitStateDeprovisioning = @"UNIT_STATE_DEPROVISIONING";
NSString * const kGTLRSaaSServiceManagement_Unit_State_UnitStateError = @"UNIT_STATE_ERROR";
NSString * const kGTLRSaaSServiceManagement_Unit_State_UnitStateNotProvisioned = @"UNIT_STATE_NOT_PROVISIONED";
NSString * const kGTLRSaaSServiceManagement_Unit_State_UnitStateProvisioning = @"UNIT_STATE_PROVISIONING";
NSString * const kGTLRSaaSServiceManagement_Unit_State_UnitStateReady = @"UNIT_STATE_READY";
NSString * const kGTLRSaaSServiceManagement_Unit_State_UnitStateUnspecified = @"UNIT_STATE_UNSPECIFIED";
NSString * const kGTLRSaaSServiceManagement_Unit_State_UnitStateUpdating = @"UNIT_STATE_UPDATING";

// GTLRSaaSServiceManagement_Unit.systemManagedState
NSString * const kGTLRSaaSServiceManagement_Unit_SystemManagedState_SystemManagedStateActive = @"SYSTEM_MANAGED_STATE_ACTIVE";
NSString * const kGTLRSaaSServiceManagement_Unit_SystemManagedState_SystemManagedStateDecommissioned = @"SYSTEM_MANAGED_STATE_DECOMMISSIONED";
NSString * const kGTLRSaaSServiceManagement_Unit_SystemManagedState_SystemManagedStateInactive = @"SYSTEM_MANAGED_STATE_INACTIVE";
NSString * const kGTLRSaaSServiceManagement_Unit_SystemManagedState_SystemManagedStateUnspecified = @"SYSTEM_MANAGED_STATE_UNSPECIFIED";

// GTLRSaaSServiceManagement_UnitCondition.status
NSString * const kGTLRSaaSServiceManagement_UnitCondition_Status_StatusFalse = @"STATUS_FALSE";
NSString * const kGTLRSaaSServiceManagement_UnitCondition_Status_StatusTrue = @"STATUS_TRUE";
NSString * const kGTLRSaaSServiceManagement_UnitCondition_Status_StatusUnknown = @"STATUS_UNKNOWN";
NSString * const kGTLRSaaSServiceManagement_UnitCondition_Status_StatusUnspecified = @"STATUS_UNSPECIFIED";

// GTLRSaaSServiceManagement_UnitCondition.type
NSString * const kGTLRSaaSServiceManagement_UnitCondition_Type_TypeOperationError = @"TYPE_OPERATION_ERROR";
NSString * const kGTLRSaaSServiceManagement_UnitCondition_Type_TypeProvisioned = @"TYPE_PROVISIONED";
NSString * const kGTLRSaaSServiceManagement_UnitCondition_Type_TypeReady = @"TYPE_READY";
NSString * const kGTLRSaaSServiceManagement_UnitCondition_Type_TypeUnspecified = @"TYPE_UNSPECIFIED";
NSString * const kGTLRSaaSServiceManagement_UnitCondition_Type_TypeUpdating = @"TYPE_UPDATING";

// GTLRSaaSServiceManagement_UnitOperation.errorCategory
NSString * const kGTLRSaaSServiceManagement_UnitOperation_ErrorCategory_Fatal = @"FATAL";
NSString * const kGTLRSaaSServiceManagement_UnitOperation_ErrorCategory_Ignorable = @"IGNORABLE";
NSString * const kGTLRSaaSServiceManagement_UnitOperation_ErrorCategory_NotApplicable = @"NOT_APPLICABLE";
NSString * const kGTLRSaaSServiceManagement_UnitOperation_ErrorCategory_Retriable = @"RETRIABLE";
NSString * const kGTLRSaaSServiceManagement_UnitOperation_ErrorCategory_Standard = @"STANDARD";
NSString * const kGTLRSaaSServiceManagement_UnitOperation_ErrorCategory_UnitOperationErrorCategoryUnspecified = @"UNIT_OPERATION_ERROR_CATEGORY_UNSPECIFIED";

// GTLRSaaSServiceManagement_UnitOperation.state
NSString * const kGTLRSaaSServiceManagement_UnitOperation_State_UnitOperationStateCancelled = @"UNIT_OPERATION_STATE_CANCELLED";
NSString * const kGTLRSaaSServiceManagement_UnitOperation_State_UnitOperationStateFailed = @"UNIT_OPERATION_STATE_FAILED";
NSString * const kGTLRSaaSServiceManagement_UnitOperation_State_UnitOperationStatePending = @"UNIT_OPERATION_STATE_PENDING";
NSString * const kGTLRSaaSServiceManagement_UnitOperation_State_UnitOperationStateRunning = @"UNIT_OPERATION_STATE_RUNNING";
NSString * const kGTLRSaaSServiceManagement_UnitOperation_State_UnitOperationStateScheduled = @"UNIT_OPERATION_STATE_SCHEDULED";
NSString * const kGTLRSaaSServiceManagement_UnitOperation_State_UnitOperationStateSucceeded = @"UNIT_OPERATION_STATE_SUCCEEDED";
NSString * const kGTLRSaaSServiceManagement_UnitOperation_State_UnitOperationStateUnknown = @"UNIT_OPERATION_STATE_UNKNOWN";

// GTLRSaaSServiceManagement_UnitOperationCondition.status
NSString * const kGTLRSaaSServiceManagement_UnitOperationCondition_Status_StatusFalse = @"STATUS_FALSE";
NSString * const kGTLRSaaSServiceManagement_UnitOperationCondition_Status_StatusTrue = @"STATUS_TRUE";
NSString * const kGTLRSaaSServiceManagement_UnitOperationCondition_Status_StatusUnknown = @"STATUS_UNKNOWN";
NSString * const kGTLRSaaSServiceManagement_UnitOperationCondition_Status_StatusUnspecified = @"STATUS_UNSPECIFIED";

// GTLRSaaSServiceManagement_UnitOperationCondition.type
NSString * const kGTLRSaaSServiceManagement_UnitOperationCondition_Type_TypeCancelled = @"TYPE_CANCELLED";
NSString * const kGTLRSaaSServiceManagement_UnitOperationCondition_Type_TypeRunning = @"TYPE_RUNNING";
NSString * const kGTLRSaaSServiceManagement_UnitOperationCondition_Type_TypeScheduled = @"TYPE_SCHEDULED";
NSString * const kGTLRSaaSServiceManagement_UnitOperationCondition_Type_TypeSucceeded = @"TYPE_SUCCEEDED";
NSString * const kGTLRSaaSServiceManagement_UnitOperationCondition_Type_TypeUnspecified = @"TYPE_UNSPECIFIED";

// GTLRSaaSServiceManagement_UnitVariable.type
NSString * const kGTLRSaaSServiceManagement_UnitVariable_Type_Bool = @"BOOL";
NSString * const kGTLRSaaSServiceManagement_UnitVariable_Type_Int = @"INT";
NSString * const kGTLRSaaSServiceManagement_UnitVariable_Type_String = @"STRING";
NSString * const kGTLRSaaSServiceManagement_UnitVariable_Type_TypeUnspecified = @"TYPE_UNSPECIFIED";

// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Aggregate
//

@implementation GTLRSaaSServiceManagement_Aggregate
@dynamic count, group;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Blueprint
//

@implementation GTLRSaaSServiceManagement_Blueprint
@dynamic engine, package, version;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Dependency
//

@implementation GTLRSaaSServiceManagement_Dependency
@dynamic alias, unitKind;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Deprovision
//

@implementation GTLRSaaSServiceManagement_Deprovision
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Empty
//

@implementation GTLRSaaSServiceManagement_Empty
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_ErrorBudget
//

@implementation GTLRSaaSServiceManagement_ErrorBudget
@dynamic allowedCount, allowedPercentage;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_FromMapping
//

@implementation GTLRSaaSServiceManagement_FromMapping
@dynamic dependency, outputVariable;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_GoogleCloudLocationLocation
//

@implementation GTLRSaaSServiceManagement_GoogleCloudLocationLocation
@dynamic displayName, labels, locationId, metadata, name;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_GoogleCloudLocationLocation_Labels
//

@implementation GTLRSaaSServiceManagement_GoogleCloudLocationLocation_Labels

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_GoogleCloudLocationLocation_Metadata
//

@implementation GTLRSaaSServiceManagement_GoogleCloudLocationLocation_Metadata

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_ListLocationsResponse
//

@implementation GTLRSaaSServiceManagement_ListLocationsResponse
@dynamic locations, nextPageToken;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"locations" : [GTLRSaaSServiceManagement_GoogleCloudLocationLocation class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"locations";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_ListReleasesResponse
//

@implementation GTLRSaaSServiceManagement_ListReleasesResponse
@dynamic nextPageToken, releases, unreachable;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"releases" : [GTLRSaaSServiceManagement_Release class],
    @"unreachable" : [NSString class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"releases";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_ListRolloutKindsResponse
//

@implementation GTLRSaaSServiceManagement_ListRolloutKindsResponse
@dynamic nextPageToken, rolloutKinds, unreachable;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"rolloutKinds" : [GTLRSaaSServiceManagement_RolloutKind class],
    @"unreachable" : [NSString class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"rolloutKinds";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_ListRolloutsResponse
//

@implementation GTLRSaaSServiceManagement_ListRolloutsResponse
@dynamic nextPageToken, rollouts, unreachable;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"rollouts" : [GTLRSaaSServiceManagement_Rollout class],
    @"unreachable" : [NSString class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"rollouts";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_ListSaasResponse
//

@implementation GTLRSaaSServiceManagement_ListSaasResponse
@dynamic nextPageToken, saas, unreachable;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"saas" : [GTLRSaaSServiceManagement_Saas class],
    @"unreachable" : [NSString class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"saas";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_ListTenantsResponse
//

@implementation GTLRSaaSServiceManagement_ListTenantsResponse
@dynamic nextPageToken, tenants, unreachable;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"tenants" : [GTLRSaaSServiceManagement_Tenant class],
    @"unreachable" : [NSString class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"tenants";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_ListUnitKindsResponse
//

@implementation GTLRSaaSServiceManagement_ListUnitKindsResponse
@dynamic nextPageToken, unitKinds, unreachable;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"unitKinds" : [GTLRSaaSServiceManagement_UnitKind class],
    @"unreachable" : [NSString class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"unitKinds";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_ListUnitOperationsResponse
//

@implementation GTLRSaaSServiceManagement_ListUnitOperationsResponse
@dynamic nextPageToken, unitOperations, unreachable;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"unitOperations" : [GTLRSaaSServiceManagement_UnitOperation class],
    @"unreachable" : [NSString class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"unitOperations";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_ListUnitsResponse
//

@implementation GTLRSaaSServiceManagement_ListUnitsResponse
@dynamic nextPageToken, units, unreachable;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"units" : [GTLRSaaSServiceManagement_Unit class],
    @"unreachable" : [NSString class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"units";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Location
//

@implementation GTLRSaaSServiceManagement_Location
@dynamic name;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_MaintenanceSettings
//

@implementation GTLRSaaSServiceManagement_MaintenanceSettings
@dynamic pinnedUntilTime;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Provision
//

@implementation GTLRSaaSServiceManagement_Provision
@dynamic inputVariables, releaseProperty;

+ (NSDictionary<NSString *, NSString *> *)propertyToJSONKeyMap {
  return @{ @"releaseProperty" : @"release" };
}

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"inputVariables" : [GTLRSaaSServiceManagement_UnitVariable class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Release
//

@implementation GTLRSaaSServiceManagement_Release
@dynamic annotations, blueprint, createTime, ETag, inputVariableDefaults,
         inputVariables, labels, name, outputVariables, releaseRequirements,
         uid, unitKind, updateTime;

+ (NSDictionary<NSString *, NSString *> *)propertyToJSONKeyMap {
  return @{ @"ETag" : @"etag" };
}

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"inputVariableDefaults" : [GTLRSaaSServiceManagement_UnitVariable class],
    @"inputVariables" : [GTLRSaaSServiceManagement_UnitVariable class],
    @"outputVariables" : [GTLRSaaSServiceManagement_UnitVariable class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Release_Annotations
//

@implementation GTLRSaaSServiceManagement_Release_Annotations

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Release_Labels
//

@implementation GTLRSaaSServiceManagement_Release_Labels

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_ReleaseRequirements
//

@implementation GTLRSaaSServiceManagement_ReleaseRequirements
@dynamic upgradeableFromReleases;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"upgradeableFromReleases" : [NSString class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Rollout
//

@implementation GTLRSaaSServiceManagement_Rollout
@dynamic annotations, control, createTime, endTime, ETag, labels, name,
         parentRollout, releaseProperty, rolloutKind,
         rolloutOrchestrationStrategy, rootRollout, startTime, state,
         stateMessage, stateTransitionTime, stats, uid, unitFilter, updateTime;

+ (NSDictionary<NSString *, NSString *> *)propertyToJSONKeyMap {
  NSDictionary<NSString *, NSString *> *map = @{
    @"ETag" : @"etag",
    @"releaseProperty" : @"release"
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Rollout_Annotations
//

@implementation GTLRSaaSServiceManagement_Rollout_Annotations

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Rollout_Labels
//

@implementation GTLRSaaSServiceManagement_Rollout_Labels

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_RolloutControl
//

@implementation GTLRSaaSServiceManagement_RolloutControl
@dynamic action, runParams;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_RolloutKind
//

@implementation GTLRSaaSServiceManagement_RolloutKind
@dynamic annotations, createTime, errorBudget, ETag, labels, name,
         rolloutOrchestrationStrategy, uid, unitFilter, unitKind, updateTime,
         updateUnitKindStrategy;

+ (NSDictionary<NSString *, NSString *> *)propertyToJSONKeyMap {
  return @{ @"ETag" : @"etag" };
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_RolloutKind_Annotations
//

@implementation GTLRSaaSServiceManagement_RolloutKind_Annotations

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_RolloutKind_Labels
//

@implementation GTLRSaaSServiceManagement_RolloutKind_Labels

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_RolloutStats
//

@implementation GTLRSaaSServiceManagement_RolloutStats
@dynamic operationsByState;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"operationsByState" : [GTLRSaaSServiceManagement_Aggregate class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_RunRolloutActionParams
//

@implementation GTLRSaaSServiceManagement_RunRolloutActionParams
@dynamic retryFailedOperations;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Saas
//

@implementation GTLRSaaSServiceManagement_Saas
@dynamic annotations, createTime, ETag, labels, locations, name, uid,
         updateTime;

+ (NSDictionary<NSString *, NSString *> *)propertyToJSONKeyMap {
  return @{ @"ETag" : @"etag" };
}

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"locations" : [GTLRSaaSServiceManagement_Location class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Saas_Annotations
//

@implementation GTLRSaaSServiceManagement_Saas_Annotations

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Saas_Labels
//

@implementation GTLRSaaSServiceManagement_Saas_Labels

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Schedule
//

@implementation GTLRSaaSServiceManagement_Schedule
@dynamic startTime;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Tenant
//

@implementation GTLRSaaSServiceManagement_Tenant
@dynamic annotations, consumerResource, createTime, ETag, labels, name, saas,
         uid, updateTime;

+ (NSDictionary<NSString *, NSString *> *)propertyToJSONKeyMap {
  return @{ @"ETag" : @"etag" };
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Tenant_Annotations
//

@implementation GTLRSaaSServiceManagement_Tenant_Annotations

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Tenant_Labels
//

@implementation GTLRSaaSServiceManagement_Tenant_Labels

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_ToMapping
//

@implementation GTLRSaaSServiceManagement_ToMapping
@dynamic dependency, ignoreForLookup, inputVariable;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Unit
//

@implementation GTLRSaaSServiceManagement_Unit
@dynamic annotations, conditions, createTime, dependencies, dependents, ETag,
         inputVariables, labels, maintenance, managementMode, name,
         ongoingOperations, outputVariables, pendingOperations, releaseProperty,
         scheduledOperations, state, systemCleanupAt, systemManagedState,
         tenant, uid, unitKind, updateTime;

+ (NSDictionary<NSString *, NSString *> *)propertyToJSONKeyMap {
  NSDictionary<NSString *, NSString *> *map = @{
    @"ETag" : @"etag",
    @"releaseProperty" : @"release"
  };
  return map;
}

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"conditions" : [GTLRSaaSServiceManagement_UnitCondition class],
    @"dependencies" : [GTLRSaaSServiceManagement_UnitDependency class],
    @"dependents" : [GTLRSaaSServiceManagement_UnitDependency class],
    @"inputVariables" : [GTLRSaaSServiceManagement_UnitVariable class],
    @"ongoingOperations" : [NSString class],
    @"outputVariables" : [GTLRSaaSServiceManagement_UnitVariable class],
    @"pendingOperations" : [NSString class],
    @"scheduledOperations" : [NSString class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Unit_Annotations
//

@implementation GTLRSaaSServiceManagement_Unit_Annotations

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Unit_Labels
//

@implementation GTLRSaaSServiceManagement_Unit_Labels

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_UnitCondition
//

@implementation GTLRSaaSServiceManagement_UnitCondition
@dynamic lastTransitionTime, message, reason, status, type;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_UnitDependency
//

@implementation GTLRSaaSServiceManagement_UnitDependency
@dynamic alias, unit;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_UnitKind
//

@implementation GTLRSaaSServiceManagement_UnitKind
@dynamic annotations, createTime, defaultRelease, dependencies, ETag,
         inputVariableMappings, labels, name, outputVariableMappings, saas, uid,
         updateTime;

+ (NSDictionary<NSString *, NSString *> *)propertyToJSONKeyMap {
  return @{ @"ETag" : @"etag" };
}

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"dependencies" : [GTLRSaaSServiceManagement_Dependency class],
    @"inputVariableMappings" : [GTLRSaaSServiceManagement_VariableMapping class],
    @"outputVariableMappings" : [GTLRSaaSServiceManagement_VariableMapping class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_UnitKind_Annotations
//

@implementation GTLRSaaSServiceManagement_UnitKind_Annotations

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_UnitKind_Labels
//

@implementation GTLRSaaSServiceManagement_UnitKind_Labels

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_UnitOperation
//

@implementation GTLRSaaSServiceManagement_UnitOperation
@dynamic annotations, cancel, conditions, createTime, deprovision, engineState,
         errorCategory, ETag, labels, name, parentUnitOperation, provision,
         rollout, schedule, state, uid, unit, updateTime, upgrade;

+ (NSDictionary<NSString *, NSString *> *)propertyToJSONKeyMap {
  return @{ @"ETag" : @"etag" };
}

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"conditions" : [GTLRSaaSServiceManagement_UnitOperationCondition class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_UnitOperation_Annotations
//

@implementation GTLRSaaSServiceManagement_UnitOperation_Annotations

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_UnitOperation_Labels
//

@implementation GTLRSaaSServiceManagement_UnitOperation_Labels

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_UnitOperationCondition
//

@implementation GTLRSaaSServiceManagement_UnitOperationCondition
@dynamic lastTransitionTime, message, reason, status, type;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_UnitVariable
//

@implementation GTLRSaaSServiceManagement_UnitVariable
@dynamic type, value, variable;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_Upgrade
//

@implementation GTLRSaaSServiceManagement_Upgrade
@dynamic inputVariables, releaseProperty;

+ (NSDictionary<NSString *, NSString *> *)propertyToJSONKeyMap {
  return @{ @"releaseProperty" : @"release" };
}

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"inputVariables" : [GTLRSaaSServiceManagement_UnitVariable class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSaaSServiceManagement_VariableMapping
//

@implementation GTLRSaaSServiceManagement_VariableMapping
@dynamic from, to, variable;
@end
