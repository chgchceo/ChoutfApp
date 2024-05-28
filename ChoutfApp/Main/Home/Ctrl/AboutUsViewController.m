//
//  AboutUsViewController.m
//  ChoutfApp
//
//  Created by cheng on 2024/4/26.
//

#import "AboutUsViewController.h"
#import "MineHeaderView.h"
#import "XC_DeviceInfo.h"
#import "MineTableViewCell.h"


@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
    MineHeaderView *_headerView;
    NSArray *_titleArr;
    NSArray *_contentArr;
    
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    _titleArr = @[@"公司地址:",@"联系电话:",@"技术支持:"];
    _contentArr = @[@"周大福集团大厦",@"180********",@"180********"];
    [self initView];
}

- (void)initView{
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineTableViewCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"MineHeaderView" owner:self options:nil] lastObject];
    _tableView.tableHeaderView = _headerView;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *version = [NSString stringWithFormat:@"V %@",app_Version];
    
    _headerView.megLab.text = version;
    _headerView.nameLab.text = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    NSString *IP = [XC_DeviceInfo getIPAddress:YES];
    
    _headerView.ipLab.text = [NSString stringWithFormat:@"IP地址:%@",IP];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden = @"MineTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    cell.nameLab.text = _titleArr[indexPath.row];
    cell.nameLab.textColor = [UIColor blackColor];
    cell.megLab.text = _contentArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if(indexPath.row >= 2){
//        
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }else{
//        
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
@end
