//
//  PrinterPdfViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/11/27.
//

#import "PrinterPdfViewController.h"
#import "header.h"
#import "TZImagePickerController.h"

@interface PrinterPdfViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,CLLocationManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,MessageAlertViewControllerDelegate,MineViewControllerDelegate,UIPrintInteractionControllerDelegate>{
    
    WKUserContentController *_userCtrl;
    WKWebView *_webView;
    UIButton *_refreshButt;//刷新页面的按钮
    UIButton *_moreButt;//顶部更多按钮
    NSString *_currentUrlStr;//当前页面的链接
}


@end

@implementation PrinterPdfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showLoadingView:@""];
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:3];
    self.title = @"文件打印";
    self.view.backgroundColor = [UIColor clearColor];
    //默认值
    if(self.htmlStrl.length == 0){
        
        self.htmlStrl = H5_URL;
    }
    _currentUrlStr = self.htmlStrl;
    [self initView];
//    [self checkAppVersion];
    _webView.backgroundColor = [UIColor clearColor];
}
//检测是否有新版本
- (void)checkAppVersion{
    
    NSDictionary *dic = @{
        
        @"platform":@"0",//0:ios 1:android
        @"type":@"1",// 1:smart portal sales 2:查货系统
    };
    [DataService requestDataWithURL:@"SALES-PORTAL-API/api/common/getVersion" withMethod:@"GET" withParames:[dic mutableCopy] withBlock:^(id result) {

        if(![result isKindOfClass:[NSDictionary class]]){

            return;
        }
        NSInteger code = [[result objectForKey:@"code"] integerValue];
        if(code == 200){

            NSDictionary *data = [result objectForKey:@"data"];
            if([data isKindOfClass:[NSDictionary class]]){
                
                NSArray *records = [data objectForKey:@"records"];
                if(records.count > 0){
                    
                    NSDictionary *dict = records[0];
                    [self showAppUpdateView:dict];
                    
                }
            }
        }
    }];
}

- (void)showAppUpdateView:(NSDictionary *)dic{
    
    if(![dic isKindOfClass:[NSDictionary class]]){
        
        return;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSString *version = [Utils getTextWithModelStr:[dic objectForKey:@"version"]];
    NSString *description = [Utils getTextWithModelStr:[dic objectForKey:@"description"]];
    NSString *updateUrl = [Utils getTextWithModelStr:[dic objectForKey:@"updateUrl"]];
    BOOL forceUpdate = [[Utils getTextWithModelStr:[dic objectForKey:@"forceUpdate"]] boolValue];
    //版本不同，需要更新
    if(![version isEqualToString:app_Version]){
        
        BOOL need = [self isNeedUpdata:app_Version withNew:version];
        
        if(need){
            
            AppUpdateAlertViewController *alertCtrl = [[AppUpdateAlertViewController alloc] init];
            alertCtrl.forceUpdate = forceUpdate;
            alertCtrl.content = description;
            alertCtrl.version = version;
            alertCtrl.updateUrl = updateUrl;
            alertCtrl.modalPresentationStyle = 5;
            [self presentViewController:alertCtrl animated:NO completion:nil];
        }
    }
}

//对版本号进行比较，判断是否需要更新
- (BOOL)isNeedUpdata:(NSString *)version withNew:(NSString *)v{
    
    NSArray *arr1 = [version componentsSeparatedByString:@"."];
    NSMutableArray *arr = [arr1 mutableCopy];
    for (int i = 0; i < 4; i ++) {
        
        [arr addObject:@"0"];
    }
    NSArray *arr2 = [v componentsSeparatedByString:@"."];
    
    for (int i = 0; i < arr2.count; i ++) {
        
        NSInteger num1 = [arr[i] integerValue];//当前
        NSInteger num2 = [arr2[i] integerValue];//最新
        
        if(num2 > num1){//需要更新
            
            return YES;
        }else if (num2 < num1){//不更新
            
            return NO;
        }else{//相等时进入下一次循环比较
            
            
        }
    }
    
    return NO;
}


- (void)openConf{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];      switch (authStatus) {          case AVAuthorizationStatusNotDetermined:
            //            没有询问是否开启麦克风
            break;
        case AVAuthorizationStatusRestricted:          //未授权，家长限制
            break;
        case AVAuthorizationStatusDenied:         //玩家未授权
            break;
        case AVAuthorizationStatusAuthorized:         //玩家授权
            break;
        default:
            break;
            
    }
    //麦克风权限(一些操作需要回到主线程进行)
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted){
        
        if (!granted) { }else{}
    }];
    

    if(![self isCameraAuthorization]){
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                
                // 允许
            } else {
                // 拒绝
            }
        }];
    }
    
    if(![self isPhotoAuthorization]){
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                // 用户同意授权
            }else {
                // 用户拒绝授权
            }
            
        }];
    }
    
    BOOL isLocation = [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined;

    if(isLocation){
        
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    }
}

