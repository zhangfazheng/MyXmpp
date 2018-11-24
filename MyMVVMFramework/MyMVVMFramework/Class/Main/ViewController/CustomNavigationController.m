///
//  CustomNavigationController.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/6.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "CustomNavigationController.h"
#import "UIBarButtonItem+Item.h"
#import "UIImage+SolidColor.h"

@interface CustomNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation CustomNavigationController

/**
 只加载一次
 */
+(void)load
{
//    //设置bar字体
//    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
//    [bar setTitleTextAttributes:dict];
//    
//    //设置bar背景图片
//    //[bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
//    
//    //设置item的字体和颜色
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//    NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
//    itemDict[NSForegroundColorAttributeName] = [UIColor blackColor];
//    itemDict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
//    [item setTitleTextAttributes:itemDict forState:UIControlStateNormal];
//    
//    NSMutableDictionary *itemDisableDict = [NSMutableDictionary dictionary];
//    itemDisableDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [item setTitleTextAttributes:itemDisableDict  forState:UIControlStateDisabled];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:21], NSFontAttributeName, nil]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //全屏滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    pan.delegate = self;
    //禁止之前的手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
    [self.view addGestureRecognizer:pan];
    
}

//消除方法警告
-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan
{
    
}


#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //是否出发手势
    return self.childViewControllers.count > 1;
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {//非根控制器
        //影藏BottomBar
        viewController.hidesBottomBarWhenPushed = YES;
        
        //返回按钮自定义
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[[UIImage imageNamed:@"navigationButtonReturn"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] WithHighlightedImage:[[UIImage imageNamed:@"navigationButtonReturnClick"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] Target:self action:@selector(backViewController) title:@"返回"];
        
    }
    //跳转(自定义以后在这里真正跳转)
    [super pushViewController:viewController animated:animated];
}


-(void)backViewController
{
    [self popViewControllerAnimated:YES];
}
@end
