//
//  RHTableViewCell.h
//  RHToolkit
//
//  Created by zhuruhong on 15/6/27.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RHTableViewCell <NSObject>

@required

/**
 *  针对数据源刷新RHTableViewCell，在cellForRowAtIndexPath的方法中被触发调用
 *
 *  @param cellData cell的数据源
 */
- (void)updateViewWithData:(id)cellData;

@end

@interface RHTableViewCell : UITableViewCell <RHTableViewCell>

/**
 *  用于记录cell class
 *
 *  @return 返回所有已经注册cell class的集合
 */
+ (NSMutableDictionary *)cellMapOfRegistered;

/**
 *  注册cell class到map
 *
 *  @param cellClass 待注册class
 *  @param type      待注册class对应的唯一类型
 */
+ (void)registerRenderCell:(Class)cellClass type:(NSInteger)type;

/**
 *  通过类型从map中获取cell class
 *
 *  @param type cell对应的唯一类型
 *
 *  @return 返回cell class
 */
+ (Class)cellClassWithType:(NSInteger)type;

/**
 *  构造RHTableViewCell
 *
 *  @param tableView tableView
 *  @param cellClass 需要构造的RHTableViewCell对应的class
 *
 *  @return 返回cellClass对应的TableViewCell类
 */
+ (instancetype)tableView:(UITableView *)tableView reusedCellOfClass:(Class)cellClass;

/**
 *  构造RHTableViewCell
 *
 *  @param tableView tableView
 *  @param type      需要构造的RHTableViewCell对应的type
 *
 *  @return 返回type对应的TableViewCell类
 */
+ (instancetype)tableView:(UITableView *)tableView reusedCellOfType:(NSInteger)type;


@end
