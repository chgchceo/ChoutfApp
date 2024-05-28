//
//  CameraCapture.h
//  QBarSDKDemo
//
//  Copyright © 2021 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol CameraCaptureDelegate<NSObject>

- (void)feedbackSampleBufferRef: (CMSampleBufferRef) sampleBuffer;

@end

@interface CameraCapture : NSObject   <AVCaptureVideoDataOutputSampleBufferDelegate>


@property (weak, nonatomic) id<CameraCaptureDelegate> delegate;

@property (strong, nonatomic) AVCaptureDevice * m_pCaptureDevice;

//
-(AVCaptureVideoPreviewLayer*)getAVCaptureVideoPreviewLayer;

-(CGSize)getCameraSize;

- (id)initWithSessionPreset:(NSString*)sessionPreset Position:(NSString*)position;

- (void) startCamera;

- (void) stopCamera;

- (void)flashTurnONOrOFF;

- (bool)startFocus;
- (bool)forceFocus;
- (bool)lockFocus;

@end
