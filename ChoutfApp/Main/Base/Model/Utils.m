//
//  Utils.m
//  
//
//  Created by chgch on 17/6/22.
//  Copyright © 2017年 chgch. All rights reserved.
//

#import "header.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import <AVKit/AVKit.h>
#import <mach/mach.h>
#import "DataService.h"
//#import "DBManager.h"
@import Darwin.sys.mount;


@interface Utils(){
    
    
}
@end

@implementation Utils


#pragma mark - 压缩图片
+ (UIImage *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size
{
    
    if(image == nil){
        
        return nil;
    }
    
    size = size -100;//转变为image时会解压，多压缩一点
    if(image.size.width > 1200){
        
        image = [Utils compressOriginalImage:image toWidth:1200];
    }
    
    //对图片进行第一轮压缩
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataSize = imgData.length/1000.0;
    
    if (dataSize > 5000){//5M以上
        
        imgData = UIImageJPEGRepresentation(image, 0.2);
    }else if (dataSize >1000){//1M-5M之间
        
        imgData = UIImageJPEGRepresentation(image, 0.5);
    }else{//1M以内
        
        imgData = UIImageJPEGRepresentation(image, 0.8);
    }
    image = [UIImage imageWithData:imgData];
    
    //对图片进行第二轮压缩，控制在目标范围内
    UIImage *OriginalImage = image;
    // 执行这句代码之后会有一个范围 例如500m 会是 100m～500k
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    
    // 执行while循环 如果第一次压缩不会小雨100k 那么减小尺寸在重新开始压缩
    while (dataKBytes > size)
    {
        while (dataKBytes > size && maxQuality > 0.1f)
        {
            maxQuality = maxQuality - 0.1f;
            data = UIImageJPEGRepresentation(image, maxQuality);
            dataKBytes = data.length / 1000.0;
            if(dataKBytes <= size )
            {
                
                UIImage *img = [UIImage imageWithData:data];
                return img;
            }
        }
        OriginalImage =[self compressOriginalImage:OriginalImage toWidth:OriginalImage.size.width * 0.8];
        image = OriginalImage;
        data = UIImageJPEGRepresentation(image, 1.0);
        dataKBytes = data.length / 1000.0;
        maxQuality = 0.9f;
    }
    
    UIImage *img = [UIImage imageWithData:data];
    return img;
}
#pragma mark - 改变图片的大小
+(UIImage *)compressOriginalImage:(UIImage *)image toWidth:(CGFloat)targetWidth
{
    CGSize imageSize = image.size;
    CGFloat Originalwidth = imageSize.width;
    CGFloat Originalheight = imageSize.height;
    CGFloat targetHeight = Originalheight / Originalwidth * targetWidth;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [image drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}


#pragma mark ---- 将时间戳转换成时间
+ (NSString *)getTimeFromTimestamp:(NSString *)tamp{
    
    //将对象类型的时间转换为NSDate类型
    
    double time =[tamp doubleValue]/1000.0;
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    
    //    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

+ (NSString *)md5String:(NSString *)str {
    
    const char *myPasswd = [str UTF8String];
    unsigned char mdc[ 16 ];//16
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    NSMutableString *md5String = [NSMutableString string ];
    for ( int i = 0 ; i< 16 ; i++){//16
        
        [md5String appendFormat : @"%02x" ,mdc[i]];
        
    }
    
    return md5String;
}

+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents* comp = [calendar components:NSCalendarUnitDay
                                         fromDate:fromDate
                                           toDate:toDate
                                          options:NSCalendarWrapComponents];
    
    return comp.day;
}

+(NSDate *)nsstringConversionNSDate:(NSString *)dateStr
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale * locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    dateFormatter.locale = locale;
    
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    
    return datestr;
}

+(NSDate *)nsstringCoNSDate:(NSString *)dateStr
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale * locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    dateFormatter.locale = locale;
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    
    return datestr;
}

+(NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate

{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

+ (NSString *)changeDateToStr:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale * locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    dateFormatter.locale = locale;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

//获取手机号尾号
+ (NSString *)getPhonePartStr:(NSString *)phone{
    
    if (phone.length < 11) {
        
        return @"";
    }
    
    NSString *str = [phone substringFromIndex:7];
    return  str;
}

//字符串转字典
+ (NSDictionary *)changeStrToDic:(NSString *)str{
    
    if ( !str || [str isEqual:@""]) {
        return nil;
    }
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        
    }
    return dic;
}
//日期转字符串包括时分秒
+ (NSString *)changeDateToAllStr:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale * locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    dateFormatter.locale = locale;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

+ (NSString *)getTextWithModelStr:(NSString *)str{
    
    NSString *text = [NSString stringWithFormat:@"%@",str];
    if ([text isEqualToString:@"<null>"] || [text isEqualToString:@""] || text == nil || [text isEqualToString:@"(null)"] || [text isKindOfClass:[NSNull class]]) {
        
        text = @"";
    }
    return text;
}
//是否登录
+ (BOOL)isLoginIn{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    token = [self getTextWithModelStr:token];
    if (token.length > 0) {
        
        return YES;
    }
    return NO;
}

//获取跳转控制器
+ (UIViewController *)findVisibleViewController {
    UIViewController* currentViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    return currentViewController;
}

//去掉字符串首尾空格和换行的方法
+ (NSString *)getSimpleString:(NSString *)str{
    
//    （1）去掉字符串首尾空格的方法：

//    NSString *str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

//     （2）去掉字符串首尾换行的方法：

//    NSString *str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];

//    （3）去掉字符串首尾空格和换行的方法：

    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return str;
}

//html转富文本
+ (NSMutableAttributedString *)getAttributedStringByHTMLString:(NSString *)htmlString
                                                    imageWidth:(CGFloat)imageWidth
                                                  textAligment:(NSTextAlignment)textAligment
                                                 lineBreakMode:(NSLineBreakMode)lineBreakMode
                                                   lineSpacing:(CGFloat)lineSpacing
                                                          font:(UIFont *)font
                                                         color:(nullable UIColor *)color {
    if (imageWidth > 0 && [htmlString containsString:@"<img"]) {
        htmlString = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@", imageWidth, htmlString];
    }
    
    if (font) { //因为设置了font，不能再使用NSFontAttributeName属性来设置，加粗字体等样式会被覆盖掉
        htmlString = [NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx;}</style>%@", font.fontName, font.pointSize, htmlString];
    }
    
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute      : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding) };
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    NSMutableParagraphStyle *paragraphStyle     = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode                = lineBreakMode;
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setAlignment:textAligment];
    paragraphStyle.paragraphSpacing = 15;//段落间距
    NSRange range = NSMakeRange(0, [attributedString length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    if (color) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    
    return attributedString;
}


//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect.size.height;
}
//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
}
//获取带token的h5路径
+ (NSString *)getHtmlStr:(NSString *)str{
    
    return @"";
}

//+(void)setImageWith:(NSString *)str withImgView:(UIImageView *)imgView{
//
//    imgView.contentMode = UIViewContentModeScaleToFill;
//    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [imgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
//
//}
/** 银行卡号有效性问题Luhn算法
 *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 *  16 位卡号校验位采用 Luhm 校验方法计算：
 *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 *  3，将加法和加上校验位能被 10 整除。
 */
+ (BOOL)isBankCardNumber:(NSString *)cardNum {
    
    NSString * lastNum = [[cardNum substringFromIndex:(cardNum.length-1)] copy];//取出最后一位
    NSString * forwardNum = [[cardNum substringToIndex:(cardNum.length -1)] copy];//前15或18位
    
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<forwardNum.length; i++) {
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count-1); i> -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (int i=0; i< forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i%2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }else{//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }else{
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal%10 ==0)?YES:NO;
}

