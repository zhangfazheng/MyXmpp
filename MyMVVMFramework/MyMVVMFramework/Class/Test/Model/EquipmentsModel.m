//
//  EquipmentsModel.m
//  OperationEquipment
//
//  Created by 张发政 on 2017/2/27.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "EquipmentsModel.h"
#import "VendorModel.h"
#import "EquipmentPatternModel.h"
#import "FMDBManager.h"

@implementation EquipmentsModel
+ (instancetype)initWithInfoDic:(NSDictionary *)infoDic{
    return [[EquipmentsModel alloc]initBaseModelDic:infoDic];
}

////手动的映射key值不同的值
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        self.equipmentId = value;
        return;
    }
    
    if ([key isEqualToString:@"insUsedCount"]) {
        self.useTimes = [value intValue];
        return;
    }
    
    if ([key isEqualToString:@"insName"]) {
        self.name = value;
        return;
    }
    
    if ([key isEqualToString:@"insPictures"]) {
        self.picturePath = value;
        return;
    }
    
    if ([key isEqualToString:@"insWeight"]) {
        self.weight = [value intValue];
        return;
    }
    if ([key isEqualToString:@"iTag"]) {
        self.epcId = value;
        return;
    }
    if ([key isEqualToString:@"itId"]) {
        self.ptId = value;
        NSArray * type = [EquipmentPatternModel findWithFormat:@"WHERE equipmentPatternId like '%@'",value];
        if (type && type.count>0) {
            EquipmentPatternModel *pat          =type[0];
            self.equipmentTypeName              = pat.instName;
        }
        
        return;
    }
    if ([key isEqualToString:@"vId"]) {
        self.vendorId = value;
        NSArray * vendorArry = [VendorModel findWithFormat:@"WHERE vendorId like '%@'",value];
        if (vendorArry && vendorArry.count>0) {
            VendorModel *vendor         = vendorArry[0];
            self.vendorName             = vendor.vendorName;

        }
        
        return;
    }

}


+ (NSString *)searchNewDate{
    FMDBManager *jkDB = [FMDBManager shareInstance];
    __block NSString *maxDate;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        //NSString *tableName = NSStringFromClass(self.class);
        
        NSString *sql = @"SELECT max(createTime) maxDate FROM EquipmentsModel";
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            maxDate = [resultSet stringForColumn:@"maxDate"];
            //FMDBRelease(model);
        }
    }];
    
    return maxDate;
    
}

//根据equipmentId更新保存
- (BOOL)saveOrUpdate
{
    FMDBManager *jkDB = [FMDBManager shareInstance];
    __block BOOL res =NO;
    WeakSelf
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        //NSString *tableName = NSStringFromClass(self.class);
        
        NSString *sql =[NSString stringWithFormat:@"SELECT pk FROM EquipmentsModel WHERE equipmentId LIKE '%@'",self.equipmentId];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            if (!isEmptyString([resultSet stringForColumn:@"pk"])) {
                res = YES;
                break;
            }
            
        }
    }];
    
    if (res) {
        [weakSelf update];
    }else{
        [weakSelf save];
    }
    
    return res;
}

/** 更新单个对象 */
- (BOOL)update
{
    FMDBManager *jkDB = [FMDBManager shareInstance];
    __block BOOL res = NO;
    NSString *primaryIdStr = @"equipmentId";
    
    //获取模型属性
    NSDictionary *dic                   = [self.class getAllProperties];
    NSMutableArray * columeNamesArry    = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"name"]];
    
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        id primaryValue = [self valueForKey:primaryIdStr];
        if (!primaryValue || primaryValue <= 0) {
            return ;
        }
        
        NSMutableString *keyString = [NSMutableString string];
        NSMutableArray *updateValues = [NSMutableArray  array];
        for (int i = 0; i < columeNamesArry.count; i++) {
            NSString *proname = [columeNamesArry objectAtIndex:i];
            if ([proname isEqualToString:primaryIdStr]) {
                continue;
            }
            [keyString appendFormat:@" %@=?,", proname];
            id value = [self valueForKey:proname];
            if (!value) {
                value = @"";
            }
            [updateValues addObject:value];
        }
        
        //删除最后那个逗号
        [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = ?;", tableName, keyString, primaryIdStr];
        [updateValues addObject:primaryValue];
        res = [db executeUpdate:sql withArgumentsInArray:updateValues];
    }];
    return res;
}

/** 通过条件查找数据 */
+ (NSArray *)findStart:(NSInteger)start andEnd:(NSInteger)end
{
    FMDBManager *jkDB = [FMDBManager shareInstance];
    NSMutableArray *users = [NSMutableArray array];
    
    //获取模型属性
    NSDictionary *dic                   = [self.class getAllProperties];
    NSMutableArray * columeNamesArry    = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"name"]];
    NSMutableArray * columeTypeArry    = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"type"]];
    
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY modifyTime desc limit %zd,%zd ",tableName,start ,end];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            DBModel *model = [[self.class alloc] init];
            for (int i=0; i< columeNamesArry.count; i++) {
                NSString *columeName = [columeNamesArry objectAtIndex:i];
                NSString *columeType = [columeTypeArry objectAtIndex:i];
                if ([columeType isEqualToString:SQLTEXT]) {
                    [model setValue:[resultSet stringForColumn:columeName] forKey:columeName];
                } else if ([columeType isEqualToString:SQLBLOB]) {
                    [model setValue:[resultSet dataForColumn:columeName] forKey:columeName];
                } else {
                    [model setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:columeName]] forKey:columeName];
                }
            }
            [users addObject:model];
            FMDBRelease(model);
        }
    }];
    
    return users;
}

/** 删除单个对象 */
- (BOOL)deleteObject
{
    NSString *epcId = @"epcId";
    FMDBManager *jkDB = [FMDBManager shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        id primaryValue = [self valueForKey:epcId];
        if (!primaryValue || primaryValue <= 0) {
            return ;
        }
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",tableName,epcId];
        res = [db executeUpdate:sql withArgumentsInArray:@[primaryValue]];
    }];
    return res;
}


+ (NSArray *)transients
{
    return @[@"isExist",@"isEdit"];
}

@end
