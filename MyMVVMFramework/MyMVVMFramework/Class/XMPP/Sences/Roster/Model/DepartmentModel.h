//
//  DepartmentModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/24.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"

@class DepartmentModel;
@class ZFZFriendModel;
@interface DepartmentModel : BaseModel
@property (nonatomic,copy) NSString *deptName;
@property (nonatomic,assign) NSInteger deptId;
@property (nonatomic,assign) NSInteger parentDeptId;
@property (nonatomic,strong) NSArray<DepartmentModel *> *childDeptListArray;
@property (nonatomic,strong) NSArray<ZFZFriendModel *> *userListArray;
@property (nonatomic,assign) NSInteger childCount;
@end
