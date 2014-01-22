//
//  SAViewController.h
//  SAGameCenterManager
//
//  Created by Abdul Aljebouri on 2013-06-08.
//  Copyright (c) 2013 shiningdevelopers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAGameCenterManager.h"
#import "SAJSONMessage.h"

@interface SAViewController : UIViewController <GKGameCenterControllerDelegate, SAGameCenterManagerDelegate> {
    SAGameCenterManager *gameCenterManager;
}

@property (strong, nonatomic) IBOutlet UILabel *playerNumberLabel;

- (IBAction)submitToLeaderboardButtonPressed:(id)sender;

- (IBAction)submitAchievementsButtonPressed:(id)sender;

- (IBAction)resetAchievementsButtonPressed:(id)sender;

- (IBAction)showAchievements:(id)sender;

- (IBAction)showLeaderboards:(id)sender;

- (IBAction)showGameCenter:(id)sender;

- (IBAction)findMatch:(id)sender;

- (void)matchStarted;
- (void)matchEnded;
- (void)receivedMessage:(SAJSONMessage *)message fromPlayer:(NSString *)playerID;
- (void)playerOrderDecided:(BOOL)ifIsPlayerOne;

@end
