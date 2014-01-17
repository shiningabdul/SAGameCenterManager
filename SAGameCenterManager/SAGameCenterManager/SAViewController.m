//
//  SAViewController.m
//  SAGameCenterManager
//
//  Created by Abdul Aljebouri on 2013-06-08.
//  Copyright (c) 2013 shiningdevelopers. All rights reserved.
//

#import "SAViewController.h"

@interface SAViewController ()

@end

@implementation SAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    gameCenterManager = [[SAGameCenterManager alloc] initWithViewController:self];
    [gameCenterManager authenticateLocalPlayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitToLeaderboardButtonPressed:(id)sender
{
    [gameCenterManager reportScore:5688 forLeaderboardID:@"game_center_test_leaderboard"];
}

- (IBAction)submitAchievementsButtonPressed:(id)sender
{
    [gameCenterManager reportAchievementIdentifier:@"game_center_manager_test_achievement" percentComplete:100];
}

- (IBAction)resetAchievementsButtonPressed:(id)sender
{
    [gameCenterManager resetAchievements];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
