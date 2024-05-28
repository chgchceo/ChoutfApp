//
//  ScanORResultViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/9/14.
//

#import "ScanORResultViewController.h"
#import "header.h"

@interface ScanORResultViewController (){
    
    UIScrollView *_scrollView;
    
}

@property(nonatomic,strong)UILabel *megLab;

@end

@implementation ScanORResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"详情";
    
    self.megLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-40, ScreenHeight)];
    self.megLab.text = [Utils getTextWithModelStr:_content];
//    self.megLab.font = [UIFont fontWithName:@"DIN-Bold" size:20];
    self.megLab.font = [UIFont systemFontOfSize:20];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, ScreenHeight-NaviBarHeight)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    self.megLab.textAlignment = NSTextAlignmentCenter;
    self.megLab.textColor = [UIColor lightGrayColor];
    [_scrollView addSubview:self.megLab];
    [Utils setLineSpace:5 withText:self.megLab.text inLabel:_megLab];
    CGFloat height = [Utils getLabelHeightWithText:self.megLab.text width:ScreenWidth-40 font:20]+100;
    if (height > ScreenHeight-NaviBarHeight){
        
        height = height *1.2;
    }else{
        height = ScreenHeight-NaviBarHeight;
    }
    self.megLab.numberOfLines = 0;
    self.megLab.frame = CGRectMake(20, 0, ScreenWidth-40, height);
    _scrollView.contentSize = CGSizeMake(ScreenWidth, height);
    [self initView];
}

- (void)initView{
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 28)];
    [moreButton setTitle:@"复制" forState:UIControlStateNormal];
    [moreButton setTitleColor:COLOR_WITH_HEX(0x666666) forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [moreButton addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = moreItem;
}

- (void)rightBarButtonClick{
    
    NSString *content = [Utils getTextWithModelStr:self.content];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:content];
    [Utils showMessage:@"复制成功"];
    
}


@end
