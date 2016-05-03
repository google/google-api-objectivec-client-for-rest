#import <TargetConditionals.h>
#import <AvailabilityMacros.h>

#ifndef GTM_USE_SESSION_FETCHER
  #define GTM_USE_SESSION_FETCHER 1
#endif

#if !__has_feature(objc_arc)
#error "This file needs to be compiled with ARC enabled."
#endif

#undef GTMSESSION_BUILD_COMBINED_SOURCES
#define GTMSESSION_BUILD_COMBINED_SOURCES 1

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"

#import "gtm-session-fetcher/Source/GTMGatherInputStream.m"
#import "gtm-session-fetcher/Source/GTMMIMEDocument.m"
#import "gtm-session-fetcher/Source/GTMReadMonitorInputStream.m"
#import "gtm-session-fetcher/Source/GTMSessionFetcher.m"
#import "gtm-session-fetcher/Source/GTMSessionFetcherLogging.m"
#import "gtm-session-fetcher/Source/GTMSessionFetcherService.m"
#import "gtm-session-fetcher/Source/GTMSessionUploadFetcher.m"

#pragma clang diagnostic pop
