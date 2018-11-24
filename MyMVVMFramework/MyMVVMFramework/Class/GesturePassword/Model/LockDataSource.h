//
//  LockDataSource.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/30.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LockDataSource <NSObject>

/// 选中圆大小比例
- (CGFloat)scale;

/// 选中圆大小的线宽
- (CGFloat)arcLineWidth;

/// 密码后缀
- (NSString *)passwordKeySuffix;
// MARK: - 设置密码

/// 最低设置密码数目
- (NSString *)configTitle;

- (int)passwordMinCount;

/// 密码错误次数
- (int)errorTimes;

/// 设置密码提示文字
- (NSString *)setPassword;


/// 重绘密码提示文字
- (NSString *)secondPassword;


/// 设置密码提示文字：确认
- (NSString *)confirmPassword;


/// 设置密码提示文字：再次密码不一致
- (NSString *)differentPassword;

/// 设置密码提示文字：设置成功
- (NSString *)setSuccess;

// MARK: - 验证密码
- (NSString *)verifyPassword;

/// 验证密码：普通提示文字
- (NSString *)enterPassword;

/// 验证密码：密码错误
- (NSString *)passwordWrong;


/// 验证密码：验证成功
- (NSString *)passwordCorrect;


//MARK: - 修改密码
- (NSString *)modifyPassword;

/// 修改密码：普通提示文字
- (NSString *)enterOldPassword;


//MARK: - 颜色

/// 背景色
- (UIColor *)backgroundColor;

/// 外环线条颜色：默认
- (UIColor *)circleLineNormalColor;

/// 外环线条颜色：选中
- (UIColor *)circleLineSelectedColor;

/// 实心圆
- (UIColor *)circleLineSelectedCircleColor;


/// 连线颜色
- (UIColor *)lockLineColor;

/// 警示文字颜色
- (UIColor *)warningTitleColor;

/// 普通文字颜色
- (UIColor *)normalTitleColor;

@end
