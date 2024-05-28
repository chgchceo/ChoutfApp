//
//  QRGreenView.m
//  ZDFProduct
//
//  Created by chgch on 2024/2/20.
//

#import "QRGreenView.h"

@implementation QRGreenView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//绘制图像
- (void)drawRect:(CGRect)rect {

    CGPoint p1 = CGPointMake(0, 0);
    CGPoint p2 = CGPointMake(0, 0);
    CGPoint p3 = CGPointMake(0, 0);
    CGPoint p4 = CGPointMake(0, 0);

    for (int i = 0; i < self.arr.count; i ++) {

        float pos_X = [[[self.arr objectAtIndex:i] objectForKey:@"posX"] floatValue];
        float pos_Y = [[[self.arr objectAtIndex:i] objectForKey:@"posY"] floatValue];

        if(_isSignle){//特殊情况的处理,对坐标位置进行适配
            
            if (ISIpad) {
                
                pos_Y = pos_Y -500;
                pos_X = pos_X -120;
            }else{
                
                pos_Y = pos_Y -200*(ScreenHeight/736.0);
                pos_X = pos_X -50*(ScreenWidth/414.0);
            }
        }
        
        
        if (pos_X< 0) {
            
            pos_X = 0;
        }

        if (pos_X>ScreenWidth ) {
            
            pos_X = ScreenWidth-20;
        }
        if (pos_Y< 0) {
            
            pos_Y = 0;
        }

        if (pos_Y>ScreenHeight ) {
            
            pos_Y = ScreenHeight-NaviBarHeight;
        }
        
        CGPoint point = CGPointMake(pos_X, pos_Y);
        if(i == 0){

            p1 = point;
        }else if(i == 1){
            p2 = point;
        }else if(i == 2){
            p3 = point;
        }else if(i == 3){
            p4 = point;
        }
    }
    CGContextRef context =  UIGraphicsGetCurrentContext();

    CGPoint  points[] = {p1,p2,p3,p4,p1};

    CGContextAddLines(context, points, 5);

    //设置属性
    
    UIColor *color = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    [color setFill];
    [color setStroke];
    //绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);



}


@end
