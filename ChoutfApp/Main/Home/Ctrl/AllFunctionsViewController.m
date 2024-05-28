//
//  AllFunctionsViewController.m
//  ChoutfApp
//
//  Created by cheng on 2024/4/28.
//

#import "AllFunctionsViewController.h"
#import "FuctionCollectionViewCell.h"
#import "header.h"

@interface AllFunctionsViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
    UICollectionView *_collectionView;
    NSArray *_titleArr;
    NSArray *_imgArr;
    
}

@end

@implementation AllFunctionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"常用功能";
    self.view.backgroundColor = [UIColor whiteColor];
    _titleArr = @[@"日志信息",@"清理缓存",@"ping域名",@"检测更新",@"历史版本",@"扫一扫",@"意见反馈",@"url地址",@"打印机",@"地图位置",@""];
    _imgArr = @[@"rizhixinxi",@"qinglihuancun",@"IPdizhi",@"jiancegengxin",@"lishibanben",@"saoyisao",@"yijianfankui",@"URLdizhi",@"dayinji",@"ditu_dingwei_o",@""];
    [self initView];
}

- (void)initView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(100, 80);
//    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 20;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, ScreenHeight-NaviBarHeight) collectionViewLayout: layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"FuctionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FuctionCollectionViewCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _titleArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FuctionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FuctionCollectionViewCell" forIndexPath:indexPath];
    
    cell.titleLab.text = _titleArr[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:_imgArr[indexPath.row]];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(20, 20, 0, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = _titleArr[indexPath.row];
    if ([title isEqualToString:@"日志信息"]) {
        
        LogMessageViewController *vc = [[LogMessageViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"清理缓存"]) {
        
        [self showLoadingView:@""];
        [self clearWeblocalStorage];
        [self performSelector:@selector(clearFinish) withObject:nil afterDelay:2];
    }else if ([title isEqualToString:@"ping域名"]) {
        
        PingHostViewController *hostCtrl = [[PingHostViewController alloc] init];
        hostCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hostCtrl animated:YES];
    }else if ([title isEqualToString:@"检测更新"]) {
        
        [Utils showMessage:@"当前已是最新版本!"];
    }else if ([title isEqualToString:@"历史版本"]) {
        
        HistoryVersionViewController *hisCtrl = [[HistoryVersionViewController alloc] init];
        hisCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hisCtrl animated:YES];
    }else if ([title isEqualToString:@"扫一扫"]) {
        
        QRScanViewController *qrCtrl = [[QRScanViewController alloc] init];
        [self.navigationController pushViewController:qrCtrl animated:YES];
    }else if ([title isEqualToString:@"意见反馈"]) {
        
        FeedBackViewController *feedCtrl = [[FeedBackViewController alloc] init];
        [self.navigationController pushViewController:feedCtrl animated:YES];
    }else if ([title isEqualToString:@"url地址"]) {
        
        MineViewController *mineCtrl = [[MineViewController alloc] init];
        mineCtrl.isFromURL = YES;
        [self.navigationController pushViewController:mineCtrl animated:YES];
    }else if ([title isEqualToString:@"打印机"]) {
        
        PrinterViewController *mineCtrl = [[PrinterViewController alloc] init];
        [self.navigationController pushViewController:mineCtrl animated:YES];
    }else if ([title isEqualToString:@"地图位置"]) {
        
        MapViewController *mineCtrl = [[MapViewController alloc] init];
        [self.navigationController pushViewController:mineCtrl animated:YES];
    }
}

- (void)clearFinish{
    
    [self hiddenView];
    [Utils showMessage:@"清理完成"];
}

#pragma mark - 清除web缓存
- (void)clearWeblocalStorage{
    
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
}


@end
