//
//  QRManager.h
//  LocalSpecialty
//
//  Created by YD on 2022/7/27.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


//返回类型的block
typedef void(^finishBlock)(BOOL finish,NSError * _Nullable error);

@interface QRManager : NSObject
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic,strong) AVCaptureDevice *device;


+ (instancetype)sharedManager;
/**
 初始化扫码Manange

 @param delegate 代理
 @param block 返回Block
 */
- (void)initQrManagerWithDelegateL:(id)delegate
                   finishInitBlock:(finishBlock)block position:(AVCaptureDevicePosition)position;


/**
 设置扫码区域的相关参数

 @param supView 父视图
 @param viewFrame 扫码区域的大小
 */
- (void)setPreviewLayerWithSupview:(UIView *)supView
                     withViewFrame:(CGRect)viewFrame;

//开始扫描
- (void)startScan;

//停止扫描
- (void)stopScan;


@end

NS_ASSUME_NONNULL_END
