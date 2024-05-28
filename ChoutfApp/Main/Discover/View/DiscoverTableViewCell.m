//
//  DiscoverTableViewCell.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/8/29.
//

#import "DiscoverTableViewCell.h"

@implementation DiscoverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)delButtAc:(id)sender {
    
    if([_delegate respondsToSelector:@selector(delButtAc:)]){
        
        [_delegate delButtAc:self.index];
    }
}



@end
