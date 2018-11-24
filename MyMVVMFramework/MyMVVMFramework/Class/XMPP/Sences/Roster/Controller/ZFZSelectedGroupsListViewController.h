//
//  ZFZSelectedGroupsListViewController.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/28.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ZFZSelectedGroupsListViewController : BaseTableViewController
@property (strong,nonatomic) NSMutableArray *groupsListArry;
@property (strong,nonatomic) RACSubject *groupNameSubject;
@end
