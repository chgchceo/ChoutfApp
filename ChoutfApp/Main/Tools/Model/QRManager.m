//
//  QRManager.m
//  LocalSpecialty
//
//  Created by YD on 2022/7/27.
//

#import "QRManager.h"
#import "header.h"

@implementation QRManager

+ (instancetype)sharedManager {
    static QRManager *_sharedQRManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedQRManager = [[QRManager alloc] init];
    });
    return _sharedQRManager;
}


/**
 初始化扫码Manange
 
 @param delegate 代理
 @param block 返回Block
 */
- (void)initQrManagerWithDelegateL:(id)delegate
                   finishInitBlock:(finishBlock)block position:(AVCaptureDevicePosition)position{
   
    NSString *mediaType = AVMediaTypeVideo;

            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];

            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
  
                UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请在iPhone的“设置”-“隐私”-“相机”功能中，找到App打开相机访问权限" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    block(NO,nil);
                }];
                
                [alertController addAction:confirmAction];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [[self findVisibleViewController] dismissViewControllerAnimated:alertController completion:nil];
                    block(NO,nil);
                }];
                [alertController addAction:cancelAction];
                [[self findVisibleViewController] presentViewController:alertController animated:YES completion:nil];
                return;
            }
    //创建上下文启动器
    _session = [[AVCaptureSession alloc] init];
    /*AVCaptureSessionPreset640x480就够使用，但是如果要保证较小的二维码图片能快速扫描，最好设置高些，如AVCaptureSessionPreset1920x1080(就是我们常说的1080p).*/
    _session.sessionPreset = AVCaptureSessionPreset1920x1080;
    
//    AVCaptureSessionPreset1920x1080;
    //设置Device
//    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //AVCaptureDeviceTypeBuiltInWideAngleCamera
    self.device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:position];//AVMediaTypeVideo
//    self.device.position = AVCaptureDevicePositionFront;
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (deviceInput) {
        //理论上这里应该添加一个判断看看能不能添加input
        if ([_session canAddInput:deviceInput]) {
            [_session addInput:deviceInput];
        }else{
            NSLog(@"不能添加input");
        }
        //创建一个输出类型
        self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        if ([_session canAddOutput:self.metadataOutput]) {
            // 这行代码要在设置 metadataObjectTypes 前
            [_session addOutput:self.metadataOutput];
            // 设置了识别类型为QRCode，枚举还有其他乐行可以进一步添加
            //AVMetadataObjectTypeQRCode,
            
            if(position == AVCaptureDevicePositionFront){
                
                self.metadataOutput.metadataObjectTypes = @[];
                
            }else{
                
                self.metadataOutput.metadataObjectTypes = @[
                    AVMetadataObjectTypeEAN13Code,
                    AVMetadataObjectTypeEAN8Code,
                    AVMetadataObjectTypeCode128Code
                ];
                
            }
            //设置代理，扫描结果将会利用代理返回
            [self.metadataOutput setMetadataObjectsDelegate:delegate queue:dispatch_get_main_queue()];
            AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
               [output setSampleBufferDelegate:delegate queue:dispatch_get_main_queue()];
            if ([self.session canAddOutput:output]) {
                    [self.session addOutput:output];
                }
        }else{
            NSLog(@"不能添加Output");
        }
        
        //放大焦距
            NSError *error = nil;
            [self.device lockForConfiguration:&error];
            if (self.device.activeFormat.videoMaxZoomFactor > 2) {

                self.device.videoZoomFactor = 3;

            }else{

                self.device.videoZoomFactor = self.device.activeFormat.videoMaxZoomFactor;
            }

            [self.device unlockForConfiguration];
            
        //设置成功了返回YES
        block(YES,nil);
        
    }else{
        NSLog(@"%@", error);
        //失败，打印Error
        block(NO,error);
    }
}
/**
 设置扫码区域的相关参数
 
 @param supView 父视图
 @param viewFrame 扫码区域的大小
 */
