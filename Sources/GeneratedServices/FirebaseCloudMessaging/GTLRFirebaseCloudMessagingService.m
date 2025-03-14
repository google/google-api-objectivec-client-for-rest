// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Firebase Cloud Messaging API (fcm/v1)
// Description:
//   FCM send API that provides a cross-platform messaging solution to reliably
//   deliver messages.
// Documentation:
//   https://firebase.google.com/docs/cloud-messaging

#import <GoogleAPIClientForREST/GTLRFirebaseCloudMessaging.h>

// ----------------------------------------------------------------------------
// Authorization scopes

NSString * const kGTLRAuthScopeFirebaseCloudMessagingCloudPlatform = @"https://www.googleapis.com/auth/cloud-platform";
NSString * const kGTLRAuthScopeFirebaseCloudMessagingFirebaseMessaging = @"https://www.googleapis.com/auth/firebase.messaging";

// ----------------------------------------------------------------------------
//   GTLRFirebaseCloudMessagingService
//

@implementation GTLRFirebaseCloudMessagingService

- (instancetype)init {
  self = [super init];
  if (self) {
    // From discovery.
    self.rootURLString = @"https://fcm.googleapis.com/";
    self.batchPath = @"batch";
    self.prettyPrintQueryParameterNames = @[ @"prettyPrint" ];
  }
  return self;
}

@end
