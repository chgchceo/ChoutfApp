//
//  QRScanAnimationView.m
//  LocalSpecialty
//
//  Created by YD on 2022/7/27.
//

#import "QRScanAnimationView.h"


@interface QRScanAnimationView ()
{
    UIImageView * line_imageView_ ;
    NSTimer * animation_timer_;
    int addOrCut_;
}

@end

@implementation QRScanAnimationView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //使用CGContextRef重写drawRect方法会产生一个默认的黑色的北京，需要在初始化方法中提前设置为clearcolor
        [self setBackgroundColor:[UIColor clearColor]];
        
        //线移动的imageView
        line_imageView_=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
        [self addSubview:line_imageView_];
        
        //初始位置为当前视图距离顶部的四分之一处
        [line_imageView_ setFrame:CGRectMake(0, self.bounds.size.height/4, self.bounds.size.width, 30)];
    }
    return self;
}

// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGFloat weight_ = self.frame.size.width;        //视图宽度
    CGFloat height_ = self.frame.size.height;       //视图高度

    CGFloat view_height_ = 10;
    CGFloat view_weight_ = 10;                      //纵向线段宽度

    CGFloat view_long_ = weight_/10;                //线段长度



    CGContextRef context = UIGraphicsGetCurrentContext();


//    CGContextSetRGBFillColor (context,  0, 1, 0, 1.0);//设置填充颜色
    //    CGContextSetRGBStrokeColor(context,0, 1, 0, 1.0);//画笔线的颜色
//    CGContextSetRGBFillColor (context,  157/255.0, 48/255.0, 48/255.0, 1.0);//设置填充颜色
    CGContextSetRGBStrokeColor(context,  123/255.0, 48/255.0, 53/255.0, 0.0);//画笔线的颜色

    CGContextSetLineWidth(context, view_height_);




    //上，左，顶

    CGPoint aPoints[2];//坐标点
    aPoints[0] =CGPointMake(0, view_height_/2);//坐标1
    aPoints[1] =CGPointMake(view_long_, view_height_/2);//坐标2

    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

    //上，左，左

    aPoints[0] =CGPointMake(view_weight_/2, 0);//坐标1
    aPoints[1] =CGPointMake(view_weight_/2 , view_long_);//坐标2

    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

    //上，右，顶

    aPoints[0] =CGPointMake(weight_-view_long_,view_height_/2);//坐标1
    aPoints[1] =CGPointMake(weight_, view_height_/2);//坐标2

    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

    //上，右，右

    aPoints[0] =CGPointMake(weight_-view_weight_/2, 0);//坐标1
    aPoints[1] =CGPointMake(weight_-view_weight_/2 , view_long_);//坐标2

    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

    //下，左，左

    aPoints[0] =CGPointMake(view_weight_/2, height_-view_long_);//坐标1
    aPoints[1] =CGPointMake(view_weight_/2 , height_);//坐标2

    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

    //下，左，底

    aPoints[0] =CGPointMake(0, height_-view_height_/2);//坐标1
    aPoints[1] =CGPointMake(view_long_ , height_-view_height_/2);//坐标2

    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

    //下，右，右

    aPoints[0] =CGPointMake(weight_-view_weight_/2, height_-view_long_);//坐标1
    aPoints[1] =CGPointMake(weight_-view_weight_/2 , height_);//坐标2

    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

    //下，右，底

    aPoints[0] =CGPointMake(weight_-view_long_, height_-view_height_/2);//坐标1
    aPoints[1] =CGPointMake(weight_ , height_-view_height_/2);//坐标2

    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
}

/**
 开始动画
 */
- (void)startAnimation
{
    if (animation_timer_) {
        [animation_timer_ invalidate];
    }
 
    //创建一个定时器，这种创建方式需要手动将timer放到runloop中
        animation_timer_=[NSTimer timerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            if (self->line_imageView_.frame.origin.y>=self.frame.size.height*3/4) {
                self->addOrCut_=-1;
            }
            else if (self->line_imageView_.frame.origin.y<=self.frame.size.height/4)
            {
                self->addOrCut_=1;
            }
            
            [self->line_imageView_ setFrame:CGRectMake(self->line_imageView_.frame.origin.x, self->line_imageView_.frame.origin.y+self->addOrCut_, self->line_imageView_.frame.size.width, self->line_imageView_.frame.size.height)];
        }];
    
    
    [[NSRunLoop mainRunLoop]addTimer:animation_timer_ forMode:NSDefaultRunLoopMode];

    
}
- (void)stopAnimation
{
    [animation_timer_ invalidate];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
