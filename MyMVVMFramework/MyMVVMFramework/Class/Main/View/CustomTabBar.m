//
//  CustomTabBar.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/6.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "CustomTabBar.h"
#import "UIView+Frame.h"
#import "Const.h"
#import "CustomNavigationController.h"


@interface CustomTabBar ()
@property (nonatomic,weak)UIButton *publishBtn;
/** 上一次点击的按钮 */
@property (nonatomic, weak) UIControl *previousClickedTabBarButton;
@end

@implementation CustomTabBar

/**
 懒加载
 */
-(UIButton *)publishBtn
{
    if (!_publishBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"tab_center_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"tab_center_open"] forState:UIControlStateSelected];
        button.width=48;
        button.height=48;
        [self addSubview:button];
        [button addTarget:self action:@selector(publishButtonClick) forControlEvents:UIControlEventTouchUpInside];
        /*******自适应**********/
        //[button sizeToFit];
        _publishBtn = button;
    }
    return _publishBtn;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnH = self.height;
    CGFloat btnW = self.width / (self.items.count + 1);
    
    CGFloat X = 0;
    NSInteger i = 0;
    //遍历
    for (UIControl *tabBar in self.subviews) {
        if ([tabBar isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (i<self.items.count) {
                NSLog(@"%@,%zd",self.items[i].title,i);
            }
            
            if (i == 2) {
                i += 1;
            }
            
            X = i * btnW;
            tabBar.frame = CGRectMake(X, 0, btnW, btnH);
            
            i++;
            
            // 监听点击
            [tabBar addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    self.publishBtn.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}
/**
 *  tabBarButton的点击
 */
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    if (self.previousClickedTabBarButton == tabBarButton) {
        // 发出通知，告知外界tabBarButton被重复点击了
        [[NSNotificationCenter defaultCenter] postNotificationName:TabBarButtonDidRepeatShowClickNotificationCenter object:nil];
    }
    
    self.previousClickedTabBarButton = tabBarButton;
}
/**
 *  弹出发布控制器
 */
- (void)publishButtonClick
{
//    UIView *publishView = [UIView new];
//    [[UIApplication sharedApplication].keyWindow addSubview:publishView];
//    publishView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [self publishViewAction];
}

#pragma mark-当cookie失效时跳转到登录界面
- (void)publishViewAction{
//    ScanViewController *loginVc=[[ScanViewController alloc]init];
//    CustomNavigationController *nav=[[CustomNavigationController alloc]initWithRootViewController:loginVc];
//    
//    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}


@end
