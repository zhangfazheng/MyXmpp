//
//  ReviewUserModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/27.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ReviewUserModel.h"

@implementation ReviewUserModel
+ (instancetype)initWithInfoDic:(NSDictionary *)infoDic{
    return [[ReviewUserModel alloc]initBaseModelDic:infoDic];
}
@end
