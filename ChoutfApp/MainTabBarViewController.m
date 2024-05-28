//
//  MainTabBarViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/8/25.
//

#import "MainTabBarViewController.h"
#import "HomeViewController.h"
#import "MainNavigationController.h"
#import "ViewController.h"
#import "DiscoverViewController.h"
#import "CenterViewController.h"
#import "MineViewController.h"
#import "WKWebViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView{
    
    WKWebViewController *homeCtrl = [[WKWebViewController alloc] init];
    MineViewController *mineCtrl = [[MineViewController alloc] init];
    NSArray *arr = @[homeCtrl,mineCtrl];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSArray *titleArr = @[@"首页",@"我的"];
    NSArray *imageName = @[@"shouye",@"wode"];
    //152,35,26
    UIColor *color = [[UIColor alloc] initWithRed:152/255.0 green:35/255.0 blue:26/255.0 alpha:1];
    for (int i = 0; i < arr.count; i ++) {
        
        UIViewController *VC = arr[i];
        MainNavigationController *navc = [[MainNavigationController alloc] initWithRootViewController:VC];
        [data addObject:navc];
        navc.title = titleArr[i];
        NSDictionary *textTitleOptions = @{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:15]};
        NSDictionary *textTitleOptionsSelected = @{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont systemFontOfSize:15]};
        [navc.tabBarItem setTitleTextAttributes:textTitleOptions forState:UIControlStateNormal];
        [navc.tabBarItem setTitleTextAttributes:textTitleOptionsSelected forState:UIControlStateSelected];
        [navc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 1)]; //设置tabbar上的文字的位置
        NSString *name = imageName[i];
        
        navc.tabBarItem.selectedImage = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        navc.tabBarItem.image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        
    }
    
    self.viewControllers = data;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = color;
    self.tabBar.unselectedItemTintColor = [UIColor grayColor];
}




@end
