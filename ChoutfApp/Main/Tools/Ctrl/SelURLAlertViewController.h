//
//  SelURLAlertViewController.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/11/15.
//

#import "BaseViewController.h"

typedef void(^SelUrlBlock)(NSString * _Nullable title);

NS_ASSUME_NONNULL_BEGIN

@interface SelURLAlertViewController : BaseViewController


@property(nonatomic,copy)SelUrlBlock block;




@end

NS_ASSUME_NONNULL_END
