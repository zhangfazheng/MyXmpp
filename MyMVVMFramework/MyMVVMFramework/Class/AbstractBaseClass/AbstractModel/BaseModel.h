//
//  BaseModel.h
//  OperationEquipment
//
//  Created by 张发政 on 2017/2/27.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
////如果模型的属性名与字典数据中的key无法对应，但又需要对应到指定的属性上时需设置该数组
////数组结构：@[@[@"属性名字符"，@"key字符"]]
//@property (nonatomic,strong) NSArray *mappingArry;

- (instancetype)initBaseModelDic:(NSDictionary *)dic;
+ (NSMutableArray *)baseModelObject:(id)object;
//根据数据模型中的一个key  返回一个跟value对应的一个数据模型（例：key = (userId) 字典样式 = 11:Model）
+ (NSMutableDictionary *)baseModelObject:(id)object andKey:(NSString *)key;
+ (instancetype)initWithInfoDic:(NSDictionary*)infoDic;

@end
