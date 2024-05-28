

//
//  QRCodeMoreViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/12/18.
//

#import "QRScanViewController.h"
#import "QRGreenView.h"
#import "header.h"


@interface QRScanViewController () < AVCaptureVideoDataOutputSampleBufferDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,AVCaptureMetadataOutputObjectsDelegate,BrightnessViewControllerDelegate>{
    
    BOOL _isSingleQR;//是否是单个扫描
    UITableView *_tableView;
    NSMutableArray *_resultArr;//多个扫描的结果
    NSMutableArray *_selArr;//选中的扫描结果
    AVCaptureDevice *_captureDevice;
    NSInteger _num;
    UIButton *_lightButt;
    
}

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, assign) CGFloat maxZoomFactor;


@end

@implementation QRScanViewController


- (void)viewDidLoad {
    
    self.title = @"华为扫码";//全屏效果
    [super viewDidLoad];
    _num = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    _resultArr = [[NSMutableArray alloc] init];
    _selArr = [[NSMutableArray alloc] init];
    _isSingleQR = false;
    [self initView];
    
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 340) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    if ([_captureDevice hasTorch]) {//设备有手电筒
        
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

    //添加原生扫码入口
    UIButton *rightButt = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButt.frame = CGRectMake(0, 0, 80, 30);
    [rightButt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButt setTitle:@"原生扫码" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButt];
    [rightButt addTarget:self action:@selector(rightButtAc) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)rightButtAc{
    
    QRCodeViewController *qrCtrl = [[QRCodeViewController alloc] init];
    [self.navigationController pushViewController:qrCtrl animated:YES];
}

- (void)longPress:(UILongPressGestureRecognizer *)press{
    
    BrightnessViewController *brightCtrl = [[BrightnessViewController alloc] init];
    brightCtrl.modalPresentationStyle = 5;
    brightCtrl.delegate = self;
    [self presentViewController:brightCtrl animated:NO completion:nil];
}

- (void)lightButtAc{
    
    _lightButt.selected = !_lightButt.selected;
    [_captureDevice lockForConfiguration:nil];
    if (_lightButt.selected) {
        
        [_captureDevice setTorchMode:AVCaptureTorchModeOn];
    }else{
        
        [_captureDevice setTorchMode:AVCaptureTorchModeOff];
    }
    [_captureDevice unlockForConfiguration];
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
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
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

        [_session
            setSessionPreset:AVCaptureSessionPreset1920x1080];
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
        [videoConnect setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
    
    //放大焦距
    [self setDeviceZoom:3];
    AVCaptureVideoPreviewLayer *_captureVidoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    CALayer *layer = self.view.layer;
    layer.masksToBounds = YES;
    _captureVidoPreviewLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    _captureVidoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [layer addSublayer:_captureVidoPreviewLayer];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //开始捕获
        [self.session startRunning];
    });
    
    // 获取最大焦距
    self.maxZoomFactor = _captureDevice.activeFormat.videoMaxZoomFactor;
    
    // 添加捏合手势
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.view addGestureRecognizer:pinchGesture];
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat newZoomFactor = _captureDevice.videoZoomFactor * recognizer.scale;
        newZoomFactor = MIN(newZoomFactor, self.maxZoomFactor);
        newZoomFactor = MAX(newZoomFactor, 1.0); // 最小焦距为1.0（无变焦）
          
        if ([_captureDevice lockForConfiguration:nil]) {
            _captureDevice.videoZoomFactor = newZoomFactor;
            [_captureDevice unlockForConfiguration];
        }
          
        // 重置手势的缩放因子，以便下次从1.0开始计算
        recognizer.scale = 1.0;
    }
}
- (void)setDeviceZoom:(NSInteger )value{
    
    [_captureDevice lockForConfiguration:nil];
    if (_captureDevice.activeFormat.videoMaxZoomFactor > value) {
        
        _captureDevice.videoZoomFactor = value;
        
    }else{
        
        _captureDevice.videoZoomFactor = _captureDevice.activeFormat.videoMaxZoomFactor;
    }
    [_captureDevice unlockForConfiguration];
    
}

