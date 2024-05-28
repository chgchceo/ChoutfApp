//
//  LogMessageViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/12/19.
//

#import "LogMessageViewController.h"
#import "LogMessageTableViewCell.h"
#import "DBManager.h"
#import "header.h"

@interface LogMessageViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    
    UITableView *_tableView;
    NSArray *_data;
    UILabel *_megLab;
}

@end

@implementation LogMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"日志信息";
    [self initView];
}

- (void)initView{
    
    _megLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, ScreenWidth, 90)];
    
    _megLab.text = @"暂无日志信息";
    _megLab.textAlignment = NSTextAlignmentCenter;
    _megLab.font = [UIFont systemFontOfSize:20];
    _megLab.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_megLab];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviBarHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerNib:[UINib nibWithNibName:@"LogMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"LogMessageTableViewCell"];
    
    _data = [Utils getAllLogMessage];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (NSInteger i = _data.count-1; i >= 0; i --) {
        
        LogMessage *message = _data[i];
        [arr addObject:message];
    }
    _data = arr;
    [_tableView reloadData];
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 28)];
    [moreButton setTitle:@"全部清除" forState:UIControlStateNormal];
    [moreButton setTitleColor:COLOR_WITH_HEX(0x666666) forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [moreButton addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = moreItem;
}

- (void)rightBarButtonClick{
    
    if(_data.count == 0){
        
        [Utils showMessage:@"暂无日志信息"];
        return;
    }
    [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否确定要清理全部日志信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1){//确定
        
        DBManager *db = [DBManager shareInstance];
        NSArray *arr = [db queryWithEntityName:@"LogMessage" withPredicate:nil];
        
        for (LogMessage *message in arr) {
            
            [db deleteMO:message];
        }
        
        //刷新
        _data = [Utils getAllLogMessage];
        [_tableView reloadData];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_data.count == 0){
        
        _tableView.hidden = YES;
    }else{
        
        _tableView.hidden = NO;
    }
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden = @"LogMessageTableViewCell";
    LogMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    LogMessage *message = _data[indexPath.row];
    NSString *date = [Utils getTextWithModelStr:message.date];
    NSString *title = [Utils getTextWithModelStr:message.title];
    NSString *content = [Utils getTextWithModelStr:message.content];
    NSString *code = [Utils getTextWithModelStr:message.code];
    
    cell.titleLab.text = [NSString stringWithFormat:@"%@ %@",title,code];
    cell.contentLab.text = content;
    cell.dateLab.text = date;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LogMessage *message = _data[indexPath.row];
//    NSString *date = [Utils getTextWithModelStr:message.date];
//    NSString *title = [Utils getTextWithModelStr:message.title];
    NSString *content = [Utils getTextWithModelStr:message.content];
//    NSString *code = [Utils getTextWithModelStr:message.code];
    
    ScanORResultViewController *vc = [[ScanORResultViewController alloc] init];
    vc.content = content;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LogMessage *message = _data[indexPath.row];
    NSString *title = [Utils getTextWithModelStr:message.title];
    CGFloat height = [Utils getLabelHeightWithText:title width:(ScreenWidth-40)/2.0 font:17] + 115;

    if(height < 150){

        return 150;
    }
    
    return height;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

@end
