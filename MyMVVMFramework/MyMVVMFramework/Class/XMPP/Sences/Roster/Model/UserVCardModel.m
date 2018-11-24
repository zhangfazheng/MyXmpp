//
//  UserVCardModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/27.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "UserVCardModel.h"
#import "XMPPConfig.h"

@implementation UserVCardModel

+ (instancetype)initWithInfoDic:(NSDictionary *)infoDic{
    return [[UserVCardModel alloc]initBaseModelDic:infoDic];
}



@end
