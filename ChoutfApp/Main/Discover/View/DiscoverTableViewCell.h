//
//  DiscoverTableViewCell.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/8/29.
//

#import <UIKit/UIKit.h>

@protocol DiscoverTableViewCellDelegate <NSObject>

//删除地址
- (void)delButtAc:(NSInteger)index;


@end

NS_ASSUME_NONNULL_BEGIN

@interface DiscoverTableViewCell : UITableViewCell


@property(nonatomic,weak)id<DiscoverTableViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *megLab;


@property(nonatomic,assign)NSInteger index;



@end

NS_ASSUME_NONNULL_END
