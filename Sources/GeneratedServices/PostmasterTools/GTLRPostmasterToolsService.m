// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Gmail Postmaster Tools API (gmailpostmastertools/v1)
// Description:
//   The Postmaster Tools API is a RESTful API that provides programmatic access
//   to email traffic metrics (like spam reports, delivery errors etc) otherwise
//   available through the Gmail Postmaster Tools UI currently.
// Documentation:
//   https://developers.google.com/workspace/gmail/postmaster

#import <GoogleAPIClientForREST/GTLRPostmasterTools.h>

// ----------------------------------------------------------------------------
// Authorization scope

NSString * const kGTLRAuthScopePostmasterToolsPostmasterReadonly = @"https://www.googleapis.com/auth/postmaster.readonly";

// ----------------------------------------------------------------------------
//   GTLRPostmasterToolsService
//

@implementation GTLRPostmasterToolsService

- (instancetype)init {
  self = [super init];
  if (self) {
    // From discovery.
    self.rootURLString = @"https://gmailpostmastertools.googleapis.com/";
    self.batchPath = @"batch";
    self.prettyPrintQueryParameterNames = @[ @"prettyPrint" ];
  }
  return self;
}

@end
