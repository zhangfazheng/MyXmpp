//
//  ViewModelServicesImpl.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/5/27.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ViewModelServicesImpl.h"

@implementation ViewModelServicesImpl
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)pushViewModel:(BaseViewModel *)viewModel animated:(BOOL)animated {}

- (void)popViewModelAnimated:(BOOL)animated {}

- (void)popToRootViewModelAnimated:(BOOL)animated {}

- (void)presentViewModel:(BaseViewModel *)viewModel animated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)resetRootViewModel:(BaseViewModel *)viewModel {}
@end
