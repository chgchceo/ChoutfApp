//
//  QBarResult.h
//  QBarCode
//
//  Copyright © 2021 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QBarResult : NSObject

@property (strong, nonatomic) NSString *charset;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *typeName;


@property (nonatomic, assign) float rst_x;
@property (nonatomic, assign) float rst_y;
@property (nonatomic, assign) float rst_width;
@property (nonatomic, assign) float rst_height;

@end

NS_ASSUME_NONNULL_END
