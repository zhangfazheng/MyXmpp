//
//  PackagePatternModel.m
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/30.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "PackagePatternModel.h"

@implementation PackagePatternModel


+ (instancetype)initWithInfoDic:(NSDictionary *)infoDic{
    return [[PackagePatternModel alloc]initBaseModelDic:infoDic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.packagePatternId = value;
        return;
    }
    
}

@end
