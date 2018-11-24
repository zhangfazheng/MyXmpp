//
//  ZFZSearchTextField.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/7.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZSearchTextField.h"

@implementation ZFZSearchTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.canTouch = YES;
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL result = [super pointInside:point withEvent:event];
    if (_canTouch) {
        return result;
    } else {
        return NO;
    }
}

- (void)dealloc {
    NSLog(@"SearchTextField dealloc");
}

@end
