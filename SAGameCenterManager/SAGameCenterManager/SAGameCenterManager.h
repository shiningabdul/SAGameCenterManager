//
//  SAGameCenterManager.h
//  SAGameCenterManager
//
//  Created by Abdul Aljebouri on 12/6/2013.
//  Copyright (c) 2013 shiningdevelopers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "SAViewController.h"

@class SAViewController;

@interface SAGameCenterManager : NSObject {
    /** Controller of the view where the Game Center elements are to be displayed. */
    SAViewController *viewController;
}

/**
 Initialize a new SAGameCenterManager object.
 @param aViewController The controller of the view where the Game Center elements are to be displayed.
 @return A new SAGameCenterManager object.
 */
- (id)initWithViewController:(SAViewController *)aViewController;
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

@end