// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Observability API (observability/v1)
// Documentation:
//   https://cloud.google.com/stackdriver/docs/

#import <GoogleAPIClientForREST/GTLRCloudObservabilityObjects.h>

// ----------------------------------------------------------------------------
//
//   GTLRCloudObservability_CancelOperationRequest
//

@implementation GTLRCloudObservability_CancelOperationRequest
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudObservability_Empty
//

@implementation GTLRCloudObservability_Empty
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudObservability_ListLocationsResponse
//

@implementation GTLRCloudObservability_ListLocationsResponse
@dynamic locations, nextPageToken;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"locations" : [GTLRCloudObservability_Location class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"locations";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudObservability_ListOperationsResponse
//

@implementation GTLRCloudObservability_ListOperationsResponse
@dynamic nextPageToken, operations;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"operations" : [GTLRCloudObservability_Operation class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"operations";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudObservability_Location
//

@implementation GTLRCloudObservability_Location
@dynamic displayName, labels, locationId, metadata, name;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudObservability_Location_Labels
//

@implementation GTLRCloudObservability_Location_Labels

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudObservability_Location_Metadata
//

@implementation GTLRCloudObservability_Location_Metadata

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudObservability_Operation
//

@implementation GTLRCloudObservability_Operation
@dynamic done, error, metadata, name, response;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudObservability_Operation_Metadata
//

@implementation GTLRCloudObservability_Operation_Metadata

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudObservability_Operation_Response
//

@implementation GTLRCloudObservability_Operation_Response

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudObservability_OperationMetadata
//

@implementation GTLRCloudObservability_OperationMetadata
@dynamic apiVersion, createTime, endTime, requestedCancellation, statusMessage,
         target, verb;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudObservability_Scope
//

@implementation GTLRCloudObservability_Scope
@dynamic logScope, name, updateTime;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudObservability_Status
//

@implementation GTLRCloudObservability_Status
@dynamic code, details, message;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"details" : [GTLRCloudObservability_Status_Details_Item class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudObservability_Status_Details_Item
//

@implementation GTLRCloudObservability_Status_Details_Item

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end
