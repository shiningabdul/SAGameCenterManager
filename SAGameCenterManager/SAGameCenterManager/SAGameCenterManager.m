//
//  SAGameCenterManager.m
//  SAGameCenterManager
//
//  Created by Abdul Aljebouri on 12/6/2013.
//  Copyright (c) 2013 shiningdevelopers. All rights reserved.
//

#import "SAGameCenterManager.h"

@implementation SAGameCenterManager

@synthesize delegate;
@synthesize gameState;

#pragma mark - Initialization

- (id)initWithViewController:(UIViewController <GKGameCenterControllerDelegate, SAGameCenterManagerDelegate> *)aViewController
{
    if(self = [super init])
    {
        viewController = aViewController;
        match = nil;
        gameState = [[SAMultiplayerGameState alloc] init];
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

#pragma mark - Match Methods

- (void)findMatch
{
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKMatchmakerViewController *mmvc =
    [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    
    gameState.isMatchReady = NO;
    gameState.isMatchStarted = NO;
    
    [viewController presentViewController:mmvc animated:YES completion:nil];
}

- (void)player:(GKPlayer *)player didAcceptInvite:(GKInvite *)invite
{
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithInvite:invite];
    mmvc.matchmakerDelegate = self;
    [viewController presentViewController:mmvc animated:YES completion:nil];
}

- (void)player:(GKPlayer *)player didRequestMatchWithPlayers:(NSArray *)playerIDsToInvite
{
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    request.playersToInvite = playerIDsToInvite;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    [viewController presentViewController:mmvc animated:YES completion:nil];
}

- (void)handleRandomNumberWithMessage:(SAJSONMessage *)message;
{
    NSLog(@"%d", message.randomNumber);
    
    // If I didn't get a chance to create my random number I create it now
    if(!gameState.isMatchReady)
    {
        gameState.isMatchReady = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kMPMatchReadyNotification object:self];
        
        // Generate a random number to determine which player is player one
        gameState.randomNumber = arc4random() % 10001;
        
        SAJSONMessage *message = [[SAJSONMessage alloc] initWithMessageType:MPMessageTypeRandomNumber];
        message.randomNumber = gameState.randomNumber;
        [self sendMessage:message withDataMode:GKMatchSendDataReliable];
    }
    
    // If the my random number is greater than the other player
    // then I am player one
    if(message.randomNumber > gameState.randomNumber)
    {
        gameState.isMatchStarted = YES;
        gameState.isPlayerOne = YES;
        NSLog(@"I am player one");
    }
    else if(message.randomNumber < gameState.randomNumber)
    {
        // Else if they have the greater number then they are player one
        gameState.isMatchStarted = YES;
        gameState.isPlayerOne = NO;
        NSLog(@"I am player two");
    }
    else
    {
        // Else we have to resend the numbers
        gameState.randomNumber = arc4random() % 1000001;
        
        SAJSONMessage *message = [[SAJSONMessage alloc] initWithMessageType:MPMessageTypeRandomNumber];
        message.randomNumber = gameState.randomNumber;
        [self sendMessage:message withDataMode:GKMatchSendDataReliable];
    }
    
    if(gameState.isMatchStarted)
    {
        [delegate playerOrderDecided:gameState.isPlayerOne];
        
        if(!gameState.isPlayerOne)
        {
            [delegate matchStarted];
            SAJSONMessage *message = [[SAJSONMessage alloc] initWithMessageType:MPMessageTypeStart];
            [self sendMessage:message withDataMode:GKMatchSendDataReliable];
        }
    }
}

- (void)sendMessage:(SAJSONMessage *)message withDataMode:(GKMatchSendDataMode)dataMode
{
    NSError *error = nil;
    NSDictionary *serializableData = [message serializableData];
    NSData *packet = [NSJSONSerialization dataWithJSONObject:serializableData options:kNilOptions error:&error];
    NSString *jsonDataToSend = [[NSString alloc] initWithData:packet encoding:NSUTF8StringEncoding];
    
    NSLog(@"Sent message: %@", jsonDataToSend);
    
    [match sendDataToAllPlayers:packet withDataMode:dataMode error:&error];
    
    if (error != nil)
    {
        // Handle the error
        NSLog(@"An error occured while sending the message: %@", [error localizedDescription]);
    }
}

- (void)endMatch
{
    if(match != nil)
    {
        [match disconnect];
        match = nil;
        [delegate matchEnded];
    }
}

#pragma mark - MatchmakerViewController Delegate Methods

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)aViewController
{
    [aViewController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Player cancelled");
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)aViewController didFailWithError:(NSError *)error
{
    [aViewController dismissViewControllerAnimated:YES completion:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MatchErrorOccured", nil)
                                                    message:NSLocalizedString(@"MatchErrorOccuredMessage", nil)
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    NSLog(@"Error in getting a match: %@", [error localizedDescription]);
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)aViewController didFindMatch:(GKMatch *)aMatch
{
    [aViewController dismissViewControllerAnimated:YES completion:nil];
    match = aMatch;
    aMatch.delegate = self;
    
    /** Determine the ID of the other player **/
    for (NSString *playerId in match.playerIDs)
    {
        if (![playerId isEqualToString:gameState.playerID])
        {
            gameState.otherPlayerID = playerId;
        }
    }
    
    if (!gameState.isMatchStarted && match.expectedPlayerCount == 0)
    {
        gameState.isMatchReady = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kMPMatchReadyNotification object:self];
        
        // Generate a random number to determine which player is player one
        gameState.randomNumber = arc4random() % 10001;
        
        SAJSONMessage *message = [[SAJSONMessage alloc] initWithMessageType:MPMessageTypeRandomNumber];
        message.randomNumber = gameState.randomNumber;
        [self sendMessage:message withDataMode:GKMatchSendDataReliable];
    }
}

#pragma mark - GKMatch Delegate Methods

- (void)match:(GKMatch *)aMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    if (match != aMatch)
    {
        return;
    }
    
    NSError *error;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *jsonDataReceived = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Received message: %@", jsonDataReceived);
    
    SAJSONMessage *receivedMessage = [[SAJSONMessage alloc] initWithJSONData:jsonData];
    
    if (!gameState.isMatchStarted)
    {
        [self handleRandomNumberWithMessage:receivedMessage];
    }
    else
    {
        [delegate receivedMessage:receivedMessage fromPlayer:playerID];
    }
}

