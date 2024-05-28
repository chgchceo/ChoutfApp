//
//  DeviceMessage.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/10/24.
//

#import "DeviceMessage.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "header.h"
@implementation DeviceMessage

+ (NSDictionary *)getDeviceMessage{
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    //手机制造商
    [dataDic setValue:@"Apple" forKey:@"manufacturer"];
    //手机品牌
    [dataDic setValue:@"Apple" forKey:@"mobilePhoneBrand"];
    //获取设备型号
    NSString *model = [UIDevice currentDevice].model;
    [dataDic setValue:model forKey:@"mobilePhoneModel"];
    //设备uuid
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [dataDic setValue:uuid forKey:@"deviceId"];
    //手机系统版本
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    [dataDic setValue:systemVersion forKey:@"systemVersion"];
    //获取系统名称
    NSString *system = [UIDevice currentDevice].systemName;
    [dataDic setValue:system forKey:@"system"];
    //内存空间。ram和rom
    [dataDic setValue:@([self deviceStorageSpace:NO] / 1000.0 / 1000.0 / 1000.0) forKey:@"ramFreeSpace"];
    
    [dataDic setValue:@([self deviceStorageSpace:YES] / 1000.0 / 1000.0 / 1000.0) forKey:@"ramTotalSpace"];
    
    
    double total = (double)[self getTotalMemory]/1000/1000/1000;
    double free = (double)[self getFreeMemory]/1000/1000/1000;
    double used = (double)[self getUsedMemory]/1000/1000/1000;
    
    
    [dataDic setValue:@(total) forKey:@"romTotalSpace"];
    
    [dataDic setValue:@(free) forKey:@"romFreeSpace"];
    
    [dataDic setValue:@(used) forKey:@"romUsedSpace"];
    //获取isoCountryCode
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    
    CTCarrier *carrier = info.subscriberCellularProvider;
    
    NSString *networkCountryIso = carrier.isoCountryCode;
    
    [dataDic setValue:networkCountryIso forKey:@"networkCountryIso"];
    //mobileCountryCode
    
    NSString *networkOperator = carrier.mobileCountryCode;
    [dataDic setValue:networkOperator forKey:@"networkOperator"];
    //carrierName
    NSString *carrierName = carrier.carrierName;
    [dataDic setValue:carrierName forKey:@"networkOperatorName"];
    
    
    
    [dataDic setValue:@(NSProcessInfo.processInfo.systemUptime) forKey:@"bootTime"];
    
    [dataDic setValue:@(NSProcessInfo.processInfo.processorCount) forKey:@"cpuCount"];
    
    //屏幕分辨率
    [dataDic setValue:[NSString stringWithFormat:@"%.1fx%.1f",UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width] forKey:@"screenResolution"];
    //屏幕的比例因子
    [dataDic setValue:@(UIScreen.mainScreen.scale) forKey:@"screenScale"];
    //是否为模拟器
    [dataDic setValue:@([self isSimulator]) forKey:@"emulator"];
    //是否越狱
    [dataDic setValue:@([self isJailBroken]) forKey:@"root"];
    //屏幕尺寸
    [dataDic setValue:[NSString stringWithFormat:@"%.1f", [self diagonal]] forKey:@"screenSize"];
    
    [dataDic setValue:NSLocale.preferredLanguages.firstObject?:@"" forKey:@"languageName"];
    
    [dataDic setValue:[NSLocale currentLocale].countryCode forKey:@"systemCountryCode"];
    //时区
    [dataDic setValue:NSTimeZone.defaultTimeZone.name  forKey:@"timezoneId"];
    //当前时间
    [dataDic setValue:[Utils getNowTimeStr] forKey:@"recentDatetime"];
    //屏幕亮度
    [dataDic setValue:@(UIScreen.mainScreen.brightness) forKey:@"screenLuminance"];
    
    // 是否在充电状态
    BOOL charging = [UIDevice new].batteryState == UIDeviceBatteryStateCharging;
    
    [dataDic setValue:@(charging) forKey:@"charging"];
    //电量 0-1，对应0%-100%
    UIDevice *device = UIDevice.currentDevice;
    
    [device setBatteryMonitoringEnabled:YES];
    
    [dataDic setValue:@(device.batteryLevel>0?device.batteryLevel*100:0) forKey:@"batterypercent"];
    
    [dataDic setValue:[self getNetworkType] forKey:@"network"];
    
    //wifi名称
    [dataDic setValue:[Utils getTextWithModelStr:[self getWifiSSID]] forKey:@"wifiName"];
    
    //routerMac
    [dataDic setValue:[Utils getTextWithModelStr:[self getWifiBSSID]] forKey:@"routerMac"];
    //app名称
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleName"];
    
    [dataDic setValue:appName forKey:@"appName"];
    
    //app版本
    [dataDic setValue:app_Version forKey:@"appVersion"];
    
    //app build版本
    [dataDic setValue:app_build forKey:@"appBuild"];
    
    
    
    return dataDic;
}



//是否是模拟器
+ (BOOL)isSimulator {
    
#if TARGET_IPHONE_SIMULATOR  //模拟器
    return YES;
#elif TARGET_OS_IPHONE      //真机
    return NO;
#endif
}

//是否越狱
+ (BOOL)isJailBroken {
    
    if ([self isSimulator]) return NO;
    
    NSArray *jailbreak_tool_paths = @[
            @"/Applications/Cydia.app",
            @"/Library/MobileSubstrate/MobileSubstrate.dylib",
            @"/bin/bash",
            @"/usr/sbin/sshd",
            @"/etc/apt"
        ];
    
    for (int i=0; i<jailbreak_tool_paths.count; i++) {
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:jailbreak_tool_paths[i]]) {
            
            NSLog(@"The device is jail broken!");
            return YES;
        }
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}

