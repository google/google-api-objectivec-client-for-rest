// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Safe Browsing API (safebrowsing/v5)
// Description:
//   Enables client applications to check web resources (most commonly URLs)
//   against Google-generated lists of unsafe web resources. The Safe Browsing
//   APIs are for non-commercial use only. If you need to use APIs to detect
//   malicious URLs for commercial purposes – meaning “for sale or
//   revenue-generating purposes” – please refer to the Web Risk API.
// Documentation:
//   https://developers.google.com/safe-browsing/

#import <GoogleAPIClientForREST/GTLRSafebrowsingObjects.h>

// ----------------------------------------------------------------------------
// Constants

// GTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHashFullHashDetail.attributes
NSString * const kGTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHashFullHashDetail_Attributes_Canary = @"CANARY";
NSString * const kGTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHashFullHashDetail_Attributes_FrameOnly = @"FRAME_ONLY";
NSString * const kGTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHashFullHashDetail_Attributes_ThreatAttributeUnspecified = @"THREAT_ATTRIBUTE_UNSPECIFIED";

// GTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHashFullHashDetail.threatType
NSString * const kGTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHashFullHashDetail_ThreatType_Malware = @"MALWARE";
NSString * const kGTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHashFullHashDetail_ThreatType_PotentiallyHarmfulApplication = @"POTENTIALLY_HARMFUL_APPLICATION";
NSString * const kGTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHashFullHashDetail_ThreatType_SocialEngineering = @"SOCIAL_ENGINEERING";
NSString * const kGTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHashFullHashDetail_ThreatType_ThreatTypeUnspecified = @"THREAT_TYPE_UNSPECIFIED";
NSString * const kGTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHashFullHashDetail_ThreatType_UnwantedSoftware = @"UNWANTED_SOFTWARE";

// ----------------------------------------------------------------------------
//
//   GTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHash
//

@implementation GTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHash
@dynamic fullHash, fullHashDetails;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"fullHashDetails" : [GTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHashFullHashDetail class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHashFullHashDetail
//

@implementation GTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHashFullHashDetail
@dynamic attributes, threatType;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"attributes" : [NSString class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSafebrowsing_GoogleSecuritySafebrowsingV5SearchHashesResponse
//

@implementation GTLRSafebrowsing_GoogleSecuritySafebrowsingV5SearchHashesResponse
@dynamic cacheDuration, fullHashes;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"fullHashes" : [GTLRSafebrowsing_GoogleSecuritySafebrowsingV5FullHash class]
  };
  return map;
}

@end
