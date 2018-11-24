//
//  BaseNormalContentViewController.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseNormalContentViewController : BaseViewController
//  level            view            frame
//  ---------------------------------------------------------------
//
//  highest          windowView      0 x  0 x width x height
//
//  higher           loadingView     0 x 64 x width x (height - 64)
//
//  high             titleView       0 x  0 x width x 64
//
//  high             contentView     0 x 64 x width x (height - 64)
//
//  normal           backgroundView  0 x  0 x width x height
//
//  low              view            0 x  0 x width x height

@property (nonatomic, strong) UIView   *windowView;
@property (nonatomic, strong) UIView   *loadingView;
@property (nonatomic, strong) UIView   *titleView;
@property (nonatomic, strong) UIView   *contentView;
@property (nonatomic, strong) UIView   *backgroundView;

/**
 *  Build titleView, please overwrite by subclass.
 */
- (void)buildTitleView;

/**
 *  Build contentView, please overwrite by subclass.
 */
- (void)buildContentView;

/**
 *  Build loadingView, please overwrite by subclass.
 */
- (void)buildLoadingView;

/**
 *  Build windowView, please overwrite by subclass.
 */
- (void)buildWindowView;

/**
 *  Build backgroundView, please overwrite by subclass.
 */
- (void)buildBackgroundView;

@end
