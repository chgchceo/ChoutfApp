//
//  TimeHandle.m
//  QBarSDKDemo
//
//

#import "TimeHandle.h"

/**
 TODO: Demo 代码仅展示接入集成示例，在正式接入需客户侧完善优化
 */

@interface  TimeHandle(){
    dispatch_source_t timer;
}
@end

@implementation TimeHandle

- (void)initGCDWith:(float)targetValue withValue:(float)begin endCallback:(void (^)(void))end eachCallback:(void (^)(float seconds))each {
    __block float time = begin;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_MSEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        time += 0.01;
        if (time > targetValue) {
            dispatch_source_cancel(self->timer);
            end();
        } else {
            each(time);
        }
    });
    dispatch_resume(timer);
    
}
- (void)cancelTimer{
    if(timer!=nil){
        dispatch_source_cancel(timer);
    }
}

@end
