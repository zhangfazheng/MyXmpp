//
//  EquipmentPatternModel.m
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/30.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "EquipmentPatternModel.h"

@implementation EquipmentPatternModel
+ (instancetype)initWithInfoDic:(NSDictionary *)infoDic{
    return [[EquipmentPatternModel alloc]initBaseModelDic:infoDic];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.equipmentPatternId = value;
        return;
    }
    
}
@end
