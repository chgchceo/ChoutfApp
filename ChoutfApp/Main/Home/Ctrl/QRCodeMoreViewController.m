////
////  QRCodeMoreViewController.m
////  ZDFProduct
////
////  Created by yuanbing bei on 2023/12/18.
////
//
#import "QRCodeMoreViewController.h"
#import "LightView.h"
#import "QRGreenView.h"
#import "header.h"
#import <AVFoundation/AVFoundation.h>
#import <ScanKitFrameWork/ScanKitFrameWork.h>


@interface QRCodeMoreViewController () < AVCaptureVideoDataOutputSampleBufferDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,LightViewDelegate>{
    
    UIButton *_changeButt;//切换扫描状态，单个/多个
    BOOL _isSingleQR;//是否是单个扫描
    UIView *_rightView;//右侧单边多个扫描结果展示视图
    UITableView *_tableView;
    NSMutableArray *_resultArr;//多个扫描的结果
    NSMutableArray *_selArr;//选中的扫描结果
    UIView *bgView;
    UIView *_resultView;
    AVCaptureDevice *_captureDevice;
    LightView *_lightView;
    UIButton *_changeVideoButt;//前后摄像头切换
    bool _isFirst;
    NSInteger _num;
    
}

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;

@end

@implementation QRCodeMoreViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    
    _num = 0;
    self.view.backgroundColor = [UIColor blackColor];
    _resultArr = [[NSMutableArray alloc] init];
    _selArr = [[NSMutableArray alloc] init];
    _isSingleQR = false;
    [self initView];

}

//判断是否有前后2个摄像头
- (BOOL)isHasFrontAndBack{
    
    bool isFront = false;
    bool isBack = false;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices ){
        
        if ( device.position == AVCaptureDevicePositionBack )
        {
            isBack = true;
        }else if (device.position == AVCaptureDevicePositionFront){
            
            isFront = true;
        }
    }
    
    return (isFront && isBack);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1){//确定
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)showAlertView{
    
    //无权限访问相机
    [[[UIAlertView alloc] initWithTitle:@"无权限访问相机" message:@"是否前往设置打开相机权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
}

- (void)initView{
    
    for (UIView *sView in self.view.subviews) {
        
        [sView removeFromSuperview];
    }
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusRestricted) {

        [self loadScanView];

    } else if (status == AVAuthorizationStatusNotDetermined) {

        // 请求使用相机权限
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {

            if (granted) {

                dispatch_async(dispatch_get_main_queue(), ^{

                    [self initView];

                });
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAlertView];

                });
                
            }
        }];
    } else {
        
        [self showAlertView];
    }
    CGFloat width = ScreenWidth;
    CGFloat height = ScreenHeight;
    //旋转视图，保持横屏状态
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    
    //连续扫描
    _changeButt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_changeButt setTitle:@"单个扫描" forState:UIControlStateNormal];

    _changeButt.frame = CGRectMake(width-120, 20, 100, 40);
    _changeButt.backgroundColor = [UIColor grayColor];
//    [bgView addSubview:_changeButt];
    _changeButt.layer.cornerRadius = 20;
    _changeButt.layer.masksToBounds = true;
    [_changeButt addTarget:self action:@selector(changeButtAc) forControlEvents:UIControlEventTouchUpInside];
    _changeButt.backgroundColor = [UIColor grayColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, StatusBarHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    _rightView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, width, 200)];

    _rightView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_rightView];
//    _rightView.hidden = YES;
    
