//
//  SAGameCenterManager.h
//  SAGameCenterManager
//
//  Created by Abdul Aljebouri on 12/6/2013.
//  Copyright (c) 2013 shiningdevelopers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "SAMultiplayerGameState.h"
#import "SAJSONMessage.h"

#define kMPMatchReadyNotification               @"kMPMatchReadyNotification"

@protocol SAGameCenterManagerDelegate;

@interface SAGameCenterManager : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKLocalPlayerListener> {
    /** Controller of the view where the Game Center elements are to be displayed. */
    UIViewController <GKGameCenterControllerDelegate, SAGameCenterManagerDelegate> *viewController;
    /** Represents a match with another player. */
    GKMatch *match;
    /** The delegate the receieves messages concerning the match. */
    __weak id<SAGameCenterManagerDelegate> delegate;
    /** Current state of the game. */
    SAMultiplayerGameState *gameState;
}

@property (nonatomic, weak) id<SAGameCenterManagerDelegate> delegate;
@property (nonatomic, readonly) SAMultiplayerGameState *gameState;

/**
 Initialize a new SAGameCenterManager object.
 @param aViewController The controller of the view where the Game Center elements are to be displayed.
 @return A new SAGameCenterManager object.
 */
- (id)initWithViewController:(UIViewController <GKGameCenterControllerDelegate, SAGameCenterManagerDelegate> *)aViewController;
/**
 Authenticates the local player. This has to be done before any other APIs are called.
 */
- (void)authenticateLocalPlayer;
/**
 Reports a given score to the server.
 @param aScore The score that is going to be reported.
 @param leaderboardID The leaderboard for which the score is being reported.
 */
- (void)reportScore:(int64_t)aScore forLeaderboardID:(NSString *)leaderboardID;
/**
 Reports the percentage completion of a given Achievement. If it is 100% or
 more then a banner is shown to the player.
 @param identifier The identifier of the achievement which has completion progress.
 @param percent The percentage of the achievement that is completed.
 */
- (void)reportAchievementIdentifier:(NSString *)identifier percentComplete:(float)percent;
/**
 Resets the player achievements.
 */
- (void)resetAchievements;
/**
 Shows the game center to the player.
 */
- (void)showGameCenter;
/**
 Shows the achievements screen of game center to the player.
 */
- (void)showAchievements;
/**
 Shows the leaderboard screen of game center to the player.
 @param leaderboardID The leaderboard for which the score is being reported.
 */
- (void)showLeaderboard:(NSString*)leaderboardID;
/**
 Finds a match with one other player.
 */
- (void)findMatch;
/**
 Handles the "Random Number" message. This message is sent at the beginning of the match to determine who player one is.
 @param message The randome number message received from another player.
 */
- (void)handleRandomNumberWithMessage:(SAJSONMessage *)message;
/**
 Sends a message to the other players.
 @param message A JSON message object that can be serialized and sent.
 @param dataMode Indiciates if a message should be sent reliably or not.
 */
- (void)sendMessage:(SAJSONMessage *)message withDataMode:(GKMatchSendDataMode)dataMode;
/**
 Ends the current match.
 */
- (void)endMatch;
/**
 This method gets called when the user cancels the matchmaking.
 @param aViewController The GKMatchmakerViewController that was presented to the user.
 */
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)aViewController;
/**
 This method gets called when the matchmaking finds a match.
 @param aViewController The GKMatchmakerViewController that was presented to the user.
 @param aMatch The match that was found.
 */
- (void)matchmakerViewController:(GKMatchmakerViewController *)aViewController didFindMatch:(GKMatch *)aMatch;
/**
 This method gets called when the matchmaking fails.
 @param aViewController The GKMatchmakerViewController that was presented to the user.
 @param error The error that was encountered.
 */
- (void)matchmakerViewController:(GKMatchmakerViewController *)aViewController didFailWithError:(NSError *)error;
/**
 This method gets called when data is received from another player.
 @param aMatch The match that this data pertains to.
 @param data The data that was received from the other player.
 @param playerID The ID of the player that sent the data.
 */
- (void)match:(GKMatch *)aMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
/**
 This method gets called when a player's state changes.
 @param aMatch The match that this state change pertains to.
 @param playerID The ID of the player whose state changed.
 @param state The player's new state.
 */
- (void)match:(GKMatch *)aMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state;
/**
 This method gets called when the connection with a player fails.
 @param aMatch The match that this error pertains to.
 @param playerID The ID of the player whom connecting to failed.
 @param error The error that was encountered.
 */
- (void)match:(GKMatch *)aMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error;
/**
 This method gets called when the match fails.
 @param aMatch The match that this failure pertains to.
 @param error The error that was encountered.
 */
- (void)match:(GKMatch *)aMatch didFailWithError:(NSError *)error;

@end

@protocol SAGameCenterManagerDelegate
- (void)matchStarted;
- (void)matchEnded;
- (void)receivedMessage:(SAJSONMessage *)message fromPlayer:(NSString *)playerID;
- (void)playerOrderDecided:(BOOL)ifIsPlayerOne;
@end