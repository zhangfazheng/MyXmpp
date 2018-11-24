//
//  LockLabel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/7/5.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "LockLabel.h"

@implementation LockLabel

- (instancetype)initWithOptions:(LockOptions *) options frame :(CGRect) frame{
    if (self = [super initWithFrame:frame]) {
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setBackgroundColor:options.backgroundColor];
        self.options = options;
    }
    return self;
}


- (void)showNormal:(NSString *)message{
    self.text = message;
    [self setTextColor:self.options.normalTitleColor];
}

- (void)showWarn:(NSString *)message{
    self.text = message;
    [self setTextColor:self.options.warningTitleColor];
}

@end
