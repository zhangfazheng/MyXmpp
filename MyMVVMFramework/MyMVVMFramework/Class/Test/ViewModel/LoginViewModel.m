//
//  LoginViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/2.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (void)initialize{
    [super initialize];
    
}

- (void)setNameSignal:(RACSignal *)nameSignal{
    _nameSignal = nameSignal;
    [_nameSignal subscribeNext:^(NSString * x) {
        NSLog(@"%@",x);
    }];
}

- (void)setPassWordSignal:(RACSignal *)passWordSignal{
    _passWordSignal = passWordSignal;
    [_passWordSignal subscribeNext:^(NSString * x) {
        NSLog(@"%@",x);
    }];
}

@end
