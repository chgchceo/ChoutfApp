//
//  HostNameSelectViewController.h
//  ZDFProduct
//
//  Created by cheng on 2024/3/14.
//

#import "BaseViewController.h"

typedef void(^HostNameBlock)(NSString * _Nullable hostName);

NS_ASSUME_NONNULL_BEGIN

@interface HostNameSelectViewController : BaseViewController



//展示的数据
@property(nonatomic,strong)NSArray *data;

//返回的选择的内容
@property(nonatomic,copy)HostNameBlock block;



@end

NS_ASSUME_NONNULL_END
