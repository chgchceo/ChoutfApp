//
//  SelQRViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/11/27.
//

#import "SelQRViewController.h"

@interface SelQRViewController ()




@end

@implementation SelQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _alertView.layer.cornerRadius = 15;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAc)];
    [_bgView addGestureRecognizer:tapGes];
}

- (void)tapAc{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)topButtAc:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    if([_delegate respondsToSelector:@selector(clickButtWithTitle:)]){
        
        [_delegate clickButtWithTitle:@"扫一扫"];
    }
}


- (IBAction)midButtAc:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    if([_delegate respondsToSelector:@selector(clickButtWithTitle:)]){
        
        [_delegate clickButtWithTitle:@"华为扫一扫"];
    }
    
}


- (IBAction)bottomButtAc:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    if([_delegate respondsToSelector:@selector(clickButtWithTitle:)]){
        
        [_delegate clickButtWithTitle:@"扫一扫"];
    }
    
}


@end
