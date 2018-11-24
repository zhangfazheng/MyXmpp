//
//  BaseNavigationController.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BaseNavigationController : UINavigationController
/**
 *  Init with rootViewController.
 *
 *  @param rootViewController An UIViewController used as rootViewController.
 *  @param hidden             Navigation bar hide or not.
 *
 *  @return CustomNavigationController object.
 */
- (instancetype)initWithRootViewController:(BaseViewController *)rootViewController setNavigationBarHidden:(BOOL)hidden;
@end
