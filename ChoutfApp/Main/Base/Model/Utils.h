//
//  Utils.h
//
//
//  Created by chgch on 17/6/22.
//  Copyright © 2017年 chgch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/SDWebImage.h>
#import <WebKit/WebKit.h>
#import "DBManager.h"

typedef NS_ENUM(NSUInteger, GradientType) {// 渐变方向
    GradientTypeTopToBottom      = 0,//从上到下
    GradientTypeLeftToRight      = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};





typedef NS_ENUM(NSUInteger,webviewLoadingStatus) {
 
    WebViewNormalStatus = 0, //正常
 
    WebViewErrorStatus, //白屏
 
    WebViewPendStatus, //待决
};

typedef void(^logoutBlock)(void);

@interface Utils : NSObject{
    
    
}

//--------------------------------------------------------------------------------
//
// Description  - 基础数据请求
// Para         - 1.(NSArray) colors，请求地址
//              - 2.(GradientType) gradientType, 渐变方向
//              - 3.(CGSize) imgSize,区域大小
//
// Return       - UIColor
// Author       - Barney
//
//+ (UIColor *)gradientColorImageFromColors:(NSArray*)colors
//                             gradientType:(GradientType)gradientType
//                                  imgSize:(CGSize)imgSize;


/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *_Nullable)label WithSpace:(float)space;


//验证条形码是否是公司的条码类型
+(BOOL)isCheckBarCodeStr:(NSString *_Nullable)str;


// 获取当前设备可用内存 ROM
+(NSString*_Nullable) freeDiskSpaceInBytes;

// 获取当前设备总内存 ROM
+(NSString*_Nullable)getTotalMemorySize;

#pragma mark - 压缩图片
+ (UIImage *_Nullable)compressOriginalImage:(UIImage *_Nullable)image toMaxDataSizeKBytes:(CGFloat)size;

//给button添加默认的渐变背景颜色
+ (void)setButtColor:(UIButton *_Nullable)butt withFrame:(CGRect)frame;

//给视图添加放大后缩小动画
+(void)buttonClick:(UIView *_Nullable)bgView;

//富文本,字体的颜色
+(void)setLabel:(UILabel *_Nullable)lab withPartStr:(NSString *_Nullable)part withContent:(NSString *_Nullable)content withColor:(UIColor *_Nullable)color;

// 判断WKWebView是否白屏
+ (void)judgeLoadingStatus:(WKWebView *_Nullable)webview  withBlock:(void (^_Nullable)(webviewLoadingStatus status))completionBlock;

//json转数组
+ (NSArray *_Nullable)stringToJSON:(NSString *_Nullable)jsonStr;

//数组转json字符串
+ (NSString *_Nullable)changeArrtoJson:(NSArray *_Nullable)array;

//去掉<null>
+ (NSString *_Nullable)getTextWithModelStr:(NSString *_Nullable)str;


//界面弹框
+ (void)showMessage:(NSString *_Nullable)meg;
//中文验证
+ (BOOL)isChinese:(NSString*_Nullable)str;

//获取当前时间字符串格式
+ (NSString *_Nullable)getNowTimeStr;

//获取当前的时分
+ (NSString *)getNowTimeHourAndM;

//为UIImageView添加一个设置gif图内容的方法：
+(void)yh_setImage:(NSURL *_Nullable)imageUrl withImgView:(UIImageView *_Nullable)imgView;

//去掉float后多余的0,必须是小数，   1000 -> 1不能用此方法
+ (NSString *_Nullable)changeFloat:(NSString *_Nullable)stringFloat;


//对数量进行处理超过1万的用 w表示
+ (NSString *)changeNum:(NSString *_Nonnull)str;

//判断是否全是空格zhengs
+ (BOOL)isEmpty:(NSString *_Nullable) str;

//手机号验证
+(BOOL)isMobilePhone:(NSString *_Nullable)phoneNum;

//验证身份证
+ (BOOL)checkIDCard:(NSString *_Nullable)str;
//删除临时文件
+(void)removeTempVideoData:(NSString *_Nullable)path;
//获取话题的数组
+(NSArray *_Nullable)getTopicWithStr:(NSString *_Nullable)str;

