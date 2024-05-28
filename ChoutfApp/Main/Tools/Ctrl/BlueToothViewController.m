//
//  BlueToothViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/8/25.
//

#import "BlueToothViewController.h"
#import "CoreBluetooth/CoreBluetooth.h"
#import "header.h"
@interface BlueToothViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
}

@property(nonatomic,strong)CBCentralManager *manager;

@property(nonatomic,strong)  NSMutableArray *peripherals;

@property(nonatomic,strong)  CBPeripheral    *peripheral;

@property(nonatomic,strong)  CBCharacteristic *characteristic;

@property(nonatomic,strong)  NSString        *data;

@end

@implementation BlueToothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蓝牙设备";
    [self initView];
    self.view.backgroundColor = [UIColor whiteColor];
    _manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    self.manager.delegate = self;
//    self.manager.CBCentralManagerScanOptionAllowDuplicatesKey = YES;
    //创建数组来管理外设
    self.peripherals = [NSMutableArray array];
}

- (void)initView{
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    CBPeripheral *per = self.peripherals[indexPath.row];
    cell.textLabel.text = per.name;
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
-(void) centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBManagerStateUnknown:
        {
            NSLog(@"无法获取设备的蓝牙状态");
        }
            [Utils showMessage:@"无法获取设备的蓝牙状态"];
            break;
        case CBManagerStateResetting:
        {
            NSLog(@"蓝牙重置");
        }
            break;
        case CBManagerStateUnsupported:
        {
            NSLog(@"该设备不支持蓝牙");
            [Utils showMessage:@"该设备不支持蓝牙"];
        }
            break;
        case CBManagerStateUnauthorized:
        {
            NSLog(@"未授权蓝牙权限");
            [Utils showMessage:@"未授权蓝牙权限"];
        }
            break;
        case CBManagerStatePoweredOff:
        {
            NSLog(@"蓝牙已关闭");
            [Utils showMessage:@"蓝牙已关闭"];
        }
            break;
        case CBManagerStatePoweredOn:
        {
            NSLog(@"蓝牙已打开");
            [Utils showMessage:@"蓝牙已打开"];
            //扫描周边蓝牙外设.
            //CBCentralManagerScanOptionAllowDuplicatesKey为true表示允许扫到重名，false表示不扫描重名的。

            NSDictionary *dic = @{CBCentralManagerScanOptionAllowDuplicatesKey:@false};
               [_manager scanForPeripheralsWithServices:nil options:dic]; //扫描语句：写nil表示扫描所有蓝牙外设，如果传上面的kServiceUUID,那么只能扫描出FFEO这个服务的外设
            
        }
            break;
            
        default:
        {
            NSLog(@"未知的蓝牙错误");
            [Utils showMessage:@"未知的蓝牙错误"];
        }
            break;
    }
}


-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"%@--%@--%@",peripheral.identifier,peripheral.name,RSSI);
    
    if(peripheral.name){
        
        if(![self.peripherals containsObject:peripheral]){
            
            [self.peripherals addObject:peripheral];
        }
    }
    if ([peripheral.name isEqualToString:@"HC-08"]) {//只连接HC-08的蓝牙
        //尝试着连接蓝牙
        self.manager.delegate = self;//?委托？
        NSLog(@"尝试连接蓝牙:%@", peripheral.name);
        self.peripheral=peripheral;//useful
        [self.manager connectPeripheral:peripheral options:nil];
        
    }
    
    [_tableView reloadData];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{

    //检测是否连接到设备
    NSLog(@"did connect to peripheral:%@", peripheral);
    //停止扫描
    [_manager stopScan ];
    //发现服务
    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    [self.peripheral discoverServices:nil];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{

    NSLog(@"did not  connect to peripheral:%@", error);

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
@end
