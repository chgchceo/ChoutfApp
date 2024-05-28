//
//  PingHost.m
//  Demo
//
//  Created by chgch on 2024/2/28.
//

#import "PingHost.h"
#import "SimplePing.h"


@interface PingHost ()<SimplePingDelegate>{
    
    SimplePing *_pinger;
    dispatch_source_t _timer;
    ResultPingBlock _block;
    NSString *_hostName;
    
}

@end


@implementation PingHost


- (void)pingHostName:(NSString *)hostName withBlock:(ResultPingBlock)block{
    
    _hostName = hostName;
    _block = block;
    
    
    NSString *name = [NSString stringWithFormat:@"%@",_hostName];
    _pinger = [[SimplePing alloc] initWithHostName:name];
    _pinger.delegate = self;
    [_pinger start];
}

- (void)stop{
    if (_pinger) {
        [_pinger stop];
    }

    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address{
    if (_timer) {
        return;
    }
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        [pinger sendPingWithData:nil];
    });
    dispatch_resume(_timer);
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber{
    NSLog(@"**可以使用网**");
    [self stop];
    _block(true);
}

-  (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error{
    if (error.code == 65) {
        
        
        
     }
    NSLog(@"**不可以使用网**");
    [self stop];
    _block(false);
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error{
    
    NSLog(@"--------------didFailWithError-------------");
    [self stop];
    _block(false);
}





@end
