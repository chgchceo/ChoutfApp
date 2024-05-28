//
//  PrintPDFViewController.m
//  ChoutfApp
//
//  Created by cheng on 2024/5/13.
//

#import "PrintPDFViewController.h"
#import "header.h"
#import "PrinterH5ViewController.h"

@interface PrintPDFViewController ()<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *butt;



@end

@implementation PrintPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"pdf打印";
    [self initView];
}

- (void)initView{
    
    _butt.layer.cornerRadius = 10;
    _butt.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 10;
    _textView.layer.masksToBounds = YES;
    _textView.delegate = self;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAc)];
    [self.view addGestureRecognizer:tapGes];
    
    // 设置 textView 的内边距
    UIEdgeInsets insets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0); // 上、左、下、右的内边距
    self.textView.textContainerInset = insets;
    self.textView.returnKeyType = UIReturnKeyDone;
}

- (void)tapAc{
    
    [_textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqual:@"\n"]) {
        
        [_textView resignFirstResponder];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    NSString *text = _textView.text;
    _textView.textColor = [UIColor blackColor];
    if ([text isEqualToString:@"请输入pdf文件或网页的URL地址"]) {
        
        _textView.text = @"";
        
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *text = _textView.text;
    if ([text isEqualToString:@""] || [text isEqualToString:@"请输入pdf文件或网页的URL地址"]) {
        
        _textView.text = @"请输入pdf文件或网页的URL地址";
        _textView.textColor = [UIColor lightGrayColor];
    }else{
        _textView.textColor = [UIColor blackColor];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    NSString *text = _textView.text;
    if ([text isEqualToString:@""]) {
        
        _textView.text = @"请输入pdf文件或网页的URL地址";
        _textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}

- (IBAction)doneButtAc:(id)sender {
    
//    _textView.text = @"https://baidu.com";
    NSString *text = [Utils getTextWithModelStr:_textView.text];
    
    if (text.length == 0 || [text isEqualToString:@"请输入pdf文件或网页的URL地址"]) {
        
        [Utils showMessage:@"输入的内容不能为空！"];
        return;
    }
    
    if (![text containsString:@"http"]) {
        
        [Utils showMessage:@"输入内容格式不正确！"];
        return;
    }
    
    PrinterH5ViewController *h5Ctrl = [[PrinterH5ViewController alloc] init];
    h5Ctrl.modalPresentationStyle = 5;
    h5Ctrl.htmlStrl = text;
    [self presentViewController:h5Ctrl animated:YES completion:nil];
}










@end
