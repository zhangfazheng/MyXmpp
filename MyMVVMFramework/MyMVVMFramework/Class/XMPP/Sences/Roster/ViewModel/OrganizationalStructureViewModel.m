//
//  OrganizationalStructureViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/24.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "OrganizationalStructureViewModel.h"
#import "Interface.h"
#import "NetWorkManager.h"
#import "UITableView+CellClass.h"
#import "DepartmentModel.h"
#import "ZFZFriendModel.h"
#import "XMPPConfig.h"
#import "DepartmentTableViewCell.h"
#import "ZFZFriendCell.h"
#import "LoginUserModel.h"
#import "MBProgressHUD+MJ.h"
#import "UserVCardModel.h"
#import "UIImage+RoundImage.h"
#import <ChameleonFramework/Chameleon.h>

@implementation OrganizationalStructureViewModel
- (void)initialize{
    [super initialize];
}

- (instancetype)initWithServices:(id<ViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        WeakSelf
        weakSelf.queryDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            //如果页面消灭网络请求的信号将不会再返回值
            return [[weakSelf executeQueryDataSignal:input] takeUntil:weakSelf.rac_willDeallocSignal];
        }];
        
        weakSelf.getUserInfoDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            //如果页面消灭网络请求的信号将不会再返回值
            return [[weakSelf executeGetUserInfoSignal:input] takeUntil:weakSelf.rac_willDeallocSignal];
        }];
    }
    return self;
}

//网络数据请求方法
- (RACSignal *)executeQueryDataSignal:(id)input{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [MBProgressHUD showMessage:@"查询中"];
        [[NetWorkManager shareManager]requestWithType:HttpRequestTypePost withUrlString:QueryUserByFullName withParaments:@{@"realName":input} withSuccessBlock:^(NSDictionary *object) {
            //对请数据进行格式化
            if ([object[@"success"] boolValue]) {
                ZFZFriendModel *user = [self configUserData: object[@"data"]];
                
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            }else{
                
                //提示错误信息
                if (!isEmptyString(object[@"stateCode"][@"msg"])) {
                    [MBProgressHUD showNoImageMessage:object[@"stateCode"][@"msg"]];
                }
                [subscriber sendCompleted];
                [MBProgressHUD hideHUD];
            }
            
        } withFailureBlock:^(NSError *error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
            [MBProgressHUD hideHUD];
            [MBProgressHUD showMessage:@"数据加载失败"];
        } progress:nil];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"查询用户信息的请求信号已经被销毁");
        }];
    }];
    return signal;
}

//网络查询用户信息数据请求方法
- (RACSignal *)executeGetUserInfoSignal:(id)input{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [MBProgressHUD showMessage:@"查询中"];
        [[NetWorkManager shareManager]requestWithType:HttpRequestTypePost withUrlString:QueryUserByFullName withParaments:@{@"realName":input} withSuccessBlock:^(NSDictionary *object) {
            //对请数据进行格式化
            if ([object[@"success"] boolValue]) {
                
                UserVCardModel *user = [UserVCardModel modelWithDictionary:object[@"data"]];
                if (!isEmptyString(object[@"data"][@"pinName"])) {
                    user.jid = [XMPPJID jidWithUser:object[@"data"][@"pinName"] domain:kDomin resource:nil];
                }
                
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            }else{
                
                //提示错误信息
                if (!isEmptyString(object[@"stateCode"][@"msg"])) {
                    [MBProgressHUD showNoImageMessage:object[@"stateCode"][@"msg"]];
                }
                [subscriber sendCompleted];
                [MBProgressHUD hideHUD];
            }
            
        } withFailureBlock:^(NSError *error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
            [MBProgressHUD hideHUD];
            [MBProgressHUD showMessage:@"数据加载失败"];
        } progress:nil];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"查询用户信息的请求信号已经被销毁");
        }];
    }];
    return signal;
}

