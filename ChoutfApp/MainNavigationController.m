//
//  MainNavigationController.m
//  FangSouSou
//
//  Created by guojiacf on 16/5/3.
//  Copyright (c) 2016年 guojiacf.com. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation MainNavigationController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //解决首页侧滑卡死问题
    __weak MainNavigationController *weakSelf = self;
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }

    //导航栏背景颜色
    self.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:36 weight:UIFontWeightMedium],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}
//
//- (BOOL)shouldAutorotate{
//    
//    return [self.topViewController shouldAutorotate];
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    
//    return [self.topViewController supportedInterfaceOrientations];
//}

//解决首页侧滑卡死问题
- (void)navigationController:(UINavigationController*)navigationController didShowViewController:(UIViewController*)viewController animated:(BOOL)animate{
    
    NSArray *ctrlArray = navigationController.viewControllers;
    if(ctrlArray.count > 1) {
        if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }else{
        
        if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}







@end





