//
//  WKProcessPoolManager.m
//  LocalSpecialty
//
//  Created by YD on 2021/12/22.
//

#import "WKProcessPoolManager.h"

@implementation WKProcessPoolManager
/*
 解决：
 A页面和B页面都存在 一个WKWebView。 在B页面使用localstorage保存信息。 回到A页面取不到最新的数据 的问题
 */

+ (WKProcessPool *)singleWkProcessPool{
    
    static WKProcessPool *sharedPool;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedPool = [[WKProcessPool alloc] init];
    });
    
    return sharedPool;
}

@end
