// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Google Workspace Reseller API (reseller/v1)
// Description:
//   Perform common functions that are available on the Channel Services console
//   at scale, like placing orders and viewing customer information
// Documentation:
//   https://developers.google.com/google-apps/reseller/

#import <GoogleAPIClientForREST/GTLRService.h>

#if GTLR_RUNTIME_VERSION != 3000
#error This file was generated by a different version of ServiceGenerator which is incompatible with this GTLR library source.
#endif

// Generated comments include content from the discovery document; avoid them
// causing warnings since clang's checks are some what arbitrary.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

NS_ASSUME_NONNULL_BEGIN

// ----------------------------------------------------------------------------
// Authorization scopes

/**
 *  Authorization scope: Manage users on your domain
 *
 *  Value "https://www.googleapis.com/auth/apps.order"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeResellerAppsOrder;
/**
 *  Authorization scope: Manage users on your domain
 *
 *  Value "https://www.googleapis.com/auth/apps.order.readonly"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeResellerAppsOrderReadonly;

// ----------------------------------------------------------------------------
//   GTLRResellerService
//

/**
 *  Service for executing Google Workspace Reseller API queries.
 *
 *  Perform common functions that are available on the Channel Services console
 *  at scale, like placing orders and viewing customer information
 */
@interface GTLRResellerService : GTLRService

// No new methods

// Clients should create a standard query with any of the class methods in
// GTLRResellerQuery.h. The query can the be sent with GTLRService's execute
// methods,
//
//   - (GTLRServiceTicket *)executeQuery:(GTLRQuery *)query
//                     completionHandler:(void (^)(GTLRServiceTicket *ticket,
//                                                 id object, NSError *error))handler;
// or
//   - (GTLRServiceTicket *)executeQuery:(GTLRQuery *)query
//                              delegate:(id)delegate
//                     didFinishSelector:(SEL)finishedSelector;
//
// where finishedSelector has a signature of:
//
//   - (void)serviceTicket:(GTLRServiceTicket *)ticket
//      finishedWithObject:(id)object
//                   error:(NSError *)error;
//
// The object passed to the completion handler or delegate method
// is a subclass of GTLRObject, determined by the query method executed.

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop