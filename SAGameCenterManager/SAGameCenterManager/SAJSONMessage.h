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
typedef NS_ENUM(NSInteger, SAMessageType) {
    /** A message with a random number to determine who player one is */
    SAMessageTypeRandomNumber       = 1,
    /** A message that indicates the match has started */
    SAMessageTypeStart              = 2,
    /** A message containing a message from the other player */
    SAMessageTypeText               = 3
};

/**
 Class that represents a JSON message sent between clients
 */
@interface SAJSONMessage : NSObject {
    /** The type of the message */
    SAMessageType messageType;
    /** A random number sent at the beginning of client communication to indicate player one */
    int randomNumber;
    
    unsigned int unreliableMessageIdentifier;
    
    NSString *textMessage;
}

@property (nonatomic, readonly) SAMessageType messageType;
@property (nonatomic, assign) int randomNumber;
@property (nonatomic, assign) unsigned int unreliableMessageIdentifier;
@property (nonatomic, retain) NSString *textMessage;

/**
 Initializes a new SAJSONMessage object with existing formatted JSON data
 @param jsonData The JSON data in a dictionary format
 @return An SAJSONMessage object reflecting the data that was passed in
 */
- (id)initWithJSONData:(NSDictionary *)jsonData;
/**
 Initializes a new SAJSONMessage object with a given message type and
 all other data set to empty
 @param aMessageType The type of the JSON Message
 @return An SAJSONMessage object with a given type
 */
- (id)initWithMessageType:(SAMessageType)aMessageType;
/**
 Returns the JSON data in a dictionary that can be serialized by the OS API
 @return The JSON data in an NSDictionary object
 */
- (NSDictionary *)serializableData;

@end
