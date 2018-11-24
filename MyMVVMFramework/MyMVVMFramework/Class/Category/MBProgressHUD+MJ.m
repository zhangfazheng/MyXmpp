//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//CGFloat const MBProgressMaxOffset = 1000000.f;
@implementation MBProgressHUD (MJ)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"queren.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+(void)showNoImageMessage:(NSString *)message
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    HUD.mode = MBProgressHUDModeText;
    
    HUD.removeFromSuperViewOnHide = YES;
    // HUD.labelText = title; 把这一行 换成这一行就
    HUD.detailsLabel.text = message;
    HUD.label.font = [UIFont systemFontOfSize:15]; //Johnkui - added
    [HUD hideAnimated:YES afterDelay:2.0];
}
//显示底部的提示框
+ (void)showBottomMessage:(NSString *)message{
    
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.offset = CGPointMake(HUD.offset.x, SCREEN_HEIGHT / 2 - 50);
    // HUD.labelText = title; 把这一行 换成这一行就
    HUD.detailsLabel.text = message;
    HUD.label.font = [UIFont systemFontOfSize:15]; //Johnkui - added
    HUD.margin = 10;
    [HUD hideAnimated:YES afterDelay:1.5];
}

+(void)showNoImageMoreRowMessage:(NSString *)message
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    HUD.mode = MBProgressHUDModeText;

    HUD.removeFromSuperViewOnHide = YES;
    // HUD.labelText = title; 把这一行 换成这一行就
    HUD.detailsLabel.text = message;
    HUD.label.font = [UIFont systemFontOfSize:15]; //Johnkui - added
    [HUD hideAnimated:YES afterDelay:1.5];
}

+ (void)showbarDeterminateMessage: (NSString *)message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // Set the bar determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = NSLocalizedString(message, @"HUD loading title");
}

+ (void)updatebarDeterminateProgress: (float)progress{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
         MBProgressHUD *hud = [self HUDForView:[[UIApplication sharedApplication].windows lastObject]];

        while (progress < 1.0f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.progress = progress;
            });
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}


@end
