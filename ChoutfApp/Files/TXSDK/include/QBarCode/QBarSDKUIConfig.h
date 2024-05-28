//
//  QBarSDKUIConfig.h
//  QBarCode
//
//  Created by v_clvchen on 2021/5/27.
//  Copyright © 2021 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,QBAR_READER_SDK) {
    SDK_ALL_READERS = 0,//下列所有码制
    SDK_ONED_BARCODE = 1,//一维码，包含UPC_A、UPC_E、EAN_8、EAN_13、CODE_39、CODE_93、CODE_128、ITF、CODABAR
    SDK_QRCODE = 2,//QRCODE二维码
    SDK_WXCODE = 3,//保留设置 不支持微信码
    SDK_PDF417 = 4,//PDF417码
    SDK_DATAMATRIX = 5,//DATAMATRIX 码
};

@interface QBarSDKUIConfig : NSObject

///导航栏是否隐藏
@property (nonatomic, assign) BOOL albumHidde;
///导航栏背景色
@property (strong, nonatomic) NSString *naviBarBgColor;

///导航栏背景色透明
@property (nonatomic, assign) BOOL naviBarBgClear;
///导航栏标题
@property (strong, nonatomic) NSString *naviBarTitle;
///导航栏标题颜色
@property (strong, nonatomic) NSString *naviBarTitleColor;
///提示语
@property (strong, nonatomic) NSString *scanTips;
///提示语文字颜色
@property (strong, nonatomic) NSString *scanTipsColor;
///是否隐藏状态栏 Tips 仅在UIViewControllerBasedStatusBarAppearance YES有效 流海屏无法隐藏状态栏，但隐藏导航栏时，状态栏一并隐藏
@property (nonatomic, assign) BOOL statusBarHidde;
/// 设置识别超时 单位帧数
@property (nonatomic, assign) long maxFrameTimeOut;
//输入码类型
@property (nonatomic, assign) QBAR_READER_SDK scanCodeType;
//同时识别多个码最大值
@property (nonatomic, assign) int maxCodeCount;
//是否上报异常日志 默认值YES
@property (nonatomic, assign) int isPostLog;
// 是否支持默认缩放
@property (nonatomic, assign) BOOL isAutoZoom;

@end

NS_ASSUME_NONNULL_END
