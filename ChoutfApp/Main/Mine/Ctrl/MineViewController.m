//
//  MineViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/8/29.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "MineHeaderView.h"
#import "PingHostViewController.h"
#import "InputUrlViewController.h"
#import "header.h"
#import "XC_DeviceInfo.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITableView *_tableView;
    NSArray *_data;
    NSMutableArray *_contentArr;
    UIView *_bgView;
    UITextField *_textField;
    UILabel *_titleLab;
    UIButton *_cancelButt;
    UIButton *_doneButt;
    MineHeaderView *_headerView;
//    HmsCustomScanViewController *hmsCustomScanViewController;
    
    
}


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    _data = @[@"url地址",@"检测更新",@"历史版本",@"日志信息",@"ping域名",@"pdf打印"];//,@"腾讯云扫码",@"扫一扫",@"华为扫一扫",@"pdf打印",@"手动输入url"
    
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUrl"];
    url = [Utils getTextWithModelStr:url];
    if(url.length == 0){
        
        url = H5_URL;
    }
    self.htmlStrl = url;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *version = [NSString stringWithFormat:@"V %@",app_Version];
    
    _contentArr = [@[url,version,@"",@"",@"",@"",@""] mutableCopy];
    
    if (_isFromURL) {
        
        _data = @[@"url地址"];
        self.title = @"url地址";
    }
    [self initView];
}

//添加事件
- (void)initView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviBarHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineTableViewCell"];
    
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
    _textField.placeholder = @"请输入url地址";
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
    _titleLab.text = @"修改url地址";
    [_bgView addSubview:_titleLab];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.font = [UIFont systemFontOfSize:18];
    
//    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"MineHeaderView" owner:self options:nil] lastObject];
//    _tableView.tableHeaderView = _headerView;
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *version = [NSString stringWithFormat:@"V %@",app_Version];
//    
//    _headerView.megLab.text = version;
//    _headerView.nameLab.text = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    
//    NSString *IP = [XC_DeviceInfo getIPAddress:YES];
//    
//    _headerView.ipLab.text = [NSString stringWithFormat:@"IP地址:%@",IP];
}

- (void)doneButtAc{
    
    NSString *text = [Utils getTextWithModelStr:_textField.text];
    if(text.length == 0){
        
        [Utils showMessage:@"请输入url地址"];
        return;
    }
    _bgView.hidden = YES;
    
    _contentArr[0] = text;
    self.htmlStrl = text;
    [_tableView reloadData];
    [_textField resignFirstResponder];
    _textField.text = @"";
    
}

- (void)cancelButtAc{
    
    _bgView.hidden = YES;
    [_textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden = @"MineTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    cell.nameLab.text = _data[indexPath.row];
    cell.nameLab.textColor = [UIColor blackColor];
    cell.megLab.text = _contentArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row >= 2){
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

//展示手动输入弹框
- (void)showInputView{
    
    InputUrlViewController *urlCtrl = [[InputUrlViewController alloc] init];
    urlCtrl.modalPresentationStyle = 5;
    urlCtrl.block = ^(NSString * _Nullable url) {
        
        self->_contentArr[0] = url;
        self.htmlStrl = url;
        [self->_tableView reloadData];
    };
    [self presentViewController:urlCtrl animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0){
       
       if(isDev){//开发环境
           
           SelURLAlertViewController *alertCtrl = [[SelURLAlertViewController alloc] init];
           alertCtrl.modalPresentationStyle = 5;
           alertCtrl.block = ^(NSString *title) {
             
               if([title isEqualToString:@"手动输入"]){
                   
//                   self->_bgView.hidden = NO;
                   [self showInputView];
                   
               }else{
                   
                   self->_contentArr[0] = title;
                   self.htmlStrl = title;
                   [self->_tableView reloadData];
               }
           };
           [self presentViewController:alertCtrl animated:NO completion:nil];
           
       }
    }else if(indexPath.row == 1){
        
        [self checkAppVersion];
    }else if(indexPath.row == 2){
        
        HistoryVersionViewController *hisCtrl = [[HistoryVersionViewController alloc] init];
        hisCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hisCtrl animated:YES];
    }else if(indexPath.row == 3){
        
        LogMessageViewController *vc = [[LogMessageViewController alloc] init];
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 4){
        
        PingHostViewController *hostCtrl = [[PingHostViewController alloc] init];
        
        hostCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hostCtrl animated:YES];
        
    }else if(indexPath.row == 5){

        //打印PDF文件
        PrinterPdfViewController *pdfCtrl = [[PrinterPdfViewController alloc] init];
        pdfCtrl.htmlStrl = @"https://sales-portal-pos-sit.chowtaifook.sz/guide/guide1.pdf";
//        [self.navigationController pushViewController:pdfCtrl animated:YES];
        pdfCtrl.modalPresentationStyle = 5;
        [self presentViewController:pdfCtrl animated:YES completion:nil];
    }else{
        
       
    }
}