//屏幕尺寸
+ (double)diagonal {
    
    CGFloat scale = UIScreen.mainScreen.scale;
    
    CGFloat ppi = scale * ((UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 132 : 163);
    
    CGFloat horizontal = UIScreen.mainScreen.bounds.size.width * scale / ppi;
    
    CGFloat vertical = UIScreen.mainScreen.bounds.size.height * scale / ppi;
    
    double diagonal = sqrt(pow(horizontal, 2) + pow(vertical, 2));
    
    return diagonal;
}

#pragma mark --- 获取当前网络状态
+ (NSString *)getNetworkType{
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags) {
        return notReachable;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    if (isReachable && !needsConnection) { }else{
        return notReachable;
    }
    
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired ) {
        
        return notReachable;
        
    } else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
        
        return [self cellularType];
        
    } else {
        return @"WiFi";
    }
    
}

+ (NSString *)cellularType {
    
    CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *currentRadioAccessTechnology;
    if (@available(iOS 12.1, *)) {
        if (info && [info respondsToSelector:@selector(serviceCurrentRadioAccessTechnology)]) {
            NSDictionary *radioDic = [info serviceCurrentRadioAccessTechnology];
            if (radioDic.allKeys.count) {
                currentRadioAccessTechnology = [radioDic objectForKey:radioDic.allKeys[0]];
            } else {
                return notReachable;
            }
        } else {
            
            return notReachable;
        }
        
    } else {
        
        currentRadioAccessTechnology = info.currentRadioAccessTechnology;
    }
    
    if (currentRadioAccessTechnology) {
        
        if (@available(iOS 14.1, *)) {
            
            if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyNRNSA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyNR]) {
                
                return @"5G";
                
            }
        }
        
        if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
            
            return @"4G";
            
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
            
            return @"3G";
            
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
            
            return @"2G";
            
        } else {
            
            return @"Unknow";
        }
        
        
    } else {
        
        return notReachable;
    }
}

+ (NSString *)getWifiSSID {
    NSString *ssid = nil;
    CFArrayRef arrRef = CNCopySupportedInterfaces();
    NSArray *ifs = (__bridge id)arrRef;
    for (NSString *ifnam in ifs) {
        CFDictionaryRef dicRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSDictionary *info = (__bridge id)dicRef;
        if (info[@"BSSID"]) {
            ssid = info[@"SSID"];
        }
        if(dicRef !=nil) {
            CFRelease(dicRef);
        }
    }
    if(arrRef != nil) {
        CFRelease(arrRef);
    }
    return ssid;
}

+ (NSString *)getWifiBSSID {
        NSString *bssid = @"";
        CFArrayRef arrRef = CNCopySupportedInterfaces();
        NSArray *ifs = (__bridge id)arrRef;
        for(NSString *ifnam in ifs) {
            CFDictionaryRef dicRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
            NSDictionary *info = (__bridge id)dicRef;
            if (info[@"BSSID"]) {
                bssid = info[@"BSSID"];
            }
           if (dicRef != nil) {
                CFRelease(dicRef);
            }
        }
        if (arrRef != nil) {
            CFRelease(arrRef);
        }
        return bssid;
}


/** 磁盘使用情况 */
+ (nonnull NSString *)diskUsage{

    return [NSString stringWithFormat:@"设备可用内存：%.01lfG\n设备总内存：%.01lfG",[self deviceStorageSpace:NO] / 1000.0 / 1000.0 / 1000.0,[self deviceStorageSpace:YES] / 1000.0 / 1000.0 / 1000.0];
}

/** 当前手机磁盘空间大小 ，totalSpace：YES：磁盘空间总大小，NO：磁盘剩余可用空间 */
+ (long long)deviceStorageSpace:(BOOL)totalSpace{
    //剩余空间
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpaces = (NSNumber *)[fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpaces = (NSNumber *)[fileSysAttributes objectForKey:NSFileSystemSize];
    if (totalSpace) {
        return totalSpaces.longLongValue;
    }
    return freeSpaces.longLongValue;
}


// 获取未使用的磁盘空间
//- (int64_t)getFreeDiskSpace {
//    NSError *error = nil;
//    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
//    if (error) return -1;
//    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
//    if (space < 0) space = -1;
//    return space;
//}
//// 获取已使用的磁盘空间
//- (int64_t)getUsedDiskSpace {
//    int64_t totalDisk = [self getTotalDiskSpace];
//    int64_t freeDisk = [self getFreeDiskSpace];
//    if (totalDisk < 0 || freeDisk < 0) return -1;
//    int64_t usedDisk = totalDisk - freeDisk;
//    if (usedDisk < 0) usedDisk = -1;
//    return usedDisk;
//}


// 获取系统总内存空间
+ (int64_t)getTotalMemory {
    int64_t totalMemory = [[NSProcessInfo processInfo] physicalMemory];
    if (totalMemory < -1) totalMemory = -1;
    return totalMemory;
}

// 获取活跃的内存,正在使用或者很短时间内被使用过
+ (int64_t)getActiveMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.active_count * page_size;
}

// 获取空闲的内存空间
+ (int64_t)getFreeMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.free_count * page_size;
}
// 获取已使用的内存空间
+ (int64_t)getUsedMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
}

@end
