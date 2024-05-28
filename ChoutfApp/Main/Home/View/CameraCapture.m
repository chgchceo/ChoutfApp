//
//  CameraCapture.m
//  QBarSDKDemo
//
//  Copyright © 2021 tencent. All rights reserved.
//

#import "CameraCapture.h"

/**
 TODO: Demo 代码仅展示接入集成示例，在接入时需客户侧完善优化
 */
@interface CameraCapture (){
    // for capturing
    AVCaptureSession* m_pSession;
    
    AVCaptureVideoPreviewLayer* m_aVCaptureVideoPreviewLayer;
    
    NSString* m_sessionPreset;
    NSString* m_position;
}
@end

@implementation CameraCapture

@synthesize delegate;

- (id)initWithSessionPreset:(NSString*)sessionPreset Position:(NSString*)position
{
    self = [super init];
    
    if (self)
    {
        m_sessionPreset = sessionPreset;
        m_position = position;
        
        if (m_pSession == nil){

            m_pSession = [[AVCaptureSession alloc] init];
            [m_pSession beginConfiguration];
            
            if ([m_sessionPreset isEqualToString:@""] == YES || m_sessionPreset == nil) {
                m_sessionPreset = AVCaptureSessionPreset640x480;
            }
            
            if ([m_position isEqualToString:@""] == YES || m_position == nil) {
                m_position = @"BACK";
            }
            [m_pSession setSessionPreset:m_sessionPreset];
            
            if ([m_position isEqualToString:@"FRONT"] == YES) {
                _m_pCaptureDevice = [self frontCamera];
            } else {
                _m_pCaptureDevice = [self backCamera];
            }
            
            if (_m_pCaptureDevice == nil)
            {
                NSLog(@"Capture Device is not valid.");
                return nil;
            }
            
            NSError *error;
            //  Add the device to the session.
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_m_pCaptureDevice error:&error];
            if (error)
            {
                NSLog(@"Cannot initialize AVCaptureDeviceInput");
                assert(0);
            }
            
            [m_pSession addInput:input]; // After this point, captureSession captureOptions are filled.
            
            //  Create the output for the capture session.
            AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
            
            // Rather drop frames that work on old ones
            [videoOutput setAlwaysDiscardsLateVideoFrames:YES];
            
            // Use BGRA pixel format.
            [videoOutput setVideoSettings:[NSDictionary
                                           dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                           forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
            
            
            // Set dispatch to be on the main thread so OpenGL can do things with the data
            [videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
            
            [m_pSession addOutput:videoOutput];
            
            dispatch_queue_t queue = dispatch_queue_create("CameraCapture", NULL);
            [videoOutput setSampleBufferDelegate:
             (id<AVCaptureVideoDataOutputSampleBufferDelegate>)self
                                             queue: queue];
            //dispatch_release(queue);
        
            
            // Make sure the framerate is 30fps
            if ([_m_pCaptureDevice respondsToSelector:@selector(setActiveVideoMaxFrameDuration:)]
                && [_m_pCaptureDevice respondsToSelector:@selector(setActiveVideoMinFrameDuration:)])
            {
                if([_m_pCaptureDevice lockForConfiguration:&error])
                {
                    [_m_pCaptureDevice setActiveVideoMaxFrameDuration:CMTimeMake(1, 30)];
                    [_m_pCaptureDevice setActiveVideoMinFrameDuration:CMTimeMake(1, 30)];
                    [_m_pCaptureDevice unlockForConfiguration];
                }
            }
            else
            {
                NSLog(@"iOS 7 or higher is required. Camera not properly configured.");
                return nil;
            }
            
            [m_pSession commitConfiguration];
            
            //
            m_aVCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:m_pSession];
        }
    }
    
    return self;
}


- (void) startCamera
{
    if (m_pSession && [m_pSession isRunning])
        return;
    

        
    // Start streaming color images.
    [m_pSession startRunning];
    
//    [self forceFocus];
    [self startFocus];

}

- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)backCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            return device;
        }
    }
    return nil;
}

