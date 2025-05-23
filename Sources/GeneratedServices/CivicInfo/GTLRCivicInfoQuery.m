// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Google Civic Information API (civicinfo/v2)
// Description:
//   Provides polling places, early vote locations, contest data, election
//   officials, and government representatives for U.S. residential addresses.
// Documentation:
//   https://developers.google.com/civic-information/

#import <GoogleAPIClientForREST/GTLRCivicInfoQuery.h>

#import <GoogleAPIClientForREST/GTLRCivicInfoObjects.h>

@implementation GTLRCivicInfoQuery

@dynamic fields;

@end

@implementation GTLRCivicInfoQuery_DivisionsQueryDivisionByAddress

@dynamic address;

+ (instancetype)query {
  NSString *pathURITemplate = @"civicinfo/v2/divisionsByAddress";
  GTLRCivicInfoQuery_DivisionsQueryDivisionByAddress *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRCivicInfo_ApiprotosV2DivisionByAddressResponse class];
  query.loggingName = @"civicinfo.divisions.queryDivisionByAddress";
  return query;
}

@end

@implementation GTLRCivicInfoQuery_DivisionsSearch

@dynamic query;

+ (instancetype)query {
  NSString *pathURITemplate = @"civicinfo/v2/divisions";
  GTLRCivicInfoQuery_DivisionsSearch *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRCivicInfo_CivicinfoApiprotosV2DivisionSearchResponse class];
  query.loggingName = @"civicinfo.divisions.search";
  return query;
}

@end

@implementation GTLRCivicInfoQuery_ElectionsElectionQuery

@dynamic productionDataOnly;

+ (instancetype)query {
  NSString *pathURITemplate = @"civicinfo/v2/elections";
  GTLRCivicInfoQuery_ElectionsElectionQuery *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRCivicInfo_CivicinfoApiprotosV2ElectionsQueryResponse class];
  query.loggingName = @"civicinfo.elections.electionQuery";
  return query;
}

@end

@implementation GTLRCivicInfoQuery_ElectionsVoterInfoQuery

@dynamic address, electionId, officialOnly, productionDataOnly,
         returnAllAvailableData;

+ (instancetype)query {
  NSString *pathURITemplate = @"civicinfo/v2/voterinfo";
  GTLRCivicInfoQuery_ElectionsVoterInfoQuery *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRCivicInfo_CivicinfoApiprotosV2VoterInfoResponse class];
  query.loggingName = @"civicinfo.elections.voterInfoQuery";
  return query;
}

@end
