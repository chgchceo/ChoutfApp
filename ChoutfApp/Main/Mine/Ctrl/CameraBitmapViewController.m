//
//
//  Copyright (c) Huawei Technologies Co., Ltd. 2020-2028. All rights reserved.
//

#import "CameraBitmapViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "header.h"
//#import <ScanKitFrameWork/ScanKitFrameWork.h>


@interface CameraBitmapViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>{
    AVCaptureDevice *captureDevice;
    
    AVCaptureVideoDataOutput *stillVideoDataOutput;
    AVCaptureConnection *videoConnect;
    UIImageView *_imgView;
    NSArray *resultList;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVidoPreviewLayer;
@end

@implementation CameraBitmapViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
//        [self.view makeToast:@"Please turn on camera permission in settings" duration:2.0 position:@"CSToastPositionCenter"];
    }else{
        [self avfoundationQRcode];
    }
    [self initUI];
    [self _creatBackButton];
}
-(void)initUI{
    
    [self _creatBackButton];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight-400, ScreenWidth, 400)];
    
    [self.view addSubview:_imgView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
//        [self.view makeToast:@"Please turn on camera permission in settings" duration:2.0 position:@"CSToastPositionCenter"];
    }else{
        if (!_captureSession.isRunning) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_captureSession startRunning];
            });
        }
    }
}

-(void)avfoundationQRcode{
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        [_captureSession setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionBack) {
            captureDevice = device;
        }
    }
    if (!captureDevice) {
//        [self.view makeToast:@"Rear camera unable to enable" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    if (captureDevice.isFocusPointOfInterestSupported &&[captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error = nil;
        [captureDevice lockForConfiguration:&error];
        [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [captureDevice unlockForConfiguration];
    }
    [captureDevice lockForConfiguration:nil];
    captureDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    BOOL exposureBool = [captureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure];
    if (exposureBool == NO) {
//        [self.view makeToast:@"The phone does not support exposure mode" duration:2.0 position:@"CSToastPositionCenter"];
    }
    
    NSError *error = nil;
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    stillVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    [stillVideoDataOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]}];
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [stillVideoDataOutput setSampleBufferDelegate:self queue:queue];
    [_captureSession addOutput:stillVideoDataOutput];
    
    videoConnect = [stillVideoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([videoConnect isVideoOrientationSupported]){
        [videoConnect setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    _captureVidoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    CALayer *layer = self.view.layer;
    layer.masksToBounds = YES;
    _captureVidoPreviewLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    _captureVidoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//AVLayerVideoGravityResizeAspect;
    _captureVidoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;//;
    [layer addSublayer:_captureVidoPreviewLayer];
}

-(void)setVideoFocus{
    NSError *error =nil;
    [captureDevice lockForConfiguration:&error];
    [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    [captureDevice unlockForConfiguration];
}

//- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
//    @autoreleasepool{
//        if(output == stillVideoDataOutput){
//            CFRetain(sampleBuffer);
////            resultList = [HmsBitMap multiDecodeBitMapForSampleBuffer:sampleBuffer withOptions:nil];
////            resultList = [HmsBitMap multiDecodeBitMapForSampleBuffer:sampleBuffer withOptions:[[HmsScanOptions alloc] initWithScanFormatType:ALL Photo:false]];
//            
////            UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
////            dispatch_async(dispatch_get_main_queue(), ^{
////
////                self->_imgView.image = image;
////
////            });
//            if (resultList.count == 0){
//                CFRelease(sampleBuffer);
//                return;
//            }
////            if (_captureSession.isRunning){
////                [_captureSession stopRunning];
////            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self toastResultForList:self->resultList];
//            });
//            CFRelease(sampleBuffer);
//        }
//    }
//}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{

    NSLog(@"imageFromSampleBuffer: called");
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);

    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);

    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);

    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);


    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];

    // Release the Quartz image
    CGImageRelease(quartzImage);

    return (image);
}

-(void)toastResultForList:(NSArray *)list{
//    [self.navigationController.view hideToastActivity];
    if (list.count == 0){
//        [self.view makeToast:@"Scanning code not recognized" duration:1.0 position:@"CSToastPositionCenter"];
        return;
    }
    for (int i=0; i<list.count; i++) {
        NSArray *pointList = [[list objectAtIndex:i] objectForKey:@"ResultPoint"];
        CGPoint point = [self getScanCenter:pointList];
        UIView *r_view = [[UIView alloc] init];
        r_view.frame = CGRectMake(point.x-20, point.y-20, 40, 40);
        r_view.backgroundColor = [UIColor greenColor];
        r_view.layer.cornerRadius = 20;
        r_view.layer.masksToBounds = YES;
        r_view.tag = i;
        [self.view addSubview:r_view];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
//        tap.numberOfTapsRequired = 1;
//        [r_view addGestureRecognizer:tap];
        
        [r_view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
    }
}

-(void)doTapChange:(UITapGestureRecognizer *)sender{
    NSString *textStr = [[resultList objectAtIndex:sender.view.tag] objectForKey:@"text"];
//    [Toast showSuccessWithMessage:textStr duration:3 finishHandler:^{
//
//    }];
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


-(void)backAction{
    if (_captureSession.isRunning){
        [_captureSession stopRunning];
    }
    _captureSession = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -backButton
-(void)_creatBackButton{
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 5+statusBarFrame.size.height, 50, 50);
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(backAction)
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"personal_back.png"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
    [self.view addSubview:button];
}

- (BOOL)isEmptyString:(NSString *)sourceStr {
    if (![sourceStr isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([sourceStr isEqual:@"null"]) {
        return YES;
    }
    if ([sourceStr isEqual:@"<null>"]) {
        return YES;
    }
    if ([sourceStr isEqual:@"(null)"]) {
        return YES;
    }
    if ([sourceStr isEqual:@""]) {
        return YES;
    }
    if (sourceStr == nil) {
        return YES;
    }
    if (sourceStr == NULL) {
        return YES;
    }
    if ((NSNull *)sourceStr == [NSNull null]) {
        return YES;
    }
    if (sourceStr.length == 0) {
        return YES;
    }
    return NO;
}

-(void)dealloc{
    [self.captureSession removeInput:self.captureDeviceInput];
    self.captureSession = nil;
    self.captureDeviceInput = nil;
    self->stillVideoDataOutput = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (BOOL)shouldAutorotate {
//    
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    
//    return UIInterfaceOrientationMaskPortrait;
//}
@end