-(AVCaptureVideoPreviewLayer*)getAVCaptureVideoPreviewLayer
{
    return m_aVCaptureVideoPreviewLayer;
}

-(CGSize)getCameraSize
{
    return CGSizeMake((float)640.0, (float)480.0);
}

- (void) stopCamera
{
    if ([m_pSession isRunning])
    {
        [m_pSession stopRunning];
    }
}

-(void)dealloc
{
    m_pSession = nil;
    self.m_pCaptureDevice = nil;
}

- (bool)forceFocus
{
    AVCaptureDevice *videoDevice = self.m_pCaptureDevice;
    
    if (!videoDevice)
        return false;
    
    // Lock the camera Focus
    [videoDevice lockForConfiguration:nil];
    if([videoDevice isFocusPointOfInterestSupported])
    {
        CGPoint autofocusPoint = CGPointMake(230.0f, 320.0f);
        //[videoDevice setFocusMode:AVCaptureFocusModeLocked];
        [videoDevice setFocusPointOfInterest:autofocusPoint];
    }
    [videoDevice unlockForConfiguration];
    
    return true;
}

- (bool)forceFocus:(CGPoint)point
{
    AVCaptureDevice *videoDevice = self.m_pCaptureDevice;
    
    if (!videoDevice)
        return false;
    
    // Lock the camera Focus
    [videoDevice lockForConfiguration:nil];
    if([videoDevice isFocusPointOfInterestSupported])
    {
        //[videoDevice setFocusMode:AVCaptureFocusModeLocked];
        [videoDevice setFocusPointOfInterest:point];
    }
    [videoDevice unlockForConfiguration];
    
    return true;
}

- (bool)startFocus
{
    AVCaptureDevice *videoDevice = self.m_pCaptureDevice;
    
    if (!videoDevice)
        return false;

    
    // Added auto focus
    if ( [videoDevice lockForConfiguration:NULL] == YES )
    {
        if ([videoDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus] == YES) {
            [videoDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            
            double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
            
            if(version>=7.0f)
            {
                if ([videoDevice isSmoothAutoFocusSupported])
                {
                    [videoDevice setSmoothAutoFocusEnabled:YES];
                }
            }

        }
        
//        if ([videoDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
//            videoDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        if ([videoDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            videoDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        if ([videoDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance])
            videoDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
        
        [videoDevice setFocusPointOfInterest:CGPointMake(0.5, 0.5)];
        [videoDevice unlockForConfiguration];
    }

    
//    [self forceFocus];
    
    return true;
}

- (bool)lockFocus
{
    AVCaptureDevice *videoDevice = self.m_pCaptureDevice;
    
    if (!videoDevice)
        return false;
    
    // Lock the camera Focus
    [videoDevice lockForConfiguration:nil];
    if([videoDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
        [videoDevice setFocusMode:AVCaptureFocusModeLocked];
    [videoDevice unlockForConfiguration];
    
    return true;
}


- (void)flashTurnONOrOFF {
    AVCaptureDevice *device = self.m_pCaptureDevice;
    BOOL result = [self.m_pCaptureDevice hasTorch];// 判断设备是否有闪光灯
    if(!result) {
        NSLog(@"老铁，该换手机了~");
        return;
    }
    if(device.torchMode == AVCaptureTorchModeOn){ //已经打开闪光灯  需关闭
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];//关
        [self.m_pCaptureDevice unlockForConfiguration];
    } else {  //未打开闪光灯  需打开
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOn];//开
        [device unlockForConfiguration];
    }
}

#pragma mark - AVCapture callbacks


- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    //[m_pSensorController frameSyncNewColorBuffer:sampleBuffer];
    [delegate feedbackSampleBufferRef:sampleBuffer];
}

@end
