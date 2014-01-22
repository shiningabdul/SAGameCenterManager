//
//  SAJSONMessage.m
//  SAGameCenterManager
//
//  Created by Abdul Aljebouri on 1/21/2014.
//  Copyright (c) 2014 shiningdevelopers. All rights reserved.
//

#import "SAJSONMessage.h"

@implementation SAJSONMessage

@synthesize messageType;
@synthesize randomNumber;
@synthesize unreliableMessageIdentifier;

#pragma mark - Initialization

- (id)init
{
    if(self = [super init])
    {
        randomNumber = 0;
        messageType = MPMessageTypeStart;
        unreliableMessageIdentifier = 0;
    }
    
    return self;
}

- (id)initWithJSONData:(NSDictionary *)jsonData
{
    if(self = [super init])
    {
        messageType = (MPMessageType)[[jsonData objectForKey:@"messageType"] intValue];

        if (messageType == MPMessageTypeRandomNumber)
        {
            randomNumber = [[jsonData objectForKey:@"randomNumber"] intValue];
        }
    }
    
    return self;
}

- (id)initWithMessageType:(MPMessageType)aMessageType
{
    if(self = [super init])
    {
        messageType = aMessageType;
        randomNumber = 0;
        unreliableMessageIdentifier = 0;
    }
    
    return self;
}

- (NSDictionary *)serializableData
{
    NSDictionary *dictionary = nil;
    if (messageType == MPMessageTypeRandomNumber)
    {
        dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [NSNumber numberWithInt:messageType], @"messageType",
                      [NSNumber numberWithInt:randomNumber], @"randomNumber",
                      nil];
    }
    else if (messageType == MPMessageTypeStart)
    {
        dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [NSNumber numberWithInt:messageType], @"messageType",
                      nil];
    }
    
    return dictionary;
}

@end
