// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Google Workspace Events API (workspaceevents/v1)
// Description:
//   The Google Workspace Events API lets you subscribe to events and manage
//   change notifications across Google Workspace applications.
// Documentation:
//   https://developers.google.com/workspace/events

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
 *  Authorization scope: On their own behalf, apps in Google Chat can see, add,
 *  update, and remove members from conversations and spaces
 *
 *  Value "https://www.googleapis.com/auth/chat.app.memberships"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsChatAppMemberships;
/**
 *  Authorization scope: On their own behalf, apps in Google Chat can create
 *  conversations and spaces and see or update their metadata (including history
 *  settings and access settings)
 *
 *  Value "https://www.googleapis.com/auth/chat.app.spaces"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsChatAppSpaces;
/**
 *  Authorization scope: Private Service:
 *  https://www.googleapis.com/auth/chat.bot
 *
 *  Value "https://www.googleapis.com/auth/chat.bot"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsChatBot;
/**
 *  Authorization scope: See, add, update, and remove members from conversations
 *  and spaces in Google Chat
 *
 *  Value "https://www.googleapis.com/auth/chat.memberships"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsChatMemberships;
/**
 *  Authorization scope: View members in Google Chat conversations.
 *
 *  Value "https://www.googleapis.com/auth/chat.memberships.readonly"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsChatMembershipsReadonly;
/**
 *  Authorization scope: See, compose, send, update, and delete messages as well
 *  as their message content; add, see, and delete reactions to messages.
 *
 *  Value "https://www.googleapis.com/auth/chat.messages"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsChatMessages;
/**
 *  Authorization scope: See, add, and delete reactions as well as their
 *  reaction content to messages in Google Chat
 *
 *  Value "https://www.googleapis.com/auth/chat.messages.reactions"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsChatMessagesReactions;
/**
 *  Authorization scope: View reactions as well as their reaction content to
 *  messages in Google Chat
 *
 *  Value "https://www.googleapis.com/auth/chat.messages.reactions.readonly"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsChatMessagesReactionsReadonly;
/**
 *  Authorization scope: See messages as well as their reactions and message
 *  content in Google Chat
 *
 *  Value "https://www.googleapis.com/auth/chat.messages.readonly"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsChatMessagesReadonly;
/**
 *  Authorization scope: Create conversations and spaces and see or update
 *  metadata (including history settings and access settings) in Google Chat
 *
 *  Value "https://www.googleapis.com/auth/chat.spaces"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsChatSpaces;
/**
 *  Authorization scope: View chat and spaces in Google Chat
 *
 *  Value "https://www.googleapis.com/auth/chat.spaces.readonly"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsChatSpacesReadonly;
/**
 *  Authorization scope: See, edit, create, and delete all of your Google Drive
 *  files
 *
 *  Value "https://www.googleapis.com/auth/drive"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsDrive;
/**
 *  Authorization scope: See, edit, create, and delete only the specific Google
 *  Drive files you use with this app
 *
 *  Value "https://www.googleapis.com/auth/drive.file"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsDriveFile;
/**
 *  Authorization scope: View and manage metadata of files in your Google Drive
 *
 *  Value "https://www.googleapis.com/auth/drive.metadata"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsDriveMetadata;
/**
 *  Authorization scope: See information about your Google Drive files
 *
 *  Value "https://www.googleapis.com/auth/drive.metadata.readonly"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsDriveMetadataReadonly;
/**
 *  Authorization scope: See and download all your Google Drive files
 *
 *  Value "https://www.googleapis.com/auth/drive.readonly"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsDriveReadonly;
/**
 *  Authorization scope: Create, edit, and see information about your Google
 *  Meet conferences created by the app.
 *
 *  Value "https://www.googleapis.com/auth/meetings.space.created"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsMeetingsSpaceCreated;
/**
 *  Authorization scope: Read information about any of your Google Meet
 *  conferences
 *
 *  Value "https://www.googleapis.com/auth/meetings.space.readonly"
 */
FOUNDATION_EXTERN NSString * const kGTLRAuthScopeWorkspaceEventsMeetingsSpaceReadonly;

// ----------------------------------------------------------------------------
//   GTLRWorkspaceEventsService
//

/**
 *  Service for executing Google Workspace Events API queries.
 *
 *  The Google Workspace Events API lets you subscribe to events and manage
 *  change notifications across Google Workspace applications.
 */
@interface GTLRWorkspaceEventsService : GTLRService

// No new methods

// Clients should create a standard query with any of the class methods in
// GTLRWorkspaceEventsQuery.h. The query can the be sent with GTLRService's
// execute methods,
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