- (void)match:(GKMatch *)aMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
    if (match != aMatch)
    {
        return;
    }
    
    switch (state)
    {
        case GKPlayerStateConnected:
            // Handle a new player connection.
            NSLog(@"Player connected!");
            
            if (!gameState.isMatchStarted && aMatch.expectedPlayerCount == 0)
            {
                NSLog(@"Ready to start match!");
            }
            
            break;
        case GKPlayerStateDisconnected:
            // A player just disconnected.
            NSLog(@"Player disconnected!");
            gameState.isMatchStarted = NO;
            gameState.isMatchReady = NO;
            match = nil;
            [delegate matchEnded];
            break;
    }
}

- (void)match:(GKMatch *)aMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error
{
    if (match != aMatch)
    {
        return;
    }
    
    gameState.isMatchStarted = NO;
    gameState.isMatchReady = NO;
    [delegate matchEnded];
    
    NSLog(@"Failed to connect to player with error: %@", [error localizedDescription]);
}

- (void)match:(GKMatch *)aMatch didFailWithError:(NSError *)error
{
    if (match != aMatch)
    {
        return;
    }
    
    gameState.isMatchStarted = NO;
    gameState.isMatchReady = NO;
    [delegate matchEnded];
    
    NSLog(@"Match failed with error: %@", [error localizedDescription]);
}

@end