//相册权限申请
- (BOOL)isPhotoAuthorization{
    
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];

    if(photoAuthStatus == PHAuthorizationStatusAuthorized){
        
        return YES;
    }
    return NO;
}

//访问相机是否授权
- (BOOL)isCameraAuthorization {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusNotDetermined) {
        return NO;
    }
    return YES;
}

//打开了新的页面
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if(navigationAction.targetFrame == nil || !navigationAction.targetFrame.isMainFrame)
    {
        [webView loadRequest:navigationAction.request];
        
//        WKWebViewController *webCtrl = [[WKWebViewController alloc] init];
//        webCtrl.htmlStrl = navigationAction.request.URL.absoluteString;
//        [self.navigationController pushViewController:webCtrl animated:true];
    }
    return nil;
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    NSLog(@"宽：%.2f",ScreenWidth);
    NSLog(@"高：%.2f",ScreenHeight);
    _refreshButt.frame = CGRectMake(ScreenWidth-200, 110, 116*0.6, 106*0.6);
    double w = ScreenWidth;
    double h = ScreenHeight;
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        
        //竖屏
        if(ScreenWidth > ScreenHeight){
            
            w = ScreenHeight;
            h = ScreenWidth;
        }
        
    }else{//横屏
        
        if(ScreenWidth < ScreenHeight){
            
            w = ScreenHeight;
            h = ScreenWidth;
        }
    }
    
    _webView.frame = CGRectMake(0, StatusBarHeight, w, h-StatusBarHeight);
    
    if(_popCtrl){
        
        [UIView animateWithDuration:0.3 animations:^{
           
            CGFloat Y = (h - 240)/2.0;
            self->_popCtrl.topBtn.frame = CGRectMake(100, Y, 240, 240);
            self->_popCtrl.bottomBtn.frame = CGRectMake(w-340, Y, 240, 240);
            
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void)initView{
    
    WKWebViewConfiguration * Configuration = [self registConfiguration];
    Configuration.applicationNameForUserAgent = @"iOS-App-Chou";
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, ScreenWidth, ScreenHeight-StatusBarHeight) configuration:Configuration];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.allowsBackForwardNavigationGestures = YES;
    /*1、iPhone上交互成功，iPad上交互失败
     原因：
     WKWebView 在iPad上加载手机端的网址时，会自动将该网址转为PC端的网址，所以只需改变WKWebview的userAgent浏览器标识就可以了
     链接：https://www.jianshu.com/p/9d1fe8aca2ec
     */
    
    [_webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id __nullable userAgent, NSError * __nullable error) {
        self->_webView.customUserAgent = [userAgent stringByReplacingOccurrencesOfString:@"iPad" withString:@"iPhone"];
            }];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    NSString *url = [Utils getTextWithModelStr:self.htmlStrl];
    
    [self.view addSubview:_webView];
    if(url.length > 0 && [url containsString:@"http"]){
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

        [NSURLRequest allowsAnyHTTPSCertificateForHost:url];
//        [request addValue:@"QiShareAuth1=QiShareAuth1;QiShareAuth2=QiShareAuth2" forHTTPHeaderField:@"Cookie"];
           
        [_webView loadRequest:request];
    }else{
        [self hiddenView];
        [Utils showMessage:@"链接地址无效"];
    }
    
    
    _refreshButt = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshButt.frame = CGRectMake(ScreenWidth-200, 110, 116*0.6, 106*0.6);
    [self.view addSubview:_refreshButt];
    [_refreshButt setBackgroundImage:[UIImage imageNamed:@"icon_refresh"] forState:UIControlStateNormal];
    [_refreshButt setTitle:@"" forState:UIControlStateNormal];
    _refreshButt.backgroundColor = [UIColor clearColor];
    _refreshButt.hidden = YES;
    [_refreshButt addTarget:self action:@selector(refreshButtAc) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat width = (133/39.0)*StatusBarHeight*0.5;
    _moreButt = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButt.frame = CGRectMake((ScreenWidth-width)/2.0, StatusBarHeight*0.25, width, StatusBarHeight*0.5);

    [self.view addSubview:_moreButt];
    [_moreButt setBackgroundImage:[UIImage imageNamed:@"more.jpg"] forState:UIControlStateNormal];
    [_moreButt setTitle:@"" forState:UIControlStateNormal];
    _moreButt.backgroundColor = [UIColor whiteColor];
//    [_moreButt addTarget:self action:@selector(moreButtAc) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreButtAc) name:@"statusBarTappedNotification" object:nil];
        
}
//点击更多按钮
- (void)moreButtAc{
    
    if(self.navigationController.viewControllers.count < 2){
       
        MessageAlertViewController *alertCtrl = [[MessageAlertViewController alloc] init];
        alertCtrl.modalPresentationStyle = 5;
        alertCtrl.delegate = self;
        alertCtrl.htmlStr = [Utils getTextWithModelStr:_currentUrlStr];
        [self presentViewController:alertCtrl animated:NO completion:nil];
    }
}

