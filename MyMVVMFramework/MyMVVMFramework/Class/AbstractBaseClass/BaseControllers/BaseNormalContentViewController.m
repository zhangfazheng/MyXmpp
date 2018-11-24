//
//  BaseNormalContentViewController.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseNormalContentViewController.h"

@interface BaseNormalContentViewController ()

@end

@implementation BaseNormalContentViewController

- (void)setup {
    
    [super setup];
    
    [self buildBackgroundView];
    [self buildContentView];
    [self buildTitleView];
    [self buildLoadingView];
    [self buildWindowView];
    
    self.loadingView.userInteractionEnabled = NO;
    self.windowView.userInteractionEnabled  = NO;
}

- (void)buildBackgroundView {
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.view addSubview:self.backgroundView];
}

- (void)buildTitleView {
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 64)];
    [self.view addSubview:self.titleView];
}

- (void)buildContentView {
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.width, self.height - 64)];
    [self.view addSubview:self.contentView];
}

- (void)buildLoadingView {
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.width, self.height - 64)];
    [self.view addSubview:self.loadingView];
}

- (void)buildWindowView {
    
    self.windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.view addSubview:self.windowView];
}
@end
