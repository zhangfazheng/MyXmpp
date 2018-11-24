//
//  LockOptions.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/30.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LockOptions : NSObject
/// 选中圆大小比例
@property (nonatomic,assign) CGFloat scale;


/// 选中圆大小的线宽
@property (nonatomic,assign) CGFloat arcLineWidth;


/// 密码后缀
@property (nonatomic,copy) NSString* passwordKeySuffix;



// MARK: - 设置密码

/// 最低设置密码数目
@property (nonatomic,copy) NSString* settingTittle;


@property (nonatomic,assign) int passwordMinCount;

/// 密码错误次数
@property (nonatomic,assign) int errorTimes;


/// 设置密码提示文字
@property (nonatomic,copy) NSString* setPassword;


/// 重绘密码提示文字
@property (nonatomic,copy) NSString* secondPassword;


/// 设置密码提示文字：确认
@property (nonatomic,copy) NSString* confirmPassword;


/// 设置密码提示文字：再次密码不一致
@property (nonatomic,copy) NSString* differentPassword;


/// 设置密码提示文字：设置成功
@property (nonatomic,copy) NSString* setSuccess;


// MARK: - 验证密码
@property (nonatomic,copy) NSString* verifyPassword;


/// 验证密码：普通提示文字
@property (nonatomic,copy) NSString* enterPassword;


/// 验证密码：密码错误
@property (nonatomic,copy) NSString* passwordWrong;



/// 验证密码：验证成功
@property (nonatomic,copy) NSString* passwordCorrect;


//MARK: - 修改密码
@property (nonatomic,copy) NSString* modifyPassword;


/// 修改密码：普通提示文字
@property (nonatomic,copy) NSString* enterOldPassword;


//MARK: - 颜色

/// 背景色
@property (nonatomic,strong) UIColor* backgroundColor;


/// 外环线条颜色：默认
@property (nonatomic,strong) UIColor* circleLineNormalColor;


/// 外环线条颜色：选中
@property (nonatomic,strong) UIColor* circleLineSelectedColor;


/// 实心圆
@property (nonatomic,strong) UIColor* circleLineSelectedCircleColor;


/// 连线颜色
@property (nonatomic,strong) UIColor* lockLineColor;


/// 警示文字颜色
@property (nonatomic,strong) UIColor* warningTitleColor;


/// 普通文字颜色
@property (nonatomic,strong) UIColor* normalTitleColor;


// MARK: - LockDelegate

/// 导航栏titleColor Default black
@property (nonatomic,strong) UIColor* barTittleColor;


/// 导航栏底部黑线是否隐藏 Default false
@property (nonatomic,assign) BOOL hideBarBottomLine;

/// barButton文字颜色 Default red
@property (nonatomic,strong) UIColor* barTintColor;


/// barButton文字大小 Default 18
@property (nonatomic,strong) UIFont* barTittleFont;


/// 导航栏背景颜色 Default nil
@property (nonatomic,strong) UIColor* barBackgroundColor;


/// 状态栏字体颜色 Default black
@property (nonatomic,assign) UIStatusBarStyle* statusBarStyle;


@end
