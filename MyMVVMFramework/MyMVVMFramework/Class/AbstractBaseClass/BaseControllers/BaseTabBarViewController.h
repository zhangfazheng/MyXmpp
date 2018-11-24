//
//  BaseTabBarViewController.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewController.h"
@class BaseTabBarViewController;

@protocol BaseTabBarViewControllerDelegate <NSObject>

@optional

- (BOOL)baseTabBarController:(BaseTabBarViewController *)tabBarController
    shouldSelectViewController:(UIViewController *)viewController
                 selectedIndex:(NSInteger)index;

- (void)baseTabBarController:(BaseTabBarViewController *)tabBarController
       didSelectViewController:(UIViewController *)viewController
                 selectedIndex:(NSInteger)index;

@end

@interface BaseTabBarViewController : BaseViewController
/**
 *  BaseTabBarViewController's delegate.
 */
@property (nonatomic, weak) id <BaseTabBarViewControllerDelegate> delegate;

/**
 *  TabBar's height, default is 49.f.
 */
@property (nonatomic) CGFloat tabBarHeight;

/**
 *  The controller's index that loaded and show by BaseTabBarViewController at the first time.
 */
@property (nonatomic) NSInteger  firstLoadIndex;

/**
 *  ViewControllers.
 */
@property(nonatomic, strong) NSArray <__kindof BaseViewController *> *viewControllers;

/**
 *  Hide TabBarView or not.
 *
 *  @param hide     Hide or not.
 *  @param animated Animated or not.
 */
- (void)hideTabBarView:(BOOL)hide animated:(BOOL)animated;

#pragma mark - Used by subClass.

/**
 *  TabBarView, you should add view on it.
 */
@property (nonatomic, strong, readonly) UIView  *tabBarView;

/**
 *  Will select index, used by subClass.
 *
 *  @param index Index.
 *
 *  @return Will selected or not.
 */
- (BOOL)willSelectIndex:(NSInteger)index;

/**
 *  Did selected index, used by subClass.
 *
 *  @param index Index.
 */
- (void)didSelectedIndex:(NSInteger)index;

/**
 *  Build items in the tabBarView.
 */
- (void)buildItems;

@end
