//
//  QRGreenView.h
//  ZDFProduct
//
//  Created by chgch on 2024/2/20.
//

#import <UIKit/UIKit.h>
#import "header.h"

NS_ASSUME_NONNULL_BEGIN

@interface QRGreenView : UIView



@property(nonatomic,strong)NSArray *arr;

//需要特殊处理
@property(nonatomic,assign)BOOL isSignle;

@end

NS_ASSUME_NONNULL_END
