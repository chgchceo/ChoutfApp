////
////  MiddleViewController.m
////  ZDFProduct
////
////  Created by yuanbing bei on 2023/12/18.
////
//
//#import "MiddleViewController.h"
////#import "QRCodeMoreViewController.h"
//
//@interface MiddleViewController (){
//    
//    BOOL _isFirst;
//    
//}
//
//
//@end
//
//@implementation MiddleViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    _isFirst = true;
//    self.view.backgroundColor = [UIColor whiteColor];
//}
//
//- (void)viewDidAppear:(BOOL)animated{
//    
//    [super viewDidAppear:animated];
//    
//    
//}
//
//- (BOOL)shouldAutorotate {
//    
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//
//- (void)viewWillAppear:(BOOL)animated{
//    
//    [super viewWillAppear:animated];
//    
//    [self changeOrientation];
//    if(_isFirst){
////        QRCodeMoreViewController *vc = [[QRCodeMoreViewController alloc] init];
//////        vc.viewCtrl = self.viewCtrl;
////        vc.delegate = self;
////        [self.navigationController pushViewController:vc animated:NO];
//        _isFirst = false;
//    }else{
//       
//        [self.navigationController popViewControllerAnimated:NO];
//    }
//}
//
//
//- (void)changeOrientation{
//    
//    // AppDelegate设置横屏
//       AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//       // 当前是否横屏
//       if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationLandscapeLeft && [UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationLandscapeRight) {
//          
//           // 已经竖屏，AppDelegate中锁定为当前屏幕状态
////           app.orientations = (1 << [UIApplication sharedApplication].statusBarOrientation);
//           
//       } else {
//           // 横屏-强制屏幕竖屏
////           app.orientations = UIInterfaceOrientationMaskPortrait;
//           // 强制旋转
//           if (@available(iOS 16.0, *)) {
//   #if defined(__IPHONE_16_0)
//               // 避免没有更新Xcode14的同事报错
//               // iOS16新API，让控制器刷新方向，新方向为上面设置的orientations
//               [self setNeedsUpdateOfSupportedInterfaceOrientations];
//   #endif
//           } else {
//               // iOS16以下
//               NSNumber *orientationPortrait = [NSNumber numberWithInt:UIInterfaceOrientationMaskPortrait];
//               [[UIDevice currentDevice] setValue:orientationPortrait forKey:@"orientation"];
//           }
//       }
//}
//
////扫描结果
//- (void)mutableQrResult:(NSArray *_Nullable)array{
//    
//    if([_delegate respondsToSelector:@selector(mutableQrResult:)]){
//        
//        [_delegate mutableQrResult:array];
//    }
//}
//
//- (void)backOrientation{
//    
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//    // 当前是否横屏
//    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
//        // 已经横屏，AppDelegate中锁定为当前屏幕状态
////        app.orientations = (1 << [UIApplication sharedApplication].statusBarOrientation);
//    } else {
//        // 竖屏-强制屏幕横屏
//        // AppDelegate中锁定为横屏
////        app.orientations = UIInterfaceOrientationMaskLandscapeRight;
//        // 强制旋转
//        if (@available(iOS 16.0, *)) {
//#if defined(__IPHONE_16_0)
//            // 避免没有更新Xcode14的同事报错
//            // iOS16新API，让控制器刷新方向，新方向为上面设置的orientations
//            [self setNeedsUpdateOfSupportedInterfaceOrientations];
//#endif
//        } else {
//            // iOS16以下
//            NSNumber *orientationPortrait = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
//            [[UIDevice currentDevice] setValue:orientationPortrait forKey:@"orientation"];
//        }
//    }
//}
//
//
///*
// - (void)changeOrientation{
//     
//     // AppDelegate设置横屏
//        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//        // 当前是否横屏
//        if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationLandscapeLeft && [UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationLandscapeRight) {
//           
//            // 已经竖屏，AppDelegate中锁定为当前屏幕状态
//            app.orientations = (1 << [UIApplication sharedApplication].statusBarOrientation);
//            
//        } else {
//            // 横屏-强制屏幕竖屏
//            app.orientations = UIInterfaceOrientationMaskPortrait;
//            // 强制旋转
//            if (@available(iOS 16.0, *)) {
//    #if defined(__IPHONE_16_0)
//                // 避免没有更新Xcode14的同事报错
//                // iOS16新API，让控制器刷新方向，新方向为上面设置的orientations
//                [self setNeedsUpdateOfSupportedInterfaceOrientations];
//    #endif
//            } else {
//                // iOS16以下
//                NSNumber *orientationPortrait = [NSNumber numberWithInt:UIInterfaceOrientationMaskPortrait];
//                [[UIDevice currentDevice] setValue:orientationPortrait forKey:@"orientation"];
//            }
//        }
// }
//
// - (void)backOrientation{
//     
//     AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//     // 当前是否横屏
//     if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
//         // 已经横屏，AppDelegate中锁定为当前屏幕状态
//         app.orientations = (1 << [UIApplication sharedApplication].statusBarOrientation);
//     } else {
//         // 竖屏-强制屏幕横屏
//         // AppDelegate中锁定为横屏
//         app.orientations = UIInterfaceOrientationMaskLandscapeRight;
//         // 强制旋转
//         if (@available(iOS 16.0, *)) {
// #if defined(__IPHONE_16_0)
//             // 避免没有更新Xcode14的同事报错
//             // iOS16新API，让控制器刷新方向，新方向为上面设置的orientations
//             [self setNeedsUpdateOfSupportedInterfaceOrientations];
// #endif
//         } else {
//             // iOS16以下
//             NSNumber *orientationPortrait = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
//             [[UIDevice currentDevice] setValue:orientationPortrait forKey:@"orientation"];
//         }
//     }
// }
//*/
//@end
