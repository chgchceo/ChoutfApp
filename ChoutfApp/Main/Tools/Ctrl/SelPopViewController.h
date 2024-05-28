//
//  SelPopViewController.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/9/13.
//

#import "BaseViewController.h"

typedef void(^SelPopBlock)(NSString *title);

NS_ASSUME_NONNULL_BEGIN

@interface SelPopViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UIButton *topBtn;


@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property(nonatomic,copy)SelPopBlock block;


@end

NS_ASSUME_NONNULL_END