+(void)setImageWith:(NSString *)str withImgView:(UIImageView *)imgView placeholderImag:(NSString *)imageName{
    
    imgView.contentMode = UIViewContentModeScaleAspectFill;
//    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    [imgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:imageName]];
    
//    imgView.image = [UIImage imageNamed:imageName];
//    imgView.contentMode = UIViewContentModeScaleToFill;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url=%@",str];
//    NSArray *array = [[DBManager shareInstance] queryWithEntityName:@"PhotoData" withPredicate:predicate];
//
//    if (array.count > 0){
//
//        for (PhotoData *pdata in array) {
//
//            NSString *url = pdata.url;
//            NSData *data = pdata.data;
//            if ([url isEqualToString:str]) {
//
//                if(data != nil){
//
//                    UIImage *image = [UIImage imageWithData:data];
//                    if (image) {
//
//                        imgView.image = image;
//                    }
//
//                }else{//没有缓存
//
//                    //开启多线程
//                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                        // 处理耗时操作的代码块...
//
//                        UIImage *image = nil;
//                        NSData *data = nil;
//                        NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedString]];
//                        image = [UIImage imageWithData:data];
//                        pdata.url = str;
//                        pdata.data = data;
//                        if(data){
//
//                            [[DBManager shareInstance] updateMO:pdata];
//                        }
//                        //回到主线程
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            if (image) {
//
//                                imgView.image = image;
//                            }
//                        });
//
//                    });
//                }
//            }
//        }
//    }
//    else{//没有缓存
//
//        //开启多线程
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            // 处理耗时操作的代码块...
//
//            UIImage *image = nil;
//            NSData *data = nil;
//            NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedString]];
//            image = [UIImage imageWithData:data];
//            PhotoData *imgData = (PhotoData *)[[DBManager shareInstance] createMO:@"PhotoData"];
//            imgData.url = str;
//            imgData.data = data;
//            if (data) {
//
//                [[DBManager shareInstance] addManagerObject:imgData];
//            }
//
//            //回到主线程
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                if (image) {
//                    imgView.image = image;
//                }
//            });
//        });
//    }
}

//获取运行内存
+ (void)getRamMemory{
    
    mach_port_t host_port;
    
    mach_msg_type_number_t host_size;
    
    vm_size_t pagesize;
    
    host_port =mach_host_self();
    
    host_size =sizeof(vm_statistics_data_t) / sizeof(integer_t);
    
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if(host_statistics(host_port,HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) !=KERN_SUCCESS) {
        
        NSLog(@"Failed to fetch vm statistics");
        
    }
    
    /* Stats in bytes */
    
    natural_t mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    
    natural_t mem_free = vm_stat.free_count * pagesize;
    
    natural_t mem_total = mem_used + mem_free;
    
    NSLog(@"已用: %uM 可用: %uM 总共: %uM", mem_used/1024/1024, mem_free/1024/1024, mem_total/1024/1024);
    
    NSString *meg = [NSString stringWithFormat:@"已用: %uM 可用: %uM 总共: %uM", mem_used/1024/1024, mem_free/1024/1024, mem_total/1024/1024];
    
    //    [self showMessage:meg];
    NSString *str1 = @"";// [self freeDiskSpaceInBytes];
    NSString *str2 = @"";//[self getTotalMemorySize];
    NSLog(@"%@,%@",str1,str2);
    
    //    [self getFreeDiskspace];
    float totalSpace = 0;
    float totalFreeSpace = 0;
    float totalUsedSpace = 0;
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        totalUsedSpace = totalSpace - totalFreeSpace;
    }
    
    NSString *deviceName = [UIDevice currentDevice].name;
    NSString *Ram_all = [NSString stringWithFormat:@"总运行内存:%uM",mem_total/1024/1024];
    NSString *Ram_free = [NSString stringWithFormat:@"剩余运行内存:%uM",mem_free/1024/1024];
    NSString *Ram_use = [NSString stringWithFormat:@"已用运行内存:%uM",mem_used/1024/1024];
    
    str1 = [[NSString stringWithFormat:@"设备总内存:%.2f",((totalSpace/1000.0f)/1000.0f/1000.0f)]     stringByAppendingString:@"GB"];
    str2 = [[NSString stringWithFormat:@"设备可用内存:%.2f",((totalFreeSpace/1000.0f)/1000.0f/1000.0f)] stringByAppendingString:@"GB"];
    
    NSDictionary *dic = @{
        
        @"Ram_all":Ram_all,
        @"Ram_free":Ram_free,
        @"Ram_use":Ram_use,
        @"Rom_all":str1,
        @"Rom_free":str2,
    };
    
    NSString *json = [self convertToJsonData:dic];
    
    NSDictionary *dict = @{
        
        @"courseName":deviceName,
        @"thirdData":json
    };
    
//    [DataService requestDataWithURL:PhoneMemoryInformation withMethod:@"POST" withParames:[dict mutableCopy] withBlock:^(id result) {
//
//
//    }];
}

// 获取当前设备可用内存 ROM
+(NSString*) freeDiskSpaceInBytes{
    
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >=0){
        
        freespace = (long long)(buf.f_bsize* buf.f_bfree);
    }
//    return[NSString stringWithFormat:@"设备可用内存:%qi GB",freespace/1000/1000/1000];
    return[NSString stringWithFormat:@"设备可用内存:%.1fGB",(double)freespace/1000/1000/1000];
}

// 获取当前设备总内存 ROM
+(NSString*)getTotalMemorySize{
    
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if(statfs("/var", &buf) >=0){
        freeSpace = (unsigned long long)(buf.f_bsize* buf.f_blocks);
    }
//    return[NSString stringWithFormat:@"设备总内存:%qi GB",freeSpace/1000/1000/1000];
    return[NSString stringWithFormat:@"设备总内存:%.1fGB",(double)freeSpace/1000/1000/1000];
}

+ (float)getFreeDiskspace {
    
    float totalSpace;
    float totalFreeSpace;
    float totalUsedSpace;
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (error == nil) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        totalUsedSpace = totalSpace - totalFreeSpace;
        
        float freePercent = totalFreeSpace/totalSpace;
        float usedPercent = totalUsedSpace/totalSpace;
        
        NSLog(@"iphone磁盘未使用率 =%@", [[NSString stringWithFormat:@"%.2f",freePercent*100]    stringByAppendingString:@"%"]);
        NSLog(@"iphone磁盘使用率  =%@",  [[NSString stringWithFormat:@"%.2f",usedPercent*100]    stringByAppendingString:@"%"]);
        NSLog(@"iphone磁盘总大小  =%@",  [[NSString stringWithFormat:@"%.2f",((totalSpace/1000.0f)/1000.0f/1000.0f)]     stringByAppendingString:@"GB"]);
        NSLog(@"iphone磁盘已使用大小    =%@",  [[NSString stringWithFormat:@"%.2f",((totalUsedSpace/1000.0f)/1000.0f/1000.0f)] stringByAppendingString:@"GB"]);
        NSLog(@"iphone磁盘剩余大小    =%@",  [[NSString stringWithFormat:@"%.2f",((totalFreeSpace/1000.0f)/1000.0f/1000.0f)] stringByAppendingString:@"GB"]);
        
        NSLog(@"Memory Capacity of %f GB with %f GB Free memory available.", ((totalSpace/1000.0f)/1000.0f/1000.0f), ((totalFreeSpace/1000.0f)/1000.0f)/1000.0f);
    }
    return totalFreeSpace;
}


//获取话题的数组
+(NSArray *)getTopicWithStr:(NSString *)str
{
    NSString * MOBIL = @"(?<=#)[\u4e00-\u9fa5A-Za-z0-9]+?(?=#|s|$|[^\u4e00-\u9fa5A-Za-z0-9])";
    NSError *error;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:MOBIL options:0 error:&error];
    NSArray *matches = [regularExpression matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    NSMutableArray *array = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        NSString *a = [str substringWithRange:matchRange];
        [array addObject:a];
    }
    return array;
}
/*
private final static String NEW_BARCODE_REGEX = "^(([0-9][1-9])|([1-9][0-9]))[a-zA-Z]{1,3}[0-9](((?!0+$)\\d{7,8}))$";
    //7位牌仔正则
    private final static String OLD_BARCODE_REGEX = "^(([0-9][1-9])|([1-9][0-9]))[a-zA-Z]{1,3}[0-9](((?!0+$)\\d{7}))$";


    
     * 用于檢查字符串是否符合牌仔的格式
     * Barcode: 牌仔字符串
     * @return  True表示符合,False表示不符合
     
    public static Boolean checkBarcode(String barcode, Integer stockNoLength){
        return stockNoLength == 7 ? barcode.matches(OLD_BARCODE_REGEX) : barcode.matches(NEW_BARCODE_REGEX);
    }
*/

//验证条形码是否是公司的条码类型
+(BOOL)isCheckBarCodeStr:(NSString *)str{
    
    NSString * MOBIL = @"^(([0-9][1-9])|([1-9][0-9]))[a-zA-Z]{1,3}[0-9](((?!0+$)\\d{7,8}))$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    if ([regextestmobile evaluateWithObject:str]) {
        
        return YES;
    }
    
    return NO;
}

+(BOOL)isMobilePhone:(NSString *)phoneNum
{
    NSString * MOBIL = @"^1(3[0-9]|4[579]|5[0-35-9]|7[01356]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    if ([regextestmobile evaluateWithObject:phoneNum]) {
        
        return YES;
    }
    
    if(phoneNum.length == 11){
        
        return YES;
    }
    return NO;
}

//根据内容生成二维码
+ (UIImage *)getQRCodeImg:(NSString *)str{
    //1.将字符串转出NSData
    //    NSString *str = [NSString stringWithFormat:@"4s-%@",@""];
    
    NSData *img_data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //2.将字符串变成二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //  条形码 filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    //3.恢复滤镜的默认属性
    [filter setDefaults];
    
    //4.设置滤镜的 inputMessage
    [filter setValue:img_data forKey:@"inputMessage"];
    
    //5.获得滤镜输出的图像
    CIImage *img_CIImage = [filter outputImage];
    
    //6.此时获得的二维码图片比较模糊，通过下面函数转换成高清
    UIImage *image = [self changeImageSizeWithCIImage:img_CIImage andSize:180];
    
    return image;
}

