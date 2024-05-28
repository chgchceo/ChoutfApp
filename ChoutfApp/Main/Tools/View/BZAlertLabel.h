//
//  BZAlertLabel.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/9/15.
//

#import <UIKit/UIKit.h>


typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;


NS_ASSUME_NONNULL_BEGIN

@interface BZAlertLabel : UILabel



@property (nonatomic, assign) VerticalAlignment verticalAlignment;





@end

NS_ASSUME_NONNULL_END