//    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, width)];
//    leftView.backgroundColor = [UIColor blackColor];
//    [bgView addSubview:leftView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20+100, 10, 200, 40)];
    titleLab.text = @"扫描结果：";
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [UIFont systemFontOfSize:30];
    [_rightView addSubview:titleLab];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, width, 200-60) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_rightView addSubview:_tableView];
    
    UIButton *butt = [UIButton buttonWithType:UIButtonTypeCustom];
    [butt setTitle:@"确定" forState:UIControlStateNormal];
    butt.frame = CGRectMake(width-100, 10, 80, 40);
    butt.layer.cornerRadius = 20;
    [butt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    butt.layer.masksToBounds = true;
    [_rightView addSubview:butt];
    butt.backgroundColor = [UIColor colorWithRed:123/255.0 green:48/255.0 blue:53/255.0 alpha:1];
    [butt addTarget:self action:@selector(doneButtAc) forControlEvents:UIControlEventTouchUpInside];
    
    //取消
    UIButton *cancelButt = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButt setTitle:@"返回" forState:UIControlStateNormal];
    [bgView addSubview:cancelButt];
    cancelButt.frame = CGRectMake(30, StatusBarHeight+10, 80, 40);
    cancelButt.layer.cornerRadius = 20;
    cancelButt.layer.masksToBounds = YES;
    cancelButt.backgroundColor = [UIColor grayColor];
    [cancelButt addTarget:self action:@selector(cancelButtAc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgView];
//    bgView.transform = CGAffineTransformMakeRotation(M_PI_2);
//    bgView.transform = CGAffineTransformTranslate(bgView.transform, 0, height-width);
    
    _lightView = [[[NSBundle mainBundle] loadNibNamed:@"LightView" owner:self options:nil] lastObject];
    _lightView.frame = CGRectMake(-100, 450, 350, 50);
    _lightView.slider.value = 0.5;
    [self cameraBackgroundDidChangeISO:0.5];
    [bgView addSubview:_lightView];
    _lightView.delegate = self;
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 0.5);
    _lightView.transform = trans;
    
    if ([self isHasFrontAndBack]) {
        
        _changeVideoButt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgView addSubview:_changeVideoButt];
        _changeVideoButt.frame = CGRectMake(50, width-100, 50, 50);
        [_changeVideoButt setBackgroundImage:[UIImage imageNamed:@"changeBack"] forState:UIControlStateNormal];
        [_changeVideoButt addTarget:self action:@selector(changeVideoButtAc) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)changeVideoButtAc{
    
    [self swapFrontAndBackCameras];
}

- (void)sliderValueChange:(CGFloat)value{
    
//    NSError *error = nil;
//    [_captureDevice lockForConfiguration:&error];
//    _captureDevice.videoZoomFactor = value*10+1;
//    [_captureDevice unlockForConfiguration];
    [self cameraBackgroundDidChangeISO:value];
}

//取消
- (void)cancelButtAc{
    
    [self onlyBackButtonAction];
}

//确定
- (void)doneButtAc{
    
    [self onlyBackButtonAction];
    if([_delegate respondsToSelector:@selector(mutableQrResult:)]){
        
        [_delegate mutableQrResult:_selArr];
    }
}

