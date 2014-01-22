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
    gameCenterManager.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.textField.delegate = self;
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

- (IBAction)showAchievements:(id)sender
{
    [gameCenterManager showAchievements];
}

- (IBAction)showLeaderboards:(id)sender
{
    [gameCenterManager showLeaderboard:@"game_center_test_leaderboard"];
}

- (IBAction)showGameCenter:(id)sender
{
    [gameCenterManager showGameCenter];
}

- (IBAction)sendMessage:(id)sender
{
    SAJSONMessage *jsonMessage = [[SAJSONMessage alloc] initWithMessageType:SAMessageTypeText];
    jsonMessage.textMessage = [self.textField text];
    [gameCenterManager sendMessage:jsonMessage withDataMode:GKMatchSendDataReliable];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissKeyboard
{
    [self.textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [self sendMessage:nil];
    
    return YES;
}

#pragma mark - Multiplayer
- (IBAction)findMatch:(id)sender
{
    [gameCenterManager findMatch];
}

- (void)matchStarted
{
    ;
}

- (void)matchEnded
{
    ;
}

- (void)disconnectMatch
{
    [gameCenterManager endMatch];
}

- (void)receivedMessage:(SAJSONMessage *)message fromPlayer:(NSString *)playerID
{
    if(message.messageType == SAMessageTypeStart)
    {
        ;
    }
    else if (message.messageType == SAMessageTypeText)
    {
        [self.otherPlayerMessage setText:message.textMessage];
    }
}

- (void)playerOrderDecided:(BOOL)ifIsPlayerOne
{
    if(ifIsPlayerOne)
    {
        [self.playerNumberLabel setText:@"Player One"];
    }
    else
    {
        [self.playerNumberLabel setText:@"Player Two"];
    }
}

@end
