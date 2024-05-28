//
//  MessageAlertViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/11/13.
//

#import "MessageAlertViewController.h"
#import "MegAlertTableViewCell.h"
#import "header.h"

@interface MessageAlertViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
    NSArray *_titleArr;
    NSArray *_imgArr;
    
}


@end

@implementation MessageAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _titleArr = @[@"我的",@"刷新",@"复制链接",@"清理缓存",@"关闭"];
    _imgArr = @[@"wode",@"shuaxin",@"fuzhi",@"qinglihuancun",@"guanbi"];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    
    [_bgView addGestureRecognizer:tapGes];
    [self initView];
}

- (void)initView{
    
    CGFloat height = 210+50;
    //不需要隐藏了
//    if(isDev == false){//生产环境
//
//        _titleArr = @[@"我的",@"刷新",@"关闭"];
//        _imgArr = @[@"wode",@"shuaxin",@"guanbi"];
//        height = 160;
//    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 290, height) style:UITableViewStyleGrouped];
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_topView addSubview:_tableView];
    
    _topView.frame = CGRectMake((ScreenWidth-290)/2.0, StatusBarHeight, 290, height);
    
    _topView.layer.cornerRadius = 20;
    _topView.layer.masksToBounds = YES;
    
    [_tableView registerNib:[UINib nibWithNibName:@"MegAlertTableViewCell" bundle:nil] forCellReuseIdentifier:@"MegAlertTableViewCell"];
}

- (void)closeView{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)topButtAc:(id)sender {
    
    [self closeView];
    
    if([_delegate respondsToSelector:@selector(mineView)]){
        
        [_delegate mineView];
    }
}

- (IBAction)bottomButtAc:(id)sender {
    
    [self closeView];
    if([_delegate respondsToSelector:@selector(refreshView)]){
        
        [_delegate refreshView];
    }
}


- (IBAction)copyButtAc:(id)sender {
    
    [self closeView];
    NSString *content = [Utils getTextWithModelStr:self.htmlStr];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:content];
    [Utils showMessage:@"复制成功"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MegAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MegAlertTableViewCell"];
    
    NSString *text = _titleArr[indexPath.section];
    cell.titleLab.text = text;
    if([text isEqualToString:@"关闭"]){
        
        cell.titleLab.textColor = [UIColor redColor];
    }else{
        
        cell.titleLab.textColor = [UIColor blackColor];
    }
    NSString *imageName = _imgArr[indexPath.section];
    cell.imgView.image = [UIImage imageNamed:imageName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *text = _titleArr[indexPath.section];
    [self closeView];
    if([text isEqualToString:@"我的"]){
        
        if([_delegate respondsToSelector:@selector(mineView)]){
            
            [_delegate mineView];
        }
    }else if([text isEqualToString:@"刷新"]){
        
        if([_delegate respondsToSelector:@selector(refreshView)]){
            
            [_delegate refreshView];
        }
    }else if([text isEqualToString:@"复制链接"]){
        
        NSString *content = [Utils getTextWithModelStr:self.htmlStr];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:content];
        [Utils showMessage:@"复制成功"];
    }else if([text isEqualToString:@"清理缓存"]){
        
        [self clearWeblocalStorage];
        if([_delegate respondsToSelector:@selector(refreshView)]){
            
            [_delegate refreshView];
        }
    }else{//打印
        
//        if([_delegate respondsToSelector:@selector(printerWeb)]){
//
//            [_delegate printerWeb];
//        }
    }
}

- (void)clearWeblocalStorage {
    
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == _titleArr.count - 1){
        
        return 6;
    }
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}







@end
