//
//  InputTableViewCell.m
//  ZDFProduct
//
//  Created by cheng on 2024/3/14.
//

#import "InputTableViewCell.h"
#import "Utils.h"


@interface InputTableViewCell ()




@property (weak, nonatomic) IBOutlet UIButton *butt;

@end



@implementation InputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initView];
    
}

- (void)initView{
    
    _butt.layer.cornerRadius = 5;
    _butt.layer.masksToBounds = YES;
    
}

- (IBAction)copyButtAc:(id)sender {
    
    NSString *content = [Utils getTextWithModelStr:self.contentLab.text];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:content];
    [Utils showMessage:@"复制成功"];
    
}





@end
