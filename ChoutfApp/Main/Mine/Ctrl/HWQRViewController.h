//
//  HWQRViewController.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/11/29.
//

#import "BaseViewController.h"
#import "GreenView.h"

@protocol HWQRViewControllerDelegate <NSObject>

//扫码结果
- (void)hwqrResult:(NSString *_Nullable)result;
    
//多个扫描结果
- (void)mutableQrResult:(NSArray *_Nullable)array;


@end



NS_ASSUME_NONNULL_BEGIN

@interface HWQRViewController : BaseViewController


@property(nonatomic,weak)id<HWQRViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *bgView;




@end

NS_ASSUME_NONNULL_END
