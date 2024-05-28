//
//  HomeViewController.m
//  SalesApp
//
//  Created by cheng on 2024/3/21.
//

#import "HomeViewController.h"
#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "header.h"
#import "UIViewController+MMDrawerController.h"



@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    
    UITableView *_tableView;
    NSArray *_data;
    NSMutableArray *_contentArr;
    
}


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    self.view.backgroundColor = [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:0.3];
    _data = @[@"设置",@"清理缓存"];//,@"华为扫码",@"原生扫码",@"zxing扫码",@"腾讯扫码(收费)"
    [self initView];
}

//添加事件
- (void)initView{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, ScreenHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviBarHeight, 300, ScreenHeight-NaviBarHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [bgView addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineTableViewCell"];
 
    _tableView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAc)];
    tapGes.delegate = self;
    [self.view addGestureRecognizer:tapGes];
}

- (void)tapAc{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden = @"MineTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    cell.nameLab.text = _data[indexPath.row];
    cell.nameLab.textColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.moreView.hidden = false;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    if (indexPath.row == 0){
       
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftViewItemClick" object:nil userInfo:@{@"name":@"set"}];
        
        UINavigationController *naVc = [[UINavigationController alloc] initWithRootViewController:self];
        MineViewController *mineCtrl = [[MineViewController alloc] init];
        [naVc pushViewController:mineCtrl animated:YES];
        
        
    }else if(indexPath.row == 1){
        
        [self showLoadingView:@""];
        [self clearWeblocalStorage];
        [self performSelector:@selector(clearFinish) withObject:nil afterDelay:2];
        
        return;
    }else if(indexPath.row == 2){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftViewItemClick" object:nil userInfo:@{@"name":@"sao1"}];
        
    }else if(indexPath.row == 3){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftViewItemClick" object:nil userInfo:@{@"name":@"sao2"}];
        
    }else if(indexPath.row == 4){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftViewItemClick" object:nil userInfo:@{@"name":@"sao3"}];
        
    }else if(indexPath.row == 5){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftViewItemClick" object:nil userInfo:@{@"name":@"sao4"}];
        
    }
//    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)clearFinish{
    
    [self hiddenView];
    [Utils showMessage:@"清理完成"];
}

#pragma mark - 清除web缓存
- (void)clearWeblocalStorage {
    
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.5 animations:^{
       
        self.mm_drawerController.maximumLeftDrawerWidth = 300.0;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {

  if([NSStringFromClass([touch.view class]) isEqual:@"UITableViewCellContentView"]){

      return NO;

   }

   return YES;
}

@end
