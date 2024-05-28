//
//  ImgViewController.h
//  ChoutfApp
//
//  Created by cheng on 2024/4/8.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImgViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property(nonatomic,strong)UIImage *img;


@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property(nonatomic,copy)NSString *text;

@end

NS_ASSUME_NONNULL_END
