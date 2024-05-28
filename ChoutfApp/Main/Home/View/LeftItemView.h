//
//  LeftItemView.h
//  ChoutfApp
//
//  Created by cheng on 2024/4/22.
//

#import <UIKit/UIKit.h>
#import "header.h"

@protocol LeftItemViewDelegate <NSObject>

//左侧界面点击事件
- (void)clickLeftItemViewWithTitle:(NSString *_Nullable)title;

@end


NS_ASSUME_NONNULL_BEGIN

@interface LeftItemView : UIView



@property(nonatomic,weak)id<LeftItemViewDelegate>delegate;


@property (weak, nonatomic)IBOutlet UITableView *tableView;

@property (weak, nonatomic)IBOutlet UILabel *megLab;

@property (weak, nonatomic) IBOutlet UIButton *butt;

@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (weak, nonatomic) IBOutlet UIView *midView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *bgArr;



@end

NS_ASSUME_NONNULL_END
