//
//  InputUrlViewController.h
//  ZDFProduct
//
//  Created by cheng on 2024/3/11.
//

#import "BaseViewController.h"

//选中的手动输入的url链接
typedef void(^SelInputUrlBlock)(NSString * _Nullable url);

NS_ASSUME_NONNULL_BEGIN

@interface InputUrlViewController : BaseViewController


@property(nonatomic,copy)SelInputUrlBlock block;

@end

NS_ASSUME_NONNULL_END