//CustomizedScan Delegate
- (void)customizedScanDelegateForResult:(NSDictionary *)resultDic{
    
    if([resultDic isKindOfClass:[NSDictionary class]]){
        
        NSString *text = [Utils getTextWithModelStr:[resultDic objectForKey:@"text"]];
        
        [Utils showMessage:text];
        
    }
     
//    dispatch_async(dispatch_get_main_queue(), ^{
//      
//        [self->hmsCustomScanViewController backAction];
//        self->hmsCustomScanViewController = nil;
//        
//    });
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    self.mm_drawerController.maximumLeftDrawerWidth = ScreenWidth;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (void)onlyBackButtonAction{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"back" forKey:@"backHome"];
    [self.navigationController popViewControllerAnimated:YES];
    if([_delegate respondsToSelector:@selector(changeUrlStr:)]){
        
        [_delegate changeUrlStr:self.htmlStrl];
    }
}

//检测是否有新版本
- (void)checkAppVersion{
    
    NSDictionary *dic = @{
        
        @"platform":@"0",//0:ios 1:android
        @"type":@"1",// 1:smart portal sales 2:查货系统
    };
    [DataService requestDataWithURL:@"SALES-PORTAL-API/api/common/getVersion" withMethod:@"GET" withParames:[dic mutableCopy] withBlock:^(id result) {

        if(![result isKindOfClass:[NSDictionary class]]){

            [Utils showMessage:@"当前已是最新版本"];
            return;
        }
        NSInteger code = [[result objectForKey:@"code"] integerValue];
        if(code == 200){
            
            NSDictionary *data = [result objectForKey:@"data"];
            if([data isKindOfClass:[NSDictionary class]]){
                
                NSArray *records = [data objectForKey:@"records"];
                if(records.count > 0){
                    
                    NSDictionary *dict = records[0];
                    [self showAppUpdateView:dict];
                    
                }else{
                    
                    [Utils showMessage:@"当前已是最新版本"];
                }
            }
        }else{
            
            [Utils showMessage:@"当前已是最新版本"];
        }
    }];
}

- (void)showAppUpdateView:(NSDictionary *)dic{
    
    if(![dic isKindOfClass:[NSDictionary class]]){
        
        [Utils showMessage:@"当前已是最新版本"];
        return;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSString *version = [Utils getTextWithModelStr:[dic objectForKey:@"version"]];
    NSString *description = [Utils getTextWithModelStr:[dic objectForKey:@"description"]];
    NSString *updateUrl = [Utils getTextWithModelStr:[dic objectForKey:@"updateUrl"]];
    BOOL forceUpdate = [[Utils getTextWithModelStr:[dic objectForKey:@"forceUpdate"]] boolValue];
    //版本不同，需要更新
    if(![version isEqualToString:app_Version]){
        
        BOOL need = [self isNeedUpdata:app_Version withNew:version];
        
        if(need){
            
            AppUpdateAlertViewController *alertCtrl = [[AppUpdateAlertViewController alloc] init];
            alertCtrl.forceUpdate = forceUpdate;
            alertCtrl.content = description;
            alertCtrl.version = version;
            alertCtrl.updateUrl = updateUrl;
            alertCtrl.modalPresentationStyle = 5;
            [self presentViewController:alertCtrl animated:NO completion:nil];
        }else{
            
            [Utils showMessage:@"当前已是最新版本"];
        }
    }else{
        
        [Utils showMessage:@"当前已是最新版本"];
    }
}

//对版本号进行比较，判断是否需要更新
- (BOOL)isNeedUpdata:(NSString *)version withNew:(NSString *)v{
    
    NSArray *arr1 = [version componentsSeparatedByString:@"."];
    NSMutableArray *arr = [arr1 mutableCopy];
    for(int i = 0; i < 4; i ++) {
        
        [arr addObject:@"0"];
    }
    NSArray *arr2 = [v componentsSeparatedByString:@"."];
    
    for (int i = 0; i < arr2.count; i ++) {
        
        NSInteger num1 = [arr[i] integerValue];//当前
        NSInteger num2 = [arr2[i] integerValue];//最新
        
        if(num2 > num1){//需要更新
            
            return YES;
        }else if (num2 < num1){//不更新
            
            return NO;
        }else{//相等时进入下一次循环比较
            
            
        }
    }
    
    return NO;
}



- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.htmlStrl forKey:@"currentUrl"];
}






@end
