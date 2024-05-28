//
//  ImgViewController.m
//  ChoutfApp
//
//  Created by cheng on 2024/4/8.
//

#import "ImgViewController.h"

@interface ImgViewController ()

@end

@implementation ImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.imgView.image = self.img;
    UIImage *img = [UIImage imageNamed:@"icon_logo"];
    self.imgView.image = self.img;
    self.nameLab.text = self.text;
}


@end