//网络数据请求方法
- (RACSignal *)executeRequestDataSignal:(id)input{
    WeakSelf
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [MBProgressHUD showMessage:@"查询中"];
        [[NetWorkManager shareManager]requestWithType:HttpRequestTypePost withUrlString:GetMyDepartments withParaments:input withSuccessBlock:^(NSDictionary *object) {
            //对请数据进行格式化
            NSArray<DepartmentModel *>* departmentArray = [weakSelf configData:object[@"data"]];
            DepartmentModel *company = [[DepartmentModel alloc]init];
            company.deptName = @"北京新脉远望";
            company.childDeptListArray = departmentArray;
            
            NSArray<NSArray<CellDataAdapter *> *>*department = [OrganizationalStructureViewModel configAdapter:company];
            
            [subscriber sendNext:department];
            [subscriber sendCompleted];
            [MBProgressHUD hideHUD];
        } withFailureBlock:^(NSError *error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
             [MBProgressHUD hideHUD];
             [MBProgressHUD showMessage:@"数据加载失败"];
        } progress:nil];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    return signal;
}

//用户信息处理
- (ZFZFriendModel *)configUserData:(NSDictionary *)dict{
    if (dict) {
        ZFZFriendModel *user = [ZFZFriendModel new];
        UserVCardModel *card = [UserVCardModel new];
        user.name = dict[@"realName"];
        user.jid =[NSString stringWithFormat:@"%@@%@",dict[@"pinName"],kDomin];
        user.phton = [UIImage imageNamed:@"army6"];
        card.sex = [dict[@"sex"] integerValue];
        card.age = [dict[@"age"] integerValue];
        card.mobile = dict[@"mobile"];
        card.postName = dict[@"postName"];
        card.mail = dict[@"mail"];
        user.userVcard = card;
        
        return user;
    }else{
        return nil;
    }
}


- (NSArray<DepartmentModel *>*)configData:(NSArray *)departmentArray{
    NSMutableArray<DepartmentModel *>*departmentModelArray = [NSMutableArray arrayWithCapacity:departmentArray.count];
    for (NSDictionary *dict in departmentArray) {
        DepartmentModel *department = [[DepartmentModel alloc]init];
        department.deptName = dict[@"deptNameCn"];
        department.deptId = [dict[@"deptId"] integerValue];
        department.parentDeptId = [dict[@"parentDeptId"] integerValue];
        
        //如果部门人员不为空
        NSArray *userList = dict[@"listUser"];
        if (userList && userList.count > 0) {
            NSMutableArray *temUserArray = [NSMutableArray arrayWithCapacity:userList.count];
            department.childCount += userList.count;
            for (NSDictionary *user in userList) {
                ZFZFriendModel *userModel = [[ZFZFriendModel alloc]init];
                userModel.name = user[@"realName"];
                userModel.jid = [NSString stringWithFormat:@"%@@%@",user[@"pinName"],kDomin];
                NSString *iconText = [userModel.name substringWithRange:NSMakeRange((userModel.name.length-2), 2)];
                userModel.phton = [UIImage drawImageRadius:RadiusMake(25, 25, 25, 25) size:CGSizeMake(50, 50) backgroundColor:RandomFlatColor text:iconText];
                [temUserArray addObject:userModel];
            }
            department.userListArray = [temUserArray copy];
        }
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
            CellDataAdapter *deptAdapter = [DepartmentTableViewCell dataAdapterWithCellReuseIdentifier:@"DepartmentTableViewCell" data:dept cellHeight:100 type:0];
            [childDeptArry addObject:deptAdapter];
        }
        [organizationalStructureArry addObject:childDeptArry];
    }
    //如果同部门同事不为空
    if (department.userListArray && department.userListArray.count>0) {
        NSMutableArray *userArry =[NSMutableArray arrayWithCapacity:department.userListArray.count];
        for (ZFZFriendModel *user in department.userListArray) {
            CellDataAdapter *userAdapter = [ZFZFriendCell dataAdapterWithCellReuseIdentifier:@"ZFZFriendCell" data:user cellHeight:100 type:0];
            [userArry addObject:userAdapter];
        }
        [organizationalStructureArry addObject:userArry];
    }
    
    return [organizationalStructureArry copy];
}


@end
