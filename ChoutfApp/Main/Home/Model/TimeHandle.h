//
//  TimeHandle.h
//  QBarSDKDemo
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeHandle : NSObject
- (void)initGCDWith:(float)targetValue withValue:(float)begin endCallback:(void (^)(void))end eachCallback:(void (^)(float seconds))each;
- (void)cancelTimer;
@end

NS_ASSUME_NONNULL_END
