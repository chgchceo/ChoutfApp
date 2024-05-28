//
//  HistoryVersionViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/11/15.
//

#import "HistoryVersionViewController.h"
#import "MineTableViewCell.h"
#import "header.h"
//#import <MJRefresh/MJRefresh.h>
@interface HistoryVersionViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
    UILabel *_megLab;
    NSMutableArray *_data;
    NSInteger _index;
    
}

@end

@implementation HistoryVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index = 1;
    self.title = @"历史版本";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _data = [[NSMutableArray alloc] init];
    [self initView];
    [self loadData];
}

- (void)loadData{
    
//    [self showLoadingView:@""];
//    NSDictionary *dic = @{
//        
//        @"current":@(_index),
//        @"size":@"10",
//        @"platform":@"0",//0:ios 1:android
//        @"type":@"1",// 1:smart portal sales 2:查货系统
//    };
//    [DataService requestDataWithURL:@"SALES-PORTAL-API/api/common/getVersion" withMethod:@"GET" withParames:[dic mutableCopy] withBlock:^(id result) {
//
//        [self hiddenView];
//        [self->_tableView.mj_header endRefreshing];
//        [self->_tableView.mj_footer endRefreshing];
//        if(![result isKindOfClass:[NSDictionary class]]){
//
//            return;
//        }
//        NSInteger code = [[result objectForKey:@"code"] integerValue];
//        if(code == 200){
//
//            if(self->_index == 1){
//                
//                [self->_data removeAllObjects];
//            }
//            NSDictionary *data = [result objectForKey:@"data"];
//            if([data isKindOfClass:[NSDictionary class]]){
//                
//                NSArray *records = [data objectForKey:@"records"];
//                
//                [self->_data addObjectsFromArray:records];
//                if(records.count < 10){
//                    
//                    [self->_tableView.mj_footer endRefreshingWithNoMoreData];
//                }
//            }
//            
//            [self->_tableView reloadData];
//        }
//    }];
}

- (void)initView{
    
    _megLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, ScreenWidth, 90)];
    
    _megLab.text = @"暂无历史版本";
    _megLab.textAlignment = NSTextAlignmentCenter;
    _megLab.font = [UIFont systemFontOfSize:20];
    _megLab.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_megLab];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviBarHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineTableViewCell"];
    
//    WEAK_SELF;
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        [weakSelf refreshData];
//    }];
//    
//    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        [weakSelf loadMoreData];
//    }];
}

- (void)refreshData{
    
    _index = 1;
    [self loadData];
}

- (void)loadMoreData{
    
    _index ++;
    [self loadData];
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
    
    static NSString *iden = @"MineTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    NSDictionary *dic = _data[indexPath.row];
    NSString *version = [Utils getTextWithModelStr:[dic objectForKey:@"version"]];
    NSString *description = [Utils getTextWithModelStr:[dic objectForKey:@"description"]];
    NSString *createDate = [Utils getTextWithModelStr:[dic objectForKey:@"createDate"]];
    NSString *title = [Utils getTextWithModelStr:[dic objectForKey:@"title"]];
    
    cell.nameLab.text = [NSString stringWithFormat:@"%@ %@",title,version];
    cell.megLab.text = description;
    cell.nameLab.textColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = _data[indexPath.row];
    NSString *description = [Utils getTextWithModelStr:[dic objectForKey:@"description"]];
    
    CGFloat height = [Utils getLabelHeightWithText:description width:(ScreenWidth-50)/2.0 font:24]+20;
    
    if(height < 100){
        
        return 100;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