//拉伸二维码图片，使其清晰
+ (UIImage *)changeImageSizeWithCIImage:(CIImage *)ciImage andSize:(CGFloat)size{
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

//添加顶部试图
+ (void)createNavigationBgView:(UIView *)supView{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NaviBarHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [supView addSubview:bgView];
    [bgView performSelector:@selector(removeFromSuperview) withObject:bgView afterDelay:1.5];
}

//根据图片logo和url删除二维码
+ (UIImage *)getQRCodeImg:(NSString *)urlString iamgeName:(NSString *)imageName{

    CGFloat size = ScreenWidth;
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage*image = [filter outputImage];
    //4.在中心增加一张图片
    UIImage *img = [self df_createNonInterpolatedUIImageFormCIImage:image withSize:size];
    //5.把中央图片划入二维码里面
    //5.1开启图形上下文
    UIGraphicsBeginImageContext(img.size);
    //5.2将二维码的图片画入
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    UIImage*centerImg = [UIImage imageNamed:imageName];
    CGFloat centerW = img.size.width*0.25;
    CGFloat centerH = centerW;
    CGFloat centerX = (img.size.width - centerW)*0.5;
    CGFloat centerY = (img.size.height - centerH)*0.5;
    [centerImg drawInRect:CGRectMake(centerX, centerY, centerW, centerH)];
    //5.3获取绘制好的图片
    UIImage *finalImg=UIGraphicsGetImageFromCurrentImageContext();
    //5.4关闭图像上下文
    UIGraphicsEndImageContext();
    return  finalImg;

}
+ (UIImage *)df_createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size{
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    
    size_t width =CGRectGetWidth(extent) * scale;
    
    size_t height =CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    
    
    // 2.保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}

#pragma mark -字符串转化成时间戳
+(NSString *)stringToTime:(NSString *)timeStr
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

+ (NSString *)changeImageToStr:(UIImage *)image{
    
    
    return [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
}


//根据网络链接获取图片
+(UIImage *)getImageWith:(NSString *)str{

    if(str.length == 0){
        
        return nil;
    }
    
    UIImage *image = nil;
    NSData *data = nil;
//    NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* encodedString = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedString]];
    image = [UIImage imageWithData:data];
    
    return image;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url=%@",str];
//    NSArray *array = [[DBManager shareInstance] queryWithEntityName:@"PhotoData" withPredicate:predicate];
//
//    if (array.count > 0){
//
//        for (PhotoData *pdata in array) {
//
//            NSString *url = pdata.url;
//            NSData *data = pdata.data;
//
//            if ([url isEqualToString:str]) {
//
//                if(data != nil){
//
//                    UIImage *image = [UIImage imageWithData:data];
//                    if (image) {
//                        return image;
//                    }
//
//                }else{//没有缓存
//
//
//                        UIImage *image = nil;
//                        NSData *data = nil;
//
//                        NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedString]];
//                        image = [UIImage imageWithData:data];
//                        pdata.url = str;
//                        pdata.data = data;
//                        if(data){
//
//                            [[DBManager shareInstance] updateMO:pdata];
//                        }
//                        return image;
//
//                    }
//            }
//        }
//    }
//    else{//没有缓存
//
//            UIImage *image = nil;
//            NSData *data = nil;
//            NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedString]];
//            image = [UIImage imageWithData:data];
//            PhotoData *imgData = (PhotoData *)[[DBManager shareInstance] createMO:@"PhotoData"];
//            imgData.url = str;
//            imgData.data = data;
//            if (data) {
//
//                [[DBManager shareInstance] addManagerObject:imgData];
//            }
//            return image;
//    }
//    return nil;
}

+ (BOOL)isPureNum:(NSString*)string{
    
    return [self isPureInt:string] || [self isPureFloat:string];
}

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//首页欢迎语
+ (void)showWelComeMeg:(UIView *)sView{
    
    if(![Utils isLoginIn]){
        
        return;
    }
//
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-200)/2.0, 136, 200, 92)];
//    bgView.backgroundColor = [UIColor blackColor];
//    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
////    bgView.alpha = 0.8;
//    bgView.layer.cornerRadius = 5;
//    bgView.layer.masksToBounds = YES;
//    NSString *townName = [Utils getTextWithModelStr:[User shareInstance].townName];
//    NSString *villageName = [Utils getTextWithModelStr:[User shareInstance].villageName];
//    NSString *nick = [Utils getTextWithModelStr:[User shareInstance].nickName];
//    if (villageName.length == 0) {
//
//        return;
//    }
//    NSString *address = [NSString stringWithFormat:@"%@-%@",townName,villageName];
//    NSString *title = [NSString stringWithFormat:@"%@ 欢迎回家~",nick];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 200, 18)];
//    label.text = address;
//    label.font = [UIFont systemFontOfSize:14];
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    [bgView addSubview:label];
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:address];
//    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//    attch.image = [UIImage imageNamed:@"icon_location"];
//    attch.bounds = CGRectMake(-3, -1, 10, 13);
//
//    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
//    [attri insertAttributedString:string atIndex:0];
//    label.attributedText = attri;
//
//    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, 200, 21)];
//    nameLab.text = title;
//    nameLab.font = [UIFont systemFontOfSize:16];
//    nameLab.textColor = [UIColor whiteColor];
//    nameLab.textAlignment = NSTextAlignmentCenter;
//    [bgView addSubview:nameLab];
//    [sView addSubview:bgView];
//    [bgView performSelector:@selector(removeFromSuperview) withObject:self afterDelay:2];
}

+ (void)showMessage:(NSString *)meg{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-220)/2.0, (ScreenHeight-80)/2.0, 220, 40)];
        
        label.text = meg;
        
    //    if (meg.length > 11) {
    //
    //        label.frame = CGRectMake((ScreenWidth-220)/2.0, (ScreenHeight-80)/2.0, 220, 40);
    //    }
        label.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];//blackColor
        label.alpha = 1;//0.6
        label.font = [UIFont systemFontOfSize:14];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:label];
        [label performSelector:@selector(removeFromSuperview) withObject:self afterDelay:1.5];
        
    });
   
}
//数字加1
+ (NSString *)numAddOne:(NSString *)str{
    
    NSInteger num = [str integerValue];
    num = num +1;
    
    if (num < 0) {
        
        num = 0;
    }
    NSString *result = [NSString stringWithFormat:@"%ld",num];
    return  result;
}
//数字减1
+ (NSString *)numReduceOne:(NSString *)str{
    
    NSInteger num = [str integerValue];
    num = num -1;
    
    if(num < 0) {
        
        num = 0;
    }
    NSString *result = [NSString stringWithFormat:@"%ld",num];
    return  result;
}

//判断一个字符是不是中文。
+ (BOOL)isChinese:(NSString*)str
{
    int strlength = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return ((strlength/2)==1)?YES:NO;
}

//富文本,字体的颜色
+(void)setLabel:(UILabel *)lab withPartStr:(NSString *)part1 withPartStr:(NSString *)part2 withContent:(NSString *)content withColor:(UIColor *)color{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSRange rg1 = [content rangeOfString:part1];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:rg1];
    
    NSRange rg2 = [content rangeOfString:part2];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:rg2];
    
    lab.attributedText = attributedString;
    
}
// 64base字符串转图片
+ (UIImage *)stringToImage:(NSString *)str {
    
    NSData * imageData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    UIImage *photo = [UIImage imageWithData:imageData ];
    
    return photo;
    
}

/// 计算文件的MD5
- (NSString *)getFileMD5StrFromPath1:(NSString *)path {
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) return @""; // 如果文件不存在
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength:256];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}


/// 获取文件的MD5值，如果文件不存在直接返回空字符串
- (NSString *)getFileMD5StrFromPath2:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:path isDirectory:nil]) {
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        
        CC_MD5( data.bytes, (CC_LONG)data.length, digest );
        
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        
        for( int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ ) {
            [output appendFormat:@"%02x", digest[i]];
        }
        return output;
    } else {
        return @"";
    }
}
//获取当前时间戳  （以毫秒为单位）
+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}

// 图片转64base字符串
+ (NSString *)imageToString:(UIImage *)image {
    
    NSData *imagedata = UIImagePNGRepresentation(image);
    
    NSString *image64 = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return image64;
    
}
//获取图片的格式
+ (NSString *)imageFormatFromImageData:(NSData *)imageData{
    
    uint8_t first_byte;
    [imageData getBytes:&first_byte length:1];
    switch (first_byte) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([imageData length] < 12) {
                return @"";
            }
            NSString *dataString = [[NSString alloc] initWithData:[imageData subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([dataString hasPrefix:@"RIFF"] && [dataString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return @"";
    }
    return nil;
}

+ (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}
//富文本,字体的颜色
+(void)setLabel:(UILabel *)lab withPartStr:(NSString *)part withContent:(NSString *)content withColor:(UIColor *)color{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSRange rg = [content rangeOfString:part];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:rg];
    
    NSRange rg2 = [part rangeOfString:@"回复"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0x333333) range:rg2];
    lab.attributedText = attributedString;
    
}

//富文本,字体的颜色和大小
+(void)setLabel:(UILabel *)lab withPartStr:(NSString *)part withContent:(NSString *)content withColor:(UIColor *)color withFont:(UIFont *)font{
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSRange rg = [content rangeOfString:part];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:rg];
    [attributedString addAttribute:NSFontAttributeName value:font range:rg];
    
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    lab.attributedText = attributedString;
    
}

