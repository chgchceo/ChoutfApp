//
//  ScanQRCodeLoginViewController.m
//  LocalSpecialty
//
//  Created by YD on 2022/7/27.
//

#import "QRCodeViewController.h"
#import "QRManager.h"
#import <ImageIO/ImageIO.h>
#import "header.h"

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,BrightnessViewControllerDelegate>{
   
    QRManager * _manager; //扫码控制中心
    UIButton *_lightButt;
    NSInteger _num;
    
}

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"原生扫一扫";
    self.view.backgroundColor = [UIColor whiteColor];
    _num = 0;
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
    
    if ([_manager.device hasTorch]) {//设备有手电筒
        
        _lightButt = [UIButton buttonWithType:UIButtonTypeCustom];
        _lightButt.frame =CGRectMake((ScreenWidth-64)/2.0, ScreenHeight-260, 64, 64) ;
        [_lightButt setBackgroundImage:[UIImage imageNamed:@"shoudiantong_guan"] forState:UIControlStateNormal];
        [_lightButt setBackgroundImage:[UIImage imageNamed:@"shoudiantong_kai"] forState:UIControlStateSelected];
        [self.view addSubview:_lightButt];
        [_lightButt addTarget:self action:@selector(lightButtAc) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //按钮长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    //长按时间
    longPress.minimumPressDuration = 0.2;
    [_lightButt addGestureRecognizer:longPress];
    
}

- (void)longPress:(UILongPressGestureRecognizer *)press{
    
    BrightnessViewController *brightCtrl = [[BrightnessViewController alloc] init];
    brightCtrl.modalPresentationStyle = 5;
    brightCtrl.delegate = self;
    [self presentViewController:brightCtrl animated:NO completion:nil];
}

- (void)lightButtAc{
    
    _lightButt.selected = !_lightButt.selected;
    [_manager.device lockForConfiguration:nil];
    if (_lightButt.selected) {
        
        [_manager.device setTorchMode:AVCaptureTorchModeOn];
    }else{
        
        [_manager.device setTorchMode:AVCaptureTorchModeOff];
    }
    [_manager.device unlockForConfiguration];
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
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startScanAnimation];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
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
    [self stopScanAnimation];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
}

