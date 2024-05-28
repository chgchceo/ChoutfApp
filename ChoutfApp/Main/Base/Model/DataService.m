//
//  DataService.m
//  RegisterDemo
//
//  Created by chgch on 17/7/11.
//  Copyright (c) 2017年 chgch. All rights reserved.
//
//



#import "DataService.h"
#import "header.h"
#import <AFNetworking/AFNetworking.h>



@implementation  DataService

//普通请求（GET/POST）
+ (NSURLSessionDataTask *)reqOtherDataWithURL:(NSString *)stringURL
                                  withMethod:(NSString *)method
                                 withParames:(NSMutableDictionary *)parames
                                   withBlock:(RequestBlock)block{


        //0.取得本地保存的token
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults objectForKey:@"token"];
        //将token添加到请求参数中
        if (token == nil){
            token = @"";
        }

    [parames setObject:token forKey:@"token"];
    [parames setObject:[Utils getSystemVersion] forKey:@"deviceVersion"];
    [parames setObject:[Utils getDeviceModelName] forKey:@"deviceName"];
    NSURLSessionDataTask *task = nil;

    //（1）获取URL
    if (![stringURL containsString:@"http"]) {

        stringURL = [BASE_URL stringByAppendingString:stringURL];

    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.allowsCellularAccess = YES;
    config.HTTPMaximumConnectionsPerHost = 20;

    //（2）创建manager对象
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    
    //（3）设置请求参数的拼接格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //（4）设置响应数据的解析方式
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置超时时间
    stringURL = [stringURL  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];

    NSString * str2 = [NSString stringWithFormat:@"Bearer %@",token];

    str2 = [Utils getTextWithModelStr:str2];
    
    if(![stringURL containsString:@"/user/accountLogin"]){
        
        [manager.requestSerializer setValue:str2 forHTTPHeaderField:@"Authori-zation"];
        
    }
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [manager.requestSerializer setTimeoutInterval:30];
    //（5）请求
    //如果是POST请求
    if ([method isEqualToString:@"POST"]) {
        
        task = [manager POST:stringURL parameters:parames headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            //释放
            [manager.session finishTasksAndInvalidate];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {

                block(responseObject);

            }else{

                NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

                NSString *status = [dic objectForKey:@"code"];
                status = [Utils getTextWithModelStr:status];
                //token失效
                if(dic == nil ){
                    
                    block(str);
                }else{
                    
                    block(dic);
                }
                if ([status isEqualToString:@"666"]) {
                    
                    [self loginButtAction];
                }
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"服务器的错误原因:%@",str);
            NSDictionary *dic = @{
                @"status":@(404),
                @"msg":@"数据加载失败，请检查网络是否连接",
                @"code":@"1"
            };
            //释放
            [manager.session finishTasksAndInvalidate];
            block(dic);
        }];
        
    }else if([method isEqualToString:@"GET"]){

        task = [manager GET:stringURL parameters:parames headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            //释放
            [manager.session finishTasksAndInvalidate];
            //返回解析的数据
            if ([responseObject isKindOfClass:[NSDictionary class]]) {

                block(responseObject);

            }else{

                NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

                NSString *status = [dic objectForKey:@"code"];
                status = [Utils getTextWithModelStr:status];
                //token失效
                if(dic == nil ){
                    
                    block(str);
                }else{
                    
                    block(dic);
                }
                if ([status isEqualToString:@"666"]) {
                    
                    [self loginButtAction];
                }
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //释放
            [manager.session finishTasksAndInvalidate];
            NSDictionary *dic = @{
                
                @"status":@(404),
                @"msg":@"数据加载失败，请检查网络是否连接",
                @"code":@"1"
            };
            block(dic);
        }];
    }
    return task;
}

