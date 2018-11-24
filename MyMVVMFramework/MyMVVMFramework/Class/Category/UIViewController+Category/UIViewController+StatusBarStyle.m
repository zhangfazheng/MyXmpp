//
//  UIViewController+StatusBarStyle.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/7.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "UIViewController+StatusBarStyle.h"
#import <objc/runtime.h>

@implementation UIViewController (StatusBarStyle)
static const char * ZFZ_STATUS_BAR_LIGHT_KEY = "ZFZ_STATUS_LIGHT";

- (void)setZfz_lightStatusBar:(BOOL)zfz_lightStatusBar {
    objc_setAssociatedObject(self, ZFZ_STATUS_BAR_LIGHT_KEY, [NSNumber numberWithInt:zfz_lightStatusBar], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self preferredStatusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)zfz_lightStatusBar {
    return objc_getAssociatedObject(self, ZFZ_STATUS_BAR_LIGHT_KEY) ? [objc_getAssociatedObject(self, ZFZ_STATUS_BAR_LIGHT_KEY) boolValue] : NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.zfz_lightStatusBar ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

@end
