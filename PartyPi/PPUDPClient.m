//
//  PPUDPService.m
//  PartyPi
//
//  Created by Tony DiPasquale on 6/28/13.
//  Copyright (c) 2013 Tony DiPasquale. All rights reserved.
//

#import "PPUDPClient.h"

static NSInteger kPort = 27072;

@implementation PPUDPClient {
    GCDAsyncUdpSocket *socket;
}

@synthesize delegate = _delegate;

+ (PPUDPClient *)sharedClient
{
    static PPUDPClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[PPUDPClient alloc] initWithPort:kPort];
    });
    return client;
}

- (id)initWithPort:(uint16_t)port
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error;
    [socket bindToPort:port error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    [socket enableBroadcast:YES error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    [socket beginReceiving:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    return self;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {    
    NSError *error;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    
    if ([response valueForKey:@"cmd"]) {
        return;
    }
    
    if ([response valueForKey:@"response"] && self.delegate) {
        [self.delegate dataReceived:response];
    }
}

- (void)sendCommand:(NSString *)cmd {
    NSDictionary *req = @{@"cmd": cmd};
    NSData *data = [NSJSONSerialization dataWithJSONObject:req options:NSJSONWritingPrettyPrinted error:nil];
    
    if (!self.ip)
        [socket sendData:data toHost:@"255.255.255.255" port:kPort withTimeout:10 tag:0];
    else
        [socket sendData:data toHost:self.ip port:kPort withTimeout:10 tag:0];
}

- (void)sendCommand:(NSString *)cmd WithParam:(NSString *)param {
    NSDictionary *req = @{@"cmd": cmd, @"param": param};
    NSData *data = [NSJSONSerialization dataWithJSONObject:req options:NSJSONWritingPrettyPrinted error:nil];
    
    if (!self.ip)
        [socket sendData:data toHost:@"255.255.255.255" port:kPort withTimeout:10 tag:0];
    else
        [socket sendData:data toHost:self.ip port:kPort withTimeout:10 tag:0];
}

@end
