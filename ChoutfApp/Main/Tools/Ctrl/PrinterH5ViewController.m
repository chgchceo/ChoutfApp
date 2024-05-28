//
//  PrinterPdfViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/11/27.
//

#import "PrinterH5ViewController.h"
#import "header.h"

@interface PrinterH5ViewController ()<WKUIDelegate,WKNavigationDelegate,UINavigationControllerDelegate,UIPrintInteractionControllerDelegate>{
    
    WKUserContentController *_userCtrl;
    WKWebView *_webView;
}


@end

@implementation PrinterH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showLoadingView:@""];
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:3];
    self.title = @"文件打印";
    self.view.backgroundColor = [UIColor clearColor];
    [self initView];
    _webView.backgroundColor = [UIColor clearColor];
}

- (void)initView{
    
    WKWebViewConfiguration * Configuration = [self registConfiguration];
    Configuration.applicationNameForUserAgent = @"iOS-App-Chou";
    /*_webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, ScreenWidth, ScreenHeight-StatusBarHeight) configuration:Configuration];*/
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) configuration:Configuration];
    _webView.allowsBackForwardNavigationGestures = YES;
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
           
        [_webView loadRequest:request];
    }else{
        [self hiddenView];
        [Utils showMessage:@"链接地址无效"];
    }
}

//打印
- (void)printerWeb{
    
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];

    controller.delegate = self;
    void (^__block completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =

     ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {

         [self dismissViewControllerAnimated:YES completion:nil];
    };
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Print for xiaodui";;
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    controller.printInfo = printInfo;
    UIViewPrintFormatter *viewFormatter = [_webView viewPrintFormatter];
    viewFormatter.startPage = 0;
    viewFormatter.perPageContentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    controller.printFormatter = viewFormatter;
    [controller presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
       
        [self dismissViewControllerAnimated:YES completion:nil];
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

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self hiddenView];
    
    [self performSelector:@selector(printerWeb) withObject:nil afterDelay:0.1];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error{
    [self hiddenView];
    
    [Utils showMessage:@"页面加载失败"];
    NSLog(@"失败原因：%@",error.localizedDescription);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {if ([challenge previousFailureCount] == 0) {NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];completionHandler(NSURLSessionAuthChallengeUseCredential, credential);} else {completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);}} else {completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
            
        }});
}

- (void)printInteractionControllerWillDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
