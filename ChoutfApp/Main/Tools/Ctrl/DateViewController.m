////
////  DateViewController.m
////  ZDFProduct
////
////  Created by yuanbing bei on 2023/8/25.
////
//
//#import "DateViewController.h"
//
//@interface DateViewController ()<UITableViewDelegate,UITableViewDataSource>{
//    
//    UITableView *_tableView;
//    NSMutableArray *_data;
//    
//}
//
//
//@end
//
//@implementation DateViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.title = @"日历事件";
//    _data = [[NSMutableArray alloc] init];
//    self.view.backgroundColor = [UIColor whiteColor];
//    _store = [[EKEventStore alloc] init];
//    accessGranted = FALSE;
//    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
//        
//        self->accessGranted = TRUE;
////        [self addEvent];
//        
//        }];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self initView];
//    [self loadData];
//}
//
//- (void)addEvent{
//    
//    if(accessGranted){
//    EKEvent *event = [EKEvent eventWithEventStore:_store];
//    event.startDate =[NSDate date];
//    event.endDate = [event.startDate dateByAddingTimeInterval:60*60];
//        event.title = @"hehe";
//    [event setCalendar:[_store defaultCalendarForNewEvents]];
//    NSError *err = nil;
//    [_store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
////    NSString *savedEventId = event.eventIdentifier;
//    }
//}
//
////添加事件
//- (void)initView{
//    
//    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//    [self.view addSubview:_tableView];
//    
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return _data.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    static NSString *iden = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
//    if(cell == nil){
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
//    }
//    EKEvent *event = _data[indexPath.row];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@---------%@",event.title,event.startDate];
//    cell.textLabel.textColor = [UIColor blackColor];
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 100;
//}
//
//// 添加提醒事件
//- (void)addEventWithTimeStr:(NSString *)timeStr title:(NSString *)title planId:(NSString *)planId
//{
//    
//    EKEventStore *store = [[EKEventStore alloc] init];
//
//    if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
//        
//        [store requestAccessToEntityType:(EKEntityTypeEvent) completion:^(BOOL granted, NSError * _Nullable error) {
//           
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                
//                if (error) {
//                    NSLog(@"发生错误");
//                } else if (!granted) {
//                    NSLog(@"未获得使用日历权限");
//                } else {
//                    EKEvent *event = [EKEvent eventWithEventStore:store];
//                    event.title = title;
////                    event.location = @"位置";
//                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                    NSDate *date = [formatter dateFromString:timeStr];
//                    // 提前一个小时开始
//                    NSDate *startDate = [NSDate dateWithTimeInterval:-3600 sinceDate:date];
//                    // 提前一分钟结束
//                    NSDate *endDate = [NSDate dateWithTimeInterval:60 sinceDate:date];
//                    event.startDate = startDate;
//                    event.endDate = endDate;
//                    event.allDay = NO;
//                    // 添加闹钟结合（开始前多少秒）若为正则是开始后多少秒。
//                    EKAlarm *elarm2 = [EKAlarm alarmWithRelativeOffset:-20];
//                    [event addAlarm:elarm2];
//                    EKAlarm *elarm = [EKAlarm alarmWithRelativeOffset:-10];
//                    [event addAlarm:elarm];
//                    [event setCalendar:[store defaultCalendarForNewEvents]];
//                    
//                    NSError *error = nil;
//                    [store saveEvent:event span:EKSpanThisEvent error:&error];
//                    if (!error) {
//                        NSLog(@"添加时间成功");
//                        //添加成功后需要保存日历关键字
//                        NSString *iden = event.eventIdentifier;
//                        // 保存在沙盒，避免重复添加等其他判断
//                        [[NSUserDefaults standardUserDefaults] setObject:iden forKey:planId];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
//                    }
//                }
//            });
//        }];
//    }
//}
//
//// 移除提醒事件
//- (void)removeEventWithPlanID:(NSString *)planId
//{
//    EKEventStore *store = [[EKEventStore alloc] init];
//    // 获取上面的这个ID呀。
//    NSString *identifier = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:planId]];
//    EKEvent *event = [store eventWithIdentifier:identifier];
//    __block BOOL isRemoved = NO;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        NSError *err = nil;
//        
//        isRemoved = [store removeEvent:event span:EKSpanThisEvent commit:YES error:&err];
//        
//        if (!err) {
//            NSLog(@"删除日历成功");
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:identifier];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        
//    });
//}
////获取事件
//- (void)loadData{
//    
//    EKEventStore* eventStore = [[EKEventStore alloc] init];
//    
//    NSDate* ssdate = [NSDate dateWithTimeIntervalSinceNow:-3600*24*90];//事件段，开始时间
//    
//    NSDate* ssend = [NSDate dateWithTimeIntervalSinceNow:3600*24*90];//结束时间，取中间
//    
//    NSPredicate* predicate = [eventStore predicateForEventsWithStartDate:ssdate
//                              
//                                                                 endDate:ssend
//                              
//                                                               calendars:nil];//谓语获取，一种搜索方法
//    
//    NSArray* events = [eventStore eventsMatchingPredicate:predicate];//数组里面就是时间段中的EKEvent事件数组
//    
//    for (EKEvent *event in events) {
//        
//        if(event.title){
//            
//            [_data addObject:event];
//        }
//        NSLog(@"%@", event.title);
//        
//        NSLog(@"%@", event.startDate);
//        
//    }
//    
//    [_tableView reloadData];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 1;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    return nil;
//}
//@end
