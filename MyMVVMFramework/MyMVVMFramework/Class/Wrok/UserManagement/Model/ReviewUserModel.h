//
//  ReviewUserModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/27.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"

@interface ReviewUserModel : BaseModel
@property (nonatomic,copy) NSString *pinName;
@property (nonatomic,copy) NSString *realName;
/**
 *邮箱
 **/
@property (nonatomic,copy) NSString *mail;
/**
 *头像地址
 **/
@property (nonatomic,copy) NSString *faceImg;
/**
 *所属部门名称中文
 **/
@property (nonatomic,copy) NSString *deptNameCn;
/**
 *审批状态:0:待审批,1:通过,2:不通过
 **/
@property (nonatomic,assign) NSInteger dealState;
/**
 *用户状态:0:无效,1:有效
 **/
@property (nonatomic,assign) NSInteger userState;
/**
 *岗位职称
 **/
@property (nonatomic,copy) NSString *postName;
/**
 *所属部门
 **/
@property (nonatomic,copy) NSString *deptId;
/**
 *年龄
 **/
@property (nonatomic,assign) NSInteger age;
/**
 *性别:0男,1女
 **/
@property (nonatomic,assign) NSInteger sex;
/**
 *手机号
 **/
@property (nonatomic,copy) NSString *mobile;
/**
 *身份证号
 **/
@property (nonatomic,copy) NSString *idCard;

@end
