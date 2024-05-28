//
//  WKProcessPoolManager.h
//  LocalSpecialty
//
//  Created by YD on 2021/12/22.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKProcessPoolManager : NSObject

+ (WKProcessPool *)singleWkProcessPool;

@end

NS_ASSUME_NONNULL_END
