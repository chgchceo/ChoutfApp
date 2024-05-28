//
//  QBarCodeKit.h
//  QBarCode
//
//  Copyright © 2020 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CMSampleBuffer.h>
#import <UIKit/UIKit.h>
#import "QBarSDKUIConfig.h"

NS_ASSUME_NONNULL_BEGIN

/**
 对外客户接口类
 */
@interface QBarCodeKit : NSObject

typedef void (^QBarResultCodeContent)(NSArray * _Nonnull resultArr);

/*!
 获取sdk 实例对象
 */
+ (instancetype) sharedInstance;

/*!
 设置UI，部分ui自定义设置
 
 @param sdkUIConfig sdk UI自定义属性
 */
-(void) setViewConfig:(QBarSDKUIConfig *)sdkUIConfig;

/*!
获取sdk 版本号
*/
- (NSString *) getVersion;

/*!
 清理持有资源，在使用完时调用
 */
- (void) releaseQBarSDK;


/*!
 视频流数据解码
@param sampleBuffer camera 桢数据
@param resultCallback 结果回调  tips:非主线程
 */
- (void) qBarDecodingWithSampleBuffer:(CMSampleBufferRef)sampleBuffer resuldHandle:(QBarResultCodeContent)resultCallback DEPRECATED_MSG_ATTRIBUTE("Please use [qBarDecodingWithSampleBufferN]");

/*!
 视频流数据解码
@param sampleBuffer camera 桢数据
@param zoomInfoCallback 拉近数据
@param resultCallback 结果回调  tips:非主线程
 */
- (void) qBarDecodingWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
                         withZoomInfo:(void(^)(float zoomFactor))zoomInfoCallback
                         resuldHandle:(QBarResultCodeContent)resultCallback DEPRECATED_MSG_ATTRIBUTE("Please use [qBarDecodingWithSampleBufferN]");

- (void) qBarDecodingWithSampleBufferN:(CMSampleBufferRef)sampleBuffer
                         withZoomInfo:(void(^)(float zoomFactor))zoomInfoCallback
                         resuldHandle:(QBarResultCodeContent)resultCallback;

/*!
 图片解码
@param image 输入图片
@param resultCallback 结果回调 主线程
 */
- (void) decodeImageWithQBar:(UIImage *)image resultHandler:(QBarResultCodeContent)resultCallback;

/*!
设置sdk秘钥

@param secretId  secretId
@param secretkey secretKey
@param teamId development teamId
@param resultCallback  鉴权结果回调
*/
- (void) initQBarCodeKit:(NSString *)secretId
               secretKey:(NSString *)secretkey
                  teamId:(NSString *)teamId
            resultHandle:(void(^)(NSDictionary *))resultCallback;

/*!
离线授权文件方式设置sdk秘钥

@param secretId  secretId
@param secretkey secretKey
@param teamId development teamId
@param resultCallback  鉴权结果回调
*/
- (void) initQBarCodeKit:(NSString *)secretId
               secretKey:(NSString *)secretkey
                  teamId:(NSString *)teamId
             licensePath:(NSString *)licensePath
            resultHandle:(void(^)(NSDictionary *))resultCallback;

/*!
 开启扫码页面
 
 @param vc 开始跳转的ViewController
 */
-(void)startDefaultQBarScan:(UIViewController *)vc withResult:(QBarResultCodeContent)resultDict;

/*!
 在必要时后停止相机桢译码
*/
-(void)qBarDecodeStop;

/*！
 恢复相机桢译码
 */
-(void)qBarDecodeResume;

/*！
 重置视频流识别引擎
 */
-(void)reset;
@end

NS_ASSUME_NONNULL_END
