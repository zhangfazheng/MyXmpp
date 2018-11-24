//
//  LoginViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/2.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"

@interface LoginViewModel : BaseViewModel
@property (strong,nonatomic) RACSignal *nameSignal;
@property (strong,nonatomic) RACSignal *passWordSignal;
@end
