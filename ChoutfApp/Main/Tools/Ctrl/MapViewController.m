//
//  MapViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/8/30.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "header.h"
@interface MapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>{
    
    CLGeocoder *_geoCoder;
    UILabel *_megLab;
    
}

@property(nonatomic,strong)CLLocation *userLocation;
@property(nonatomic,strong)MKMapView *mapView;
@property(nonatomic,strong)CLLocationManager *locationManager;



@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地图";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    [self initView];
    UILongPressGestureRecognizer *mTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [self.mapView addGestureRecognizer:mTap];
}
- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    
    if(gestureRecognizer.state != UIGestureRecognizerStateBegan){
        
        return;
    }
    //这里touchPoint是点击的某点在地图控件中的位置
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    //这里touchMapCoordinate就是该点的经纬度了
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    //添加大头针
    CLLocation *location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [_geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *mark = [placemarks lastObject];
        CNPostalAddress *address = (CNPostalAddress *)mark.postalAddress;
        NSString *cityName = mark.locality;
        
        NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@",address.state,address.city,address.subLocality,address.street];
        NSLog(@"城市 - %@", addressStr);
//        [Utils showMessage:addressStr];
        
        MKAnnotation *anno = [[MKAnnotation alloc] init];

        anno.title = cityName;

        anno.subtitle = addressStr;

        //经度和纬度

        anno.coordinate = touchMapCoordinate;
        [self.mapView addAnnotation:anno];
    }];
}

- (void)initView{
    
    _megLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 100)];
    _megLab.numberOfLines = 0;
    double size = 15;
    if(ISIpad){
        size = 25;
    }
    [self.view addSubview:_megLab];
    _megLab.textColor = [UIColor blackColor];
    _megLab.font = [UIFont systemFontOfSize:size];
    self.locationManager = [[CLLocationManager alloc] init];
    // 设置定位精度，十米，百米，最好
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //每隔多少米定位一次（这里的设置为任何的移动）
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self; //代理设置
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        // 开始时时定位
        if ([CLLocationManager locationServicesEnabled]){
            // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
            [self.locationManager startUpdatingLocation];
        }else{
            NSLog(@"请开启定位功能");
        }
        

       });
    
}
//开启定位后会先调用此方法，判断有没有权限
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
    {
        //判断ios8 权限
        
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            
        {
            
            [self.locationManager requestAlwaysAuthorization]; // 永久授权
            
            [self.locationManager requestWhenInUseAuthorization]; //使用中授权
            
        }
        
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    //地址
    self.userLocation = [locations lastObject];
    
        [manager stopUpdatingLocation];
    
        // 初始化编码器
        _geoCoder = [[CLGeocoder alloc] init];
        // 通过定位获取的经纬度坐标，反编码获取地理信息标记并打印改标记下得城市名
        [_geoCoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
            
            CLPlacemark *mark = [placemarks lastObject];
            CNPostalAddress *address = (CNPostalAddress *)mark.postalAddress;
            if (address) {
                
//                NSString *cityName = mark.locality;
                NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@\n经度：%f\n纬度：%f",address.state,address.city,address.subLocality,address.street,self.userLocation.coordinate.longitude,self.userLocation.coordinate.latitude];
                NSLog(@"城市 - %@", addressStr);
                [Utils showMessage:addressStr];
                self->_megLab.text = addressStr;
            }else{
                
                NSString *addressStr = [NSString stringWithFormat:@"经度：%f\n纬度：%f",self.userLocation.coordinate.longitude,self.userLocation.coordinate.latitude];
                NSLog(@"城市 - %@", addressStr);
                [Utils showMessage:addressStr];
                self->_megLab.text = addressStr;
            }
        }];
    
    [self.locationManager stopUpdatingHeading];
    //地址
    self.userLocation = [locations lastObject];
    
    //将地图视图移到当前位置
    [self.mapView setCenterCoordinate:self.userLocation.coordinate animated:YES];
    
    //设置地图显示范围
    MKCoordinateSpan span = MKCoordinateSpanMake(0.021321, 0.019366);
    MKCoordinateRegion regoin = MKCoordinateRegionMake(self.userLocation.coordinate, span);
    [self.mapView setRegion:regoin animated:YES];
}

// 定位失败错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"error");
}

- (MKMapView *)mapView{
    
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,100, ScreenWidth, ScreenHeight-100)];
        //设置用户的跟踪模式
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
        //设置标准地图
        _mapView.mapType = MKMapTypeStandard;
        // 不显示罗盘和比例尺
        if (@available(iOS 9.0, *)) {
            _mapView.showsCompass = NO;
            _mapView.showsScale = NO;
        }
        // 开启定位
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
        //初始位置及显示范围
        MKCoordinateSpan span=MKCoordinateSpanMake(0.021251, 0.016093);
        [_mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.coordinate, span) animated:YES];
    }
    return _mapView;
}

- (MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        
        return nil;
    }
    
    static NSString * ID =@"anno";
    
    MKPinAnnotationView * annoView= (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    
    if(annoView == nil) {
        
        annoView= [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
        
        //显示气泡
        annoView.canShowCallout = YES;
        //设置绿色
        
        annoView.pinTintColor = [UIColor greenColor];
    }
    
    return annoView;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if(!ISIpad){
        
        return;
    }
    
    self.mapView.frame = CGRectMake(0,100, ScreenWidth, ScreenHeight-100);
}



@end
