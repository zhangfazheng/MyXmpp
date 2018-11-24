//
//  RHTableView.h
//  RHToolkit
//
//  Created by zhuruhong on 15/6/27.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//
/*
    tableView与父控制器的数据交互方便简洁，可直接在父控制器对tableView进行数据更新的操作
 */

#import <UIKit/UIKit.h>

@class RHTableViewAdapter;

@interface RHTableView : UITableView

- (void)setTableViewAdapter:(RHTableViewAdapter *)tableViewAdapter;

@end
