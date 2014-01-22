//
//  SAJSONMessage.h
//  SAGameCenterManager
//
//  Created by Abdul Aljebouri on 1/21/2014.
//  Copyright (c) 2014 shiningdevelopers. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Enumerator used to indicate the type of message
 */
typedef NS_ENUM(NSInteger, MPMessageType) {
    /** A message with a random number to determine who player one is */
    MPMessageTypeRandomNumber       = 1,
    /** A message that indicates the match has started */
    MPMessageTypeStart              = 2,
    /** A message containing player movement data */
    MPMessageTypeMovement           = 3,
    /** A message containing missile creation data */
    MPMessageTypeMissile            = 4,
    /** A message containing enemy creation data */
    MPMessageTypeEnemySummon        = 5,
    /** A message containing boss summon data */
    MPMessageTypeBossSummon         = 6,
    /** A message containing boss movement data */
    MPMessageTypeBossMovement       = 7,
    /** A message indicating that the boss has died */
    MPMessageTypeBossDead           = 8,
    /** A message indicating that the player has died */
    MPMessageTypePlayerDead         = 9,
    /** A message indicating the the player has chosen to end the match */
    MPMessageTypePlayerEnd          = 10
};

/**
 Class that represents a JSON message sent between clients
 */
@interface SAJSONMessage : NSObject {
    /** The type of the message */
    MPMessageType messageType;
    /** A random number sent at the beginning of client communication to indicate player one */
    int randomNumber;
    
    unsigned int unreliableMessageIdentifier;
}

@property (nonatomic, readonly) MPMessageType messageType;
@property (nonatomic, assign) int randomNumber;
@property (nonatomic, assign) unsigned int unreliableMessageIdentifier;

/**
 Initializes a new MPJSONMessage object with existing formatted JSON data
 @param jsonData The JSON data in a dictionary format
 @return An MPJSONMessage object reflecting the data that was passed in
 */
- (id)initWithJSONData:(NSDictionary *)jsonData;
/**
 Initializes a new MPJSONMessage object with a given message type and
 all other data set to empty
 @param aMessageType The type of the JSON Message
 @return An MPJSONMessage object with a given type
 */
- (id)initWithMessageType:(MPMessageType)aMessageType;
/**
 Returns the JSON data in a dictionary that can be serialized by the OS API
 @return The JSON data in an NSDictionary object
 */
- (NSDictionary *)serializableData;

@end
