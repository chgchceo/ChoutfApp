//
//  PingHostViewController.m
//  ZDFProduct
//
//  Created by cheng on 2024/3/8.
//

#import "PingHostViewController.h"
#import "HostNameSelectViewController.h"
#import "header.h"
#import "PingHost.h"

@interface PingHostViewController ()<UITextViewDelegate>{
    
    PingHost *_pingHost;
}

@property (weak, nonatomic) IBOutlet UIButton *selButt;



@property (weak, nonatomic) IBOutlet UIButton *clearButt;


@property (weak, nonatomic) IBOutlet UITextView *textView;


@property (weak, nonatomic) IBOutlet UIButton *butt;

@property (weak, nonatomic) IBOutlet UITextView *resultView;



@end

@implementation PingHostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ping域名";
    
    [self initView];
}

- (void)initView{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line];
    
    _butt.layer.cornerRadius = 10;
    _butt.layer.masksToBounds = YES;
    
    _selButt.layer.cornerRadius = 10;
    _selButt.layer.masksToBounds = YES;
    
    _textView.layer.cornerRadius = 10;
    _textView.layer.masksToBounds = YES;
    
    _resultView.layer.cornerRadius = 10;
    _resultView.layer.masksToBounds = YES;
    
    _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 50);
    _resultView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    
    _textView.layoutManager.allowsNonContiguousLayout = NO;
    
    _resultView.editable = NO;
    _textView.delegate = self;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAc)];
    [self.view addGestureRecognizer:tapGes];
    _pingHost = [[PingHost alloc] init];
}

- (void)tapAc{
    
    [_textView resignFirstResponder];
}

- (IBAction)selButtAc:(id)sender {
    
    HostNameSelectViewController *hostCtrl = [[HostNameSelectViewController alloc] init];
    hostCtrl.modalPresentationStyle = 5;
    hostCtrl.block = ^(NSString * _Nullable hostName) {
      
        self->_textView.text = hostName;
        self->_textView.textColor = [UIColor darkGrayColor];
    };
    hostCtrl.data = @[
    
        @"https://www.baidu.com",
        @"https://sales-uat.chowtaifook.sz",
        @"https://sales.chowtaifook.sz",
        @"https://www.hao123.com/?src=from_pc_logon",
        @"https://www.163.com",
    ];
    [self presentViewController:hostCtrl animated:NO completion:nil];
}

- (IBAction)doneButtAc:(id)sender {
    
    [_textView resignFirstResponder];
    _resultView.text = @"";
    NSString *text = [Utils getTextWithModelStr:_textView.text];
    if ([text isEqualToString:@""] || [text isEqualToString:@"请输入域名地址"]) {
        
        _textView.text = @"请输入域名地址";
        [Utils showMessage:@"请输入域名地址"];
        return;
    }
    text = [self getHostNameFromStr:text];
    [self showLoadingView:@""];
    [self performSelector:@selector(showResult:) withObject:text afterDelay:1];
}
//去掉链接中多余的部分
- (NSString *)getHostNameFromStr:(NSString *)url{
    //去掉https:// ，http://
    NSArray *arr = [url componentsSeparatedByString:@"://"];
    url = [arr lastObject];
    if ([url containsString:@"/"]) {
     
        NSRange range= [url rangeOfString:@"/"];
        url = [url substringToIndex:range.location];
    }
    
//    //去掉www.
//    url = [url stringByReplacingOccurrencesOfString:@"www." withString:@""];
    
    return url;
}

- (void)showResult:(NSString *)text{
    
    [self hiddenView];
    [_pingHost pingHostName:text withBlock:^(_Bool isLink) {
       
        if (isLink) {
            
            self->_resultView.text = [NSString stringWithFormat:@"Ping 成功！ \n\n域名：%@",text];
        }else{
            
            self->_resultView.text = [NSString stringWithFormat:@"Ping 失败，请检查网络是否连接正确，或域名是否正确！ \n\n域名：%@",text];
        }
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    NSString *text = [Utils getTextWithModelStr:_textView.text];
    if ([text isEqualToString:@"请输入域名地址"]) {
        
        _textView.text = @"";
    }else{
        
        _clearButt.hidden = false;
    }
    _textView.textColor = [UIColor darkGrayColor];
    return true;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    NSString *text = [Utils getTextWithModelStr:_textView.text];
    _clearButt.hidden = true;
    if ([text isEqualToString:@""]) {
        
        _textView.text = @"请输入域名地址";
        _textView.textColor = [UIColor lightGrayColor];
    }else{
        
        _textView.textColor = [UIColor darkGrayColor];
    }
    return true;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *text = [Utils getTextWithModelStr:_textView.text];
    
    if (text.length > 0) {
        
        _clearButt.hidden = false;
        
    }else{
        _clearButt.hidden = true;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return true;
}

- (IBAction)clearButtAc:(id)sender {
    
    _textView.text = @"";
}






@end