+ (NSString *)getNowTimeStr{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr =[dateFormatter stringFromDate:date];
    return dateStr;
}
//获取当前的时分
+ (NSString *)getNowTimeHourAndM{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateStr =[dateFormatter stringFromDate:date];
    return dateStr;
}

//获取今天日期,2010-02
+ (NSString *)getNowDateYearAndMonthStr{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *dateStr =[dateFormatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)getNowDateStr{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr =[dateFormatter stringFromDate:date];
    return dateStr;
}
//获取网络视频的宽高
+ (CGSize)getSizeWithVideoUrl:(NSString *)url{
    
    CGSize videoSize = CGSizeZero;
    AVURLAsset*asset = [AVURLAsset assetWithURL: [NSURL URLWithString: url]];
    NSArray * array = asset.tracks;
    
    for(AVAssetTrack *track in array) {
        
        if([track.mediaType isEqualToString: AVMediaTypeVideo]) {
            
            videoSize = track.naturalSize;
        }
    }
    return videoSize;
}

// 获取网络视频第一帧
+ (UIImage*)getVideoPreViewImage:(NSURL *)path
{
//    NSString *str = path.absoluteString;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url=%@",str];
//    NSArray *array = [[DBManager shareInstance] queryWithEntityName:@"PhotoData" withPredicate:predicate];
//
//    if (array.count > 0){
//
//        for (PhotoData *pdata in array) {
//
//            NSString *url = pdata.url;
//            NSData *data = pdata.data;
//            if ([url isEqualToString:str]) {
//
//                if(data != nil){
//
//                    UIImage *image = [UIImage imageWithData:data];
//                    if (image) {
//
//                        return image;
//                    }
//                }else{
//
//                    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
//                    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//                    assetGen.appliesPreferredTrackTransform = YES;
//                    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
//                    NSError *error = nil;
//                    CMTime actualTime;
//                    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//                    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
//                    CGImageRelease(image);
//
//                    pdata.url = str;
//                    pdata.data = UIImageJPEGRepresentation(videoImage, 0.6);
//                    if (data) {
//
//                        [[DBManager shareInstance] updateMO:pdata];
//                    }
//                    return videoImage;
//
//                }
//            }
//        }
//    }
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
        AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetGen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        
//        PhotoData *imgData = (PhotoData *)[[DBManager shareInstance] createMO:@"PhotoData"];
//        imgData.url = str;
//        imgData.data = UIImageJPEGRepresentation(videoImage, 0.6);
//        if (imgData.data) {
//
//            [[DBManager shareInstance] addManagerObject:imgData];
//        }
        return videoImage;
}

//删除临时文件
+(void)removeTempVideoData:(NSString *)path{
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"temp文件删除失败:%@",error);
    }else{
        NSLog(@"temp文件删除成功");
    }
}
//对视频进行压缩
+ (void)videoCompressWithSourceURL:(NSURL*)sourceURL completion:(void(^)(int statusCode, NSString *outputVideoURL))completion {
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    NSString* resultQuality = AVAssetExportPreset960x540;
    
    if ([compatiblePresets containsObject:resultQuality]) {
        int random = arc4random() % 1000000;
        NSString* resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/%d.mp4", random];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:resultPath]) {
            [fileManager removeItemAtPath:resultPath error:nil];
        }
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:resultQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         {
            switch (exportSession.status) {
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"AVAssetExportSessionStatusUnknown");
                    break;
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"AVAssetExportSessionStatusWaiting");
                    break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"AVAssetExportSessionStatusExporting");
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"AVAssetExportSessionStatusCompleted");
                    if(completion)
                        completion(0, resultPath);
                    break;
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"AVAssetExportSessionStatusFailed");
                    if(completion)
                        completion(1, nil);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"AVAssetExportSessionStatusCancelled");
                    if(completion)
                        completion(1, nil);
                    break;
            }
        }];
    }
}
//IM即时通讯退去登录
+ (void)logOutIM:(logoutBlock)block{
    
//    [TUILogin logout:^{
//        if (block) {
//            block();
//        }
//        NSLog(@"IM logout succ");
//    } fail:^(int code, NSString *msg) {
//        NSLog(@"IM logout fail");
//        if (block) {
//            block();
//        }
//    }];
}

+ (void)logoutApp:(logoutBlock)block{
//    NSDictionary *dic = @{};
//    [DataService requestDataWithURL:AppLogOut withMethod:@"POST" withParames:[dic mutableCopy] withBlock:^(id result) {        NSLog(@"result is  -- %@",result);
//        if (block) {
//            block();
//        }
//    }];
}

//IM即时通讯登录
+ (void)loginIM{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    token = [self getTextWithModelStr:token];
    if (token.length == 0) {
        
        return;
    }
    
    NSDictionary *dic = @{
        
        @"token":token
    };
    
    [DataService requestDataWithURL:@"/open/message/getTimUserSig" withMethod:@"GET" withParames:[dic mutableCopy] withBlock:^(id result) {
        
        if (![result isKindOfClass:[NSDictionary class]]) {
            
            return;
        }
        NSInteger code = [[result objectForKey:@"code"] integerValue];
        NSString *msg = [result objectForKey:@"msg"];
        
        if (code == 0) {
            
            NSDictionary *data = [result objectForKey:@"data"];
            NSString *userId = [data objectForKey:@"userId"];
            NSString *userSig = [data objectForKey:@"userSig"];
            [self login:userId userSig:userSig];
        }else{
            
            //            [Utils showMessage:msg];
        }
    }];
}

// 后续优化，先直接新增一个同样的方法
+ (void)loginIM:(logoutBlock)block{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    token = [self getTextWithModelStr:token];
    if (token.length == 0) {
        
        return;
    }
    
    NSDictionary *dic = @{
        
        @"token":token
    };
    
    [DataService requestDataWithURL:@"/open/message/getTimUserSig" withMethod:@"GET" withParames:[dic mutableCopy] withBlock:^(id result) {
        
        if (![result isKindOfClass:[NSDictionary class]]) {
            
            return;
        }
        NSInteger code = [[result objectForKey:@"code"] integerValue];
        NSString *msg = [result objectForKey:@"msg"];
        
        if (code == 0) {
            
            NSDictionary *data = [result objectForKey:@"data"];
            NSString *userId = [data objectForKey:@"userId"];
            NSString *userSig = [data objectForKey:@"userSig"];
            [self login:userId userSig:userSig withBlock:^{
                if (block) {
                    block();
                }
            }];
        }else{
            if (block) {
                block();
            }
            //            [Utils showMessage:msg];
        }
    }];
}

//succ:(TSucc)succ fail:(TFail)fail
// 您可以在用户 UI 点击登录的时候登录 UI 组件
+ (void)login:(NSString *)identifier userSig:(NSString *)sig
{
//    [TUILogin login:identifier userSig:sig succ:^{
//        NSLog(@"-----> 登录成功");
//        id tab =  [LSTabbarController currentTabBarController];
//        // 这里需要判断, 因为第一次进App rootViewController是 引导页
//        if (tab && [tab isKindOfClass:LSTabbarController.class]) {
//            [tab getUnReadMessageCount];
//        }
//
////        [self registerTPNS];
//
//    } fail:^(int code, NSString *msg) {
//        NSLog(@"-----> 登录失败");
//    }];
}


+ (void)login:(NSString *)identifier userSig:(NSString *)sig withBlock:(logoutBlock)block
{
//    [TUILogin login:identifier userSig:sig succ:^{
//        NSLog(@"-----> 登录成功");
//        id tab =  [LSTabbarController currentTabBarController];
//        // 这里需要判断, 因为第一次进App rootViewController是 引导页
//        if (tab && [tab isKindOfClass:LSTabbarController.class]) {
//            [tab getUnReadMessageCount];
//        }
//        if (block) {
//            block();
//        }
////        [self registerTPNS];
//
//    } fail:^(int code, NSString *msg) {
//        NSLog(@"-----> 登录失败");
//        if (block) {
//            block();
//        }
//    }];
}

+ (BOOL)checkIDCard:(NSString *)str{
    
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isValid = [pre evaluateWithObject:str];//此处返回的是BOOL类型,YES or NO;
    return isValid;
}
/**
 校验身份证号码是否正确 返回BOOL值
 
 @param idCardString 身份证号码
 @return 返回BOOL值 YES or NO
 */