//普通请求（GET/POST）
+ (NSURLSessionDataTask *)requestDataWithURL:(NSString *)stringURL
                                  withMethod:(NSString *)method
                                 withParames:(NSMutableDictionary *)parames
                                   withBlock:(RequestBlock)block{


//        //0.取得本地保存的token
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *token = [defaults objectForKey:@"token"];
//        //将token添加到请求参数中
//        if (token == nil){
//            token = @"";
//        }
//    if ([stringURL containsString:@"getPhoneCode"]) {
//
//    }else{
//
//        [parames setObject:token forKey:@"token"];
//    }
//    [parames setObject:[Utils getSystemVersion] forKey:@"deviceVersion"];
//    [parames setObject:[Utils getDeviceModelName] forKey:@"deviceName"];
    NSURLSessionDataTask *task = nil;

    //（1）获取URL
    if (![stringURL containsString:@"http"]) {

        stringURL = [BASE_URL stringByAppendingString:stringURL];

    }

    //（2）创建manager对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //忽略无效证书
    // 是否允许无效证书, 默认为NO
    manager.securityPolicy.allowInvalidCertificates = YES;
    // 是否校验域名, 默认为YES
    manager.securityPolicy.validatesDomainName = NO;
    
    //（3）设置请求参数的拼接格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //（4）设置响应数据的解析方式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置超时时间
    stringURL = [stringURL  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];

//    NSString * str2 = [NSString stringWithFormat:@"%@",token];
//
//    if(![stringURL containsString:@"getPhoneCode"]){
//        [manager.requestSerializer setValue:str2 forHTTPHeaderField:@"token"];
//    }
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"content-type"];
    
    [manager.requestSerializer setTimeoutInterval:30];
    //（5）请求
    //如果是POST请求
    if ([method isEqualToString:@"POST"]) {
        
        task = [manager POST:stringURL parameters:parames headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            //释放
            [manager.session finishTasksAndInvalidate];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {

                block(responseObject);

            }else{

                NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

                NSString *status = [dic objectForKey:@"code"];
                status = [Utils getTextWithModelStr:status];
                //token失效
                if(dic == nil ){
                    
                    block(str);
                }else{
                    
                    block(dic);
                }
                if ([status isEqualToString:@"666"]) {
                    
                    [self loginButtAction];
                }
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"服务器的错误原因:%@",str);
            NSDictionary *dic = @{
                
                @"status":@(404),
                @"msg":@"数据加载失败，请检查网络是否连接",
                @"code":@"1"
            };
            //释放
            [manager.session finishTasksAndInvalidate];
            block(dic);
        }];
        
    }else if([method isEqualToString:@"GET"]){

        task = [manager GET:stringURL parameters:parames headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            //释放
            [manager.session finishTasksAndInvalidate];
            //返回解析的数据
            if ([responseObject isKindOfClass:[NSDictionary class]]) {

                block(responseObject);

            }else{

                NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

                NSString *status = [dic objectForKey:@"code"];
                status = [Utils getTextWithModelStr:status];
                //token失效
                if(dic == nil ){
                    
                    block(str);
                }else{
                    
                    block(dic);
                }
                if ([status isEqualToString:@"666"]) {
                    
                    [self loginButtAction];
                }
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
            block(error);
//            //释放
//            [manager.session finishTasksAndInvalidate];
//            NSDictionary *dic = @{
//
//                @"status":@(404),
//                @"msg":@"数据加载失败，请检查网络是否连接",
//                @"code":@"1"
//            };
//            block(dic);
        }];
    }
    return task;
}

