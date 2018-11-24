//
//  VendorModel.m
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/24.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "VendorModel.h"

@implementation VendorModel
+ (instancetype)initWithInfoDic:(NSDictionary *)infoDic{
    return [[VendorModel alloc]initBaseModelDic:infoDic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.vendorId = value;
        return;
    }
}

@end
