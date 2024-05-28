//
//  QRCodeViewController.h
//  ChoutfApp
//
//  Created by cheng on 2024/4/1.
//

#import "BaseViewController.h"
#import "ScanORResultViewController.h"
#import "BrightnessViewController.h"

typedef void(^ResultBlock)(NSString * _Nullable result);

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeViewController : BaseViewController




@property(nonatomic,copy)ResultBlock block;



@end

NS_ASSUME_NONNULL_END

