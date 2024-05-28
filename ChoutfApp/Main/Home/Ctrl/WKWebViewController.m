//
//  WKWebViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/8/25.
//

#import "WKWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SKWebView.h"
#import "header.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerController.h"



@interface WKWebViewController ()<WKUIDelegate,WKNavigationDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MineViewControllerDelegate,UIPrintInteractionControllerDelegate,WKScriptMessageHandler,LeftItemViewDelegate>{
    
    WKUserContentController *_userCtrl;
    SKWebView *_webView;
    UIButton *_refreshButt;//刷新页面的按钮
    PingHost *_pingHost;
    bool _isClickLeft;//点击左侧栏进行了跳转
    NSInteger _leftStatus;//左侧栏打开的状态
    LeftItemView *_leftView;
    UIView *_topView;
    CGPoint cumulativeTranslation;
    
}

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showLoadingView:@""];
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:3];
    self.navigationItem.title = @"";
    
    //默认值
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUrl"];
    url = [Utils getTextWithModelStr:url];
    if(url.length == 0){
        
        url = H5_URL;
    }
    self.htmlStrl = url;
    _pingHost = [[PingHost alloc] init];
    [self initView];
    
    //监听侧栏打开状态
    WEAK_SELF;
    [self.mm_drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         
        self->_leftStatus = percentVisible;
        [weakSelf checkUrlIsChange];
     }];
}

- (void)initView{
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NaviBarHeight)];
    
    UIButton *butt = [UIButton buttonWithType:UIButtonTypeCustom];
    butt.frame = CGRectMake(15, StatusBarHeight+10, 50, 30);
    [butt setImage:[UIImage imageNamed:@"sanheng"] forState:UIControlStateNormal];
    [butt addTarget:self action:@selector(openLeftView) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:butt];
    [self.view addSubview:_topView];
    WKWebViewConfiguration * Configuration = [self registConfiguration];
    Configuration.applicationNameForUserAgent = @"iOS-App-Chou";
    Configuration.showConsole = YES;
    _webView = [[SKWebView alloc] initWithFrame:CGRectMake(0, NaviBarHeight, ScreenWidth, ScreenHeight-NaviBarHeight) configuration:Configuration];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.allowsBackForwardNavigationGestures = YES;
    
    [_webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id __nullable userAgent, NSError * __nullable error) {
        self->_webView.customUserAgent = [userAgent stringByReplacingOccurrencesOfString:@"iPad" withString:@"iPhone"];
            }];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    NSString *url = [Utils getTextWithModelStr:self.htmlStrl];
    
    [self.view addSubview:_webView];
    if(url.length > 0 && [url containsString:@"http"]){
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];

        [_webView loadRequest:request];
    }else{
        [self hiddenView];
        [Utils showMessage:@"链接地址无效"];
    }
    
    _refreshButt = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshButt.frame = CGRectMake(ScreenWidth-150, 110, 116*0.6, 106*0.6);
    [self.view addSubview:_refreshButt];
    [_refreshButt setBackgroundImage:[UIImage imageNamed:@"icon_refresh"] forState:UIControlStateNormal];
    [_refreshButt setTitle:@"" forState:UIControlStateNormal];
    _refreshButt.backgroundColor = [UIColor clearColor];
    _refreshButt.hidden = YES;
    [_refreshButt addTarget:self action:@selector(refreshButtAc) forControlEvents:UIControlEventTouchUpInside];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sanheng"] style:UIBarButtonItemStyleDone target:self action:@selector(openLeftView)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"saoyisao"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtn)];

    _leftView = [[[NSBundle mainBundle] loadNibNamed:@"LeftItemView" owner:self options:nil] lastObject];
    _leftView.delegate = self;
    _leftView.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight);
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.view addSubview:_leftView];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAc:)];
    
    [self.view addGestureRecognizer:panGes];
}

- (void)panAc:(UIPanGestureRecognizer *)recognizer{
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // 获取当前平移量
            CGPoint translation = [recognizer translationInView:self.view];
            
            // 重置识别器的平移量，以便下次调用时获取新的增量
            [recognizer setTranslation:CGPointZero inView:self.view];
            
            // 判断平移方向
            if (fabs(translation.x) > fabs(translation.y)) {
                if (translation.x > 0) {
                    
                    
                    if (_leftView.frame.origin.x< 0) {
                        NSLog(@"向右平移");
                        [self openLeftView];
                    }
                    
                } else {
                    NSLog(@"向左平移");
                }
            } else {
                if (translation.y > 0) {
                    NSLog(@"向下平移");
                } else {
                    NSLog(@"向上平移");
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            // 处理平移结束的逻辑
            break;
        }
        default:
            break;
    }
}
//关闭左侧边栏
- (void)closeLeftView{
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self->_leftView.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight);
    }];
}

//打开左侧边栏
-(void)openLeftView{
    
    [UIView animateWithDuration:0.4 animations:^{
       
        self->_leftView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }];
}

