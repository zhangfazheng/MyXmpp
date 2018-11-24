//
//  LockOptions.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/30.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "LockOptions.h"

@implementation LockOptions

- (instancetype)init{
    if (self=[super init]) {
        self->_scale=0.3;
        self->_arcLineWidth=1;
        self->_passwordKeySuffix=@"passwordKeySuffix";
        self->_settingTittle=@"设置密码";
        self->_passwordMinCount=4;
        self->_errorTimes=5;
        self->_setPassword=@"请滑动设置新密码";
        self->_secondPassword=@"请重新绘制新密码";
        self->_confirmPassword= @"请再次输入确认密码";
        self->_differentPassword=@"再次密码输入不一致";
        self->_setSuccess=@"密码设置成功!";
        self->_verifyPassword=@"验证密码";
        self->_enterPassword=@"请滑动输入密码";
        self->_passwordWrong=@"输入密码错误";
        self->_passwordCorrect=@"密码正确";
        self->_modifyPassword=@"修改密码";
        self->_enterOldPassword=@"请输入旧密码";
        self->_backgroundColor=[UIColor whiteColor];
        self->_circleLineNormalColor=RGB(173, 216, 230);
        self.circleLineSelectedColor=RGB(0, 191, 255);
        self.circleLineSelectedCircleColor=RGB(0, 191, 255);
        self.lockLineColor=RGB(0, 191, 255);
        self.warningTitleColor=RGB(254, 82, 92);
        self.normalTitleColor=RGB(192, 192, 192);
        self.barTittleColor=[UIColor blackColor];
        self->_hideBarBottomLine=NO;
        self->_barTintColor=[UIColor redColor];
        self->_barTittleFont= [UIFont systemFontOfSize:18];
        self->_statusBarStyle=UIStatusBarStyleDefault;
    }
    
    return self;
}

@end
