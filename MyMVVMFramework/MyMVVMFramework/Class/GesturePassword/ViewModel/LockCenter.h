//
//  LockCenter.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/7/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LockOptions.h"

@interface LockCenter : NSObject
@property (nonatomic,strong)LockOptions *options;

+ (instancetype)shareLockCenter;
-(void)showSettingLockControllerIn:(UIViewController *)controller;
-(void)showVerifyLockControllerIn:(UIViewController *)controller;
-(void)showModifyLockControllerIn:(UIViewController *)controller;
@end
