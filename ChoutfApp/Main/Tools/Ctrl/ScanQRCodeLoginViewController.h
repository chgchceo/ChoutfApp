//
//  ScanQRCodeLoginViewController.h
//  LocalSpecialty
//
//  Created by YD on 2022/7/27.
//

#import "BaseViewController.h"
#import "ScanORResultViewController.h"

typedef void(^ResultBlock)(NSString * _Nullable result);

NS_ASSUME_NONNULL_BEGIN

@interface ScanQRCodeLoginViewController : BaseViewController



@property(nonatomic,copy)ResultBlock block;




@end

NS_ASSUME_NONNULL_END
