//
//  MaskView.m
//  LocalSpecialty
//
//  Created by YD on 2022/7/27.
//

#import "MaskView.h"

@implementation MaskView



/**
 根据蒙版的大小，视图扫码区域的大小创建蒙版
 
 @param maskFrame 蒙版在父视图中的大小
 @param scanFrame 扫码区域的大小
 @return 返回蒙版View
 */
- (instancetype)initMaskViewWithFrame:(CGRect)maskFrame
                        withScanFrame:(CGRect)scanFrame
{
    self = [super initWithFrame:maskFrame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:scanFrame cornerRadius:1] bezierPathByReversingPath]];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        
        maskLayer.path = maskPath.CGPath;
        
        self.layer.mask = maskLayer;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
