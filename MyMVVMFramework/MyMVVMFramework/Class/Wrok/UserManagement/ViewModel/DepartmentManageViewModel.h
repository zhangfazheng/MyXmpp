//
//  DepartmentManageViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/12/18.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"

@class DepartmentModel;
@class CellDataAdapter;
@interface DepartmentManageViewModel : BaseViewModel

@property (strong, nonatomic) RACCommand *queryDataCommand;
@property (strong, nonatomic) RACCommand *getUserInfoDataCommand;
/**
 *  查询数据请求
 */
+ (NSArray<NSArray<CellDataAdapter *> *>*)configAdapter:(DepartmentModel *)department;
@end