+ (NSURLSessionDataTask *)reqDataWithURL:(NSString *)stringURL
                              withMethod:(NSString *)method
                             withParames:(id)parames
                               withBlock:(RequestBlock)block {

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];

    [headers setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];

    token = [Utils getTextWithModelStr:token];
    [parames setObject:token forKey:@"token"];
    [parames setObject:[Utils getSystemVersion] forKey:@"deviceVersion"];
    [parames setObject:[Utils getDeviceModelName] forKey:@"deviceName"];
    if(![stringURL containsString:@"http"]){

        stringURL = [BASE_URL stringByAppendingString:stringURL];
    }

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parames options:NSJSONWritingPrettyPrinted error:nil];
    
    request.URL = [NSURL URLWithString:stringURL];
    request.HTTPMethod = method;
    [request setAllHTTPHeaderFields:headers];
    
    if ([method isEqualToString:@"POST"]) {
        
        [request setHTTPBody:jsonData];
        
    }
    
    request.timeoutInterval = 30;
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){

        //释放
        [session finishTasksAndInvalidate];
        if(error == nil){//请求成功

            NSError *error1;
            NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

            if(error1 == nil){//解析成功

                dispatch_async(dispatch_get_main_queue(), ^{
                    block(dic);

                });
            }else{

                dispatch_async(dispatch_get_main_queue(), ^{

                    block(@"");
//                    [Utils showMessage:@"请求失败，请检查网络是否连接!"];
                });
            }
        }else{//请求失败
            dispatch_async(dispatch_get_main_queue(), ^{

                block(@"");
                
//                [Utils showMessage:@"请求失败，请检查网络是否连接!"];
            });
        }
    }];

    [task resume];
    return task;
}

+ (void)upLoadImge:(NSArray *)array withURL:(NSString *)url withParames:(NSMutableDictionary *)parames
         withBlock:(RequestBlock)block{
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     
        //ContentType设置
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",@"application/xml",@"text／plain",nil];
     
    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
        manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString * str2 = [NSString stringWithFormat:@"Bearer %@",token];

    str2 = [Utils getTextWithModelStr:str2];
    [manager.requestSerializer setValue:str2 forHTTPHeaderField:@"Authori-zation"];
    [parames setObject:[Utils getSystemVersion] forKey:@"deviceVersion"];
    [parames setObject:[Utils getDeviceModelName] forKey:@"deviceName"];
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];

    [headers setObject:@"multipart/form-data;" forKey:@"content-type"];
    
    [manager POST:url parameters:parames headers:headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        for(int i = 0;i < array.count; i ++){
            UIImage *image = array[i];
            NSData *data = UIImageJPEGRepresentation(image, 1.0f);
            NSData * imageData = data;
            // 上传的参数
            NSString * Name = @"file";

            NSString * fileName = @"file.jpeg";
            if (imageData != nil) {

                [formData appendPartWithFileData:imageData name:Name fileName:fileName mimeType:@"image/jpeg"];
            }
        }
        
        } progress:^(NSProgress * _Nonnull uploadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            //释放
            [manager.session finishTasksAndInvalidate];
            //返回解析的数据
            if ([responseObject isKindOfClass:[NSDictionary class]]) {

                block(responseObject);

            }else{

                NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

                NSString * str2 = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];

                str2 = [str2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];

                str2 = [str2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];

                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str2 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

                block(dic);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {


            //释放
            [manager.session finishTasksAndInvalidate];
            NSDictionary *dic = @{
                @"status":@(404),
                @"msg":@"数据加载失败，请检查网络是否连接",
                @"code":@"1"
            };
            block(dic);
        }];
    
}

