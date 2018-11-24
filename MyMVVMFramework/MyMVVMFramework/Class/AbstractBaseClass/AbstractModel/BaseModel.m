//
//  BaseModel.m
//  OperationEquipment
//
//  Created by 张发政 on 2017/2/27.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "BaseModel.h"
#import "NSObject+YYModel.h"

@implementation BaseModel

//手动的映射key值不同的值
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


- (instancetype)initBaseModelDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
    
}

+ (instancetype)initWithInfoDic:(NSDictionary *)infoDic{
    return nil;
}

+ (NSMutableArray *)baseModelObject:(id)object
{
    NSMutableArray *arr = [NSMutableArray array];
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = object;
        BaseModel *base = [[self alloc] initBaseModelDic:dic];
        [arr addObject:base];
    } else if ([object isKindOfClass:[NSArray class]]) {
        NSArray *array = object;
        
        for (NSDictionary *dic in array) {
            if([dic isKindOfClass:[NSDictionary class]]){
                @autoreleasepool {
                    BaseModel *base = [[self alloc] initBaseModelDic:dic];
                    [arr addObject:base];
                }
            }
        }
    }
    return arr;
    
}
+ (NSMutableDictionary *)baseModelObject:(id)object andKey:(NSString *)key{
    NSMutableDictionary *returnDict = [NSMutableDictionary dictionary];
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = object;
        
        BaseModel *base = [[self alloc] initBaseModelDic:dic];
        [returnDict setObject:base forKey:[dic objectForKey:key]];
    } else if ([object isKindOfClass:[NSArray class]]) {
        NSArray *array = object;
        for (NSDictionary *dic in array) {
            @autoreleasepool {
                BaseModel *base = [[self alloc] initBaseModelDic:dic];
                [returnDict setObject:base forKey:[dic objectForKey:key]];
            }
        }
    }
    return returnDict;
}
@end
