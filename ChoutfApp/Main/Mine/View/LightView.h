//
//  LightView.h
//  ZDFProduct
//
//  Created by chgch on 2024/2/19.
//

#import <UIKit/UIKit.h>


@protocol LightViewDelegate <NSObject>

- (void)sliderValueChange:(CGFloat)value;

@end



NS_ASSUME_NONNULL_BEGIN

@interface LightView : UIView


@property(nonatomic,weak)id<LightViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UISlider *slider;


@end

NS_ASSUME_NONNULL_END
