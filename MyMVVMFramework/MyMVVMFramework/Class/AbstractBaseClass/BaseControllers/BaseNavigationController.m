//
//  BaseNavigationController.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (instancetype)initWithRootViewController:(BaseViewController *)rootViewController setNavigationBarHidden:(BOOL)hidden {
    
    BaseNavigationController *ncController = [[[self class] alloc] initWithRootViewController:rootViewController];
    [ncController setNavigationBarHidden:hidden animated:NO];
    [rootViewController useInteractivePopGestureRecognizer];
    
    return ncController;
}

@end