+ (BOOL)cly_verifyIDCardString:(NSString *)idCardString{
    NSString *regex = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isRe = [predicate evaluateWithObject:idCardString];
    if (!isRe) {
        //身份证号码格式不对
        return NO;
    }
    //加权因子 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2
    NSArray *weightingArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //校验码 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2
    NSArray *verificationArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    NSInteger sum = 0;//保存前17位各自乖以加权因子后的总和
    for (int i = 0; i < weightingArray.count; i++) {//将前17位数字和加权因子相乘的结果相加
        NSString *subStr = [idCardString substringWithRange:NSMakeRange(i, 1)];
        sum += [subStr integerValue] * [weightingArray[i] integerValue];
    }
    
    NSInteger modNum = sum % 11;//总和除以11取余
    NSString *idCardMod = verificationArray[modNum]; //根据余数取出校验码
    NSString *idCardLast = [idCardString.uppercaseString substringFromIndex:17]; //获取身份证最后一位
    
    if (modNum == 2) {//等于2时 idCardMod为10  身份证最后一位用X表示10
        idCardMod = @"X";
    }
    if ([idCardLast isEqualToString:idCardMod]) { //身份证号码验证成功
        return YES;
    } else { //身份证号码验证失败
        return NO;
    }
}

//html高度计算
+(CGFloat)getHtmlHeight:(NSString *)htmlStr withWidht:(CGFloat)width{
    
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
    NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    NSData *data = [htmlStr dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    
    CGFloat height =  [attStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;//针对富文本有专门的计算动态高度的方法，与nsstring 大同小异；
    
    return height;
}

+ (NSString *)changeTimeStr:(NSString *)timeStr{
    
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSRange rg = [timeStr rangeOfString:@"."];
    //有点时间后面没有"."
    if (rg.location <= timeStr.length){
        
        timeStr = [timeStr substringToIndex:rg.location];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale * locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    dateFormatter.locale = locale;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    //转换时区
    //    date = [self getNowDateFromatAnDate:date];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    timeStr = [dateFormatter2 stringFromDate:date];
    return timeStr;
}

+ (NSString *)changeDetailTimeStr:(NSString *)timeStr{
    
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSRange rg = [timeStr rangeOfString:@"."];
    //有点时间后面没有"."
    if (rg.location <= timeStr.length){
        
        timeStr = [timeStr substringToIndex:rg.location];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale * locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    dateFormatter.locale = locale;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    //转换时区
    //    date = [self getNowDateFromatAnDate:date];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    timeStr = [dateFormatter2 stringFromDate:date];
    return timeStr;
}

+ (NSString *)changeOtherDetailTimeStr:(NSString *)timeStr{
    
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSRange rg = [timeStr rangeOfString:@"."];
    //有点时间后面没有"."
    if (rg.location <= timeStr.length){
        
        timeStr = [timeStr substringToIndex:rg.location];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale * locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    dateFormatter.locale = locale;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    //转换时区
    //    date = [self getNowDateFromatAnDate:date];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    timeStr = [dateFormatter2 stringFromDate:date];
    return timeStr;
}
//获取几月几日
+ (NSString *)getSimpleTimeStr:(NSString *)timeStr{
    
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSRange rg = [timeStr rangeOfString:@"."];
    //有点时间后面没有"."
    if (rg.location <= timeStr.length) {
        
        timeStr = [timeStr substringToIndex:rg.location];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale * locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    dateFormatter.locale = locale;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    timeStr = [dateFormatter2 stringFromDate:date];
    return timeStr;
}
+ (NSArray *)stringToJSON:(NSString *)jsonStr {
    
    if (jsonStr) {
    id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                return tmp;
            }else if([tmp isKindOfClass:[NSString class]] || [tmp isKindOfClass:[NSDictionary class]]) {
                     return [NSArray arrayWithObject:tmp];
                     
                 }else{
                     return  @[];
                         }
        }else{
                return  @[];
            }
    }else{
            return @[];
            
        }
}


//数组转json字符串
+ (NSString *_Nullable)changeArrtoJson:(NSArray *_Nullable)array{
    
    if ([array isKindOfClass:[NSString class]]) {
        return (NSString *)array;
    }
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (parseError) {
        jsonStr = @"";
    }
    return jsonStr;
}

+(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label{
    
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
}

// 字典转json字符串方法
+ (NSString *)convertToJsonData:(NSDictionary *)dict{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

// 字符串加
+ (NSString *)addV1:(NSString *)v1 v2:(NSString *)v2 {
    CGFloat result = [v1 floatValue] + [v2 floatValue];
    return [NSString stringWithFormat:@"%.2f", result];
}

// 字符串减
+ (NSString *)subV1:(NSString *)v1 v2:(NSString *)v2 {
    CGFloat result = [v1 floatValue] - [v2 floatValue];
    return [NSString stringWithFormat:@"%.2f", result];
}

// 字符串乘
+ (NSString *)mulV1:(NSString *)v1 v2:(NSString *)v2 {
    CGFloat result = [v1 floatValue] * [v2 floatValue];
    
    return [NSString stringWithFormat:@"%.2f", result];
}

// 字符串除
+ (NSString *)divV1:(NSString *)v1 v2:(NSString *)v2 {
    CGFloat result = [v1 floatValue] / [v2 floatValue];
    return [NSString stringWithFormat:@"%.2f", result];
}

// 简单只包含 + - 的计算
+ (NSString *)calcSimpleFormula:(NSString *)formula {
    
    NSString *result = @"0";
    char symbol = '+';
    
    int len = (int)formula.length;
    int numStartPoint = 0;
    for (int i = 0; i < len; i++) {
        char c = [formula characterAtIndex:i];
        if (c == '+' || c == '-') {
            NSString *num = [formula substringWithRange:NSMakeRange(numStartPoint, i - numStartPoint)];
            switch (symbol) {
                case '+':
                    result = [self addV1:result v2:num];
                    break;
                case '-':
                    result = [self subV1:result v2:num];
                    break;
                default:
                    break;
            }
            symbol = c;
            numStartPoint = i + 1;
        }
    }
    if (numStartPoint < len) {
        NSString *num = [formula substringWithRange:NSMakeRange(numStartPoint, len - numStartPoint)];
        switch (symbol) {
            case '+':
                result = [self addV1:result v2:num];
                break;
            case '-':
                result = [self subV1:result v2:num];
                break;
            default:
                break;
        }
    }
    return result;
}

// 获取字符串中的后置数字
+ (NSString *)lastNumberWithString:(NSString *)str {
    int numStartPoint = 0;
    
    for (int i = (int)str.length - 1; i >= 0; i--) {
        char c = [str characterAtIndex:i];
        if ((c < '0' || c > '9') && c != '.') {
            numStartPoint = i + 1;
            break;
        }
    }
    return [str substringFromIndex:numStartPoint];
}

// 获取字符串中的前置数字
+ (NSString *)firstNumberWithString:(NSString *)str {
    int numEndPoint = (int)str.length;
    for (int i = 0; i < str.length; i++) {
        char c = [str characterAtIndex:i];
        if ((c < '0' || c > '9') && c != '.') {
            numEndPoint = i;
            break;
        }
    }
    return [str substringToIndex:numEndPoint];
}

+ (NSString *)changeFloat:(NSString *)stringFloat
{
    const char *floatChars = [stringFloat UTF8String];
    int length = (int)[stringFloat length];
    int zeroLength = 0;
    int i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}

//判断是否全是空格
+ (BOOL)isEmpty:(NSString *) str {
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

+ (UIImage *)image:(UIImage *)image centerInSize: (CGSize)viewsize{
    
    CGSize size = image.size;
    CGFloat scalex = viewsize.width / size.width;
    CGFloat scaley = viewsize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    
    UIGraphicsBeginImageContext(viewsize);
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    float dwidth = ((viewsize.width - width) / 2.0f);
    float dheight = ((viewsize.height - height) / 2.0f);
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

//修改图片的尺寸
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

//获取网络状态
+(BOOL)getNetState{
    /*carrier = 0;
     networkType = 2;
     "networkType" 网络类型： 0.无网络/ 1.数据流量 / 2.wifi / 3.数据+wifi
     */
//    NSDictionary *netInfo = [UASDKLogin.shareLogin networkInfo];
//    if ([netInfo isKindOfClass:[NSDictionary class]]) {
//
//        NSString *networkType = [netInfo objectForKey:@"networkType"];
//        networkType = [self getTextWithModelStr:networkType];
//        if (![networkType isEqualToString:@"0"]) {
//
//            return YES;
//        }
//    }
    return NO;
}

//过滤表情
+ (NSString *)filterEmoji:(NSString *)str {
    
    __block NSString *text = str;
    NSString *string  = [[NSString alloc] initWithString:str];
    
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        //emoji length is 2  replace emoji with emptyString
        if (substring.length == 2){
            
            text = [text stringByReplacingOccurrencesOfString:substring withString:@""];
            
        }
    }];
    
    return text;
}


/**
 *  从身份证上获取性别
 */

+(NSString *)getIdentityCardSex:(NSString *)numberStr
{
    
    NSString *sex = @"";
    NSString *str = @"";
    //获取18位 二代身份证  性别
    if (numberStr.length==18)
        
    {
        int sexInt=[[numberStr substringWithRange:NSMakeRange(16,1)] intValue];
        if(sexInt%2!=0)
            
        {
            
            NSLog(@"1");
            sex = @"男";
            str = @"先生";
            
        }else{
            
            NSLog(@"2");
            sex = @"女";
            str = @"女士";
            
        }
    }
    
    //  获取15位 一代身份证  性别
    
    if (numberStr.length==15)
        
    {
        
        int sexInt=[[numberStr substringWithRange:NSMakeRange(14,1)] intValue];
        
        if(sexInt%2!=0)
            
        {
            
            NSLog(@"1");
            
            sex = @"男";
            str = @"先生";
            
        }else{
            
            NSLog(@"2");
            sex = @"女";
            str = @"女士";
            
        }
    }
    return str;
}

//转换日期格式 将年月日转换成2019-01-23
+ (NSString *)changeDateStr:(NSString *)DateStr{
    
    DateStr = [DateStr stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    DateStr = [DateStr stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    DateStr = [DateStr stringByReplacingOccurrencesOfString:@"日" withString:@""];
    
    return DateStr;
}


#define FileHashDefaultChunkSizeForReadingData 1024*8

+(NSString*)getFileMD5WithPath:(NSString*)path

{
    
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
    
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    
    // Declare needed variables
    
    CFStringRef result = NULL;
    
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    
    CFURLRef fileURL =
    
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  
                                  (CFStringRef)filePath,
                                  
                                  kCFURLPOSIXPathStyle,
                                  
                                  (Boolean)false);
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            
                                            (CFURLRef)fileURL);
    
    if (!readStream) goto done;
    
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    
    CC_MD5_CTX hashObject;
    
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    
    if (!chunkSizeForReadingData) {
        
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
        
    }
    
    // Feed the data to the hash object
    
    bool hasMoreData = true;
    
    while (hasMoreData) {
        
        uint8_t buffer[chunkSizeForReadingData];
        
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        
        if (readBytesCount == -1) break;
        
        if (readBytesCount == 0) {
            
            hasMoreData = false;
            
            continue;
            
        }
        
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
        
    }
    
    // Check if the read operation succeeded
    
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    
    if (!didSucceed) goto done;
    
    // Compute the string result
    
    char hash[2 * sizeof(digest) + 1];
    
    for (size_t i = 0; i < sizeof(digest); ++i) {
        
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        
    }
    
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
    
    
done:
    
    if (readStream) {
        
        CFReadStreamClose(readStream);
        
        CFRelease(readStream);
        
    }
    
    if (fileURL) {
        
        CFRelease(fileURL);
        
    }
    
    return result;
    
}
//获取视频的时长
+ (CGFloat)getTimeFromVideoPath:(NSString *)filePath
{
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
    CMTime   time = [asset duration];
    CGFloat seconds = time.value/time.timescale;
    return seconds;
}
//获取图片的md5
+ (NSString *)getMd5WithImage:(UIImage *)image{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *filePath = nil;
    filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/images"];
    [manager  createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/images/file.jpeg"];
    
    BOOL result = [UIImageJPEGRepresentation(image, 1) writeToFile:path atomically:YES];
    
    if (result) {
        
        NSString *md5 = [self getFileMD5WithPath:path];
        return md5;
    }
    return @"";
}

//给视图添加放大后缩小动画
+(void)buttonClick:(UIView *)bgView{
    
    CAKeyframeAnimation *continueAimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    continueAimation.duration = 0.5f;
    NSMutableArray *continueValues = [NSMutableArray array];
    [continueValues addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [continueValues addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
    [continueValues addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [continueValues addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [continueValues addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [continueValues addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    continueAimation.values = continueValues;
    continueAimation.removedOnCompletion = NO;
    continueAimation.fillMode = kCAFillModeForwards;
    [bgView.layer addAnimation:continueAimation forKey:nil];
    
//    bgView.transform = CGAffineTransformIdentity;
//    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
//        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
//
//            bgView.transform = CGAffineTransformMakeScale(1.5, 1.5);
//        }];
//        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
//
//            bgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
//        }];
//        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
//
//            bgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//        }];
//    } completion:nil];
}
//+ (UIColor *)gradientColorImageFromColors:(NSArray *)colors
//                             gradientType:(GradientType)gradientType
//                                  imgSize:(CGSize)imgSize {
//    NSMutableArray *ar = [NSMutableArray array];
//
//    for(UIColor *c in colors) {
//        [ar addObject:(id)c.CGColor];
//    }
//
//    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
//    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
//    CGPoint start;
//    CGPoint end;
//
//    switch (gradientType) {
//        case GradientTypeTopToBottom:
//            start = CGPointMake(0.0, 0.0);
//            end = CGPointMake(0.0, imgSize.height);
//            break;
//        case GradientTypeLeftToRight:
//            start = CGPointMake(0.0, 0.0);
//            end = CGPointMake(imgSize.width, 0.0);
//            break;
//        case GradientTypeUpleftToLowright:
//            start = CGPointMake(0.0, 0.0);
//            end = CGPointMake(imgSize.width, imgSize.height);
//            break;
//        case GradientTypeUprightToLowleft:
//            start = CGPointMake(imgSize.width, 0.0);
//            end = CGPointMake(0.0, imgSize.height);
//            break;
//        default:
//            break;
//    }
//
//    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    CGGradientRelease(gradient);
//    CGContextRestoreGState(context);
//    CGColorSpaceRelease(colorSpace);
//    UIGraphicsEndImageContext();
//
//    return [UIColor colorWithPatternImage:image];
//}
//给button添加默认的渐变背景颜色
+ (void)setButtColor:(UIButton *)butt withFrame:(CGRect)frame{
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = frame;
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)COLOR_WITH_HEX(0x1CC186).CGColor,(__bridge id)COLOR_WITH_HEX(0x2CB63F).CGColor];
    gl.locations = @[@(0),@(1.0f)];
//    [butt.layer addSublayer:gl];
    [butt.layer insertSublayer:gl atIndex:0];
}

// 判断是否白屏
+ (void)judgeLoadingStatus:(WKWebView *)webview  withBlock:(void (^)(webviewLoadingStatus status))completionBlock{
//    webviewLoadingStatus __block status = WebViewPendStatus;
//    if (@available(iOS 11.0, *)) {
//        if (webview && [webview isKindOfClass:[WKWebView class]]) {
//            CGFloat statusBarHeight =  [[UIApplication sharedApplication] statusBarFrame].size.height; //状态栏高度
//            CGFloat navigationHeight = webview.viewContainingController.navigationController.navigationBar.frame.size.height; //导航栏高度
//            WKSnapshotConfiguration *shotConfiguration = [[WKSnapshotConfiguration alloc] init];
//            shotConfiguration.rect = CGRectMake(0, statusBarHeight + navigationHeight, webview.bounds.size.width, (webview.bounds.size.height - navigationHeight - statusBarHeight)); //仅截图检测导航栏以下部分内容
//            [webview takeSnapshotWithConfiguration:shotConfiguration completionHandler:^(UIImage * _Nullable snapshotImage, NSError * _Nullable error) {
//                if (snapshotImage) {
////                    CGImageRef imageRef = snapshotImage.CGImage;
////                    UIImage * scaleImage = [self scaleImage:snapshotImage];
//                    BOOL isWhiteScreen = [self searchEveryPixel:snapshotImage];
////                    BOOL isWhiteScreen = [self judgePureColor:snapshotImage];
//                    if (isWhiteScreen) {
//                       status = WebViewErrorStatus;
//                    }else{
//                       status = WebViewNormalStatus;
//                    }
//                }
//                if (completionBlock) {
//                    completionBlock(status);
//                }
//            }];
//        }
//    }
}




//#pragma mark --- 判断是否是一个纯色图片
/**
 判断是否是一个纯色图片
 @param image 目标图片
 @return 返回值
 */
//+(BOOL)judgePureColor:(UIImage*)image{
//
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
//    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
//#else
//    int bitmapInfo = kCGImageAlphaPremultipliedLast;
//#endif
//
//    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
////    CGSize thumbSize=CGSizeMake(40, 40);
//
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(NULL,
//                                                 image.size.width,
//                                                 image.size.height,
//                                                 8,//bits per component
//                                                 image.size.width*4,
//                                                 colorSpace,
//                                                 bitmapInfo);
//
//    CGRect drawRect = CGRectMake(0, 0, image.size.width, image.size.height);
//    CGContextDrawImage(context, drawRect, image.CGImage);
//    CGColorSpaceRelease(colorSpace);
//
//    //第二步 取每个点的像素值
//    unsigned char* data = CGBitmapContextGetData (context);
//
//    if (data == NULL) return YES;
//
//    int temp_r =  data[0],temp_g = data[1],temp_b = data[2];
//
//    BOOL flag = NO;
//    for (int x=0; x<image.size.width*image.size.height; x++) {
//
//        int offset = 4*x;
//        int red = data[offset];
//        int green = data[offset+1];
//        int blue = data[offset+2];
//        //        int alpha =  data[offset+3];
//        //
//        //        NSLog(@"r == %d",red);
//        //        NSLog(@"g == %d",green);
//        //        NSLog(@"b == %d",blue);
//
//        if (red == temp_r && green == temp_g && temp_b == blue) {
//            //颜色相同仍然继续
//            flag = YES;
//        }else{
//            //颜色不同---停止
//            flag = NO;
//            break;
//        }
//        temp_r = red;
//        temp_g = green;
//        temp_b = blue;
//    }
//    CGContextRelease(context);
//
//    return flag;
//}


//对数量进行处理超过1万的用 w表示
+ (NSString *)changeNum:(NSString *_Nonnull)str{
    
    str = [Utils getTextWithModelStr:str];
    if (str.length == 0) {
        
        return @"0";
    }
    
    if ([str doubleValue] >= 10000.0) {//大于1万用w做单位
        
        double num = [str doubleValue]/10000.0;
        NSString *numStr = [NSString stringWithFormat:@"%.2f",num];
        
        //去掉最后一位小数，避免四舍五入
        numStr = [numStr substringToIndex:numStr.length-1];
        numStr = [Utils changeFloat:numStr];//去掉小数尾部的0
        str = [NSString stringWithFormat:@"%@w+",numStr];
        return str;
    }
    return str;
}
  

//// 遍历像素点 白色像素占比大于95%认定为白屏
+ (BOOL)searchEveryPixel:(UIImage *)image {

    CGImageRef cgImage = [image CGImage];
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage); //每个像素点包含r g b a 四个字节
    size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);

    CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    UInt8 * buffer = (UInt8*)CFDataGetBytePtr(data);

    int whiteCount = 0;
    int totalCount = 0;

    for (int j = 0; j < height; j ++ ) {
        for (int i = 0; i < width; i ++) {
            UInt8 * pt = buffer + j * bytesPerRow + i * (bitsPerPixel / 8);
            UInt8 red   = * pt;
            UInt8 green = *(pt + 1);
            UInt8 blue  = *(pt + 2);
            UInt8 alpha = *(pt + 3);

            totalCount ++;
            if (red == 255 && green == 255 && blue == 255) {
                whiteCount ++;
            }
        }
    }
    float proportion = (float)whiteCount / totalCount ;
    NSLog(@"当前像素点数：%d,白色像素点数:%d , 占比: %f",totalCount , whiteCount , proportion );
    if([[self getDeviceModelName] containsString:@"iPhone 5"] || [[self getDeviceModelName] containsString:@"iPhone 6"]){
        if (proportion >=  1.0) {
            return YES;
        }else{
            return NO;
        }
    }else{
        if (proportion >= 0.72) {
            return YES;
        }else{
            return NO;
        }
    }
    
}


 
////// 遍历像素点 白色像素占比大于95%认定为白屏
//+ (BOOL)searchEveryPixel:(UIImage *)image {
//
//    CGImageRef cgImage = [image CGImage];
//    size_t width = CGImageGetWidth(cgImage);
//    size_t height = CGImageGetHeight(cgImage);
//    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage); //每个像素点包含r g b a 四个字节
//    size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
//
//    CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
//    CFDataRef data = CGDataProviderCopyData(dataProvider);
//    UInt8 * buffer = (UInt8*)CFDataGetBytePtr(data);
//    int r =  1000;
//    int g =  1000;
//    int b =  1000;
//
//    for (int j = 0; j < height; j ++ ) {
//        for (int i = 0; i < width; i ++) {
//            UInt8 * pt = buffer + j * bytesPerRow + i * (bitsPerPixel / 8);
//            UInt8 red   = * pt;
//            UInt8 green = *(pt + 1);
//            UInt8 blue  = *(pt + 2);
//
//            if (r == 1000) {//记录第一组的像素
//
//                r = red;
//                g = green;
//                b = blue;
//            }else{
//
//                if (r == red && g == green && b == blue) {//后面的和第一次的都相同
//
//                }else{//有和第一次的不同,不是纯色，不是白屏
//
//                    return NO;
//                }
//            }
//        }
//    }
//    return YES;
//}

//// 遍历像素点 白色像素占比大于95%认定为白屏
//+ (BOOL)searchEveryPixel:(UIImage *)image {
//
//    CGImageRef cgImage = [image CGImage];
//    size_t width = CGImageGetWidth(cgImage);
//    size_t height = CGImageGetHeight(cgImage);
//    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage); //每个像素点包含r g b a 四个字节
//    size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
//
//    CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
//    CFDataRef data = CGDataProviderCopyData(dataProvider);
//    UInt8 * buffer = (UInt8*)CFDataGetBytePtr(data);
//
//    int whiteCount = 0;
//    int totalCount = 0;
//
//    for (int j = 0; j < height; j ++ ) {
//        for (int i = 0; i < width; i ++) {
//            UInt8 * pt = buffer + j * bytesPerRow + i * (bitsPerPixel / 8);
//            UInt8 red   = * pt;
//            UInt8 green = *(pt + 1);
//            UInt8 blue  = *(pt + 2);
////            UInt8 alpha = *(pt + 3);
//
//            totalCount ++;
//            if (red == 255 && green == 255 && blue == 255) {
//                whiteCount ++;
//            }
//        }
//    }
//    float proportion = (float)whiteCount / totalCount ;
//    NSLog(@"当前像素点数：%d,白色像素点数:%d , 占比: %f",totalCount , whiteCount , proportion );
//    if (proportion >= 1.0) {//全白屏
//        return YES;
//    }else{
//        return NO;
//    }
//}
 
//缩放图片
+ (UIImage *)scaleImage: (UIImage *)image {
    CGFloat scale = 0.2;
    CGSize newsize;
    newsize.width = floor(image.size.width * scale);
    newsize.height = floor(image.size.height * scale);
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer * renderer = [[UIGraphicsImageRenderer alloc] initWithSize:newsize];
          return [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                        [image drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
                 }];
    }else{
        return image;
    }
}

/// 获取设备型号，该型号就是 设置->通用->关于手机->型号名称
+ (NSString *)getDeviceModelName {
    struct utsname systemInfo;
    
    if (uname(&systemInfo) < 0) {
        return @"";
    } else {
        // 获取设备标识Identifier
        NSString *deviceIdentifer = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        // 根据identifier去匹配到对应的型号名称
        NSString *modelName = [[self modelList] objectForKey:deviceIdentifer];
        return modelName?:@"";
    }
}

/// 只列出了iphone、ipad和simulator的型号，其他设备型号请到 https://www.theiphonewiki.com/wiki/Models 查看
+ (NSDictionary *)modelList {
    // @{identifier: name}
    return @{
        // iPhone
        @"iPhone1,1" : @"iPhone",
        @"iPhone1,2" : @"iPhone 3G",
        @"iPhone2,1" : @"iPhone 3GS",
        @"iPhone3,1" : @"iPhone 4",
        @"iPhone3,2" : @"iPhone 4",
        @"iPhone3,3" : @"iPhone 4",
        @"iPhone4,1" : @"iPhone 4S",
        @"iPhone5,1" : @"iPhone 5",
        @"iPhone5,2" : @"iPhone 5",
        @"iPhone5,3" : @"iPhone 5c",
        @"iPhone5,4" : @"iPhone 5c",
        @"iPhone6,1" : @"iPhone 5s",
        @"iPhone6,2" : @"iPhone 5s",
        @"iPhone7,2" : @"iPhone 6",
        @"iPhone7,1" : @"iPhone 6 Plus",
        @"iPhone8,1" : @"iPhone 6s",
        @"iPhone8,2" : @"iPhone 6s Plus",
        @"iPhone8,4" : @"iPhone SE (1st generation)",
        @"iPhone9,1" : @"iPhone 7",
        @"iPhone9,3" : @"iPhone 7",
        @"iPhone9,2" : @"iPhone 7 Plus",
        @"iPhone9,4" : @"iPhone 7 Plus",
        @"iPhone10,1" : @"iPhone 8",
        @"iPhone10,4" : @"iPhone 8",
        @"iPhone10,2" : @"iPhone 8 Plus",
        @"iPhone10,5" : @"iPhone 8 Plus",
        @"iPhone10,3" : @"iPhone X",
        @"iPhone10,6" : @"iPhone X",
        @"iPhone11,8" : @"iPhone XR",
        @"iPhone11,2" : @"iPhone XS",
        @"iPhone11,6" : @"iPhone XS Max",
        @"iPhone11,4" : @"iPhone XS Max",
        @"iPhone12,1" : @"iPhone 11",
        @"iPhone12,3" : @"iPhone 11 Pro",
        @"iPhone12,5" : @"iPhone 11 Pro Max",
        @"iPhone12,8" : @"iPhone SE (2nd generation)",
        @"iPhone13,1" : @"iPhone 12 mini",
        @"iPhone13,2" : @"iPhone 12",
        @"iPhone13,3" : @"iPhone 12 Pro",
        @"iPhone13,4" : @"iPhone 12 Pro Max",
        @"iPhone14,4" : @"iPhone 13 mini",
        @"iPhone14,5" : @"iPhone 13",
        @"iPhone14,2" : @"iPhone 13 Pro",
        @"iPhone14,3" : @"iPhone 13 Pro Max",
        @"iPhone14,6" : @"iPhone SE (3rd generation)",
        // iPad
        @"iPad1,1" : @"iPad",
        @"iPad2,1" : @"iPad 2",
        @"iPad2,2" : @"iPad 2",
        @"iPad2,3" : @"iPad 2",
        @"iPad2,4" : @"iPad 2",
        @"iPad3,1" : @"iPad (3rd generation)",
        @"iPad3,2" : @"iPad (3rd generation)",
        @"iPad3,3" : @"iPad (3rd generation)",
        @"iPad3,4" : @"iPad (4th generation)",
        @"iPad3,5" : @"iPad (4th generation)",
        @"iPad3,6" : @"iPad (4th generation)",
        @"iPad6,11" : @"iPad (5th generation)",
        @"iPad6,12" : @"iPad (5th generation)",
        @"iPad7,5" : @"iPad (6th generation)",
        @"iPad7,6" : @"iPad (6th generation)",
        @"iPad7,11" : @"iPad (7th generation)",
        @"iPad7,12" : @"iPad (7th generation)",
        @"iPad11,6" : @"iPad (8th generation)",
        @"iPad11,7" : @"iPad (8th generation)",
        @"iPad12,1" : @"iPad (9th generation)",
        @"iPad12,2" : @"iPad (9th generation)",
        @"iPad4,1" : @"iPad Air",
        @"iPad4,2" : @"iPad Air",
        @"iPad4,3" : @"iPad Air",
        @"iPad5,3" : @"iPad Air 2",
        @"iPad5,4" : @"iPad Air 2",
        @"iPad11,3" : @"iPad Air (3rd generation)",
        @"iPad11,4" : @"iPad Air (3rd generation)",
        @"iPad13,1" : @"iPad Air (4th generation)",
        @"iPad13,2" : @"iPad Air (4th generation)",
        @"iPad13,16" : @"iPad Air (5th generation)",
        @"iPad13,17" : @"iPad Air (5th generation)",
        @"iPad6,7" : @"iPad Pro (12.9-inch)",
        @"iPad6,8" : @"iPad Pro (12.9-inch)",
        @"iPad6,3" : @"iPad Pro (9.7-inch)",
        @"iPad6,4" : @"iPad Pro (9.7-inch)",
        @"iPad7,1" : @"iPad Pro (12.9-inch) (2nd generation)",
        @"iPad7,2" : @"iPad Pro (12.9-inch) (2nd generation)",
        @"iPad7,3" : @"iPad Pro (10.5-inch)",
        @"iPad7,4" : @"iPad Pro (10.5-inch)",
        @"iPad8,1" : @"iPad Pro (11-inch)",
        @"iPad8,2" : @"iPad Pro (11-inch)",
        @"iPad8,3" : @"iPad Pro (11-inch)",
        @"iPad8,4" : @"iPad Pro (11-inch)",
        @"iPad8,5" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,6" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,7" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,8" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,9" : @"iPad Pro (11-inch) (2nd generation)",
        @"iPad8,10" : @"iPad Pro (11-inch) (2nd generation)",
        @"iPad8,11" : @"iPad Pro (12.9-inch) (4th generation)",
        @"iPad8,12" : @"iPad Pro (12.9-inch) (4th generation)",
        @"iPad13,4" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,5" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,6" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,7" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,8" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad13,9" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad13,10" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad13,11" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad2,5" : @"iPad mini",
        @"iPad2,6" : @"iPad mini",
        @"iPad2,7" : @"iPad mini",
        @"iPad4,4" : @"iPad mini 2",
        @"iPad4,5" : @"iPad mini 2",
        @"iPad4,6" : @"iPad mini 2",
        @"iPad4,7" : @"iPad mini 3",
        @"iPad4,8" : @"iPad mini 3",
        @"iPad4,9" : @"iPad mini 3",
        @"iPad5,1" : @"iPad mini 4",
        @"iPad5,2" : @"iPad mini 4",
        @"iPad11,1" : @"iPad mini (5th generation)",
        @"iPad11,2" : @"iPad mini (5th generation)",
        @"iPad14,1" : @"iPad mini (6th generation)",
        @"iPad14,2" : @"iPad mini (6th generation)",
        // 其他
        @"i386" : @"iPhone Simulator",
        @"x86_64" : @"iPhone Simulator",
    };
}
//获取手机系统版本号村
+(NSString *)getSystemVersion{
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本(phoneVersion)：%@",phoneVersion);
    return phoneVersion;
}



//解析gif文件数据的方法 block中会将解析的数据传递出来
+(void)getGifImageWithUrk:(NSURL *)url returnData:(void(^)(NSArray<UIImage *> * imageArray, NSArray<NSNumber *>*timeArray,CGFloat totalTime, NSArray<NSNumber *>* widths,NSArray<NSNumber *>* heights))dataBlock{
    //通过文件的url来将gif文件读取为图片数据引用
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    //获取gif文件中图片的个数
    size_t count = CGImageSourceGetCount(source);
    //定义一个变量记录gif播放一轮的时间
    float allTime=0;
    //存放所有图片
    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    //存放每一帧播放的时间
    NSMutableArray * timeArray = [[NSMutableArray alloc]init];
    //存放每张图片的宽度 （一般在一个gif文件中，所有图片尺寸都会一样）
    NSMutableArray * widthArray = [[NSMutableArray alloc]init];
    //存放每张图片的高度
    NSMutableArray * heightArray = [[NSMutableArray alloc]init];
    //遍历
    for (size_t i=0; i<count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        [imageArray addObject:(__bridge UIImage *)(image)];
        CGImageRelease(image);
        //获取图片信息
        NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
        CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
        [widthArray addObject:[NSNumber numberWithFloat:width]];
        [heightArray addObject:[NSNumber numberWithFloat:height]];
        NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
        allTime+=time;
        [timeArray addObject:[NSNumber numberWithFloat:time]];
    }
    dataBlock(imageArray,timeArray,allTime,widthArray,heightArray);
}

//为UIImageView添加一个设置gif图内容的方法：
+(void)yh_setImage:(NSURL *)imageUrl withImgView:(UIImageView *)imgView{
    
    [self getGifImageWithUrk:imageUrl returnData:^(NSArray<UIImage *> *imageArray, NSArray<NSNumber *> *timeArray, CGFloat totalTime, NSArray<NSNumber *> *widths, NSArray<NSNumber *> *heights) {
        //添加帧动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        NSMutableArray * times = [[NSMutableArray alloc]init];
        float currentTime = 0;
        //设置每一帧的时间占比
        for (int i=0; i<imageArray.count; i++) {
            [times addObject:[NSNumber numberWithFloat:currentTime/totalTime]];
            currentTime+=[timeArray[i] floatValue];
        }
        [animation setKeyTimes:times];
        [animation setValues:imageArray];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        //设置循环
        animation.repeatCount= MAXFLOAT;//
        //设置播放总时长
        animation.duration = totalTime;
        //Layer层添加
        [imgView.layer addAnimation:animation forKey:@"gifAnimation"];
    }];
}


//存储日志信息
+ (void)saveLogMessage:(NSString *_Nullable)date withTitle:(NSString *_Nonnull)title withContent:(NSString *_Nullable)content withCode:(NSString *_Nullable)code{
    
    if ([self getTextWithModelStr:content].length == 0) {
        //没有内容，不保存
        return;
    }
    DBManager *db = [DBManager shareInstance];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title=%@&&content=%@&&code=%@",title,content,code];
    NSArray *arr = [db queryWithEntityName:@"LogMessage" withPredicate:predicate];
    
    if (arr.count > 0) {//更新日志
        
        for (LogMessage *meg in arr) {

            meg.date = date;
            [db updateMO:meg];
        }
    }else{//新增日志
        
        //对图片data等较大内容进行裁剪，
        content = [self getTextWithModelStr:content];
        if (content.length > 50000) {
            
            content = [content substringToIndex:50000];
        }
        LogMessage *message = (LogMessage *)[db createMO:@"LogMessage"];
        message.date = [self getTextWithModelStr:date];
        message.title = [self getTextWithModelStr:title];
        message.content = content;
        message.code = [self getTextWithModelStr:code];
        
        [db addManagerObject:message];
    }
}

//获取全部日志信息
+ (NSArray *_Nullable)getAllLogMessage{
    
    DBManager *db = [DBManager shareInstance];
    NSArray *arr = [db queryWithEntityName:@"LogMessage" withPredicate:nil];
    return arr;
    
    return @[];
}




+(void)getThankLetter{
    
}


@end