- (void)changeButtAc{
    
    _isSingleQR = !_isSingleQR;
    
    if(_isSingleQR){
        
        [_changeButt setTitle:@"单个扫描" forState:UIControlStateNormal];
    }else{
       
        [_changeButt setTitle:@"连续扫描" forState:UIControlStateNormal];
    }
    
    _rightView.hidden = _isSingleQR;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _resultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSString *text = _resultArr[indexPath.row];
    cell.textLabel.text = text;
    
    if([_selArr containsObject:text]){
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *text = _resultArr[indexPath.row];
    if([_selArr containsObject:text]){
        
        [_selArr removeObject:text];
        
    }else{
        
        [_selArr addObject:text];
    }
    
    [_tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (void)loadScanView {
    
    _session = [[AVCaptureSession alloc] init];
    if ([_session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        [_session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (!_captureDevice) {

        return;
    }
    
    if (_captureDevice.isFocusPointOfInterestSupported &&[_captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error = nil;
        [_captureDevice lockForConfiguration:&error];
        [_captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        _captureDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        [_captureDevice unlockForConfiguration];
    }

    NSError *error = nil;
    AVCaptureDeviceInput *_captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:_captureDevice error:&error];
    if ([_session canAddInput:_captureDeviceInput]) {
        [_session addInput:_captureDeviceInput];
    }
    _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    [_videoDataOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]}];
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [_videoDataOutput setSampleBufferDelegate:self queue:queue];
    [_session addOutput:_videoDataOutput];
    
    AVCaptureConnection *videoConnect = [_videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([videoConnect isVideoOrientationSupported]){
        [videoConnect setVideoOrientation:AVCaptureVideoOrientationPortrait];
        [videoConnect setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
    AVCaptureVideoPreviewLayer *_captureVidoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    CALayer *layer = self.view.layer;
    layer.masksToBounds = YES;
    _captureVidoPreviewLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    _captureVidoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//AVLayerVideoGravityResizeAspect;
    [layer addSublayer:_captureVidoPreviewLayer];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            //开始捕获
            [self.session startRunning];
    });
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
// 获取到光线的强弱值
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

    
   //次方法调用的太频繁，过滤掉一些,太频繁会出现错误的结果
    if (_num >= 2) {
        
        _num = 0;
    }
    if (_num == 0) {
        
        @autoreleasepool{
            if(output == self.videoDataOutput){
                CFRetain(sampleBuffer);
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
    }
    
    _num ++;
    
}

-(void)toastResultForList:(NSArray *)list{

    if (list.count == 0){

        return;
    }
    for (int i=0; i<list.count; i++) {
        NSArray *pointList = [[list objectAtIndex:i] objectForKey:@"ResultPoint"];
        if(_resultView == nil){
            
            _resultView = [[UIView alloc] initWithFrame:bgView.bounds];
            _resultView.backgroundColor = [UIColor clearColor];
            _resultView.userInteractionEnabled = NO;
            _resultView.transform = CGAffineTransformMakeRotation(M_PI_2);
            [self.view addSubview:_resultView];
        }

        NSString *text = [[list objectAtIndex:i] objectForKey:@"text"];
        
        QRGreenView *view = [[QRGreenView alloc] initWithFrame:bgView.bounds];
        
        view.arr = pointList;
        [_resultView addSubview:view];
        [view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
        
        if ([Utils isCheckBarCodeStr:text]) {
            
            [self qrResult:text];
        }
//        if(text.length > 8 && text.length <= 13){
//            
//            //过滤掉纯数字类型
//            if(![Utils isPureNum:text]){
//                
//                [self qrResult:text];
//            }
//        }
    }
}

//处理扫描结果
- (void)qrResult:(NSString *)text{
    
    if(_isSingleQR){//单个扫描
        
        [self onlyBackButtonAction];
        if([self->_delegate respondsToSelector:@selector(mutableQrResult:)]){
            
            [self->_delegate mutableQrResult:@[text]];
        }
        
    }else{//连续扫描
        
        if(![_resultArr containsObject:text]){
            
            [_resultArr addObject:text];
            [_selArr addObject:text];
            [_tableView reloadData];
        }
    }
}

-(CGPoint)getScanCenter:(NSArray *)list{
    float posXEnd = 0;
    float posYEnd = 0;
    for (int i=0; i<list.count; i++) {
        float pos_X = [[[list objectAtIndex:i] objectForKey:@"posX"] floatValue];
        posXEnd = posXEnd + pos_X;
        float pos_Y = [[[list objectAtIndex:i] objectForKey:@"posY"] floatValue];
        posYEnd = posYEnd + pos_Y;
    }
    float scan_x = posXEnd/4;
    float scan_y = posYEnd/4;
    CGPoint point = CGPointMake(scan_x, scan_y);
    return point;
}

- (void)dealloc {

    NSLog(@"QrCodeReader - dealloc");

    // 将引用置空
    [self.session stopRunning];
    self.session = nil;
    self.layer = nil;
    self.videoDataOutput = nil;
}

- (BOOL)shouldAutorotate {

    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {

    return UIInterfaceOrientationMaskPortrait;
}

- (void)onlyBackButtonAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 调节ISO，光感度 0.0-1.0
- (void)cameraBackgroundDidChangeISO:(CGFloat)iso {
    
    NSError *error;
    if ([_captureDevice lockForConfiguration:&error]) {
        CGFloat minISO = _captureDevice.activeFormat.minISO;
        CGFloat maxISO = _captureDevice.activeFormat.maxISO;
        CGFloat currentISO = (maxISO - minISO) * iso + minISO;
        [_captureDevice setExposureModeCustomWithDuration:AVCaptureExposureDurationCurrent ISO:currentISO completionHandler:nil];
        [_captureDevice unlockForConfiguration];
    }else{
        // Handle the error appropriately.
    }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
    {
        if ( device.position == position ){
            
            return device;
        }
    }
        
    return nil;
}
 
- (void)swapFrontAndBackCameras {
 
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
 
            if (position == AVCaptureDevicePositionFront){
                
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            }else{
                
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            }
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
 
            [self.session beginConfiguration];
            [self.session removeInput:input];
            [self.session addInput:newInput];
 
            [self.session commitConfiguration];
            break;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = false;
}

-(UIImage *)imageFromSampleBuffer:(CMSampleBufferRef ) sampleBuffer{
   
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
      
    // 获取像素缓冲区的宽度和高度
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
      
    // 获取像素缓冲区的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
      
    // 创建 CGDataProvider
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, width * height * 4, NULL);
      
    // 创建 CGColorSpace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
      
    // 创建 CGImage
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, width * 4, colorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big, provider, NULL, false, kCGRenderingIntentDefault);
      
    // 解锁像素缓冲区
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
      
    // 创建 UIImage
    UIImage *image = [UIImage imageWithCGImage:cgImage];
      
    // 释放资源
    CGImageRelease(cgImage);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
      
    return image;
}

@end