//左侧界面点击事件
- (void)clickLeftItemViewWithTitle:(NSString *_Nullable)title{
    
    if ([title isEqualToString:@"关闭"]) {
        
        [self closeLeftView];
    }else if([title isEqualToString:@"设置"]){
        
//        [self closeLeftView];
        MineViewController *mineCtrl = [[MineViewController alloc] init];
        [self.navigationController pushViewController:mineCtrl animated:YES];
    }else if([title isEqualToString:@"扫一扫"]){
        
//        [self closeLeftView];
        QRScanViewController *qrCtrl = [[QRScanViewController alloc] init];
        [self.navigationController pushViewController:qrCtrl animated:YES];
    }else if([title isEqualToString:@"清理缓存"]){
        
        [self showLoadingView:@""];
        [self clearWeblocalStorage];
        [self performSelector:@selector(clearFinish) withObject:nil afterDelay:2];
        
    }else if([title isEqualToString:@"日志信息"]){
        
//        [self closeLeftView];
        LogMessageViewController *vc = [[LogMessageViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([title isEqualToString:@"ping域名"]){
        
//        [self closeLeftView];
        PingHostViewController *hostCtrl = [[PingHostViewController alloc] init];
        hostCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hostCtrl animated:YES];
    }else if([title isEqualToString:@"检测更新"]){
        
        [Utils showMessage:@"当前已是最新版本!"];
    }else if([title isEqualToString:@"历史版本"]){
        
//        [self closeLeftView];
        HistoryVersionViewController *hisCtrl = [[HistoryVersionViewController alloc] init];
        hisCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hisCtrl animated:YES];
    }else if([title isEqualToString:@"关于我们"]){
        
//        [self closeLeftView];
        AboutUsViewController *aboutCtrl = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutCtrl animated:YES];
    }else if([title isEqualToString:@"意见反馈"]){
        
        FeedBackViewController *feedCtrl = [[FeedBackViewController alloc] init];
        [self.navigationController pushViewController:feedCtrl animated:YES];
    }else if([title isEqualToString:@"更多"]){
        
        AllFunctionsViewController *allCtrl = [[AllFunctionsViewController alloc] init];
        [self.navigationController pushViewController:allCtrl animated:YES];
    }
}

- (void)clearFinish{
    
    [self hiddenView];
    [Utils showMessage:@"清理完成"];
}

#pragma mark - 清除web缓存
- (void)clearWeblocalStorage{
    
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
}

-(void)rightBtn{
    
    QRScanViewController *qrCtrl = [[QRScanViewController alloc] init];
    [self.navigationController pushViewController:qrCtrl animated:YES];
}

//刷新
- (void)refreshView{
    
    [self refreshButtAc];
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
    if(_isClickLeft && _leftStatus == 0){
        
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];//左侧打开关闭侧边栏方法
    }
    _isClickLeft = false;
    NSString *backHome = [Utils getTextWithModelStr:[[NSUserDefaults standardUserDefaults] objectForKey:@"backHome"]];
    
    if (backHome.length > 0) {
        
//        [self openLeftView];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"backHome"];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self checkUrlIsChange];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (WKWebViewConfiguration *)registConfiguration{
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    return configuration;
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    NSString *host = webView.URL.host;
    NSString *content = webView.URL.absoluteString;
    [_pingHost pingHostName:host withBlock:^(_Bool isLink) {
       
        if (isLink == false) {//ping失败了，保存记录到本地数据库
            
            NSString *date = [Utils getNowTimeStr];
            NSString *title = @"域名ping不通，请检查网络是否连接正确,域名：";
            NSString *code = host;
            
            [Utils saveLogMessage:date withTitle:title withContent:content withCode:code];
        }
    }];
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
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error{
    [self hiddenView];
    _refreshButt.hidden = NO;
    [Utils showMessage:@"页面加载失败"];
    NSLog(@"失败原因：%@",error.localizedDescription);
    NSString *date = [Utils getNowTimeStr];
    NSString *title = [Utils getTextWithModelStr:error.localizedDescription];
    NSString *content = [Utils getTextWithModelStr:error.description];
    NSString *code = [NSString stringWithFormat:@"%ld",error.code];
    
    [Utils saveLogMessage:date withTitle:title withContent:content withCode:code];
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

//重新发送信息和h5进行交换
- (void)reSendMessageH5:(NSString *)json{
    
    NSString *jsStr = [NSString stringWithFormat:@"window.proxy.%@",json];
    [self->_webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
}

- (void)checkUrlIsChange{
    
    //判断个人中心页面是否切换了链接
   NSString *currentUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUrl"];
    
    currentUrl = [Utils getTextWithModelStr:currentUrl];
    
    if (currentUrl.length > 0 && ![currentUrl isEqualToString:self.htmlStrl]) {
        
        
        self.htmlStrl = currentUrl;
        [self refreshButtAc];
    }
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message { 
    
}










@end
