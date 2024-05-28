//
//  PrintTextViewController.m
//  ChoutfApp
//
//  Created by cheng on 2024/5/13.
//

#import "PrintTextViewController.h"
#import "header.h"

@interface PrintTextViewController ()<UITextViewDelegate,UIPrintInteractionControllerDelegate>


@property (weak, nonatomic) IBOutlet UITextView *textView;


@property (weak, nonatomic) IBOutlet UIButton *butt;


@end

@implementation PrintTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文本打印";
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
    if ([text isEqualToString:@"请输入要打印的文本内容"]) {
        
        _textView.text = @"";
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *text = _textView.text;
    if ([text isEqualToString:@""] || [text isEqualToString:@"请输入要打印的文本内容"]) {
        
        _textView.text = @"请输入要打印的文本内容";
        _textView.textColor = [UIColor lightGrayColor];
    }else{
        _textView.textColor = [UIColor blackColor];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    NSString *text = _textView.text;
    if ([text isEqualToString:@""]) {
        
        _textView.text = @"请输入要打印的文本内容";
        _textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}

- (IBAction)doneButtAc:(id)sender {
    
    NSString *text = [Utils getTextWithModelStr:_textView.text];
    
    if (text.length == 0 || [text isEqualToString:@"请输入要打印的文本内容"]) {
        
        [Utils showMessage:@"输入的内容不能为空！"];
        return;
    }
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    if  (pic) {
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"jobName";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        UIMarkupTextPrintFormatter *htmlFormatter = [[UIMarkupTextPrintFormatter alloc]
                                                     initWithMarkupText:text];
        htmlFormatter.startPage = 0;
        
        pic.printFormatter = htmlFormatter;
        
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (!completed && error)
                NSLog(@"FAILED! due to error in domain %@ with error code %u",
                      error.domain, error.code);
        };
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:nil];
            [pic presentFromBarButtonItem:item animated:YES
                        completionHandler:completionHandler];
        } else {
            [pic presentAnimated:YES completionHandler:completionHandler];
        }
    }
}










@end
