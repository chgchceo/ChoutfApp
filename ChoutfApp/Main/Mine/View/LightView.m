//
//  LightView.m
//  ZDFProduct
//
//  Created by chgch on 2024/2/19.
//

#import "LightView.h"

@implementation LightView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    _bgView.layer.cornerRadius = 25;
    _bgView.layer.masksToBounds = YES;
    
    [_slider addTarget:self action:@selector(sliderAc:) forControlEvents:UIControlEventValueChanged];
    
//    [_slider setBackgroundColor:[UIColor redColor]];
    [_slider setTintColor:[UIColor greenColor]];
//    [_slider setThumbTintColor:[UIColor orangeColor]];
    [_slider setMaximumTrackTintColor:[UIColor grayColor]];
    [_slider setMinimumTrackTintColor:[UIColor greenColor]];
}



- (void)sliderAc:(UISlider*)s{
    
    CGFloat num = s.value;
    
    if([_delegate respondsToSelector:@selector(sliderValueChange:)]){
        
        [_delegate sliderValueChange:num];
    }
}



@end