- (void)setPreviewLayerWithSupview:(UIView *)supView
                     withViewFrame:(CGRect)viewFrame
{
    //设置扫码区域
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //默认的是全部的界面，这样整个背景都是摄像头信息
    previewLayer.frame = CGRectMake(0, 0, supView.frame.size.width, supView.frame.size.height);
//    previewLayer.frame = viewFrame;
    [supView.layer insertSublayer:previewLayer atIndex:0];
    
    //重点1：采集到的摄像头很多情况是顺时针旋转90度的，造成这个的原因可能是AVFoundation本身的原因，需要进行下面步骤的修正：
    //1、获取到AVCaptureVideoPreviewLayer的方向并进行修正
    AVCaptureConnection *previewLayerConnection=previewLayer.connection;
    //2、判断并修正
    if ([previewLayerConnection isVideoOrientationSupported])
    {
        [previewLayerConnection setVideoOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    }
    // 经实践发现  (0,0,,1,1)这个写法有点坑   实际为(y,x,h,w)  即坐标y,x  尺寸高,宽(h,w)*/
    self.metadataOutput.rectOfInterest = CGRectMake(viewFrame.origin.y/ScreenHeight,viewFrame.origin.x/ScreenWidth,   viewFrame.size.height/ScreenHeight,viewFrame.size.width/ScreenWidth);
    
//    NSLog(@"%@",self.metadataOutput.rectOfInterest);
    //重点2：全屏幕扫码不是我们需要想要的功能，我们需要限制扫码的范围就要使用rectOfInterest。
    //然而这个属性的frame是一个比例系数，范围是[0,1];很多人采用试的方式是不合理的，利用metadataOutputRectOfInterestForRect方法可以成功的将AVCaptureVideoPreviewLayer所在的父视图中的Frame转换成对应的rectOfInterest的frame。

    //1、将传进来的需要限制区域的viewFrame转换成AVCaptureVideoPreviewLayer需要的Frame
//    CGRect intertRect = [previewLayer metadataOutputRectOfInterestForRect:viewFrame];

//    CGRect layerRect = [previewLayer rectForMetadataOutputRectOfInterest:intertRect];

//    NSLog(@"%@,  %@",NSStringFromCGRect(intertRect),NSStringFromCGRect(layerRect));
    //2、设置限定区域
    
//    if (ISIpad){
//        
////        self.metadataOutput.rectOfInterest = CGRectMake(viewFrame.origin.x/ScreenWidth, viewFrame.origin.y/ScreenHeight, viewFrame.size.width/ScreenWidth, viewFrame.size.height/ScreenHeight);
//    }else{
//        
////        self.metadataOutput.rectOfInterest = CGRectMake(viewFrame.origin.y/ScreenHeight,viewFrame.origin.x/ScreenWidth,viewFrame.size.height/ScreenHeight , viewFrame.size.width/ScreenWidth);
//    }
    
    /*大致意思是设置每一帧画面感兴趣的区域     也就是扫描范围的设置  默认为左上角  (0,0,1,1)这是默认值  全屏的 最大为1
     
     经实践发现  (0,0,,1,1)这个写法有点坑   实际为(y,x,h,w)  即坐标y,x  尺寸高,宽(h,w)*/
    
    
//    CGSize size = supView.bounds.size;
//    CGRect cropRect = viewFrame;
//    CGFloat p1 = size.height/size.width;
//    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
//    if (p1 < p2) {
//      CGFloat fixHeight = supView.bounds.size.width * 1920. / 1080.;
//      CGFloat fixPadding = (fixHeight - size.height)/2;
//        self.metadataOutput.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
//                                              cropRect.origin.x/size.width,
//                                              cropRect.size.height/fixHeight,
//                                              cropRect.size.width/size.width);
//    } else {
//        CGFloat fixWidth = supView.bounds.size.height * 1080. / 1920.;
//        CGFloat fixPadding = (fixWidth - size.width)/2;
//        self.metadataOutput.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
//                                              (cropRect.origin.x + fixPadding)/fixWidth,
//                                              cropRect.size.height/size.height,
//                                              cropRect.size.width/fixWidth);
//    }
}

- (void)startScan
{
    [self.session startRunning];
}

- (void)stopScan
{
    [self.session stopRunning];
}

- (UIViewController *)findVisibleViewController {
    UIViewController* currentViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    return currentViewController;
}
@end
