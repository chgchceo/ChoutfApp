//
//  DataService.h
//  RegisterDemo
//
//  Created by chgch on 15/7/11.
//  Copyright (c) 2015年 chgch. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef  void(^RequestBlock)(id _Nullable result);

@interface DataService : NSObject{
    
    
}
//普通请求（GET/POST）
+ (NSURLSessionDataTask *)reqOtherDataWithURL:(NSString *)stringURL
                                  withMethod:(NSString *)method
                                 withParames:(NSMutableDictionary *)parames
                                    withBlock:(RequestBlock)block;
//普通请求（GET/POST）
+ (NSURLSessionDataTask *)reqDataWithURL:(NSString *)stringURL
                withMethod:(id)method
               withParames:(id)parames
                 withBlock:(RequestBlock)block;


//
+ (NSURLSessionDataTask *)requestDataWithURL:(NSString *)stringURL
                                  withMethod:(NSString *)method
                                 withParames:(NSMutableDictionary *)parames
                                   withBlock:(RequestBlock)block;


//上传视频
+ (void)upLoadVideo:(NSData *)data withURL:(NSString *)url withParames:(NSMutableDictionary *)parames
          withBlock:(RequestBlock)block;




/**

 *  封装POST图片上传(多张图片) // 可扩展成多个别的数据上传如:mp3等

 *

 *  @parammodelurl  请求的链接

 *  @paramdicData    请求的参数

 *  @paramimages    存放图片数组

 *  @paramsuccess    发送成功的回调

 *  @paramfailure    发送失败的回调

 */

+ (void)multiPartPost:(NSMutableDictionary*)dicData andImageNames:(NSArray*)images
     andImageNamesKey:(NSString*)imageName URL:(nonnull NSString*)modelurl
              success:(void(^)(id json))success
              failure:(void(^)(NSError *error))failure;



//上传图片
+ (void)upLoadImage:(NSArray *)images withUrl:(NSString *)url with:(NSMutableDictionary *)parames withBlock:(RequestBlock)block;


//上传语音
+ (void)upLoadAudio:(NSData *)data withUrl:(NSString *)url with:(NSMutableDictionary *)parames withBlock:(RequestBlock)block;



@end







