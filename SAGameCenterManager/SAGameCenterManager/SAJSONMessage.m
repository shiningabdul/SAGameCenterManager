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
@synthesize textMessage;

#pragma mark - Initialization

- (id)init
{
    if(self = [super init])
    {
        randomNumber = 0;
        messageType = SAMessageTypeStart;
        unreliableMessageIdentifier = 0;
    }
    
    return self;
}

- (id)initWithJSONData:(NSDictionary *)jsonData
{
    if(self = [super init])
    {
        messageType = (SAMessageType)[[jsonData objectForKey:@"messageType"] intValue];

        if (messageType == SAMessageTypeRandomNumber)
        {
            randomNumber = [[jsonData objectForKey:@"randomNumber"] intValue];
        }
        else if (messageType == SAMessageTypeText)
        {
            textMessage = [jsonData objectForKey:@"textMessage"];
        }
    }
    
    return self;
}

- (id)initWithMessageType:(SAMessageType)aMessageType
{
    if(self = [super init])
    {
        messageType = aMessageType;
        randomNumber = 0;
        unreliableMessageIdentifier = 0;
        textMessage = @"";
    }
    
    return self;
}

- (NSDictionary *)serializableData
{
    NSDictionary *dictionary = nil;
    if (messageType == SAMessageTypeRandomNumber)
    {
        dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [NSNumber numberWithInt:messageType], @"messageType",
                      [NSNumber numberWithInt:randomNumber], @"randomNumber",
                      nil];
    }
    else if (messageType == SAMessageTypeStart)
    {
        dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [NSNumber numberWithInt:messageType], @"messageType",
                      nil];
    }
    else if (messageType == SAMessageTypeText)
    {
        dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [NSNumber numberWithInt:messageType], @"messageType",
                      textMessage, @"textMessage",
                      nil];
    }
    
    return dictionary;
}

@end
