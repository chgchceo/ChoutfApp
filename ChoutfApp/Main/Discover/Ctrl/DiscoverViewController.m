//
//  DiscoverViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/8/29.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewCell.h"
#import "Header.h"
#import "WKWebViewController.h"


@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DiscoverTableViewCellDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_data;
    UIView *_bgView;
    UITextField *_textField;
    UILabel *_titleLab;
    UIButton *_cancelButt;
    UIButton *_doneButt;
}

@end

@implementation DiscoverViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"H5列表";
    self.view.backgroundColor = [UIColor grayColor];
    
    [self initView];
    [self loadData];
}
//获取本地存储的h5地址
- (void)loadData{
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"H5List"];
    
    str = [Utils getTextWithModelStr:str];
    
    if(str.length > 0){
        
        NSArray *arr = [str componentsSeparatedByString:@"%=%=%"];
        _data = [arr mutableCopy];
    }
    [_tableView reloadData];
}

//添加事件
- (void)initView{
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"DiscoverTableViewCell" bundle:nil] forCellReuseIdentifier:@"DiscoverTableViewCell"];
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 28)];
    [moreButton setTitle:@"新增h5链接" forState:UIControlStateNormal];
    [moreButton setTitleColor:COLOR_WITH_HEX(0x666666) forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [moreButton addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = moreItem;
    
    CGFloat w = 40;
    if(ISIpad){
        
        w = 400;
    }
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(w/2.0, 10, ScreenWidth-w, 240)];
    
    [self.view addSubview:_bgView];
    _bgView.backgroundColor = [UIColor whiteColor];
    
    _bgView.layer.borderWidth = 1;
    _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgView.layer.cornerRadius = 30;
    _bgView.layer.masksToBounds = YES;
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 80, ScreenWidth-w-30, 50)];
    _textField.placeholder = @"请输入h5地址";
    [_bgView addSubview:_textField];
    _textField.delegate = self;
    _bgView.hidden = YES;
    _textField.returnKeyType = UIReturnKeyDone;
    
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.layer.cornerRadius = 5;
    _textField.layer.masksToBounds = YES;
    _textField.layer.borderWidth = 1;
    _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _cancelButt = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButt.frame = CGRectMake(0, 180, (ScreenWidth-w)/2.0, 40);
    [_cancelButt setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButt addTarget:self action:@selector(cancelButtAc) forControlEvents:UIControlEventTouchUpInside];
    
    _doneButt = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButt.frame = CGRectMake((ScreenWidth-w)/2.0, 180, (ScreenWidth-w)/2.0, 40);
    [_doneButt setTitle:@"确定" forState:UIControlStateNormal];
    [_doneButt addTarget:self action:@selector(doneButtAc) forControlEvents:UIControlEventTouchUpInside];
    
    [_cancelButt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_doneButt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bgView addSubview:_cancelButt];
    [_bgView addSubview:_doneButt];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth-w, 50)];
    _titleLab.text = @"新增h5地址";
    [_bgView addSubview:_titleLab];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.font = [UIFont systemFontOfSize:18];
    
}

- (void)doneButtAc{
    
    NSString *text = _textField.text;
    if(text.length == 0){
        
        [Utils showMessage:@"请输入h5地址"];
        return;
    }
    _bgView.hidden = YES;
    
    [_data addObject:text];
    NSString *str = [_data componentsJoinedByString:@"%=%=%"];
    
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"H5List"];
    
    [_textField resignFirstResponder];
    _textField.text = @"";
    //刷新数据
    [self loadData];
}

- (void)cancelButtAc{
    
    _bgView.hidden = YES;
    [_textField resignFirstResponder];
}

//删除地址
- (void)delButtAc:(NSInteger)index{
    
    if(_data.count > index){
        
        [_data removeObjectAtIndex:index];
        
        NSString *str = [_data componentsJoinedByString:@"%=%=%"];
        
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"H5List"];
        
        //刷新数据
        [self loadData];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)rightBarButtonClick{
    
    _bgView.hidden = NO;
    [_textField becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverTableViewCell"];
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.megLab.text = _data[indexPath.row];
    cell.megLab.textColor = [UIColor blackColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *html = _data[indexPath.row];
    WKWebViewController *webCtrl = [[WKWebViewController alloc] init];
    webCtrl.htmlStrl = html;
    webCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webCtrl animated:YES];
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

    if(!ISIpad){
        
        return;
    }
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviBarHeight-TabbarHeight);
    
    _bgView.frame = CGRectMake(200, 10, ScreenWidth-400, 240);
    _titleLab.frame = CGRectMake(0, 20, ScreenWidth-400, 50);
    _textField.frame = CGRectMake(15, 80, ScreenWidth-400-30, 50);
    _cancelButt.frame = CGRectMake(0, 180, (ScreenWidth-400)/2.0, 40);
    
    _doneButt.frame = CGRectMake((ScreenWidth-400)/2.0, 180, (ScreenWidth-400)/2.0, 40);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if(!ISIpad){
        
        return;
    }
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviBarHeight-TabbarHeight);
    
    _bgView.frame = CGRectMake(200, 10, ScreenWidth-400, 240);
    _titleLab.frame = CGRectMake(0, 20, ScreenWidth-400, 50);
    _textField.frame = CGRectMake(15, 80, ScreenWidth-400-30, 50);
    _cancelButt.frame = CGRectMake(0, 180, (ScreenWidth-400)/2.0, 40);
    
    _doneButt.frame = CGRectMake((ScreenWidth-400)/2.0, 180, (ScreenWidth-400)/2.0, 40);
}
@end
