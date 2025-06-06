// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Google Play Games Services Management API (gamesManagement/v1management)
// Description:
//   The Google Play Games Management API allows developers to manage resources
//   from the Google Play Game service.
// Documentation:
//   https://developers.google.com/games/

#import <GoogleAPIClientForREST/GTLRGamesManagementQuery.h>

@implementation GTLRGamesManagementQuery

@dynamic fields;

@end

@implementation GTLRGamesManagementQuery_AchievementsReset

@dynamic achievementId;

+ (instancetype)queryWithAchievementId:(NSString *)achievementId {
  NSArray *pathParams = @[ @"achievementId" ];
  NSString *pathURITemplate = @"games/v1management/achievements/{achievementId}/reset";
  GTLRGamesManagementQuery_AchievementsReset *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.achievementId = achievementId;
  query.expectedObjectClass = [GTLRGamesManagement_AchievementResetResponse class];
  query.loggingName = @"gamesManagement.achievements.reset";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_AchievementsResetAll

+ (instancetype)query {
  NSString *pathURITemplate = @"games/v1management/achievements/reset";
  GTLRGamesManagementQuery_AchievementsResetAll *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRGamesManagement_AchievementResetAllResponse class];
  query.loggingName = @"gamesManagement.achievements.resetAll";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_AchievementsResetAllForAllPlayers

+ (instancetype)query {
  NSString *pathURITemplate = @"games/v1management/achievements/resetAllForAllPlayers";
  GTLRGamesManagementQuery_AchievementsResetAllForAllPlayers *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.loggingName = @"gamesManagement.achievements.resetAllForAllPlayers";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_AchievementsResetForAllPlayers

@dynamic achievementId;

+ (instancetype)queryWithAchievementId:(NSString *)achievementId {
  NSArray *pathParams = @[ @"achievementId" ];
  NSString *pathURITemplate = @"games/v1management/achievements/{achievementId}/resetForAllPlayers";
  GTLRGamesManagementQuery_AchievementsResetForAllPlayers *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.achievementId = achievementId;
  query.loggingName = @"gamesManagement.achievements.resetForAllPlayers";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_AchievementsResetMultipleForAllPlayers

+ (instancetype)queryWithObject:(GTLRGamesManagement_AchievementResetMultipleForAllRequest *)object {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSString *pathURITemplate = @"games/v1management/achievements/resetMultipleForAllPlayers";
  GTLRGamesManagementQuery_AchievementsResetMultipleForAllPlayers *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.bodyObject = object;
  query.loggingName = @"gamesManagement.achievements.resetMultipleForAllPlayers";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_ApplicationsListHidden

@dynamic applicationId, maxResults, pageToken;

+ (instancetype)queryWithApplicationId:(NSString *)applicationId {
  NSArray *pathParams = @[ @"applicationId" ];
  NSString *pathURITemplate = @"games/v1management/applications/{applicationId}/players/hidden";
  GTLRGamesManagementQuery_ApplicationsListHidden *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.applicationId = applicationId;
  query.expectedObjectClass = [GTLRGamesManagement_HiddenPlayerList class];
  query.loggingName = @"gamesManagement.applications.listHidden";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_EventsReset

@dynamic eventId;

+ (instancetype)queryWithEventId:(NSString *)eventId {
  NSArray *pathParams = @[ @"eventId" ];
  NSString *pathURITemplate = @"games/v1management/events/{eventId}/reset";
  GTLRGamesManagementQuery_EventsReset *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.eventId = eventId;
  query.loggingName = @"gamesManagement.events.reset";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_EventsResetAll

+ (instancetype)query {
  NSString *pathURITemplate = @"games/v1management/events/reset";
  GTLRGamesManagementQuery_EventsResetAll *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.loggingName = @"gamesManagement.events.resetAll";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_EventsResetAllForAllPlayers

+ (instancetype)query {
  NSString *pathURITemplate = @"games/v1management/events/resetAllForAllPlayers";
  GTLRGamesManagementQuery_EventsResetAllForAllPlayers *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.loggingName = @"gamesManagement.events.resetAllForAllPlayers";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_EventsResetForAllPlayers

@dynamic eventId;

+ (instancetype)queryWithEventId:(NSString *)eventId {
  NSArray *pathParams = @[ @"eventId" ];
  NSString *pathURITemplate = @"games/v1management/events/{eventId}/resetForAllPlayers";
  GTLRGamesManagementQuery_EventsResetForAllPlayers *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.eventId = eventId;
  query.loggingName = @"gamesManagement.events.resetForAllPlayers";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_EventsResetMultipleForAllPlayers

+ (instancetype)queryWithObject:(GTLRGamesManagement_EventsResetMultipleForAllRequest *)object {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSString *pathURITemplate = @"games/v1management/events/resetMultipleForAllPlayers";
  GTLRGamesManagementQuery_EventsResetMultipleForAllPlayers *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.bodyObject = object;
  query.loggingName = @"gamesManagement.events.resetMultipleForAllPlayers";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_PlayersHide

@dynamic applicationId, playerId;

+ (instancetype)queryWithApplicationId:(NSString *)applicationId
                              playerId:(NSString *)playerId {
  NSArray *pathParams = @[
    @"applicationId", @"playerId"
  ];
  NSString *pathURITemplate = @"games/v1management/applications/{applicationId}/players/hidden/{playerId}";
  GTLRGamesManagementQuery_PlayersHide *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.applicationId = applicationId;
  query.playerId = playerId;
  query.loggingName = @"gamesManagement.players.hide";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_PlayersUnhide

@dynamic applicationId, playerId;

+ (instancetype)queryWithApplicationId:(NSString *)applicationId
                              playerId:(NSString *)playerId {
  NSArray *pathParams = @[
    @"applicationId", @"playerId"
  ];
  NSString *pathURITemplate = @"games/v1management/applications/{applicationId}/players/hidden/{playerId}";
  GTLRGamesManagementQuery_PlayersUnhide *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.applicationId = applicationId;
  query.playerId = playerId;
  query.loggingName = @"gamesManagement.players.unhide";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_ScoresReset

@dynamic leaderboardId;

+ (instancetype)queryWithLeaderboardId:(NSString *)leaderboardId {
  NSArray *pathParams = @[ @"leaderboardId" ];
  NSString *pathURITemplate = @"games/v1management/leaderboards/{leaderboardId}/scores/reset";
  GTLRGamesManagementQuery_ScoresReset *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.leaderboardId = leaderboardId;
  query.expectedObjectClass = [GTLRGamesManagement_PlayerScoreResetResponse class];
  query.loggingName = @"gamesManagement.scores.reset";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_ScoresResetAll

+ (instancetype)query {
  NSString *pathURITemplate = @"games/v1management/scores/reset";
  GTLRGamesManagementQuery_ScoresResetAll *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRGamesManagement_PlayerScoreResetAllResponse class];
  query.loggingName = @"gamesManagement.scores.resetAll";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_ScoresResetAllForAllPlayers

+ (instancetype)query {
  NSString *pathURITemplate = @"games/v1management/scores/resetAllForAllPlayers";
  GTLRGamesManagementQuery_ScoresResetAllForAllPlayers *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.loggingName = @"gamesManagement.scores.resetAllForAllPlayers";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_ScoresResetForAllPlayers

@dynamic leaderboardId;

+ (instancetype)queryWithLeaderboardId:(NSString *)leaderboardId {
  NSArray *pathParams = @[ @"leaderboardId" ];
  NSString *pathURITemplate = @"games/v1management/leaderboards/{leaderboardId}/scores/resetForAllPlayers";
  GTLRGamesManagementQuery_ScoresResetForAllPlayers *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.leaderboardId = leaderboardId;
  query.loggingName = @"gamesManagement.scores.resetForAllPlayers";
  return query;
}

@end

@implementation GTLRGamesManagementQuery_ScoresResetMultipleForAllPlayers

+ (instancetype)queryWithObject:(GTLRGamesManagement_ScoresResetMultipleForAllRequest *)object {
  if (object == nil) {
#if defined(DEBUG) && DEBUG
    NSAssert(object != nil, @"Got a nil object");
#endif
    return nil;
  }
  NSString *pathURITemplate = @"games/v1management/scores/resetMultipleForAllPlayers";
  GTLRGamesManagementQuery_ScoresResetMultipleForAllPlayers *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.bodyObject = object;
  query.loggingName = @"gamesManagement.scores.resetMultipleForAllPlayers";
  return query;
}

@end
