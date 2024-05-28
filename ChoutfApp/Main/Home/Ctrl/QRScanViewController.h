


//
//  QRCodeMoreViewController.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/12/18.
//

#import "BaseViewController.h"
#import <ScanKitFrameWork/ScanKitFrameWork.h>
#import <AVFoundation/AVFoundation.h>
#import "BrightnessViewController.h"
#import "QRCodeViewController.h"
  
@protocol QRScanViewControllerDelegate <NSObject>


    
//扫描结果
- (void)mutableQrResult:(NSArray *_Nullable)array;


@end



NS_ASSUME_NONNULL_BEGIN

@interface QRScanViewController : BaseViewController

@property(nonatomic,weak)id<QRScanViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END

