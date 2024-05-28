//
//  ScanQRCodeLoginViewController.m
//  LocalSpecialty
//
//  Created by YD on 2022/7/27.
//

#import "ScanQRCodeLoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRManager.h"
#import "MaskView.h"
#import "QRScanAnimationView.h"
#import <ImageIO/ImageIO.h>
#import "header.h"
@interface ScanQRCodeLoginViewController ()<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
{
    CGRect scan_frame_;
    QRManager * qr_scan_manager_; //扫码控制中心
    MaskView * qr_mask_view_;  //顶部蒙版视图
    QRScanAnimationView * qr_scan_animation_view_; //扫码动画视图
    
}
@property (nonatomic, assign) BOOL isAutoOpen;
@end

@implementation ScanQRCodeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor whiteColor];
    //首先创建限制区域的大小和frame，如果需要修改限制区域的位置，只需要修改此处的frame即可
    //条形码
//    qr_scan_animation_view_= [[QRScanAnimationView alloc]initWithFrame:                     CGRectMake(self.view.center.x-self.view.frame.size.height/4 + StatusBarHeight/2,                                    self.view.center.y-self.view.frame.size.height/4 - StatusBarHeight,                                    self.view.frame.size.height/2- StatusBarHeight,                                      (self.view.frame.size.height/2-StatusBarHeight)/2.0)];
    
    
    //二维码
    qr_scan_animation_view_= [[QRScanAnimationView alloc]initWithFrame:                     CGRectMake(self.view.center.x-self.view.frame.size.height/4 + StatusBarHeight/2,                                    self.view.center.y-self.view.frame.size.height/4 - StatusBarHeight,                                    self.view.frame.size.height/2- StatusBarHeight,                                      (self.view.frame.size.height/2-StatusBarHeight))];
    
    ///2.0
    [self.view addSubview:qr_scan_animation_view_];
    
    //这个是用来设置扫描区域的frame的，这个frame需要注意的是，必须是AVCaptureVideoPreviewLayer所在的layer上的frame，在当前软件中，因为顶部有一个topview，所以应该要在原有的self.view.center.y的基础上上移20+64个像素
    
    scan_frame_ = CGRectMake(qr_scan_animation_view_.frame.origin.x,
                             qr_scan_animation_view_.frame.origin.y,
                             qr_scan_animation_view_.bounds.size.width,
                             qr_scan_animation_view_.bounds.size.height) ;
    
    //创建蒙版的View
    qr_mask_view_=[[MaskView alloc]initMaskViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) withScanFrame:scan_frame_];
    
    [self.view addSubview:qr_mask_view_];
    
    
    //初始化二维码扫码功能模块单利
    qr_scan_manager_ = [QRManager sharedManager];
    //设置相关参数
    
    WEAK_SELF;
    [qr_scan_manager_ initQrManagerWithDelegateL:self finishInitBlock:^(BOOL finish, NSError *error) {
        if (finish) {
            
            [weakSelf scanSuccess];
        }else{
            
            [weakSelf scanFail:error];
        }
    } position:AVCaptureDevicePositionBack];
}

- (void)scanSuccess{
    
    //开启成功，开始设置扫码参数并开始进行扫码
    [self->qr_scan_manager_ setPreviewLayerWithSupview:self.view withViewFrame:self->scan_frame_];
}

- (void)scanFail:(NSError *)error{
    
    if (error == nil) {
        [self.navigationController popViewControllerAnimated:YES];
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
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startScanAnimation];
}
//开始扫描和动画
- (void)startScanAnimation{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //界面进入后需要开始进行扫码
        [self->qr_scan_manager_ startScan];
        //开启动画
        [self->qr_scan_animation_view_ startAnimation];
    });
}

//结束扫描和动画
- (void)stopScanAnimation{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //界面进入后需要开始进行扫码
        [self->qr_scan_manager_ stopScan];
        //开启动画
        [self->qr_scan_animation_view_ stopAnimation];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self stopScanAnimation];
    self.isAutoOpen = NO;
}
# pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject *object = [metadataObjects objectAtIndex:0];
        stringValue = [Utils getTextWithModelStr:object.stringValue];
        if (object == nil) {
            
            [Utils showMessage:@"不是二维码"];
            return;
        }
        
        if(self.block){
            
            self.block(stringValue);
            [self onlyBackButtonAction];
        }else{
            
            ScanORResultViewController *result = [[ScanORResultViewController alloc] init];
            result.content = stringValue;
            [self.navigationController pushViewController:result animated:YES];
            
        }
        
        
//        [self stopScanAnimation];
//        if ([object.type isEqualToString:AVMetadataObjectTypeQRCode]){
//            NSLog(@"得到的qr字符串为：%@",object.stringValue);
//            //二维码
//            [Utils showMessage:stringValue];
//
//        }else{//条形码
//
//            [Utils showMessage:stringValue];
//        }
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    // brightnessValue 值代表光线强度，值越小代表光线越暗(12至-5)
    if (brightnessValue <= -2.0 && !self.isAutoOpen) {
        self.isAutoOpen = YES;
        //        [self.torchBtn setSelected:YES];
        //        [self turnTorchOn:YES];
    }
}

// 打开/关闭手电筒
- (void)turnTorchOn:(BOOL)on{
//    if ([qr_scan_manager_.device hasTorch] && [qr_scan_manager_.device hasFlash]){
//
//        [qr_scan_manager_.device lockForConfiguration:nil];
//        if (on) {
//            [qr_scan_manager_.device setTorchMode:AVCaptureTorchModeOn];
//            [qr_scan_manager_.device setFlashMode:AVCaptureFlashModeOn];
//        } else {
//            [qr_scan_manager_.device setTorchMode:AVCaptureTorchModeOff];
//            [qr_scan_manager_.device setFlashMode:AVCaptureFlashModeOff];
//        }
//        [qr_scan_manager_.device unlockForConfiguration];
//    } else {
//        UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前设备没有闪光灯，不能提供手电筒功能" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [self dismissViewControllerAnimated:alertController completion:nil];
//        }];
//        [alertController addAction:cancelAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
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


@end
