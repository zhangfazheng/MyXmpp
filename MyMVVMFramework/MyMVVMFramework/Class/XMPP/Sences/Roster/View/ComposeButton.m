//
//  ComposeButton.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/10.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ComposeButton.h"

@implementation ComposeButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
    
}

- (void)setUpUI{
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:Font_Small_Text];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, self.bounds.size.width, self.bounds.size.width, self.bounds.size.height - self.bounds.size.width);
}

@end
