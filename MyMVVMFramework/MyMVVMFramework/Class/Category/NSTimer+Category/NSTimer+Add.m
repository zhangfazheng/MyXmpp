//
//  NSTimer+Add.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/19.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "NSTimer+Add.h"

@implementation NSTimer (Add)
+ (void)_ExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(_ExecBlock:) userInfo:[block copy] repeats:repeats];
}
@end
