//
//  BaseHeaderFooterView.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseHeaderFooterView;



@interface BaseHeaderFooterView : UITableViewHeaderFooterView
#pragma mark - Propeties.


/**
 *  BaseHeaderFooterView's data.
 */
@property (nonatomic, weak) id data;

/**
 *  UITableView's section.
 */
@property (nonatomic,assign) NSInteger section;

/**
 *  TableView.
 */
@property (nonatomic, weak) UITableView *tableView;

/**
 *  Controller.
 */
@property (nonatomic, weak) UIViewController *controller;

#pragma mark - Some useful method.

- (void)initialize;
/**
 *  Set HeaderFooterView backgroundColor.
 *
 *  @param color Color.
 */
- (void)setHeaderFooterViewBackgroundColor:(UIColor *)color;

#pragma mark - Method override by subclass.

/**
 *  Setup HeaderFooterView, override by subclass.
 */
- (void)setupHeaderFooterView;

/**
 *  Build subview, override by subclass.
 */
- (void)buildSubview;

/**
 *  Load content, override by subclass.
 */
- (void)loadContent;
@end
