//
//  PPUDPClient.h
//  PartyPi
//
//  Created by Tony DiPasquale on 6/28/13.
//  Copyright (c) 2013 Tony DiPasquale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncUdpSocket.h>

@protocol PPUDPClientDelegate <NSObject>

- (void)dataReceived:(NSDictionary *)data;

@end

@interface PPUDPClient : NSObject <GCDAsyncUdpSocketDelegate>

@property (strong, nonatomic) NSString *ip;
@property (weak, nonatomic) id <PPUDPClientDelegate> delegate;

+ (PPUDPClient *)sharedClient;

- (void)sendCommand:(NSString *)cmd;
- (void)sendCommand:(NSString *)cmd WithParam:(NSString *)param;

@end
