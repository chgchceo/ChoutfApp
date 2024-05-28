//
//  AppUpdateAlertViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/9/15.
//

#import "AppUpdateAlertViewController.h"
#import "header.h"
@interface AppUpdateAlertViewController ()

@end

@implementation AppUpdateAlertViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initView];
    [Utils setImageWith:@"https://smartportal-sales-oss.ctf.com.cn/public/clienteling/icon/update.jpg" withImgView:_imgView placeholderImag:@"update.jpg"];
}

- (void)initView{
    
    NSString *text = [NSString stringWithFormat:@"版本号:%@\n%@",self.version,self.content];
    _textView.text = text;
    
    if(self.forceUpdate){
        
        self.buttView.hidden = YES;
    }else{
        
        self.buttView.hidden = NO;
    }
    
    _bgView.layer.cornerRadius = 20;
    _bgView.layer.masksToBounds = YES;
    _butt.layer.cornerRadius = 20;
    _butt.layer.masksToBounds = YES;
    _textView.editable = NO;
}

- (IBAction)doneButtAc:(id)sender {
    
    NSString *updateUrl = [Utils getTextWithModelStr:self.updateUrl];
    if(updateUrl.length == 0){
        
       [self dismissViewControllerAnimated:NO completion:nil];

    }else{
        
        NSURL *url = [NSURL URLWithString:updateUrl];
        [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
    }
}

- (IBAction)closeButtAc:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}








@end
