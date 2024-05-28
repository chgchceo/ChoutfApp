//
//  WKWebViewController.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/8/25.
//

#import "BaseViewController.h"
#import <CoreLocation/CLLocationManager.h>
#import "MineViewController.h"
#import "PingHost.h"
#import "header.h"
#import "QRCodeMoreViewController.h"
#import "QRCodeViewController.h"
#import "HomeViewController.h"
#import "CameraViewController.h"
#import "QBarCodeKit.h"
#import "ZXingQRViewController.h"
#import "QRScanViewController.h"
#import "HuaWeiQRViewController.h"
#import "LeftItemView.h"
#import "AboutUsViewController.h"
#import "PingHostViewController.h"
#import "HistoryVersionViewController.h"
#import "LogMessageViewController.h"
#import "FeedBackViewController.h"
#import "AllFunctionsViewController.h"


NS_ASSUME_NONNULL_BEGIN


@interface WKWebViewController : BaseViewController<UIAlertViewDelegate,WKUIDelegate,WKNavigationDelegate>{
    
}

//h5链接地址
@property(nonatomic,copy)NSString *htmlStrl;
//页面标题
@property(nonatomic,copy)NSString *titleStr;




@end

NS_ASSUME_NONNULL_END
