//
//  QRCodeMoreViewController.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/12/18.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
  
@protocol QRCodeMoreViewControllerDelegate <NSObject>

    
//扫描结果
- (void)mutableQrResult:(NSArray *_Nullable)array;


@end



NS_ASSUME_NONNULL_BEGIN

@interface QRCodeMoreViewController : UIViewController


@property(nonatomic,weak)id<QRCodeMoreViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
