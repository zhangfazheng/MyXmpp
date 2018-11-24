//
//  OrganizationalStructureViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/24.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"
#import "Interface.h"
#import "NetWorkManager.h"
#import "UITableView+CellClass.h"
#import "DepartmentModel.h"
#import "DepartmentTableViewCell.h"
#import "LoginUserModel.h"
#import "MBProgressHUD+MJ.h"
#import <ChameleonFramework/Chameleon.h>

@class DepartmentModel;
@class CellDataAdapter;
@interface OrganizationalStructureViewModel : BaseViewModel
+ (NSArray<NSArray<CellDataAdapter *> *>*)configAdapter:(DepartmentModel *)department;
/**
 *  查询数据请求
 */
@property (strong, nonatomic) RACCommand *queryDataCommand;
@property (strong, nonatomic) RACCommand *getUserInfoDataCommand;
@end
