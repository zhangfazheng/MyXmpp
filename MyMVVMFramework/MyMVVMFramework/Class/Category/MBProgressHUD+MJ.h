//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MJ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
//无图提示框
+(void)showNoImageMessage:(NSString *)message;
//显示多行
+(void)showNoImageMoreRowMessage:(NSString *)message;
//显示底部的提示框
+ (void)showBottomMessage:(NSString *)message;
//显示进度条的提示框
+ (void)showbarDeterminateMessage: (NSString *)message;
//显示进度条的提示框
+ (void)updatebarDeterminateProgress: (float)progress;

@end
