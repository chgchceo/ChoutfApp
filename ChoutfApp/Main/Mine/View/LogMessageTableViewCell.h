//
//  LogMessageTableViewCell.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/12/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogMessageTableViewCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@property (weak, nonatomic) IBOutlet UILabel *contentLab;


@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@end

NS_ASSUME_NONNULL_END
