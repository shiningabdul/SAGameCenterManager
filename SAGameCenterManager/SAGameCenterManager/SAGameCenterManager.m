//
//  SAGameCenterManager.m
//  SAGameCenterManager
//
//  Created by Abdul Aljebouri on 12/6/2013.
//  Copyright (c) 2013 shiningdevelopers. All rights reserved.
//

#import "SAGameCenterManager.h"

@implementation SAGameCenterManager

#pragma mark - Initialization

- (id)initWithViewController:(SAViewController *)aViewController
{
    if(self = [super init])
    {
        viewController = aViewController;
    }
    
    return self;
}

#pragma mark - Single Player Methods

- (void)authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *receivedViewController, NSError *error) {
        if (receivedViewController != nil)
        {
            [viewController presentViewController:receivedViewController animated:YES completion:nil];
        }
        
        if(error != nil)
        {
            NSLog(@"Error in authenticating the player: %@", [error localizedDescription]);
        }
    };
}

- (void)reportScore:(int64_t)aScore forLeaderboardID:(NSString *)leaderboardID
{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardID];
    score.value = aScore;
    score.context = 0;
    NSArray *scores = [[NSArray alloc] initWithObjects:score, nil];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        // If there is an error we simply log it
        if (error != nil)
        {
            NSLog(@"Error in reporting score: %@", [error localizedDescription]);
        }
    }];
}

- (void)reportAchievementIdentifier:(NSString *)identifier percentComplete:(float)percent
{
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
    if (achievement)
    {
        achievement.percentComplete = percent;
        if(percent >= 100.00)
        {
            achievement.showsCompletionBanner = YES;
        }
        
        NSArray *achievements = [[NSArray alloc] initWithObjects:achievement, nil];
        
        [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
            // If there is an error we simply log it
            if (error != nil)
            {
                NSLog(@"Error in reporting achievements: %@", [error localizedDescription]);
            }
        }];
    }
}

- (void)resetAchievements
{
    // Clear all progress saved on Game Center.
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            NSLog(@"Error in reporting achievements: %@", [error localizedDescription]);
        }
    }];
}

- (void)showGameCenter
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = viewController;
        gameCenterController.viewState = GKGameCenterViewControllerStateDefault;
        [viewController presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (void)showAchievements
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = viewController;
        gameCenterController.viewState = GKGameCenterViewControllerStateAchievements;
        [viewController presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (void)showLeaderboard:(NSString *)leaderboardID
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = viewController;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardIdentifier = leaderboardID;
        [viewController presentViewController: gameCenterController animated: YES completion:nil];
    }
}

@end
