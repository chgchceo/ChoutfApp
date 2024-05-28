//
//  LeftItemView.m
//  ChoutfApp
//
//  Created by cheng on 2024/4/22.
//

#import "LeftItemView.h"
#import "MineTableViewCell.h"

@interface LeftItemView ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    
    NSArray *_data;
    NSMutableArray *_contentArr;
    
}



@end

@implementation LeftItemView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    _data = @[@"设置",@"清理缓存"];
    [self initView];
}

- (void)initView{
    
    _butt.layer.cornerRadius = 21;
    _butt.layer.masksToBounds = YES;
    
    _megLab.text = [self getCurrentTimePeriod];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAc)];
    tapGes.delegate = self;
    [self addGestureRecognizer:tapGes];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineTableViewCell"];
    _tableView.userInteractionEnabled = YES;
    
    _bannerView.layer.cornerRadius = 15;
    _bannerView.layer.masksToBounds = YES;
    _midView.layer.cornerRadius = 15;
    _midView.layer.masksToBounds = YES;
    _bottomView.layer.cornerRadius = 15;
    _bottomView.layer.masksToBounds = YES;
    
    for (UIView *bgView in _bgArr) {
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTapAc:)];
        
        [bgView addGestureRecognizer:tapGes];
    }
}

- (void)bgViewTapAc:(UITapGestureRecognizer *)tap{
    
    UIView *bgView = (UIView *)tap.view;
    NSInteger index = [_bgArr indexOfObject:bgView];
    NSArray *titleArr = @[@"日志信息",@"清理缓存",@"ping域名",@"检测更新",@"历史版本",@"扫一扫",@"关于我们",@"设置",@"意见反馈"];
    
    NSString *title = @"";
    if (titleArr.count > index) {
        
        title = titleArr[index];
    }
    if ([_delegate respondsToSelector:@selector(clickLeftItemViewWithTitle:)]) {
        
        [_delegate clickLeftItemViewWithTitle:title];
    }
}

- (void)tapAc{
    
    if ([_delegate respondsToSelector:@selector(clickLeftItemViewWithTitle:)]) {
        
        [_delegate clickLeftItemViewWithTitle:@"关闭"];
    }
}

- (IBAction)qrCodeButtAc:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(clickLeftItemViewWithTitle:)]) {
        
        [_delegate clickLeftItemViewWithTitle:@"扫一扫"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden = @"MineTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    cell.nameLab.text = _data[indexPath.row];
    cell.nameLab.textColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.moreView.hidden = false;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0){
        
        if ([_delegate respondsToSelector:@selector(clickLeftItemViewWithTitle:)]) {
            
            [_delegate clickLeftItemViewWithTitle:@"设置"];
        }
    }else if(indexPath.row == 1){
        
        if ([_delegate respondsToSelector:@selector(clickLeftItemViewWithTitle:)]) {
            
            [_delegate clickLeftItemViewWithTitle:@"清理缓存"];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {

  if([NSStringFromClass([touch.view class]) isEqual:@"UITableViewCellContentView"]){

      return NO;

   }

   return YES;
}
  
- (NSString *)getCurrentTimePeriod{
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger hour = [calendar component:NSCalendarUnitHour fromDate:currentDate];
      
    if (hour >= 0 && hour < 12) {
        return @"上午好！";
    } else if (hour >= 12 && hour < 14) {
        return @"中午好！";
    } else if (hour >= 14 && hour < 18) {
        return @"下午好！";
    } else {
        return @"晚上好！";
    }
}

- (IBAction)moreButtAc:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(clickLeftItemViewWithTitle:)]) {
        
        [_delegate clickLeftItemViewWithTitle:@"更多"];
    }
}


@end
