//
//  LineView.m
//
//
//

#import "LineView2.h"
#define M_SIZE 30

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define mc_Is_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define mc_Is_iphoneX SCREEN_WIDTH >=375.0f && SCREEN_HEIGHT >=812.0f&& mc_Is_iphone
#define mcNavBarAndStatusBarHeight (CGFloat)(mc_Is_iphoneX?(88.0):(64.0))

/**
 TODO: Demo 代码仅展示接入集成示例，在接入时需客户侧完善优化
 */

@interface LineView2(){
    UIImage *imagePoint;
}

@property (strong, nonatomic) NSMutableArray *resultArr;

@end

@implementation LineView2

- (NSMutableArray *)resultArr {
    if (!_resultArr) {
        _resultArr = [NSMutableArray array];
    }
    return _resultArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imagePoint = [UIImage imageNamed:@"qbar_scan_point"];
    }
    return self;
}

- (void)addQBarResult:(QBarResult *)qbarResult{
    [self.resultArr addObject:qbarResult];
}

- (void)Clear{
    [self.resultArr removeAllObjects];
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    
    
    NSLog(@"%@",self.resultArr);
    for (QBarResult *rst in self.resultArr) {
        /**
         qBarDecodingWithSampleBufferN 接口返回的是图片(720x1280)坐标
         CGFloat tX = rst.rst_x / 720 * width;
         CGFloat tY = rst.rst_y / 1280 * height;
         CGFloat tW = rst.rst_width / 720 * width;
         CGFloat tH = rst.rst_height / 1280 * height;
         CGPoint centerPoint = CGPointMake(tX + tW/2, tY + tH/2);
         
         qBarDecodingWithSampleBuffer 返回的是比例值
         CGPoint centerPoint = CGPointMake(rst.rst_x*width + rst.rst_width*width/2, rst.rst_y*height + rst.rst_height*height/2);
         */
        CGFloat tX = rst.rst_x / 720 ;
        CGFloat tY = rst.rst_y / 1280 ;
        CGFloat tW = rst.rst_width / 720 ;
        CGFloat tH = rst.rst_height / 1280 ;
        
        NSLog(@"result-w %f %f %f %f",tX,tY,tW,tH);
        
        CGFloat target_X = (tX+tW/2)*viewWidth;
        CGFloat target_Y = (tY+tH/2)*viewHeight;
        CGFloat target_w = tW*viewWidth;
        CGFloat target_h = tH*viewHeight;
        
        CGPoint centerPoint = CGPointMake(target_X, target_Y);
        CGFloat pointX = centerPoint.x - M_SIZE/2;
        CGFloat pointY = centerPoint.y - M_SIZE/2 + mcNavBarAndStatusBarHeight;
        CGFloat rectX = centerPoint.x - target_w/2;
        CGFloat rectY = centerPoint.y - target_h/2 + mcNavBarAndStatusBarHeight;
        // Drawing code
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 3.0);
        UIFont *font = [UIFont systemFontOfSize:13];
        NSDictionary *attriDict = @{
            NSFontAttributeName:font,
            NSForegroundColorAttributeName:[UIColor whiteColor]
        };
//        
//        CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
//        CGContextFillEllipseInRect(context, CGRectMake(pointX, pointY, M_SIZE, M_SIZE));
        
        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextSetLineWidth(context, 2.0);
        CGRect rect = CGRectMake(rectX, rectY, target_w, target_h);
        CGContextAddRect(context, rect);
        CGContextDrawPath(context, kCGPathFillStroke);
        // 绘制文字
//        [rst.data drawInRect:CGRectMake(pointX+M_SIZE, pointY+M_SIZE, 100, 60) withAttributes:attriDict];
    }
}

@end