//获取两个日期之间的天数
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *_Nullable)fromDate toDate:(NSDate *_Nullable)toDate;
//获取当前时间戳  （以毫秒为单位）
+(NSString *_Nullable)getNowTimeTimestamp;
//获取视频的时长
+ (CGFloat)getTimeFromVideoPath:(NSString *_Nullable)filePath;
//修改图片的尺寸
+ (UIImage *_Nullable)reSizeImage:(UIImage *_Nullable)image toSize:(CGSize)reSize;

// 获取网络视频第一帧
+ (UIImage*_Nullable)getVideoPreViewImage:(NSURL *_Nullable)path;
//对视频进行压缩
+ (void)videoCompressWithSourceURL:(NSURL*_Nullable)sourceURL completion:(void(^_Nullable)(int statusCode, NSString *_Nullable outputVideoURL))completion;

//获取运行内存
+ (void)getRamMemory;

//获取网络状态
+(BOOL)getNetState;


//缩图
+ (UIImage *_Nullable)image:(UIImage *_Nullable)image centerInSize: (CGSize)viewsize;

//图片转base64
+ (NSString *_Nullable)changeImageToStr:(UIImage *_Nullable)image;

//根据url或本地链接获取图片，可设置加载失败后的默认图片
+(void)setImageWith:(NSString *_Nullable)str withImgView:(UIImageView *_Nullable)imgView placeholderImag:(NSString *_Nullable)imageName;

// 字典转json字符串方法
+ (NSString *_Nullable)convertToJsonData:(NSDictionary *_Nullable)dict;

//字符串转字典
+ (NSDictionary *_Nullable)changeStrToDic:(NSString *_Nullable)str;

//根据链接获取图片
+(UIImage *_Nullable)getImageWith:(NSString *_Nullable)str;

//判断是否为浮点型：
+ (BOOL)isPureFloat:(NSString *_Nullable)string;

//判断是否为整型：
+ (BOOL)isPureInt:(NSString*_Nullable)string;


//判断是否为数据（包括整型和浮点型）
+ (BOOL)isPureNum:(NSString*_Nullable)string;

//时间格式转换
+ (NSString *_Nullable)changeTimeStr:(NSString *_Nullable)timeStr;

//设置行间距
+(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *_Nullable)text inLabel:(UILabel *_Nullable)label;

//获取几月几日
+ (NSString *_Nullable)getSimpleTimeStr:(NSString *_Nullable)timeStr;

//身份证号码验证
+ (BOOL)cly_verifyIDCardString:(NSString *_Nullable)idCardString;

//html转富文本
+ (NSMutableAttributedString *_Nullable)getAttributedStringByHTMLString:(NSString *_Nullable)htmlString
                                                    imageWidth:(CGFloat)imageWidth
                                                  textAligment:(NSTextAlignment)textAligment
                                                 lineBreakMode:(NSLineBreakMode)lineBreakMode
                                                   lineSpacing:(CGFloat)lineSpacing
                                                                   font:(UIFont *_Nullable)font
                                                         color:(nullable UIColor *)color;

//时间转日期
+(NSDate *_Nullable)nsstringCoNSDate:(NSString *_Nullable)dateStr;


//html高度计算
+(CGFloat)getHtmlHeight:(NSString *_Nullable)htmlStr withWidht:(CGFloat)width;

//字符串转时间
+(NSDate *_Nullable)nsstringConversionNSDate:(NSString *_Nullable)dateStr;

//日期转字符串
+ (NSString *_Nullable)changeDateToStr:(NSDate *_Nullable)date;

//日期转字符串包括时分秒
+ (NSString *_Nullable)changeDateToAllStr:(NSDate *_Nullable)date;

//转换时区8小时
+(NSDate *_Nullable)getNowDateFromatAnDate:(NSDate *_Nullable)anyDate;

//字符串转md5
+ (NSString *_Nullable)md5String:(NSString *_Nullable)str;


//将时间戳转换成时间
+ (NSString *_Nullable)getTimeFromTimestamp:(NSString *_Nullable)tamp;

//字符串转化成时间戳
+(NSString *_Nullable)stringToTime:(NSString *_Nullable)timeStr;

//银行卡号验证
+ (BOOL)isBankCardNumber:(NSString *_Nullable)cardNum;

//显示时分秒
+ (NSString *_Nullable)changeDetailTimeStr:(NSString *_Nullable)timeStr;

