//
//  SAViewController.h
//  SAGameCenterManager
//
//  Created by Abdul Aljebouri on 2013-06-08.
//  Copyright (c) 2013 shiningdevelopers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAGameCenterManager.h"

@class SAGameCenterManager;

@interface SAViewController : UIViewController <GKGameCenterControllerDelegate> {
    SAGameCenterManager *gameCenterManager;
}

- (IBAction)submitToLeaderboardButtonPressed:(id)sender;

- (IBAction)submitAchievementsButtonPressed:(id)sender;

- (IBAction)resetAchievementsButtonPressed:(id)sender;

@end
