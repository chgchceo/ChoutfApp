//
//  GreenView.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/12/15.
//

#import "GreenView.h"

@implementation GreenView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

//绘制图像
- (void)drawRect:(CGRect)rect {

//    CGPoint p1 = CGPointMake(0, 0);
//    CGPoint p2 = CGPointMake(0, 0);
//    CGPoint p3 = CGPointMake(0, 0);
//    CGPoint p4 = CGPointMake(0, 0);
//
//    for (int i = 0; i < self.arr.count; i ++) {
//        
//        float pos_X = [[[self.arr objectAtIndex:i] objectForKey:@"posX"] floatValue];
//        float pos_Y = [[[self.arr objectAtIndex:i] objectForKey:@"posY"] floatValue];
//
//        CGPoint point = CGPointMake(pos_X, pos_Y);
//
//        if(i == 0){
//
//            p1 = point;
//        }else if(i == 1){
//            p2 = point;
//        }else if(i == 2){
//            p3 = point;
//        }else if(i == 3){
//            p4 = point;
//        }
//    }
//    CGContextRef context =  UIGraphicsGetCurrentContext();
//
//    CGPoint  points[] = {p1,p2,p3,p4,p1};
//
//    CGContextAddLines(context, points, 5);
//
//    //设置属性
//    [[UIColor greenColor] setStroke];
//
//    [[UIColor greenColor] setFill];
//
//    //绘制路径
//    CGContextDrawPath(context, kCGPathFillStroke);
//


}


@end
