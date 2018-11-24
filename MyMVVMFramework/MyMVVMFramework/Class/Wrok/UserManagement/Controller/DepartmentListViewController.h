//
//  DepartmentListViewController.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/12/18.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseTableViewController.h"

@interface DepartmentListViewController : BaseTableViewController
/** 所以标题数组 */
@property (nonatomic, strong) NSMutableArray *titles;
/**
 根据角标，选中对应的控制器
 */
@property (nonatomic, assign) NSInteger selectIndex;

/** 当前部门名称 */
@property (nonatomic, strong) NSString *dataAdapterName;

- (instancetype)initWithdataAdapterName:(NSArray *) dataAdapterNameArray data:(NSArray *)data;

@end
