//
//  BaseViewController.h
//  LocalSpecialty
//
//  Created by cgc on 2021/9/13.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

//test
NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
{

    MBProgressHUD *_hud;

}


@property(nonatomic,assign)BOOL isModal;

//显示加载视图
- (void)showLoadingView:(NSString *)labelText;

//隐藏视图
-(void)hiddenView;


-(void)onlyBackButtonAction;

@end

NS_ASSUME_NONNULL_END
