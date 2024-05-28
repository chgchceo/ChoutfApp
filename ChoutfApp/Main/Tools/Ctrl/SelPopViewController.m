//
//  SelPopViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/9/13.
//

#import "SelPopViewController.h"
#import "header.h"

@interface SelPopViewController ()

@end

@implementation SelPopViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView{
    
    _topBtn.layer.cornerRadius = 20;
    _topBtn.layer.masksToBounds = YES;
    
    _bottomBtn.layer.cornerRadius = 20;
    _bottomBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAc)];
    
    [self.bgView addGestureRecognizer:tapGes];
    
    CGFloat Y = (ScreenHeight - 240)/2.0;
    _topBtn.frame = CGRectMake(100, Y, 240, 240);
    _bottomBtn.frame = CGRectMake(ScreenWidth-340, Y, 240, 240);
}

- (void)tapAc{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    if(self.block){
        
        self.block(@"0");
    }
}


- (IBAction)topButtAc:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    if(self.block){
        
        self.block(@"1");
    }
}



- (IBAction)bottomButtAc:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    if(self.block){
        
        self.block(@"2");
    }
    
}


@end
