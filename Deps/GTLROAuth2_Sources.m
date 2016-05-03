#import <TargetConditionals.h>
#import <AvailabilityMacros.h>

#if __has_feature(objc_arc)
#error "This file needs to be compiled with ARC disabled."
#endif

#ifndef GTM_USE_SESSION_FETCHER
  #define GTM_USE_SESSION_FETCHER 1
#endif

#import "gtm-oauth2/Source/GTMOAuth2Authentication.m"
#import "gtm-oauth2/Source/GTMOAuth2SignIn.m"
#if TARGET_OS_IPHONE
  #import "gtm-oauth2/Source/Touch/GTMOAuth2ViewControllerTouch.m"
#elif TARGET_OS_MAC
  #import "gtm-oauth2/Source/Mac/GTMOAuth2WindowController.m"
#else
  #error Need Target Conditionals
#endif
