//
//  PingHost.h
//  Demo
//
//  Created by chgch on 2024/2/28.
//

#import <Foundation/Foundation.h>

//isLink,true域名ping成功,false域名ping失败
typedef void(^ResultPingBlock)(bool isLink);

NS_ASSUME_NONNULL_BEGIN

@interface PingHost : NSObject



//ping域名是否可以访问
- (void)pingHostName:(NSString *)hostName withBlock:(ResultPingBlock)block;






@end

NS_ASSUME_NONNULL_END
