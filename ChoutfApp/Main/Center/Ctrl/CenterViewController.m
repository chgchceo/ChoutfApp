//
//  CenterViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/8/29.
//

#import "CenterViewController.h"
//#import "MineCollectionViewCell.h"
#import "Header.h"


@interface CenterViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>{
    
    UICollectionView *_collectionView;
    CGFloat _gap;
    
}

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _gap = 12;
    if(ISIpad){
        _gap = 58;
    }
    self.navigationItem.title = @"消息";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
//    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    _collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}


- (void)initView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (ScreenWidth-64)/4.0;
    if(ISIpad){
        
        width = (ScreenWidth-304)/4.0;
    }
    layout.minimumLineSpacing = _gap;
    layout.minimumInteritemSpacing = _gap;
    layout.itemSize = CGSizeMake(width, width);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabbarHeight-NaviBarHeight) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
//    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"MineCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MineCollectionViewCell"];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCollectionViewCell" forIndexPath:indexPath];
//    
//    cell.layer.cornerRadius = 20;
//    cell.layer.masksToBounds = YES;
//    return cell;
    
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, _gap, _gap, _gap);
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

    _collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    NSLog(@"----------width:%f,height:%f",ScreenWidth,ScreenHeight);
//    BOOL landscape = UIInterfaceOrientationIsLandscape(toInterfaceOrientation); //判断是不是横屏
//      if (landscape) {// 横屏情况下,frame是怎样的
//
//          _collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//      }else{// 竖屏情况下,frame是怎样的
//
//          _collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    }
}



@end
