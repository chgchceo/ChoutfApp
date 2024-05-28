//
//  InputUrlViewController.m
//  ZDFProduct
//
//  Created by cheng on 2024/3/11.
//

#import "InputUrlViewController.h"
#import "InputTableViewCell.h"
#import "Utils.h"


@interface InputUrlViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    
    NSMutableArray *_data;
}


@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *butt;

@property (weak, nonatomic) IBOutlet UILabel *megLab;


@end

@implementation InputUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [[NSMutableArray alloc] init];
    [self initView];
}

- (void)initView{
    
    _textField.layer.cornerRadius = 10;
    _textField.layer.masksToBounds = YES;
    _textField.layer.borderWidth = 1;
    _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _bgView.layer.cornerRadius = 20;
    _bgView.layer.masksToBounds = YES;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _butt.layer.cornerRadius = 10;
    _butt.layer.masksToBounds = YES;
    
    NSString *saveLocalUrl = [Utils getTextWithModelStr:[[NSUserDefaults standardUserDefaults] objectForKey:@"saveLocalUrl"]];
    
    NSArray *arr = [Utils stringToJSON:saveLocalUrl];
    _data = [arr mutableCopy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_data.count == 0) {
        
        _megLab.hidden = NO;
    }else{
        
        _megLab.hidden = YES;
    }
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item_cell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InputTableViewCell" owner:self options:nil] lastObject];
    }
    
    NSString *text = _data[indexPath.row];
    cell.contentLab.text = text;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}


- (IBAction)doneButtAc:(id)sender {
    
    NSString *url = [Utils getSimpleString:_textField.text];
    
    if (url.length == 0) {
        
        [Utils showMessage:@"输入内容不能为空"];
        return;
    }
    
    if (![_data containsObject:url]) {
        
        [_data addObject:url];
        NSString *str = [Utils changeArrtoJson:_data];
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"saveLocalUrl"];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.block) {
        
        self.block(url);
    }
}

- (IBAction)clearButtAc:(id)sender {
    
    if(_data.count == 0){
        
        [Utils showMessage:@"暂无历史记录"];
        return;
    }
    
    // 创建UIAlertController实例
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                             message:@"是否确定要清除全部历史记录"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加一个“确定”按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        // 处理按钮点击事件
        NSLog(@"确定按钮被点击了");
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"saveLocalUrl"];
        [self->_data removeAllObjects];
        [self->_tableView reloadData];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    
    // 将按钮添加到alertController
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    // 显示alertController
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (IBAction)closeButtAc:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *text = _data[indexPath.row];
    
    if (self.block) {
        
        self.block(text);
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}



@end
