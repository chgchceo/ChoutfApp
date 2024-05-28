//
//  AppDelegate.m
//  ChoutfApp
//
//  Created by yuanbing bei on 2024/3/21.
//

#import "AppDelegate.h"
#import "MainTabBarViewController.h"
#import "HomeViewController.h"
#import "WKWebViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MainNavigationController.h"
#import <arpa/inet.h>
#import <resolv.h>
#import <ifaddrs.h>
#import <netdb.h>
#import "QBarCodeKit.h"
#import "XC_DeviceInfo.h"
  

static NSString* const SECRET_ID     = @"2384103880c22c4a90f4aa43792526f9";
static NSString* const SECRET_KEY    = @"b19c3c4c6c99c447571c383e03ebde02";
static NSString* const TEAM_ID       = @"Z5LSRCJ5UR";


@interface AppDelegate ()


@property(nonatomic,strong) MMDrawerController * drawerController;



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    //1、初始化控制器
//    UIViewController *centerVC = [[WKWebViewController alloc]init];
//    UIViewController *leftVC = [[HomeViewController alloc]init];
//
//    //2、初始化导航控制器
//    UINavigationController *centerNvaVC = [[UINavigationController alloc]initWithRootViewController:centerVC];
//    UINavigationController *leftNvaVC = [[UINavigationController alloc]initWithRootViewController:leftVC];
//   
//    //3、使用MMDrawerController
//    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerNvaVC leftDrawerViewController:leftNvaVC rightDrawerViewController:nil];
//    self.drawerController.view.backgroundColor = [UIColor whiteColor];
//    self.drawerController.centerViewController.view.backgroundColor = [UIColor whiteColor];
//    //4、设置打开/关闭抽屉的手势
//    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
//    self.drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
//    //5、设置左右两边抽屉显示的多少
//    self.drawerController.maximumLeftDrawerWidth = 300.0;
//    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    _window.rootViewController = self.drawerController;
//    _window.backgroundColor = [UIColor whiteColor];
//    [_window makeKeyWindow];


    WKWebViewController *webCtrl = [[WKWebViewController alloc] init];
    MainNavigationController *naviCtrl = [[MainNavigationController alloc] initWithRootViewController:webCtrl];
    
    _window.rootViewController = naviCtrl;
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyWindow];
    
     [self getNetworkIPAddressWithCompletionHandler:^(NSString *ipAddress, NSError *error) {
        
        
    }];
    [_window makeKeyAndVisible];
    [self registerAppId];

    
    NSLog(@"=====idfv=======%@",[XC_DeviceInfo idfvString]);
    
    return YES;
}
//腾讯扫码功能注册
- (void)registerAppId{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
//        @try {
//            
//            [[QBarCodeKit sharedInstance] initQBarCodeKit:SECRET_ID
//                                                secretKey:SECRET_KEY
//                                                   teamId:TEAM_ID
//                                              licensePath:@""
//                                             resultHandle:^(NSDictionary * _Nonnull resultDic) {
//                
//                NSLog(@"%@",resultDic);
//            }];
//        } @catch (NSException *exception) {
//            
//        } @finally {
//            
//        }
//       
    });
}


- (void)getNetworkIPAddressWithCompletionHandler:(void (^)(NSString *ipAddress, NSError *error))completionHandler {
    NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:ipURL
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                completionHandler(nil, error);
                return;
            }
              
            NSError *jsonError;
            NSDictionary *ipDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError || !ipDict || [ipDict[@"code"] integerValue] != 0) {
                completionHandler(nil, jsonError ? jsonError : [NSError errorWithDomain:@"com.yourdomain.app" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Failed to fetch IP address"}]);
                return;
            }
              
            NSString *ipStr = ipDict[@"data"][@"ip"];
            completionHandler(ipStr, nil);
        }
    ];
    [task resume];
}
  

@end
