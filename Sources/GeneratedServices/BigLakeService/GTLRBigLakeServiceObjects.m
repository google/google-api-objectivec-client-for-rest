// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   BigLake API (biglake/v1)
// Description:
//   The BigLake API provides access to BigLake Metastore, a serverless, fully
//   managed, and highly available metastore for open-source data that can be
//   used for querying Apache Iceberg tables in BigQuery.
// Documentation:
//   https://cloud.google.com/bigquery/

#import <GoogleAPIClientForREST/GTLRBigLakeServiceObjects.h>

// ----------------------------------------------------------------------------
// Constants

// GTLRBigLakeService_Database.type
NSString * const kGTLRBigLakeService_Database_Type_Hive        = @"HIVE";
NSString * const kGTLRBigLakeService_Database_Type_TypeUnspecified = @"TYPE_UNSPECIFIED";

// GTLRBigLakeService_Table.type
NSString * const kGTLRBigLakeService_Table_Type_Hive           = @"HIVE";
NSString * const kGTLRBigLakeService_Table_Type_TypeUnspecified = @"TYPE_UNSPECIFIED";

// ----------------------------------------------------------------------------
//
//   GTLRBigLakeService_Catalog
//

@implementation GTLRBigLakeService_Catalog
@dynamic createTime, deleteTime, expireTime, name, updateTime;
@end


// ----------------------------------------------------------------------------
//
//   GTLRBigLakeService_Database
//

@implementation GTLRBigLakeService_Database
@dynamic createTime, deleteTime, expireTime, hiveOptions, name, type,
         updateTime;
@end


// ----------------------------------------------------------------------------
//
//   GTLRBigLakeService_HiveDatabaseOptions
//

@implementation GTLRBigLakeService_HiveDatabaseOptions
@dynamic locationUri, parameters;
@end


// ----------------------------------------------------------------------------
//
//   GTLRBigLakeService_HiveDatabaseOptions_Parameters
//

@implementation GTLRBigLakeService_HiveDatabaseOptions_Parameters

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRBigLakeService_HiveTableOptions
//

@implementation GTLRBigLakeService_HiveTableOptions
@dynamic parameters, storageDescriptor, tableType;
@end


// ----------------------------------------------------------------------------
//
//   GTLRBigLakeService_HiveTableOptions_Parameters
//

@implementation GTLRBigLakeService_HiveTableOptions_Parameters

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRBigLakeService_ListCatalogsResponse
//

@implementation GTLRBigLakeService_ListCatalogsResponse
@dynamic catalogs, nextPageToken;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"catalogs" : [GTLRBigLakeService_Catalog class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"catalogs";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRBigLakeService_ListDatabasesResponse
//

@implementation GTLRBigLakeService_ListDatabasesResponse
@dynamic databases, nextPageToken;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"databases" : [GTLRBigLakeService_Database class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"databases";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRBigLakeService_ListTablesResponse
//

@implementation GTLRBigLakeService_ListTablesResponse
@dynamic nextPageToken, tables;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"tables" : [GTLRBigLakeService_Table class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"tables";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRBigLakeService_RenameTableRequest
//

@implementation GTLRBigLakeService_RenameTableRequest
@dynamic newName;
@end


// ----------------------------------------------------------------------------
//
//   GTLRBigLakeService_SerDeInfo
//

@implementation GTLRBigLakeService_SerDeInfo
@dynamic serializationLib;
@end


// ----------------------------------------------------------------------------
//
//   GTLRBigLakeService_StorageDescriptor
//

@implementation GTLRBigLakeService_StorageDescriptor
@dynamic inputFormat, locationUri, outputFormat, serdeInfo;
@end


// ----------------------------------------------------------------------------
//
//   GTLRBigLakeService_Table
//

@implementation GTLRBigLakeService_Table
@dynamic createTime, deleteTime, ETag, expireTime, hiveOptions, name, type,
         updateTime;

+ (NSDictionary<NSString *, NSString *> *)propertyToJSONKeyMap {
  return @{ @"ETag" : @"etag" };
}

@end
