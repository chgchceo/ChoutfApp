//
//  QBarViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/11/23.
//

#import "QBarViewController.h"
//#import "QBarCodeKit.h"
//#import "QBarResult.h"

static NSString* const SECRET_ID     = @"e8d9fb4c0980bcc240701bc0558dcc8c";
static NSString* const SECRET_KEY    = @"810c034d1f4ef6470dcf8bda432bde54";


@interface QBarViewController ()

@end

@implementation QBarViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.title = @"扫描条形码";
//    self.view.backgroundColor = [UIColor clearColor];
//    QBarSDKUIConfig *config = [[QBarSDKUIConfig alloc] init];
//    config.scanTips = @"扫描条形码";
//    config.naviBarBgColor = @"0x000000";
//    config.maxCodeCount = 3;
//    [[QBarCodeKit sharedInstance] setViewConfig:config];
//    NSLog(@"version：%@",[[QBarCodeKit sharedInstance] getVersion]);
//    
//    [self initView];
//}
//
//- (void)initView{
//    
//    [[QBarCodeKit sharedInstance] initQBarCodeKit:SECRET_ID
//                                        secretKey:SECRET_KEY teamId:@"287ZL65P9C"
//                                     resultHandle:^(NSDictionary * _Nonnull resultDic) {
//        
//        if([resultDic isKindOfClass:[NSDictionary class]]){
//            
//            NSString *errormsg = [Utils getTextWithModelStr:[resultDic objectForKey:@"errormsg"]];
//            
//            if([errormsg isEqualToString:@"SUCCESS"]){
//                
//                [self start];
//            }else{
//                
//                [Utils showMessage:errormsg];
//                [self closeView];
//            }
//            
//        }else{
//            
//            [Utils showMessage:@"认证失败"];
//            [self closeView];
//        }
//    }];
//}
//
//
//- (void)start{
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[QBarCodeKit sharedInstance] startDefaultQBarScan:self withResult:^(NSArray * _Nonnull resultArr) {
//            
//              NSMutableString *tmpResult = [NSMutableString string];
//              NSInteger count = resultArr.count;
//      //        if(count > 1){
//      //            count = 1;
//      //        }
//              for (int i = 0; i < count; ++i) {
//                  id tmpObj = resultArr[i];
//                  if ([tmpObj isKindOfClass:[NSDictionary class]]) {
//                      
//                  } else if ([tmpObj isKindOfClass:[QBarResult class]]) {
//                      QBarResult *tmpQbar = tmpObj;
//                      NSString *result = [Utils getTextWithModelStr:tmpQbar.data];
//                      [Utils showMessage:result];
//                      
//                  }
//              }
//              NSLog(@"init result%@",tmpResult);
//              
//              [self closeView];
//            
//        }];
//
//    });
//        
//}
//
//- (void)closeView{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}



@end
