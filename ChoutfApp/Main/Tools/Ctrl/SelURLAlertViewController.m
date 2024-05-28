//
//  SelURLAlertViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/11/15.
//

#import "SelURLAlertViewController.h"
#import "header.h"

@interface SelURLAlertViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *grayView;

@end

@implementation SelURLAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initView];
}

- (void)initView{
    
    _bgView.layer.cornerRadius = 20;
    _bgView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    [_grayView addGestureRecognizer:tapGes];
}

- (void)closeView{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)firstButtAc:(id)sender {
    
    UIButton *butt = (UIButton *)sender;
    NSString *title = [Utils getTextWithModelStr:butt.titleLabel.text];
    [self closeView];
    if(self.block){
        
        self.block(title);
    }
}

- (IBAction)secondButtAc:(id)sender {
    
    UIButton *butt = (UIButton *)sender;
    NSString *title = [Utils getTextWithModelStr:butt.titleLabel.text];
    [self closeView];
    if(self.block){
        
        self.block(title);
    }
}


- (IBAction)thirdButtAc:(id)sender {
    
    UIButton *butt = (UIButton *)sender;
    NSString *title = [Utils getTextWithModelStr:butt.titleLabel.text];
    [self closeView];
    if(self.block){
        
        self.block(title);
    }
}

- (IBAction)fourthButtAc:(id)sender {
    
    UIButton *butt = (UIButton *)sender;
    NSString *title = [Utils getTextWithModelStr:butt.titleLabel.text];
    [self closeView];
    if(self.block){
        
        self.block(title);
    }
}


- (IBAction)fifthButtAc:(id)sender {
    
    UIButton *butt = (UIButton *)sender;
    NSString *title = [Utils getTextWithModelStr:butt.titleLabel.text];
    [self closeView];
    if(self.block){
        
        self.block(title);
    }
}

@end