//#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if (_num >= 10) {
        
        _num = 0;
    }
    if (_num == 0) {
        
        CFRetain(sampleBuffer);
        CGImageRef img = [self imageFromSampleBuffer:sampleBuffer];
        img = CGImageRotateAndAddPadding(img,-90,0);
        
        CFRelease(sampleBuffer);
        
        UIImage *image = [UIImage imageWithCGImage:img];
        
        NSArray *resultList = [HmsBitMap multiDecodeBitMapForImage:image withOptions:nil];
        
        CGImageRelease(img);
        
        if (resultList.count == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self->_lightButt.hidden = NO;
            });
            
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_lightButt.hidden = YES;
            [self toastResultForList:resultList];
        });
    }
    _num ++;
}

-(void)toastResultForList:(NSArray *)list{
    
    if (list.count == 0){
        
        return;
    }
    for (int i=0; i<list.count; i++) {
        NSArray *pointList = [[list objectAtIndex:i] objectForKey:@"ResultPoint"];
        
        NSString *text = [[list objectAtIndex:i] objectForKey:@"text"];
        QRGreenView *view = [[QRGreenView alloc] initWithFrame:self.view.bounds];
        view.isSignle = true;
        view.arr = pointList;
        [self.view addSubview:view];
        [view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
        
        if ([Utils isCheckBarCodeStr:text]) {
            
            [self qrResult:text];
        }
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

- (void)dealloc {
    
    NSLog(@"QrCodeReader - dealloc");
    // 将引用置空
    [self.session stopRunning];
    self.session = nil;
    self.videoDataOutput = nil;
}

- (void)onlyBackButtonAction{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"back" forKey:@"backHome"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    // 创建一个设备发现会话，用于发现视频设备
    for ( AVCaptureDevice *device in devices )
    {
        if ( device.position == position ){
            
            return device;
        }
    }
    
    return nil;
}

-(CGImageRef )imageFromSampleBuffer:(CMSampleBufferRef ) sampleBuffer{
    
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
    return  cgImage;
}

CGImageRef CGImageRotateAndAddPadding(CGImageRef imageRef, CGFloat degrees, CGFloat padding) {
    // 获取原始图像的尺寸
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    
    // 计算旋转后的新尺寸（考虑到90度旋转时宽度和高度会交换）
    CGFloat newWidth, newHeight;
    if (fabs(degrees) == 90.0 || fabs(degrees) == 270.0) {
        newWidth = imageSize.height + 2 * padding;
        newHeight = imageSize.width + 2 * padding;
    } else {
        newWidth = imageSize.width + 2 * padding;
        newHeight = imageSize.height + 2 * padding;
    }
    
    // 创建颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 计算每行所需的字节数（假设每个像素4字节，即RGBA格式）
    size_t bytesPerRow = newWidth * 4;
    
    // 创建新的图像上下文
    CGContextRef context = CGBitmapContextCreate(NULL, newWidth, newHeight, 8, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    // 确保上下文创建成功
    if (!context) {
        CGColorSpaceRelease(colorSpace);
        return nil;
    }
    
    // 清除上下文为透明背景
    CGContextClearRect(context, CGRectMake(0, 0, newWidth, newHeight));
    
    // 将上下文原点移动到中心，以准备旋转
    CGContextTranslateCTM(context, newWidth / 2.0, newHeight / 2.0);
    
    // 旋转上下文
    CGAffineTransform transform = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    CGContextConcatCTM(context, transform);
    
    // 计算绘制图像的位置，考虑旋转和边距
    CGRect drawRect = CGRectMake(-imageSize.width / 2.0, -imageSize.height / 2.0, imageSize.width, imageSize.height);
    
    // 绘制旋转的图像到新的上下文
    CGContextDrawImage(context, drawRect, imageRef);
    
    // 从上下文中获取新的图像
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    
    // 释放资源
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return newImageRef;
}

// 将角度转换为弧度
CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

- (void)showAlertView{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无权限访问相机"
                                                                             message:@"是否前往设置打开相机权限"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        // 用户点击了取消按钮，这里可以添加取消操作的代码
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        // 用户点击了确定按钮，这里可以添加打开相机权限的代码
        // 例如，可以跳转到应用的设置页面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
            
        }];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    // 显示警告视图控制器
    [self presentViewController:alertController animated:YES completion:nil];
}


//更新手电筒的状态
- (void)upDateLightStatus{
    
    if (_captureDevice.torchLevel > 0) {
        
        _lightButt.selected = YES;
    }else{
        
        _lightButt.selected = NO;
    }
}

@end


