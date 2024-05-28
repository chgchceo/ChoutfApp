/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <AudioToolbox/AudioToolbox.h>
#import "ZXingQRViewController.h"
#import "ZXCapture.h"
#import "header.h"

@interface ZXingQRViewController ()<ZXCaptureDelegate>

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, strong) IBOutlet UIView *scanView;
@property (nonatomic) BOOL isScanning;
@property (nonatomic) BOOL isFirstApplyOrientation;

@end

@implementation ZXingQRViewController {
    CGAffineTransform _captureSizeTransform;
}

#pragma mark - View Controller Methods

- (void)dealloc {
    [self.capture.layer removeFromSuperlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"zxing扫一扫";
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (_isFirstApplyOrientation) return;
    _isFirstApplyOrientation = TRUE;
    [self applyOrientation];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
        [self applyOrientation];
    }];
}

#pragma mark - Private
- (void)setup {
    self.capture = [[ZXCapture alloc] init];
    self.capture.sessionPreset = AVCaptureSessionPreset1920x1080;
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.delegate = self;
    
    self.isScanning = NO;
    self.capture.layer.frame = self.view.frame;
    [self.view.layer addSublayer:self.capture.layer];
    self.scanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view bringSubviewToFront:self.scanView];
    self.scanView.backgroundColor = [UIColor redColor];
    
//      [self.capture setLuminance: TRUE];
//      [self.capture.luminance setFrame: CGRectMake(150, 30, 100, 100)];
//      [self.view.layer addSublayer: self.capture.luminance];
//
//      [self.capture enableHeuristic];
}

- (void)applyOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    float scanRectRotation;
    float captureRotation;
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            captureRotation = 90;
            scanRectRotation = 180;
            break;
        case UIInterfaceOrientationLandscapeRight:
            captureRotation = 270;
            scanRectRotation = 0;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            captureRotation = 180;
            scanRectRotation = 270;
            break;
        default:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
    }
    
    [self applyRectOfInterest:orientation];
    
    CGFloat angleRadius = captureRotation / 180 * M_PI;
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleRadius);
    
    [self.capture setTransform:transform];
    [self.capture setRotation:scanRectRotation];
    self.capture.layer.frame = self.view.frame;
}

- (void)applyRectOfInterest:(UIInterfaceOrientation)orientation {
    CGRect transformedScanRect;
//    if (UIInterfaceOrientationIsLandscape(orientation)) {
//        transformedScanRect = CGRectMake(_scanView.frame.origin.y,
//                                         _scanView.frame.origin.x,
//                                         _scanView.frame.size.height,
//                                         _scanView.frame.size.width);
//    } else {
//        transformedScanRect = _scanView.frame;
//    }
//
//    CGRect metadataOutputRect = [(AVCaptureVideoPreviewLayer *) _capture.layer metadataOutputRectOfInterestForRect:transformedScanRect];
//    CGRect rectOfInterest = [_capture.output rectForMetadataOutputRectOfInterest:metadataOutputRect];
//    _capture.scanRect = rectOfInterest;
    _capture.scanRect = CGRectMake(0, 0, 0, 0);
}

#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureCameraIsReady:(ZXCapture *)capture {
    self.isScanning = YES;
}

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
   
    [self getCenterPoint:result.resultPoints];
    [Utils showMessage:result.text];
}

- (CGPoint)getCenterPoint:(NSArray *)points{
    
    CGPoint point = CGPointMake(0, 0);
    
    CGFloat X = 0;
    CGFloat Y = 0;
    if (points.count > 1) {
        
        ZXResultPoint *point1 = (ZXResultPoint*)points[0];
        ZXResultPoint *point2 = (ZXResultPoint*)points[1];
        
        NSLog(@"%@",point1);
        NSLog(@"%@",point2);
        Y = point1.y;
        X = point1.x + (point2.x-point1.x)/2.0;
    }
    X = X*(ScreenWidth/820.0);
    Y = Y*(ScreenHeight/1180.0);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    bgView.backgroundColor = [UIColor greenColor];
    
    
    if (X < ScreenWidth/5.0) {
        
        X = X -50*(ScreenWidth/820.0);
    }else if (X< ScreenWidth*2/5.0){
        
        X = X -80*(ScreenWidth/820.0);
    }else if (X< ScreenWidth*3/5.0){
        
        X = X -110*(ScreenWidth/820.0);
    }else if (X< ScreenWidth*4/5.0){
        
        X = X -130*(ScreenWidth/820.0);
    }else{
        
        X = X -150*(ScreenWidth/820.0);
    }
    
    CGFloat h = ScreenHeight-NaviBarHeight;
    
    if (Y < h/8.0) {
        
        Y = Y -200*(ScreenHeight/1180.0);
    }else if (Y < h*2/8.0) {
        
        Y = Y -220*(ScreenHeight/1180.0);
    }else if (Y < h*3/8.0) {
        
        Y = Y -250*(ScreenHeight/1180.0);
    }else if (Y < h*4/8.0) {
        
        Y = Y -280*(ScreenHeight/1180.0);
    }else if (Y < h*5/8.0) {
        
        Y = Y -320*(ScreenHeight/1180.0);
    }else if (Y < h*6/8.0) {
        
        Y = Y -360*(ScreenHeight/1180.0);
    }else if (Y < h*7/8.0) {
        
        Y = Y -400*(ScreenHeight/1180.0);
    }else{
        
        Y = Y -450*(ScreenHeight/1180.0);
    }
    bgView.center = CGPointMake(X, Y);
    [self.view addSubview:bgView];
    [bgView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
    
    return point;
}

@end


