//
//  PrinterPdfViewController.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/11/27.
//

#import "BaseViewController.h"

#import "ScanQRCodeLoginViewController.h"
#import "BaseViewController.h"
#import "WKProcessPoolManager.h"
#import <CoreLocation/CLLocationManager.h>
#import "NSURLRequest+IgnoreSSL.h"
#import "SelPopViewController.h"
#import "AppUpdateAlertViewController.h"
#import "QRCodeViewController.h"
#import "MessageAlertViewController.h"
#import "MineViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrinterPdfViewController : BaseViewController{
    
    SelPopViewController *_popCtrl;
}



@property(nonatomic,copy)NSString *htmlStrl;



@end

NS_ASSUME_NONNULL_END