+ (void)upLoadVideo:(NSData *)data withURL:(NSString *)url withParames:(NSMutableDictionary *)parames
          withBlock:(RequestBlock)block;{
    
    NSMutableData * bodyData = [NSMutableData data];
    for(NSString*key in parames.allKeys) {
        
        id value = [parames objectForKey:key];
        [bodyData appendData:[[NSString stringWithFormat:@"--%@\r\n",@"POST_BOUNDS"]
                              dataUsingEncoding:NSUTF8StringEncoding]];
        
        [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [bodyData appendData:[[NSString stringWithFormat:@"%@\r\n",value] dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    NSString *fileName=@"file";
    [bodyData appendData:[[NSString stringWithFormat:@"--%@\r\n",@"POST_BOUNDS"]dataUsingEncoding:NSUTF8StringEncoding]];
    
    [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.mp4\"\r\n",fileName,@"files"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [bodyData appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n",@"video/mp4"]dataUsingEncoding:NSUTF8StringEncoding]];
    
    [bodyData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [bodyData appendData:data];
    [bodyData appendData:[[NSString stringWithFormat:@"\r\n"]dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 添加尾部分隔线
    
    [bodyData appendData:[[NSString stringWithFormat:@"--%@--\r\n",@"POST_BOUNDS"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    [request addValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",@"POST_BOUNDS"] forHTTPHeaderField:@"Content-Type"];
    
    [request addValue: [NSString stringWithFormat:@"%zd",data.length] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:bodyData];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString * str2 = [NSString stringWithFormat:@"Bearer %@",token];
    
    str2 = [Utils getTextWithModelStr:str2];
    [request setValue:str2 forHTTPHeaderField:@"Authori-zation"];
    [parames setObject:[Utils getSystemVersion] forKey:@"deviceVersion"];
    [parames setObject:[Utils getDeviceModelName] forKey:@"deviceName"];
    [request setValue:@"好天气" forHTTPHeaderField:@"context"];
    AFURLSessionManager*manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //忽略无效证书
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [[manager uploadTaskWithRequest:request fromData:bodyData progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                
        
                //释放
                [manager.session finishTasksAndInvalidate];
                if (error == nil) {
                    
                    block(responseObject);
                }else{
                    
                    block(error);
                }
                
            }] resume];
    
}

//跳转登录界面,登录超时
+ (void)loginButtAction{
    if ([Utils isLoginIn]) {
        [self performSelector:@selector(exitSuccess) withObject:nil afterDelay:0];
    }
}
//超时登录，被顶下，token失效
+ (void)exitSuccess{
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"token"];
//        [User shareInstance].villageName = @"";
//        [User shareInstance].townName = @"";
//        [User shareInstance].countyName = @"";
//        [User shareInstance].villageId = @"";
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        LSTabbarController *root = (LSTabbarController *)window.rootViewController;
//        if (![root isKindOfClass:[LSTabbarController class]]) {
//
//            return;
//        }
//        [root _initTabBar: 0];//回到首页
//    });
}


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
              failure:(void(^)(NSError *error))failure {
    [dicData setObject:[Utils getSystemVersion] forKey:@"deviceVersion"];
    [dicData setObject:[Utils getDeviceModelName] forKey:@"deviceName"];
    NSURL*url = [NSURL URLWithString:modelurl];
    NSMutableData * bodyData = [NSMutableData data];
    for(NSString*key in dicData.allKeys) {
        
        id value = [dicData objectForKey:key];
        [bodyData appendData:[[NSString stringWithFormat:@"--%@\r\n",@"POST_BOUNDS"]
                              dataUsingEncoding:NSUTF8StringEncoding]];
        
        [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [bodyData appendData:[[NSString stringWithFormat:@"%@\r\n",value] dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    for(NSInteger i = 0; i < images.count; i++) {
        
        UIImage* keyN = images[i];
        NSString*suffix,*contentType;
        NSData* imageData;

        if(UIImageJPEGRepresentation(keyN,1.0)) {
            
            //返回为JPEG图像。
            
            imageData =UIImageJPEGRepresentation(keyN,0.6);
            suffix =@"jpg";
            contentType =@"image/jpeg";
            
        }else{
            
            //返回为png图像。
            
            imageData =UIImagePNGRepresentation(keyN);
            suffix =@"png";
            contentType =@"image/png";
            
        }

        NSString *fileName=@"file";
        [bodyData appendData:[[NSString stringWithFormat:@"--%@\r\n",@"POST_BOUNDS"]dataUsingEncoding:NSUTF8StringEncoding]];

        [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@%ld.jpeg\"\r\n",fileName,imageName,(long)i] dataUsingEncoding:NSUTF8StringEncoding]];

        [bodyData appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n",contentType]dataUsingEncoding:NSUTF8StringEncoding]];

        [bodyData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

        [bodyData appendData:imageData];
        [bodyData appendData:[[NSString stringWithFormat:@"\r\n"]dataUsingEncoding:NSUTF8StringEncoding]];

        // 添加尾部分隔线
        [bodyData appendData:[[NSString stringWithFormat:@"--%@--\r\n",@"POST_BOUNDS"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    [request addValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",@"POST_BOUNDS"] forHTTPHeaderField:@"Content-Type"];
    
    [request addValue: [NSString stringWithFormat:@"%zd",bodyData.length] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:bodyData];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString * str2 = [NSString stringWithFormat:@"Bearer %@",token];
    
    str2 = [Utils getTextWithModelStr:str2];
    [request setValue:str2 forHTTPHeaderField:@"Authori-zation"];
    
    AFURLSessionManager*manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //忽略无效证书
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [[manager uploadTaskWithRequest:request fromData:bodyData progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                
        
                //释放
                [manager.session finishTasksAndInvalidate];
                if (error == nil) {
                    
                    success(responseObject);
                }else{
                    
                    failure(error);
                }
                
            }] resume];
    
}

+ (void)upLoadImage:(NSArray *)images withUrl:(NSString *)url with:(NSMutableDictionary *)parames withBlock:(RequestBlock)block{
 
    NSString *temp = url;
    [parames setObject:[Utils getSystemVersion] forKey:@"deviceVersion"];
    [parames setObject:[Utils getDeviceModelName] forKey:@"deviceName"];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:temp parameters:parames constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        for (int i = 0; i < images.count; i ++) {
            
            UIImage *image = images[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 1); //0.5是压缩的比例
            NSString *name = @"file";
            [formData appendPartWithFileData:imageData name:name fileName:@"file.jpeg" mimeType:@"image/jpeg"];
            
        }
        
    } error:nil];

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString * str2 = [NSString stringWithFormat:@"Bearer %@",token];

    str2 = [Utils getTextWithModelStr:str2];
    [request setValue:str2 forHTTPHeaderField:@"Authori-zation"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //忽略无效证书
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;

    //设置服务器返回内容的接受格式
    AFHTTPResponseSerializer *responseSer = [AFHTTPResponseSerializer serializer];
    responseSer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",@"application/xml",@"text／plain",nil];
    manager.responseSerializer = responseSer;

    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        //释放
        [manager.session finishTasksAndInvalidate];
        if (responseObject == nil) {
            
            NSDictionary *dic = @{
                
                @"status":@(404),
                @"msg":@"数据加载失败，请检查网络是否连接",
                @"code":@"1"
            };
            block(dic);
            
        }else{
            
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            block(dic);
        }
    }];

    [uploadTask resume];
}



+ (void)upLoadAudio:(NSData *)data withUrl:(NSString *)url with:(NSMutableDictionary *)parames withBlock:(RequestBlock)block{
    
    NSString *temp = url;
    [parames setObject:[Utils getSystemVersion] forKey:@"deviceVersion"];
    [parames setObject:[Utils getDeviceModelName] forKey:@"deviceName"];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:temp parameters:parames constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
//        for (int i = 0; i < images.count; i ++) {
            
            NSString *name = [NSString stringWithFormat:@"file%@",@"audio"];
            NSString *filename = [NSString stringWithFormat:@"filename%@.mp3",@"audio"];
            [formData appendPartWithFileData:data name:name fileName:filename mimeType:@"amr/mp3/wmr"];
            
//        }
        
    } error:nil];


    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString * str2 = [NSString stringWithFormat:@"Bearer %@",token];
    
    str2 = [Utils getTextWithModelStr:str2];
    [request setValue:str2 forHTTPHeaderField:@"Authori-zation"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //忽略无效证书
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    

    //设置服务器返回内容的接受格式
    AFHTTPResponseSerializer *responseSer = [AFHTTPResponseSerializer serializer];
    responseSer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.responseSerializer = responseSer;

    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        //释放
        [manager.session finishTasksAndInvalidate];
        if (responseObject == nil) {
            
            NSDictionary *dic = @{
                
                @"status":@(404),
                @"msg":@"数据加载失败，请检查网络是否连接",
                @"code":@"1"
            };
            block(dic);
            
        }else{
            
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            block(dic);
        }
        
        
    }];

    [uploadTask resume];
}


@end
