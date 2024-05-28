//
//  BrightnessViewController.h
//  ChoutfApp
//
//  Created by cheng on 2024/4/18.
//

#import "BaseViewController.h"

@protocol BrightnessViewControllerDelegate <NSObject>

//更新手电筒的状态
- (void)upDateLightStatus;


@end


NS_ASSUME_NONNULL_BEGIN

@interface BrightnessViewController : BaseViewController


@property(nonatomic,weak)id<BrightnessViewControllerDelegate>delegate;


@end

NS_ASSUME_NONNULL_END