//打印
- (void)printerWeb{
    
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];

    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =

     ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {

        if(error){
            NSLog(@"FAILED! due to error in domain %@ with error code %ld-- %@",

                  error.domain, (long)error.code, completionHandler);
        }
    };

    UIPrintInfo *printInfo = [UIPrintInfo printInfo];

    printInfo.outputType = UIPrintInfoOutputGeneral;

    printInfo.jobName = @"Print for xiaodui";;

    printInfo.duplex = UIPrintInfoDuplexLongEdge;

    controller.printInfo = printInfo;

//    controller.showsPageRange = YES;

   
    UIViewPrintFormatter *viewFormatter = [_webView viewPrintFormatter];

    viewFormatter.startPage = 0;
    viewFormatter.perPageContentInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    controller.printFormatter = viewFormatter;
    
    [controller presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
       
        if (!completed && error) {
            NSLog(@"Error");
        }
    }];
}
//刷新
- (void)refreshView{
    
    [self refreshButtAc];
}
//我的
- (void)mineView{
    
    MineViewController *mineCtrl = [[MineViewController alloc] init];
    mineCtrl.delegate = self;
    mineCtrl.htmlStrl = self.htmlStrl;
    [self.navigationController pushViewController:mineCtrl animated:YES];
}

//修改了url地址
- (void)changeUrlStr:(NSString *_Nonnull)htmlStr{
    
    if(![self.htmlStrl isEqualToString:htmlStr]){
        
        self.htmlStrl = htmlStr;
        [self refreshButtAc];
    }
}
//刷新页面
- (void)refreshButtAc{
    
    [self showLoadingView:@""];
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:10];
    NSString *url = [Utils getTextWithModelStr:self.htmlStrl];
//    if(url.length > 0 && [url containsString:@"http"]){
    _currentUrlStr = url;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [NSURLRequest allowsAnyHTTPSCertificateForHost:url];
        [_webView loadRequest:request];
//    }else{
//
//        [self hiddenView];
//        [Utils showMessage:@"链接地址无效"];
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = true;
    //注入js 方法
    NSArray *methodArr = @[@"OpenNativeCamera",@"OpenNativeQrCamera",@"OpenNativePrint"];

    //这里要事先注入 和 h5 约定的方法名称
    [methodArr enumerateObjectsUsingBlock:^(NSString *methodStr, NSUInteger idx, BOOL * _Nonnull stop) {

        [_webView.configuration.userContentController addScriptMessageHandler:self name:methodStr];
    }];
    
    [self printPdf:@"https://sales-portal-pos-sit.chowtaifook.sz/guide/guide1.pdf"];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = false;
    NSArray *methodArr = @[@"OpenNativeCamera",@"OpenNativeQrCamera",@"OpenNativePrint"];
    // 删除注册方法， 避免循环引用
    [methodArr enumerateObjectsUsingBlock:^(NSString *methodStr, NSUInteger idx, BOOL * _Nonnull stop) {

        [_webView.configuration.userContentController removeScriptMessageHandlerForName:methodStr];
    }];
}


