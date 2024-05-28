//
//  BrightnessViewController.m
//  ChoutfApp
//
//  Created by cheng on 2024/4/18.
//

#import "BrightnessViewController.h"
#import "header.h"

@interface BrightnessViewController (){
    
    CGFloat _currentNum;//手电筒当前的亮度值，为0时关闭手电筒
    AVCaptureDevice* _captureDevice;
    
}

@property (weak, nonatomic) IBOutlet UIButton *bottomButt;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttArr;


@end

@implementation BrightnessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _currentNum = _captureDevice.torchLevel;
    
    [self initView];
    [self refreshView];
}

- (void)tapAc{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    if ([_delegate respondsToSelector:@selector(upDateLightStatus)]) {
        
        [_delegate upDateLightStatus];
    }
}

- (void)initView{
    
//    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    
//    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
//    
//    view.frame = CGRectMake(0, 0,ScreenWidth , ScreenHeight);
//    
//    self.view.backgroundColor = [UIColor clearColor];
//    [self.view insertSubview:view atIndex:0];
    // 创建毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
      
    // 创建毛玻璃视图
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
      
    // 创建色彩层视图
    UIView *colorOverlayView = [[UIView alloc] initWithFrame:blurEffectView.bounds];
    colorOverlayView.backgroundColor = [UIColor colorWithRed:67/255.0 green:125/255.0 blue:148/255.0 alpha:0.6]; // 设置颜色和透明度
      
    // 获取毛玻璃视图的 contentView 并添加色彩层视图
    UIView *contentView = blurEffectView.contentView;
    [contentView addSubview:colorOverlayView];
      
    // 设置父视图的背景色为透明
    self.view.backgroundColor = [UIColor clearColor];
      
    // 将毛玻璃视图添加到父视图
    [self.view insertSubview:blurEffectView atIndex:0];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAc)];
    
    [self.view addGestureRecognizer:tapGes];
    
    
    _bgView.layer.cornerRadius = 30;
    _bgView.layer.masksToBounds = YES;
    
    for (UIButton *butt in _buttArr) {
        
        //点击事件
        [butt addTarget:self action:@selector(buttAc:) forControlEvents:UIControlEventTouchUpInside];
        
        //轻扫事件
        UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeTap:)];
        
        [butt addGestureRecognizer:pan1];
        
    }
    
        UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeTap:)];
        [_bottomButt addGestureRecognizer:pan2];
    
}

- (void)swipeTap:(UIPanGestureRecognizer *)swipe{
    
    CGPoint point = [swipe locationInView:_bgView];
    
    CGFloat Y = point.y;
    if (Y <= 60) {
        
        if (_currentNum != 1) {
            _currentNum = 1;
        }else{
            //避免重复调用刷新方法
            return;
        }
        
    }else if(Y<= 120){
        
        if (_currentNum != 0.75) {
            _currentNum = 0.75;
        }else{
            
            return;
        }
        
    }else if(Y<= 180){
        
        if (_currentNum != 0.5) {
            _currentNum = 0.5;
        }else{
            
            return;
        }
        
    }else if(Y<= 240){
        
        if (_currentNum != 0.25) {
            _currentNum = 0.25;
        }else{
            
            return;
        }
        
    }else{
        
        _currentNum = 0;
    }
    
    [self refreshView];
}

- (void)buttAc:(UIButton *)butt{
    
    NSInteger index = [_buttArr indexOfObject:butt];
    
    if (index == 0) {
        
        if (_currentNum != 1.0) {
            
            _currentNum = 1.0;
        }else{
            _currentNum = 0.75;
        }
        
    }else if (index == 1) {
        
        if (_currentNum != 0.75) {
            
            _currentNum = 0.75;
        }else{
            _currentNum = 0.5;
        }
        
    }else if (index == 2) {
        if (_currentNum != 0.5) {
            _currentNum = 0.5;
        }else{
            _currentNum = 0.25;
        }
        
    }else if (index == 3) {
        
        if (_currentNum != 0.25) {
            
            _currentNum = 0.25;
        }else{
            _currentNum = 0;
        }
        
    }
    [self refreshView];
}

//修改值后刷新界面，控制手电筒的亮度和开关
- (void)refreshView{
    
    [_captureDevice lockForConfiguration:nil];
    if(_currentNum == 0){
        
        [_captureDevice setTorchMode:AVCaptureTorchModeOff];
        
        for (UIButton *butt in _buttArr) {
            
            butt.backgroundColor = COLOR_WITH_HEX(0x214855);
        }
        
        
    }else{
        
        if (_captureDevice.torchMode == AVCaptureTorchModeOff) {
            [_captureDevice setTorchMode:AVCaptureTorchModeOn];
        }
        
        if (_currentNum == 0.25){
           
            [_captureDevice setTorchModeOnWithLevel:0.25 error:nil];
            
            for (int i = 0; i < _buttArr.count; i ++) {
                
                UIButton *butt = _buttArr[i];
                if (i == _buttArr.count -1) {
                    
                    butt.backgroundColor = COLOR_WITH_HEX(0xF0F0F0);
                }else{
                    
                    butt.backgroundColor = COLOR_WITH_HEX(0x214855);
                }
            }
            
            
       }else if (_currentNum == 0.5){
           
           [_captureDevice setTorchModeOnWithLevel:0.5 error:nil];
           
           for (int i = 0; i < _buttArr.count; i ++) {
               
               UIButton *butt = _buttArr[i];
               if (i >= _buttArr.count -2) {
                   
                   butt.backgroundColor = COLOR_WITH_HEX(0xF0F0F0);
               }else{
                   
                   butt.backgroundColor = COLOR_WITH_HEX(0x214855);
               }
           }
           
           
       }else if (_currentNum == 0.75){
           
           [_captureDevice setTorchModeOnWithLevel:0.75 error:nil];
           
           for (int i = 0; i < _buttArr.count; i ++) {
               
               UIButton *butt = _buttArr[i];
               if (i >= _buttArr.count -3) {
                   
                   butt.backgroundColor = COLOR_WITH_HEX(0xF0F0F0);
               }else{
                   
                   butt.backgroundColor = COLOR_WITH_HEX(0x214855);
               }
           }
           
           
       }else if (_currentNum == 1.0){
           
           [_captureDevice setTorchModeOnWithLevel:1.0 error:nil];
           for (UIButton *butt in _buttArr) {
               
               butt.backgroundColor = COLOR_WITH_HEX(0xF0F0F0);
           }
       }
       
    }
    [_captureDevice unlockForConfiguration];
}




@end
