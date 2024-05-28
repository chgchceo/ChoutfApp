////
////  HWQRViewController.m
////  ZDFProduct
////
////  Created by yuanbing bei on 2023/11/29.
////
//
//#import "HWQRViewController.h"
//
//@interface HWQRViewController ()<CustomizedScanDelegate,UITableViewDelegate,UITableViewDataSource>{
//    
//    HmsCustomScanViewController *hmsCustomScanViewController;
//    UIButton *_changeButt;//切换扫描状态，单个/多个
//    BOOL _isSingleQR;//是否是单个扫描
//    UIView *_rightView;//右侧单边多个扫描结果展示视图
//    UITableView *_tableView;
//    NSMutableArray *_resultArr;//多个扫描的结果
//    NSMutableArray *_selArr;//选中的扫描结果
//}
//
//@end
//
//@implementation HWQRViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    _resultArr = [[NSMutableArray alloc] init];
//    _selArr = [[NSMutableArray alloc] init];
//    _isSingleQR = true;
//    [self initView];
//}
////
////- (void)initView{
////
//////    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAc)];
//////    [self.view addGestureRecognizer:tapGes];
////
////    hmsCustomScanViewController = [[HmsCustomScanViewController alloc] init];
////    hmsCustomScanViewController.customizedScanDelegate = self;
////    hmsCustomScanViewController.backButtonHidden = true;
////    hmsCustomScanViewController.continuouslyScan = true;
////
////    CGFloat width = ScreenWidth;
////    if(ScreenWidth > ScreenHeight){
////
////        width = ScreenHeight;
////    }
////    hmsCustomScanViewController.view.frame = CGRectMake(0, 0, width, width);
////    hmsCustomScanViewController.cutArea = CGRectMake(0, 0, width, width);
////    _bgView.frame = CGRectMake(0, 0, width, width);
////    [_bgView addSubview:hmsCustomScanViewController.view];
////
////    _bgView.transform = CGAffineTransformMakeRotation(-M_PI_2);
////
////    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pichClick)];
////
////    [hmsCustomScanViewController.view addGestureRecognizer:pinchGesture];
////
////
////    //连续扫描
////    _changeButt = [UIButton buttonWithType:UIButtonTypeCustom];
////    [_changeButt setTitle:@"单个扫描" forState:UIControlStateNormal];
////    _changeButt.frame = CGRectMake(width-120, 20, 100, 40);
////    _changeButt.backgroundColor = [UIColor grayColor];
////    [self.view addSubview:_changeButt];
////    _changeButt.layer.cornerRadius = 20;
////    _changeButt.layer.masksToBounds = true;
////    [_changeButt addTarget:self action:@selector(changeButtAc) forControlEvents:UIControlEventTouchUpInside];
////    _changeButt.backgroundColor = [UIColor grayColor];
////
////    _rightView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, ScreenWidth-width, width)];
////
////    _rightView.backgroundColor = [UIColor whiteColor];
////    [self.view addSubview:_rightView];
////    _rightView.hidden = YES;
////
////    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 40)];
////    titleLab.text = @"扫描结果：";
////    titleLab.textColor = [UIColor blackColor];
////    titleLab.font = [UIFont systemFontOfSize:30];
////    [_rightView addSubview:titleLab];
////
////    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth-width, width-130) style:UITableViewStyleGrouped];
////    _tableView.dataSource = self;
////    _tableView.delegate = self;
////    [_rightView addSubview:_tableView];
////
////    UIButton *butt = [UIButton buttonWithType:UIButtonTypeCustom];
////    [butt setTitle:@"确定" forState:UIControlStateNormal];
////    butt.frame = CGRectMake(40, width-60, (ScreenWidth-width)-80, 40);
////    butt.layer.cornerRadius = 20;
////    [butt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////    butt.layer.masksToBounds = true;
////    [_rightView addSubview:butt];
////    butt.backgroundColor = [UIColor colorWithRed:123/255.0 green:48/255.0 blue:53/255.0 alpha:1];
////    [butt addTarget:self action:@selector(doneButtAc) forControlEvents:UIControlEventTouchUpInside];
////
////    //取消
////    UIButton *cancelButt = [UIButton buttonWithType:UIButtonTypeCustom];
////    [cancelButt setTitle:@"取消" forState:UIControlStateNormal];
////    [self.view addSubview:cancelButt];
////    cancelButt.frame = CGRectMake(20, 20, 80, 40);
////    cancelButt.layer.cornerRadius = 20;
////    cancelButt.layer.masksToBounds = YES;
////    cancelButt.backgroundColor = [UIColor grayColor];
////    [cancelButt addTarget:self action:@selector(cancelButtAc) forControlEvents:UIControlEventTouchUpInside];
////
////}
//
//
//- (void)initView{
//    
//    hmsCustomScanViewController = [[HmsCustomScanViewController alloc] init];
//    hmsCustomScanViewController.customizedScanDelegate = self;
//    hmsCustomScanViewController.backButtonHidden = true;
//    hmsCustomScanViewController.continuouslyScan = true;
//    
//    CGFloat width = ScreenWidth;
//    if(ScreenWidth > ScreenHeight){
//        
//        width = ScreenHeight;
//    }
//    hmsCustomScanViewController.view.frame = CGRectMake(0, 0, width, width);
//    hmsCustomScanViewController.cutArea = CGRectMake(0, 0, width, width);
//    _bgView.frame = CGRectMake(0, 0, width, width);
//    [_bgView addSubview:hmsCustomScanViewController.view];
//
//    _bgView.transform = CGAffineTransformMakeRotation(-M_PI_2);
//
//    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pichClick)];
//
//    [hmsCustomScanViewController.view addGestureRecognizer:pinchGesture];
//    
//    
//    //连续扫描
//    _changeButt = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_changeButt setTitle:@"单个扫描" forState:UIControlStateNormal];
//    _changeButt.frame = CGRectMake(width-120, 20, 100, 40);
//    _changeButt.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:_changeButt];
//    _changeButt.layer.cornerRadius = 20;
//    _changeButt.layer.masksToBounds = true;
//    [_changeButt addTarget:self action:@selector(changeButtAc) forControlEvents:UIControlEventTouchUpInside];
//    _changeButt.backgroundColor = [UIColor grayColor];
//    
//    _rightView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, ScreenWidth-width, width)];
//
//    _rightView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_rightView];
//    _rightView.hidden = YES;
//    
//    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 40)];
//    titleLab.text = @"扫描结果：";
//    titleLab.textColor = [UIColor blackColor];
//    titleLab.font = [UIFont systemFontOfSize:30];
//    [_rightView addSubview:titleLab];
//    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth-width, width-130) style:UITableViewStyleGrouped];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//    [_rightView addSubview:_tableView];
//    
//    UIButton *butt = [UIButton buttonWithType:UIButtonTypeCustom];
//    [butt setTitle:@"确定" forState:UIControlStateNormal];
//    butt.frame = CGRectMake(40, width-60, (ScreenWidth-width)-80, 40);
//    butt.layer.cornerRadius = 20;
//    [butt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    butt.layer.masksToBounds = true;
//    [_rightView addSubview:butt];
//    butt.backgroundColor = [UIColor colorWithRed:123/255.0 green:48/255.0 blue:53/255.0 alpha:1];
//    [butt addTarget:self action:@selector(doneButtAc) forControlEvents:UIControlEventTouchUpInside];
//    
//    //取消
//    UIButton *cancelButt = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelButt setTitle:@"取消" forState:UIControlStateNormal];
//    [self.view addSubview:cancelButt];
//    cancelButt.frame = CGRectMake(20, 20, 80, 40);
//    cancelButt.layer.cornerRadius = 20;
//    cancelButt.layer.masksToBounds = YES;
//    cancelButt.backgroundColor = [UIColor grayColor];
//    [cancelButt addTarget:self action:@selector(cancelButtAc) forControlEvents:UIControlEventTouchUpInside];
//    
//}
//
////取消
//- (void)cancelButtAc{
//    
//    [self dismissViewControllerAnimated:NO completion:nil];
//}
//
////确定
//- (void)doneButtAc{
//    
//    [self dismissViewControllerAnimated:NO completion:nil];
//    if([_delegate respondsToSelector:@selector(mutableQrResult:)]){
//        
//        [_delegate mutableQrResult:_selArr];
//    }
//}
//
//- (void)changeButtAc{
//    
//    _isSingleQR = !_isSingleQR;
//    
//    if(_isSingleQR){
//        
//        [_changeButt setTitle:@"单个扫描" forState:UIControlStateNormal];
//    }else{
//       
//        [_changeButt setTitle:@"连续扫描" forState:UIControlStateNormal];
//    }
//    
//    _rightView.hidden = _isSingleQR;
//}
//
//- (void)pichClick{
//    
//    
//}
//
////- (void)tapAc{
////
//////    [self dismissViewControllerAnimated:NO completion:nil];
////}
////扫码结果
//- (void)customizedScanDelegateForResult:(NSDictionary *)resultDic{
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if([resultDic isKindOfClass:[NSDictionary class]]){
//            
//            NSString *text = [Utils getTextWithModelStr:[resultDic objectForKey:@"text"]];
//            
//            if ([Utils isCheckBarCodeStr:text]) {//对条形码进行验证
//                
//                [self qrResult:text];
//                
//            }
////            [self showQRView:resultDic];
//        }
//    });
//}
//
//- (void)showQRView:(NSDictionary *)dic{
//    
//    if(dic){
//        
//        NSArray *arr = [dic objectForKey:@"ResultPoint"];
//        CGPoint point = [self getScanCenter:arr];
//        CGFloat width = _bgView.frame.size.width;
//        GreenView *centerView = [[GreenView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
//        centerView.backgroundColor = [UIColor clearColor];
//        centerView.center = point;
//        GreenView *view = [[GreenView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//        view.backgroundColor = [UIColor clearColor];
//        view.arr = arr;
//        centerView.backgroundColor = [UIColor greenColor];
//        [view addSubview:centerView];
//        [self.view addSubview:view];
//        view.transform = CGAffineTransformMakeRotation(-M_PI_2);
//        [view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
//    }
//}
//
////
////- (void)showQRView:(NSDictionary *)dic{
////
////    if(dic){
////
////        NSArray *arr = [dic objectForKey:@"ResultPoint"];
////        CGPoint point = [self getScanCenter:arr];
////        CGFloat width = _bgView.frame.size.width;
//////        CGFloat X = point.x-90;
//////        CGFloat Y = point.y-60;
//////        if(X > width || Y > width || X < 0 || Y < 0){
//////
//////            return;
//////        }
////        GreenView *centerView = [[GreenView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
////        centerView.backgroundColor = [UIColor clearColor];
////        point.x = point.x-60;
////        centerView.center = point;
////        GreenView *view = [[GreenView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
////        view.backgroundColor = [UIColor clearColor];
////        view.arr = arr;
////        centerView.backgroundColor = [UIColor greenColor];
////        [view addSubview:centerView];
////        [self.view addSubview:view];
////        view.transform = CGAffineTransformMakeRotation(-M_PI_2);
////        [view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
////    }
////}
//
//-(CGPoint)getScanCenter:(NSArray *)list{
//    float posXEnd = 0;
//    float posYEnd = 0;
//    for (int i=0; i<list.count; i++) {
//        float pos_X = [[[list objectAtIndex:i] objectForKey:@"posX"] floatValue];
//        posXEnd = posXEnd + pos_X;
//        float pos_Y = [[[list objectAtIndex:i] objectForKey:@"posY"] floatValue];
//        posYEnd = posYEnd + pos_Y;
//    }
//    float scan_x = posXEnd/4;
//    float scan_y = posYEnd/4;
//    CGPoint point = CGPointMake(scan_x, scan_y);
//    return point;
//}
//
////处理扫描结果
//- (void)qrResult:(NSString *)text{
//    
//    if(_isSingleQR){//单个扫描
//        
//        [self dismissViewControllerAnimated:NO completion:nil];
//        if([self->_delegate respondsToSelector:@selector(hwqrResult:)]){
//            
//            [self->_delegate hwqrResult:text];
//        }
//        
//    }else{//连续扫描
//        
//        if(![_resultArr containsObject:text]){
//            
//            [Utils showMessage:@"扫描成功"];
//            [_resultArr addObject:text];
//            [_selArr addObject:text];
//            [_tableView reloadData];
//        }
//    }
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return _resultArr.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    
//    if(cell == nil){
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
//    NSString *text = _resultArr[indexPath.row];
//    cell.textLabel.text = text;
//    
//    if([_selArr containsObject:text]){
//        
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }else{
//        
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSString *text = _resultArr[indexPath.row];
//    if([_selArr containsObject:text]){
//        
//        [_selArr removeObject:text];
//        
//    }else{
//        
//        [_selArr addObject:text];
//    }
//    
//    [_tableView reloadData];
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 0;
//}
//
//@end