- (WKWebViewConfiguration *)registConfiguration{
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    _userCtrl = [WKUserContentController new];
    NSString *systemVersion = [Utils getTextWithModelStr:[UIDevice currentDevice].systemVersion];
    NSString *cookieSource = [NSString stringWithFormat:@"document.cookie = 'systemVersion=%@;domain=chowtaifook.sz'",systemVersion];
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [_userCtrl addUserScript:cookieScript];
    
    configuration.userContentController = _userCtrl;
    configuration.processPool = [WKProcessPoolManager singleWkProcessPool];
    configuration.allowsInlineMediaPlayback = YES; // 允许内屏播放
    configuration.mediaTypesRequiringUserActionForPlayback = NO;
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    return configuration;
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    _currentUrlStr = webView.URL.absoluteString;
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self hiddenView];
    _refreshButt.hidden = YES;
    _currentUrlStr = webView.URL.absoluteString;
    
    [self performSelector:@selector(printerWeb) withObject:nil afterDelay:1];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error{
    [self hiddenView];
    _refreshButt.hidden = NO;
    [Utils showMessage:@"页面加载失败"];
    NSLog(@"失败原因：%@",error.localizedDescription);
}

// 监听h5调用原生
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    
    NSString *name = message.name;
    
    //调用原生的相机
    if([name isEqualToString:@"OpenNativeCamera"]){
        
        if(_popCtrl == nil){
            
            _popCtrl = [[SelPopViewController alloc] init];
        }
        _popCtrl.modalPresentationStyle = 5;
        WEAK_SELF;
        _popCtrl.block = ^(NSString *title) {

            if([title isEqualToString:@"1"]){

                [weakSelf selImgLibary];
            }else if ([title isEqualToString:@"2"]){

                [weakSelf takePhoto];
            }else{
                
                [weakSelf cancelTakePhoto];//取消拍照
            }
        };
        [self presentViewController:_popCtrl animated:NO completion:nil];
    }else if([name isEqualToString:@"OpenNativeQrCamera"]){
        //扫一扫
        [self openQrView];

    }else if([name isEqualToString:@"OpenNativePrint"]){
        
        [Utils showMessage:message.name];
        [self printPdf:message.body];
        
        //base64打印
//        UIImage *image = [Utils stringToImage:message.body];
//        if(image){
//
//            [self printImg:image];
//        }
    }
}

- (void)printPdf:(NSString *)str{
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
//    UIImage *image = [UIImage imageNamed:@"icon_back"];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"pdf"];
//    NSData *myPDFData = [[NSData alloc] initWithContentsOfFile:path];
//    NSData *myPDFData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
//    NSData *myPDFData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:str]];
    NSURL *url = [NSURL URLWithString:str];
    NSData *myPDFData = [[NSData alloc] initWithContentsOfURL:url];
    if  (pic && url ) {
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"jobName";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
//        pic.showsPageRange = YES;
        pic.printingItem = myPDFData;
//        printInfo.orientation = UIPrintInfoOrientationPortrait;//打印纵向还是横向
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
//            self.content = nil;
            if (!completed && error)
                NSLog(@"FAILED! due to error in domain %@ with error code %u",
                      error.domain, error.code);
        };
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:nil];
            [pic presentFromBarButtonItem:item animated:YES
                        completionHandler:completionHandler];
        } else {
            [pic presentAnimated:YES completionHandler:completionHandler];
        }
    }
}
- (void)printImg:(UIImage *)image{
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
//    UIImage *image = [UIImage imageNamed:@"icon_back"];
    NSData *myPDFData = UIImageJPEGRepresentation(image, 1);
    if  (pic && [UIPrintInteractionController canPrintData: myPDFData] ) {
//        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"jobName";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
//        pic.showsPageRange = YES;
        pic.printingItem = myPDFData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
//            self.content = nil;
            if (!completed && error)
                NSLog(@"FAILED! due to error in domain %@ with error code %u",
                      error.domain, error.code);
        };
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:nil];
            [pic presentFromBarButtonItem:item animated:YES
                        completionHandler:completionHandler];
        } else {
            [pic presentAnimated:YES completionHandler:completionHandler];
        }
    }
}


- (void)openQrView{
    
//    QRCodeViewController *megCtrl = [[QRCodeViewController alloc] init];
//    megCtrl.modalPresentationStyle = 5;
//    megCtrl.block = ^(NSString * _Nullable result) {
//        
//        if([result isEqualToString:@"切换摄像头"]){
//            
//            [self openQrView];
//            return;
//        }
//      
//        //扫描结果
//        NSString *jsStr = [NSString stringWithFormat:@"qrCameraInfo('%@')",result];
//        NSLog(@"%@",jsStr);
//        [self->_webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//            
//        }];
//    };
//    [self presentViewController:megCtrl animated:NO completion:nil];
}
//相册
- (void)selImgLibary{
    
    if(![self isPhotoAuthorization]){
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                // 用户同意授权
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 允许
                    [self setTZimageView];//拍照
                });
            }else {
                // 用户拒绝授权
                [Utils showMessage:@"请在设置中打开拍照权限"];
            }
            
        }];
    }else{
        
        [self setTZimageView];
    }
}

