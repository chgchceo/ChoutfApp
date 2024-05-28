//
//  HuaWeiQRViewController.m
//  ChoutfApp
//
//  Created by cheng on 2024/4/16.
//

#import "HuaWeiQRViewController.h"
#import "QRManager.h"
#import <ScanKitFrameWork/ScanKitFrameWork.h>
#import "header.h"
#import "LightView.h"
#import "QRGreenView.h"
#import <ImageIO/ImageIO.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreGraphics/CoreGraphics.h>

@interface HuaWeiQRViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,LightViewDelegate>{
   
    QRManager * _manager; //扫码控制中心
    LightView *_lightView;
    NSInteger _num;
    bool  _isSingleQR;
    UIView *_resultView;
    
    
}
@property (nonatomic, assign) BOOL isAutoOpen;
@end

@implementation HuaWeiQRViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"华为扫一扫";
    _isSingleQR = false;
    self.view.backgroundColor = [UIColor whiteColor];
    _num = 0;
    [self initView];
    
}

- (void)initView{
    
    //初始化二维码扫码功能模块单利
    _manager = [QRManager sharedManager];
    
    AVCaptureDevicePosition position = AVCaptureDevicePositionBack;
    WEAK_SELF;
    [_manager initQrManagerWithDelegateL:self finishInitBlock:^(BOOL finish, NSError *error) {
        if (finish) {
            
            [weakSelf scanSuccess];
        }else{
            
            [weakSelf scanFail:error];
        }
    } position:position];
    
    _lightView = [[[NSBundle mainBundle] loadNibNamed:@"LightView" owner:self options:nil] lastObject];
    _lightView.frame = CGRectMake(-100, 450, 450, 50);
    _lightView.frame = CGRectMake(-130, 450, 450, 50);
    _lightView.slider.value = 0;
    [self sliderValueChange:0];
    [self.view addSubview:_lightView];
    _lightView.delegate = self;
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 0.5);
    _lightView.transform = trans;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NaviBarHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIButton *butt = [UIButton buttonWithType:UIButtonTypeCustom];
    [butt setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    butt.frame = CGRectMake(15, StatusBarHeight, 40, NaviBarHeight-StatusBarHeight);
    [butt addTarget:self action:@selector(onlyBackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:butt];
}

- (void)sliderValueChange:(CGFloat)value{
    
    bool lightStatus = true;
    if (value <= 0) {
     
        lightStatus = false;
    }
    if ([_manager.device hasTorch]){//是否有手电筒

        [_manager.device lockForConfiguration:nil];
        if (lightStatus) {
            
            if (_manager.device.torchMode == AVCaptureTorchModeOff) {
                [_manager.device setTorchMode:AVCaptureTorchModeOn];
            }
            [_manager.device setTorchModeOnWithLevel:value error:nil];
        } else {
            [_manager.device setTorchMode:AVCaptureTorchModeOff];
        }
        
        [_manager.device unlockForConfiguration];
    } else {
        
        _lightView.hidden = true;//没有手电筒，隐藏滑动界面
    }
}

- (void)scanSuccess{
    
    //开启成功，开始设置扫码参数并开始进行扫码
    [self->_manager setPreviewLayerWithSupview:self.view withViewFrame:self.view.frame];
}

- (void)scanFail:(NSError *)error{
    
    if (error == nil) {
        
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
        NSString * qr_error_string_  =[NSString stringWithFormat:@"错误信息：%@",error];
        
        UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"扫描启动失败！" message:qr_error_string_ preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self onlyBackButtonAction];
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)onlyBackButtonAction{
    
    [self stopScanAnimation];
    self.isAutoOpen = NO;
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self startScanAnimation];
}

//开始扫描和动画
- (void)startScanAnimation{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //界面进入后需要开始进行扫码
        [self->_manager startScan];
    });
}

//结束扫描和动画
- (void)stopScanAnimation{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //界面进入后需要开始进行扫码
        [self->_manager stopScan];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    self.navigationController.navigationBarHidden = false;
    [self stopScanAnimation];
    self.isAutoOpen = NO;
}

// 打开/关闭手电筒
- (void)turnTorchOn:(BOOL)on{
    
    if ([_manager.device hasTorch] && [_manager.device hasFlash]){

        [_manager.device lockForConfiguration:nil];
        if (on) {
            [_manager.device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [_manager.device setTorchMode:AVCaptureTorchModeOff];
        }
        [_manager.device unlockForConfiguration];
    } else {
        UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前设备没有闪光灯，不能提供手电筒功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:alertController completion:nil];
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)tipAlter:(NSString *)masge{
    UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"扫码结果" message:masge preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //界面开始扫码
        [self startScanAnimation];
        [self dismissViewControllerAnimated:alertController completion:nil];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)loadData:(NSString *)ticket{
    [self showLoadingView:@""];
    
}

-(void)dealloc{
    NSLog(@"销毁控制器");
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    //次方法调用的太频繁，过滤掉一些,太频繁会出现错误的结果
     if (_num >= 8) {
         
         _num = 0;
     }
    
     if (_num == 0) {
         
         @autoreleasepool{
             
                 CFRetain(sampleBuffer);
             //这种识别方式只能中间部分识别，屏幕顶部和底部不能识别条形码
                NSArray *resultList = [HmsBitMap multiDecodeBitMapForSampleBuffer:sampleBuffer withOptions:nil];

                 if (resultList.count == 0){
                     CFRelease(sampleBuffer);
                     return;
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [self toastResultForList:resultList];
                 });
                 CFRelease(sampleBuffer);
                 NSLog(@"%@-----------",[NSData data]);
             }
     }
     _num ++;
 }

-(void)toastResultForList:(NSArray *)list{

    if (list.count == 0){

        return;
    }
    CGRect frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    for (int i=0; i<list.count; i++) {
        NSArray *pointList = [[list objectAtIndex:i] objectForKey:@"ResultPoint"];
        if(_resultView == nil){
            
            _resultView = [[UIView alloc] initWithFrame:frame];
            _resultView.backgroundColor = [UIColor clearColor];
            _resultView.userInteractionEnabled = NO;
            _resultView.transform = CGAffineTransformMakeRotation(M_PI_2);
            [self.view addSubview:_resultView];
        }

        NSString *text = [[list objectAtIndex:i] objectForKey:@"text"];
        
        QRGreenView *view = [[QRGreenView alloc] initWithFrame:frame];
        
        view.arr = pointList;
        [_resultView addSubview:view];
        [view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
        
        if ([Utils isCheckBarCodeStr:text]) {
            
            [self qrResult:text];
        }
    }
}

//处理扫描结果
- (void)qrResult:(NSString *)text{
    
}

@end
