//
//  SelQRViewController.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/11/27.
//

#import "BaseViewController.h"

@protocol SelQRViewControllerDelegate <NSObject>

//点击了扫描类型
- (void)clickButtWithTitle:(NSString *_Nullable)title;


@end

NS_ASSUME_NONNULL_BEGIN

@interface SelQRViewController : BaseViewController

@property(nonatomic,weak)id<SelQRViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UIView *alertView;



@end

NS_ASSUME_NONNULL_END
