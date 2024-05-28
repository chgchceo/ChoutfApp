//
//  BaseViewController.m
//  LocalSpecialty
//
//  Created by cgc on 2021/9/13.
//

#import "BaseViewController.h"
#import "LOTAnimationView.h"
#import "UIImage+YYAdd.h"
#import "Header.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>{
    UIView *view;
    UIView *_line;//分割线
    
}

@property(nonatomic, strong) LOTAnimationView *loadingView;//加载视图

@property(nullable,nonatomic,weak) id <UIGestureRecognizerDelegate> originalGestureDelegate;

@property(nonatomic, strong) UIButton *leftBarButton;

@end

@implementation BaseViewController


- (void)dealloc{
    
    NSLog(@"销毁了");
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _originalGestureDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = _originalGestureDelegate;
    [self hiddenView];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    view = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-160)/2.0, (ScreenHeight-160)/2.0, 160, 160)];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    self.modalPresentationStyle = UIModalPresentationFullScreen;//适配iOS13
    self.navigationController.navigationBar.translucent = NO;
    //设置返回按钮的字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self _initBackButton];
    
    // add by lostvoices
    
    if(@available(ios 15.0,*)){
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor whiteColor];
        appearance.backgroundImage = [UIImage imageWithColor:UIColor.clearColor];
        appearance.shadowColor = [UIColor clearColor];
        appearance.shadowImage = [UIImage imageWithColor:UIColor.clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = self.navigationController.navigationBar.standardAppearance;
    } else {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColor.clearColor] forBarMetrics:UIBarMetricsDefault];//设置导航栏背景图片
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    _line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_line];
}

//显示加载视图
- (void)showLoadingView:(NSString *)labelText{

    // add by lostvoices
    if (!self.loadingView.superview) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.loadingView];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadingView play];
    });
   
}

//隐藏视图
-(void)hiddenView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadingView stop];
    });
    [self.loadingView removeFromSuperview];
}


-(void)_initBackButton{
    
       if (self.navigationController.viewControllers.count > 1 ||  self.isModal == YES) {
           self.leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
           [self.leftBarButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
           self.leftBarButton.frame = CGRectMake(0, 0, 40, 40);
           self.leftBarButton.imageEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 0);
           [self.leftBarButton addTarget:self action:@selector(onlyBackButtonAction) forControlEvents:UIControlEventTouchUpInside];
           self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBarButton];
       }
}

-(void)onlyBackButtonAction{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"back" forKey:@"backHome"];
    if(_isModal){
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        
        //测试
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (LOTAnimationView *)loadingView {
    if (!_loadingView) {
       _loadingView = [LOTAnimationView animationNamed:@"loading"];
        _loadingView.loopAnimation = YES;
        _loadingView.frame = CGRectMake((ScreenWidth-40)/2.0, (ScreenHeight-40)/2.0, 40, 40);
    }
    return _loadingView;
}

//- (BOOL)shouldAutorotate {
//    
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    
//    return UIInterfaceOrientationMaskLandscapeRight;
//}
@end
