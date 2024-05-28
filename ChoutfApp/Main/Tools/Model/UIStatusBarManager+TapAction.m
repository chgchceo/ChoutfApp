//
//  UIStatusBarManager+TapAction.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/11/13.
//

#import "UIStatusBarManager+TapAction.h"
#if TARGET_OS_IPHONE
#import <objc/runtime.h>
#import <objc/message.h>
#else
#import <objc/objc-class.h>
#endif

@implementation UIStatusBarManager (TapAction)

+ (void)load
{
    Method orignalMethod = class_getInstanceMethod(self, @selector(handleTapAction:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(statusBarTouchedAction:));
    method_exchangeImplementations(orignalMethod, swizzledMethod);
}

- (void)statusBarTouchedAction:(id)sender{
    [self statusBarTouchedAction:sender];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"statusBarTappedNotification" object:nil];
}


@end