//拍照
- (void)takePhoto{
    
    //判断是否打开相机权限
    if(![self isCameraAuthorization]){
        [self cancelTakePhoto];
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 允许
                    [self buttAc];//拍照
                });
            } else {
                // 拒绝
                [Utils showMessage:@"请在设置中打开拍照权限"];
            }
        }];
    }else{
        
        [self buttAc];//拍照
    }
}

//取消拍照
- (void)cancelTakePhoto{
    
    NSDictionary *dic = @{
        
        @"image":@"",
    };
    NSString *json = [Utils convertToJsonData:dic];
    NSString *jsStr = [NSString stringWithFormat:@"nativeCameraInfo(%@)",json];
    [self->_webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
          
    }];
}

- (void)setTZimageView{

    TZImagePickerController *imagePC = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
    imagePC.allowTakePicture = YES;
    imagePC.allowTakeVideo = NO;
    imagePC.allowPickingVideo = NO;
    imagePC.allowPickingGif = NO;
    imagePC.showSelectedIndex = YES;
    imagePC.allowPickingOriginalPhoto = YES;//原图
    imagePC.minImagesCount = 0;
    imagePC.maxImagesCount = 1;
    imagePC.showSelectBtn = NO;
    imagePC.allowPreview = YES;
    imagePC.autoSelectCurrentWhenDone = YES;
    imagePC.modalPresentationStyle = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self presentViewController:imagePC animated:YES completion:nil];

    });
}
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker{
    
    [self cancelTakePhoto];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{

    
    if(photos.count > 0){
        
        UIImage *img = photos[0];
        if(img){//传递给h5
            
            CGFloat w = img.size.width;
            CGFloat h = img.size.height;
            
            if(w > 1200){
                
                img = [Utils reSizeImage:img toSize:CGSizeMake(1200, 1200*(h/w))];
            }
            
            NSData *data = UIImageJPEGRepresentation(img, 0.5);
            img = [UIImage imageWithData:data];
            NSString *imgStr = [Utils imageToString:img];
            
            NSDictionary *dic = @{
                
                @"image":imgStr,
            };
            NSString *json = [Utils convertToJsonData:dic];
            NSString *jsStr = [NSString stringWithFormat:@"nativeCameraInfo(%@)",json];
            [self->_webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                
            }];
        }
    }
}

//相册中选择视频
- (void)buttAc{
    
       UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
       imagePicker.delegate = self;
//       imagePicker.allowsEditing = YES;//编辑模式  但是编辑框是正方形的
     // imagePicker.mediaTypes = @[@"public.movie"];
    //, @"public.image"
    // 重点: public.movie 视频, public.image 图片 **
       imagePicker.mediaTypes = @[@"public.image"];
       imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
       [self presentViewController:imagePicker animated:YES completion:nil];
    
}


#pragma mark - =======UIImagePickerControllerDelegate=========
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //拍摄的照片
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
 
    if(img){//传递给h5
        
        CGFloat w = img.size.width;
        CGFloat h = img.size.height;
        
        if(w > 1200){
            
            img = [Utils reSizeImage:img toSize:CGSizeMake(1200, 1200*(h/w))];
        }
        
        NSData *data = UIImageJPEGRepresentation(img, 0.5);
        img = [UIImage imageWithData:data];
        NSString *imgStr = [Utils imageToString:img];
        
        NSDictionary *dic = @{
            
            @"image":imgStr,
        };
        NSString *json = [Utils convertToJsonData:dic];
        NSString *jsStr = [NSString stringWithFormat:@"nativeCameraInfo(%@)",json];
        [self->_webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            
        }];
    }
}

// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [self cancelTakePhoto];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
 
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {if ([challenge previousFailureCount] == 0) {NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];completionHandler(NSURLSessionAuthChallengeUseCredential, credential);} else {completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);}} else {completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
                                                                                                                                                                                                                                                       }
        
         });
}


- (void)onlyBackButtonAction{
    
    if([_webView canGoBack]){
        
        [_webView goBack];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)printInteractionControllerWillDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
