//
//  DeviceMessage.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/10/24.
//

#import <Foundation/Foundation.h>
#import <mach/mach.h>

#import <SystemConfiguration/SCNetworkReachability.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import <SystemConfiguration/CaptiveNetwork.h>
//无网络
static NSString * _Nullable notReachable = @"notReachable";


NS_ASSUME_NONNULL_BEGIN

@interface DeviceMessage : NSObject


+ (NSDictionary *)getDeviceMessage;

@end

NS_ASSUME_NONNULL_END
