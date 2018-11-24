//
//  DepartmentManageViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/12/18.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "DepartmentManageViewModel.h"
#import "Interface.h"
#import "NetWorkManager.h"
#import "UITableView+CellClass.h"
#import "DepartmentModel.h"
#import "DepartmentSelectTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import <ChameleonFramework/Chameleon.h>

@implementation DepartmentManageViewModel


//网络数据请求方法,获取所有部门信息
- (RACSignal *)executeRequestDataSignal:(id)input{
    WeakSelf
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //[MBProgressHUD showMessage:@"查询中"];
        [[NetWorkManager shareManager]requestWithType:HttpRequestTypePost withUrlString:GetMyDepartments withParaments:input withSuccessBlock:^(NSDictionary *object) {
            //对请数据进行格式化
            //[MBProgressHUD hideHUD];
            NSArray<DepartmentModel *>* departmentArray = [weakSelf configData:object[@"data"]];
            DepartmentModel *company = [[DepartmentModel alloc]init];
            company.deptName = @"北京新脉远望";
            company.childDeptListArray = departmentArray;
            
            NSArray<NSArray<CellDataAdapter *> *>*department = [DepartmentManageViewModel configAdapter:company];
            
            [subscriber sendNext:department];
            [subscriber sendCompleted];
            [MBProgressHUD hideHUD];
        } withFailureBlock:^(NSError *error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
            [MBProgressHUD hideHUD];
            [MBProgressHUD showNoImageMessage:@"数据加载失败"];
        } progress:nil];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    return signal;
}


- (NSArray<DepartmentModel *>*)configData:(NSArray *)departmentArray{
    NSMutableArray<DepartmentModel *>*departmentModelArray = [NSMutableArray arrayWithCapacity:departmentArray.count];
    for (NSDictionary *dict in departmentArray) {
        DepartmentModel *department = [[DepartmentModel alloc]init];
        department.deptName = dict[@"deptNameCn"];
        department.deptId = [dict[@"deptId"] integerValue];
        department.parentDeptId = [dict[@"parentDeptId"] integerValue];
        
//        //如果部门人员不为空
//        NSArray *userList = dict[@"listUser"];
//        if (userList && userList.count > 0) {
//            NSMutableArray *temUserArray = [NSMutableArray arrayWithCapacity:userList.count];
//            department.childCount += userList.count;
//            for (NSDictionary *user in userList) {
//                ZFZFriendModel *userModel = [[ZFZFriendModel alloc]init];
//                userModel.name = user[@"realName"];
//                userModel.jid = [NSString stringWithFormat:@"%@@%@",user[@"pinName"],kDomin];
//                NSString *iconText = [userModel.name substringWithRange:NSMakeRange((userModel.name.length-2), 2)];
//                userModel.phton = [UIImage drawImageRadius:RadiusMake(25, 25, 25, 25) size:CGSizeMake(50, 50) backgroundColor:RandomFlatColor text:iconText];
//                [temUserArray addObject:userModel];
//            }
//            department.userListArray = [temUserArray copy];
//        }
        //如果子部门不为空
        NSArray *childDeptList = dict[@"childDept"];
        if (childDeptList && childDeptList.count > 0) {
            department.childCount += childDeptList.count;
            NSArray<DepartmentModel *>*temCholdArray = [self configData:childDeptList];
            department.childDeptListArray = temCholdArray;
        }
        [departmentModelArray addObject:department];
        
    }
    
    return [departmentModelArray copy];
}

+ (NSArray<NSArray<CellDataAdapter *> *>*)configAdapter:(DepartmentModel *)department{
    NSMutableArray *organizationalStructureArry =[NSMutableArray arrayWithCapacity:department.childDeptListArray.count];
    
    
    //如果子部门不为空
    if (department.childDeptListArray && department.childDeptListArray.count>0) {
        NSMutableArray *childDeptArry =[NSMutableArray arrayWithCapacity:department.childDeptListArray.count];
        for (DepartmentModel *dept in department.childDeptListArray) {
            CellDataAdapter *deptAdapter = [DepartmentSelectTableViewCell dataAdapterWithCellReuseIdentifier:@"DepartmentSelectTableViewCell" data:dept cellHeight:100 type:0];
            [childDeptArry addObject:deptAdapter];
        }
        [organizationalStructureArry addObject:childDeptArry];
    }
    
    return [organizationalStructureArry copy];
}
@end