-(void)dealloc{
    NSLog(@"销毁控制器");
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (_num > 5) {
        
        _num = 0;
    }
    if (_num == 0) {
        
        if ([metadataObjects count] > 0){
            
            NSMutableArray *qrCodesArray = [NSMutableArray new];
            [metadataObjects enumerateObjectsUsingBlock:^(AVMetadataMachineReadableCodeObject *result, NSUInteger idx, BOOL *stop) {
                NSString *code = result.stringValue;
                NSLog(@"2222 扫描后的url是:%@",code);
                // 标注多个二维码
                [self makeFrameWithCodeObject:result Index:qrCodesArray.count];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }
    }
    _num ++;
}

//重新扫码
-(void)reScanBtnAction:(UIButton *)sender {
    [self startScanAnimation];
}

/*
 AVMetadataMachineReadableCodeObject，输出的点位坐标是其在原始数据流上的坐标，与屏幕视图坐标不一样，（坐标系，值都会有差别）
 将坐标值转为屏幕显示的图像视图（self.videoPreviewLayer）上的坐标值
 */
-(CGRect)makeFrameWithCodeObject:(AVMetadataMachineReadableCodeObject *)objc Index:(NSInteger)index
{
    //将二维码坐标转化为扫码控件输出视图上的坐标
    //     CGSize isize = CGSizeMake(720.0, 1280.0); // 尺寸可以考虑不要写死,当前设置的是captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    CGSize isize = self.view.frame.size; //扫码控件的输出尺寸，
    float Wout = 0.00;
    float Hout = 0.00;
    BOOL wMore = YES;
    /*取分辨率与输出的layer尺寸差，
     此处以AVLayerVideoGravityResizeAspectFill填充方式为例，判断扫描的范围更宽还是更长，并计算出超出部分的尺寸，后续计算减去这部分。
     如果是其它填充方式，计算方式不一样（比如AVLayerVideoGravityResizeAspect，则计算计算留白的尺寸，并后续补足这部分）
     */
    if (isize.width/isize.height > self.view.bounds.size.width/self.view.bounds.size.height) {
        //当更宽时，计算扫描的坐标x为0 的点比输出视图的0点差多少（输出视图为全屏时，即屏幕外有多少）
        wMore = YES;
        Wout = (isize.width/isize.height)* self.view.bounds.size.height;
        Wout = Wout - self.view.bounds.size.width;
        Wout = Wout/2;
    }else{
        // 当更长时，计算y轴超出多少。
        wMore = NO;
        Hout = (isize.height/isize.width)* self.view.bounds.size.width;
        Hout = Hout  - self.view.bounds.size.height;
        Hout = Hout/2;
    }
    
    CGPoint point1 = CGPointZero;
    CGPoint point2 = CGPointZero;
    CGPoint point3 = CGPointZero;
    CGPoint point4 = CGPointZero;
    /*
     源坐标系下frame和角点，都是比例值，即源视频流尺寸下的百分比值。
     例子：frame ：(x = 0.26720550656318665, y = 0.0014114481164142489), size = (width = 0.16406852006912231, height = 0.29584407806396484))
     objc.corners：{0.26823519751360592, 0.29203594744002659}
     {0.4312740177700658, 0.29725551905635411}
     {0.4294213439632073, 0.012761536345436197}
     {0.26720551457151021, 0.0014114481640513654}
     */
    CGRect frame = objc.bounds;//在源坐标系的frame，
    NSArray *array = objc.corners;//源坐标系下二维码的角点
    CGPoint P = frame.origin;
    CGSize S = frame.size;
    
    //获取点
    for (int n = 0; n< array.count; n++) {
        
        CGPoint point = CGPointZero;
        CFDictionaryRef dict = (__bridge CFDictionaryRef)(array[n]);
        CGPointMakeWithDictionaryRepresentation(dict, &point);
//        NSLog(@"二维码角点%@",NSStringFromCGPoint(point));
        //交换xy轴
        point.x = point.y +  point.x;
        point.y = point.x - point.y;
        point.x = point.x - point.y;
        //x轴反转
        point.x = (1-point.x);
        //point乘以比列。减去尺寸差，
        if (wMore) {
            point.x = (point.x * (isize.width/isize.height)* self.view.bounds.size.height) - Wout;
            point.y = self.view.bounds.size.height *(point.y);
        }else{
            point.x = self.view.bounds.size.width *(point.x);
            point.y = (point.y) * (isize.height/isize.width)* self.view.bounds.size.width - Hout;
        }
        if (n == 0) {
            point1 = point;
        }
        if (n == 1) {
            point2 = point;
        }
        if (n == 2) {
            point3 = point;
        }
        if (n == 3) {
            point4 = point;
        }
    }
    //通过获取最小和最大的X，Y值，二维码在视图上的frame（前面得到的点不一定是正方形的二维码，也可能是菱形的或者有一定旋转角度的）
    float minX = point1.x;
    minX = minX>point2.x?point2.x:minX;
    minX = minX>point3.x?point3.x:minX;
    minX = minX>point4.x?point4.x:minX;
    
    float minY = point1.y;
    minY = minY>point2.y?point2.y:minY;
    minY = minY>point3.y?point3.y:minY;
    minY = minY>point4.y?point4.y:minY;
    P.x = minX;
    P.y = minY;
    
    float maxX = point1.x;
    maxX = maxX<point2.x?point2.x:maxX;
    maxX = maxX<point3.x?point3.x:maxX;
    maxX = maxX<point4.x?point4.x:maxX;
    
    float maxY = point1.y;
    maxY = maxY<point2.y?point2.y:maxY;
    maxY = maxY<point3.y?point3.y:maxY;
    maxY = maxY<point4.y?point4.y:maxY;
    
    S.width = maxX - minX;
    S.height = maxY - minY;
    
    //y轴坐标方向调整
    CGRect QRFrame = CGRectMake(P.x , P.y  , S.width-50, S.height+50);
    
    UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];//多个二维码添加选择btn
    tempButton.backgroundColor = [UIColor greenColor];
    tempButton.frame = QRFrame;
    [self.view addSubview:tempButton];
    tempButton.tag = 1000 + index;
    [tempButton performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
    return QRFrame;
}


//更新手电筒的状态
- (void)upDateLightStatus{
    
    if (_manager.device.torchLevel > 0) {
        
        _lightButt.selected = YES;
    }else{
        
        _lightButt.selected = NO;
    }
}


@end
