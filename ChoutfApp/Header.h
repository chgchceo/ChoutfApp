//
//  Header.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/8/24.
//

#ifndef Header_h
#define Header_h
#import <EventKit/EventKit.h>
#import <WebKit/WebKit.h>
#import "BaseViewController.h"
#import "Utils.h"
#import <AVFoundation/AVFoundation.h>
#import "DataService.h"
#import "TZImagePickerController.h"

#define COLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]

//主体色
#define MainColor    COLOR_WITH_HEX(0x06B71E)

//#define VOSSColor    [UIColor colorWithRed:59/255.0 green:155/255.0 blue:255/255.0 alpha:1] //蓝色
#define VOSSColor    [UIColor colorWithRed:72/255.0 green:132/255.0 blue:252/255.0 alpha:1] //蓝色


#define TEXTColor    [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9] //字体色

#define BGColor    [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1] //背景灰白色

#define BColor    [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1]

#define PROJECTColor    [UIColor colorWithRed:252/255.0 green:248/255.0 blue:254/255.0 alpha:1] //

#define TColor    [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] //

#define projectTColor    [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] //

#define IOS8LATER [[UIDevice currentDevice].systemVersion floatValue] >=8.0

#define IOS7LATER [[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0

#define TitleHeight  40
/** 判读是否为iPhone X及以上 **/



#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define TabbarHeight     (StatusBarHeight>20?83:49) // 适配iPhone x 底栏高度
#define Bottom_Safe  (StatusBarHeight>20? 34 : 0)
#define SafeTop (([[UIScreen mainScreen] bounds].size.height<812) ? 20 : 44)
#define NaviBarHeight     (StatusBarHeight + 44)
//#define NaviBarHeight     (StatusBarHeight>20?88:64)
// 适配iPhone x 顶栏高度

#ifdef DEBUG
#define DLog(format, ...) printf("类名: <%p %s:(%d) > \n函数名: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] );
#else
# define DLog(...);
#endif

#define WEAK_SELF __typeof(&*self) __weak weakSelf = self;
#define STRONG_SELF __typeof(&*self) __strong strongSelf = weakSelf


// 屏幕的宽
#define ScreenWidth                 [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define ScreenHeight                [[UIScreen mainScreen] bounds].size.height


#define ISIpad  [[UIDevice currentDevice].model isEqualToString:@"iPad"]


//开发环境
#define BASE_URL   @"https://smartics-gateway-uat.chowtaifook.sz/"
//#define H5_URL @"https://sales-uat.chowtaifook.sz"
#define H5_URL @"https://www.baidu.com"
#define isDev  true



//生产环境
//#define BASE_URL  @"https://smartics-gateway.chowtaifook.sz/"
//#define H5_URL @"https://sales.chowtaifook.sz"
//#define isDev  false







#endif /* Header_h */
