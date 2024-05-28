//
//  CameraViewController.m
//  QBarSDKDemo
//
//  Copyright © 2021 tencent. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraCapture.h"
#import "QBarCodeKit.h"
#import "QBarResult.h"
#import "LineView2.h"
#import "TimeHandle.h"

#import <Photos/Photos.h>

#define SCAN_WIDTH  720
#define SCAN_HEIGHT 1280

/**
 TODO: Demo 代码仅展示接入集成示例，在接入时需客户侧完善优化
 */
@interface CameraViewController ()<CameraCaptureDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    int tmpImageCount;
    TimeHandle *timeHandle;
    CGFloat realityZoomFactor;
    BOOL isZooming;
    NSInteger _count;
}

@property (nonatomic, strong) CameraCapture* cameraCapture;

@property (strong, nonatomic) LineView2 *lineView;

@property (strong, nonatomic) UIButton *albumButton;
@end

@implementation CameraViewController

- (CameraCapture *)cameraCapture {
    if (!_cameraCapture) {
        //TODO: QBAR SDK SessionPreset值固定AVCaptureSessionPreset1280x720，设置其他参数会出现错误
        _cameraCapture = [[CameraCapture alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 Position:@"BACK"];
        _cameraCapture.delegate = self;
    }
    return _cameraCapture;
}

- (UIButton *)albumButton {
    if (!_albumButton) {
        _albumButton = [[UIButton alloc] init];
        [_albumButton setTitle:@"AlbumButton" forState:UIControlStateNormal];
        [_albumButton setBackgroundColor:[UIColor blackColor]];
        [_albumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _albumButton;
}

- (void)initLinView{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    float viewWidth = bounds.size.width;
    float viewHeight = bounds.size.height;
    float realWidth = 720;
    float realHeight = 1280;

    float sx = realWidth/viewWidth;
    float sy = realHeight/viewHeight;
    
    float s = sx < sy ? sx : sy;
    
    float newWidth = realWidth / s;
    float newHeight = realHeight / s;
    
    float topX = -(newWidth - viewWidth)/2.0;
    float topY = -(newHeight - viewHeight)/2.0;
    //lineview
    self.lineView = [[LineView2 alloc] initWithFrame:CGRectMake(topX, topY-64, newWidth, newHeight)];
    self.lineView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.lineView];

    CGRect rectBounds;
    rectBounds.origin.x = 0;
    rectBounds.origin.y = 0 / s;

    rectBounds.size.width =  viewWidth;
    rectBounds.size.height = viewHeight;

//    UIView *rectView = [[UIView alloc] initWithFrame:rectBounds];
//    [rectView setBackgroundColor:[UIColor clearColor]];
//    [rectView.layer setBorderWidth:1];
//    [rectView.layer setBorderColor:[[UIColor greenColor] CGColor]];
//    [self.view addSubview:rectView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"腾讯扫一扫";
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    float viewWidth = bounds.size.width;
    float viewHeight = bounds.size.height;

    AVCaptureVideoPreviewLayer* aVCaptureVideoPreviewLayer = [self.cameraCapture getAVCaptureVideoPreviewLayer];
    aVCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    aVCaptureVideoPreviewLayer.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    aVCaptureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;

    [self.cameraVIew.layer addSublayer:aVCaptureVideoPreviewLayer];

    [self initLinView];

    [self.albumButton addTarget:self action:@selector(albumButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];

    timeHandle = [[TimeHandle alloc] init];
    isZooming = NO;
    realityZoomFactor = 1.0;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.cameraCapture startCamera];
    [[QBarCodeKit sharedInstance] qBarDecodeResume];
}

- (void)albumButtonClickEvent:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.mediaTypes = @[@"public.image"];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate method
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *targetImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!targetImage) {
        NSLog(@"pick image nil");
        return;
    }
    // 压缩方法1，图片对象，压缩系数0-1。
    NSData *imgData = UIImageJPEGRepresentation(targetImage, 0.6);
    NSLog(@"dst size %lu", (unsigned long)[imgData length]);
    UIImage *imageNew1 = [UIImage imageWithData:imgData];
//    [self.qBarKitHandle qBarDecodeResume];
    [[QBarCodeKit sharedInstance] decodeImageWithQBar:imageNew1 resultHandler:^(NSArray * _Nonnull resultArr) {
        if (resultArr.count>0) {
            QBarResult *rst = resultArr[0];
            NSLog(@"result:%@",rst.data);
        }

    }];

}

- (void)feedbackSampleBufferRef:(CMSampleBufferRef)sampleBuffer {
    /**
    视频流数据解码
    sampleBuffer 桢数据
    */
    _count ++;
    if (_count >10) {
        
        _count = 0;
        [self.lineView Clear];
    }
    
    [[QBarCodeKit sharedInstance] qBarDecodingWithSampleBufferN:sampleBuffer withZoomInfo:^(float zoomFactor) {
        NSLog(@"zoomFactor:%f",zoomFactor);
        if (self->isZooming || zoomFactor > 6.0) {
            return;
        }
        if (zoomFactor < self->realityZoomFactor) {
            return;
        }
        [self startCaptchaTimerWithTime:zoomFactor];
        self->realityZoomFactor = zoomFactor;
    } resuldHandle:^(NSArray * _Nonnull resultArr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.lineView Clear];
                NSMutableString *tmpResult = [NSMutableString string];
                for (int i = 0; i < resultArr.count; ++i) {
                    id tmpObj = resultArr[i];
                    if ([tmpObj isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *tmpDic = tmpObj;
                        [tmpResult appendFormat:@"{%@}",[self convertToJsonData:tmpDic]];
                    } else if ([tmpObj isKindOfClass:[QBarResult class]]) {
                        QBarResult *tmpQbar = tmpObj;
                        [tmpResult appendFormat:@"{%@-%@-%@}",tmpQbar.charset,tmpQbar.typeName,tmpQbar.data];
                        [self.lineView addQBarResult:tmpQbar];
                    }
                }
                NSLog(@"init result%@",tmpResult);
            });
    }];
    //获取环境光感数据
//    [self setLightSwitch:sampleBuffer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.lineView setNeedsDisplay];
    });
    
}

- (void)setLightSwitch:(CMSampleBufferRef)sampleBuffer {
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];

    //TODO: 根据brightnessValue来判断是否开启闪光灯
//    NSLog(@"环境光感 ： %f",brightnessValue);
    //....
    //TODO: 开启与关闭闪光灯方法
    //主线程调用
    //[self.cameraCapture flashTurnONOrOFF];
}


-(void) startCaptchaTimerWithTime:(float)zoomFactor{
    NSLog(@"startCaptchaTimerWithTime current:%f  targetTime:%f",realityZoomFactor,zoomFactor);
    [timeHandle cancelTimer];
    [timeHandle initGCDWith:zoomFactor withValue:realityZoomFactor endCallback:^{
        self->isZooming = NO;
    } eachCallback:^(float tmpZoom) {
        NSError *error = nil;
        if(tmpZoom<1.0 || tmpZoom > 6.0) {
            return;
        }
        if ([self.cameraCapture.m_pCaptureDevice lockForConfiguration:&error] ) {
            self.cameraCapture.m_pCaptureDevice.videoZoomFactor = tmpZoom;
            [self.cameraCapture.m_pCaptureDevice unlockForConfiguration];
        }
    }];
}

- (NSString *)convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = nil;

    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;
}

/**
 * 界面销毁时主动是否资源
 */
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
    [[QBarCodeKit sharedInstance] releaseQBarSDK];
}
- (void)dealloc {
    NSLog(@"custom dealloc");
}
@end

