//
//  AppUpdateAlertViewController.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/9/15.
//

#import "BaseViewController.h"
#import "BZAlertLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppUpdateAlertViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UIView *buttView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *butt;

//更新内容
@property(nonatomic,copy)NSString *content;

//是否强制更新
@property(nonatomic,assign)BOOL forceUpdate;

//最新版本号
@property(nonatomic,copy)NSString *version;

//下载链接
@property(nonatomic,copy)NSString *updateUrl;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

NS_ASSUME_NONNULL_END