//不显示秒
+ (NSString *_Nullable)changeOtherDetailTimeStr:(NSString *_Nullable)timeStr;


//过滤表情
+ (NSString *_Nullable)filterEmoji:(NSString *_Nullable)string;


//获取身份证号里的性别
+(NSString *_Nullable)getIdentityCardSex:(NSString *_Nullable)numberStr;


//转换日期格式 将年月日转换成2019-01-23
+ (NSString *_Nullable)changeDateStr:(NSString *_Nullable)DateStr;

//获取今天日期
+ (NSString *_Nullable)getNowDateStr;


//获取今天日期,2010-02
+ (NSString *_Nullable)getNowDateYearAndMonthStr;


//添加顶部试图
+ (void)createNavigationBgView:(UIView *_Nullable)supView;

//根据图片logo和url删除二维码
+ (UIImage *_Nullable)getQRCodeImg:(NSString *_Nullable)urlString iamgeName:(NSString *_Nullable)imageName;

//根据内容生成二维码
+ (UIImage *_Nullable)getQRCodeImg:(NSString *_Nullable)str;

//数字加1
+ (NSString *_Nullable)numAddOne:(NSString *_Nullable)str;

//数字减1
+ (NSString *_Nullable)numReduceOne:(NSString *_Nullable)str;


//富文本,字体的颜色和大小
+(void)setLabel:(UILabel *_Nullable)lab withPartStr:(NSString *_Nullable)part withContent:(NSString *_Nullable)content withColor:(UIColor *_Nullable)color withFont:(UIFont *_Nullable)font;

//首页欢迎语
+ (void)showWelComeMeg:(UIView *_Nullable)sView;

//视图生成image
+ (UIImage *_Nullable)makeImageWithView:(UIView *_Nullable)view withSize:(CGSize)size;

//获取手机号尾号
+ (NSString *_Nullable)getPhonePartStr:(NSString *_Nullable)phone;

//富文本,字体的颜色
+(void)setLabel:(UILabel *_Nullable)lab withPartStr:(NSString *_Nullable)part1 withPartStr:(NSString *_Nullable)part2 withContent:(NSString *_Nullable)content withColor:(UIColor *_Nullable)color;



// 64base字符串转图片
+ (UIImage *_Nullable)stringToImage:(NSString *_Nullable)str;

// 图片转64base字符串
+ (NSString *_Nullable)imageToString:(UIImage *_Nullable)image;

//获取图片的格式
+ (NSString *_Nullable)imageFormatFromImageData:(NSData *_Nullable)imageData;

//获取文件的md5值
+(NSString*_Nullable)getFileMD5WithPath:(NSString*_Nullable)path;

//获取图片的md5
+ (NSString *_Nullable)getMd5WithImage:(UIImage *_Nullable)image;

//获取网络视频的宽高
+ (CGSize)getSizeWithVideoUrl:(NSString *_Nullable)url;

//去掉字符串首尾空格和换行的方法
+ (NSString *_Nullable)getSimpleString:(NSString *_Nullable)str;

//IM即时通讯登录
+ (void)loginIM;

// 后续优化，先直接新增一个同样的方法
+ (void)loginIM:(logoutBlock _Nullable )block;

//IM即时通讯退去登录
+ (void)logOutIM:(logoutBlock _Nullable )block;

// app 退出登录
+ (void)logoutApp:(logoutBlock _Nonnull )block;

//是否登录
+ (BOOL)isLoginIn;



//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getLabelHeightWithText:(NSString *_Nullable)text width:(CGFloat)width font: (CGFloat)font;

//获取带token的h5路径
+ (NSString *_Nullable)getHtmlStr:(NSString *_Nullable)str;

//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithText:(NSString *_Nullable)text height:(CGFloat)height font:(CGFloat)font;




//获取跳转控制器
+ (UIViewController *_Nullable)findVisibleViewController;

//获取手机机型
+ (NSString *_Nullable)getDeviceModelName;

//获取手机系统版本号村
+(NSString *_Nullable)getSystemVersion;
//感谢信
+(void)getThankLetter;


//存储日志信息
+ (void)saveLogMessage:(NSString *_Nullable)date withTitle:(NSString *_Nonnull)title withContent:(NSString *_Nullable)content withCode:(NSString *_Nullable)code;

//获取全部日志信息
+ (NSArray *_Nullable)getAllLogMessage;





@end









