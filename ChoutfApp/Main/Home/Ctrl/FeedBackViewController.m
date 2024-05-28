//
//  FeedBackViewController.m
//  ChoutfApp
//
//  Created by cheng on 2024/4/26.
//

#import "FeedBackViewController.h"
#import "Utils.h"

@interface FeedBackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *butt;


@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    [self initView];
}

- (void)initView{
    
    _butt.layer.cornerRadius = 10;
    _butt.layer.masksToBounds = YES;
    
    _textView.layer.cornerRadius = 10;
    _butt.layer.masksToBounds = YES;
    
    _textView.delegate = self;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAc)];
    [self.view addGestureRecognizer:tapGes];
    
    // 设置 textView 的内边距
    UIEdgeInsets insets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0); // 上、左、下、右的内边距
//    self.textView.contentInset = insets;
    self.textView.textContainerInset = insets;
    self.textView.returnKeyType = UIReturnKeyDone;
}

- (void)tapAc{
    
    [_textView resignFirstResponder];
}

- (IBAction)dontButtAc:(id)sender {
    
    NSString *text = [Utils getTextWithModelStr:_textView.text];
    
    if (text.length == 0 || [text isEqualToString:@"请输入您的宝贵意见"]) {
        
        [Utils showMessage:@"输入的内容不能为空！"];
        return;
    }
    
    [self showLoadingView:@""];
    [self performSelector:@selector(hideAlertView) withObject:nil afterDelay:2];
}

- (void)hideAlertView{
    
    [self hiddenView];
    [Utils showMessage:@"感谢您的宝贵意见！"];
    _textView.text = @"";
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqual:@"\n"]) {
        
        [_textView resignFirstResponder];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    NSString *text = _textView.text;
    if ([text isEqualToString:@"请输入您的宝贵意见"]) {
        
        _textView.text = @"";
        _textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    NSString *text = _textView.text;
    if ([text isEqualToString:@""]) {
        
        _textView.text = @"请输入您的宝贵意见";
        _textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}

@end
