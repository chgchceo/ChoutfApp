//
//  MineViewController.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/8/29.
//

#import "BaseViewController.h"
#import "PrinterPdfViewController.h"
#import "AppUpdateAlertViewController.h"
#import "SelURLAlertViewController.h"
#import "HistoryVersionViewController.h"
#import "LogMessageViewController.h"
#import "UIViewController+MMDrawerController.h"

@protocol MineViewControllerDelegate <NSObject>

//修改了url地址
- (void)changeUrlStr:(NSString *_Nonnull)htmlStr;


@end

NS_ASSUME_NONNULL_BEGIN

@interface MineViewController : BaseViewController

@property(nonatomic,assign)BOOL isFromURL;//来自url地址，只有一项

//h5链接地址
@property(nonatomic,copy)NSString *htmlStrl;


@property(nonatomic,weak)id<MineViewControllerDelegate>delegate;


@end

NS_ASSUME_NONNULL_END
