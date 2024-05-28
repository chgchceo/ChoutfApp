//
//  MessageAlertViewController.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/11/13.
//

#import "BaseViewController.h"

@protocol MessageAlertViewControllerDelegate <NSObject>

//刷新
- (void)refreshView;
//我的
- (void)mineView;

//打印
- (void)printerWeb;



@end

NS_ASSUME_NONNULL_BEGIN

@interface MessageAlertViewController : BaseViewController


@property(nonatomic,weak)id<MessageAlertViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property(nonatomic,copy)NSString *htmlStr;//链接



@end

NS_ASSUME_NONNULL_END
