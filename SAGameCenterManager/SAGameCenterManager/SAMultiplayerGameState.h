//
//  SAMultiplayerGameState.h
//  SAGameCenterManager
//
//  Created by Abdul Aljebouri on 1/21/2014.
//  Copyright (c) 2014 shiningdevelopers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAMultiplayerGameState : NSObject {
    NSString *playerID;
    NSString *otherPlayerID;
    
    BOOL isPlayerOne;
    BOOL isMatchReady;
    BOOL isMatchStarted;
    
    int randomNumber;
}

@property (nonatomic, retain) NSString *playerID;
@property (nonatomic, retain) NSString *otherPlayerID;
@property (nonatomic, assign) BOOL isPlayerOne;
@property (nonatomic, assign) BOOL isMatchReady;
@property (nonatomic, assign) BOOL isMatchStarted;
@property (atomic, assign) int randomNumber;

@end
