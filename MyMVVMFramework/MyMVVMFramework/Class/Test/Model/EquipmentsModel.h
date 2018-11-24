//
//  EquipmentsModel.h
//  OperationEquipment
//
//  Created by 张发政 on 2017/2/27.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "DBModel.h"

@interface EquipmentsModel : DBModel
@property (nonatomic,copy) NSString *equipmentId;
@property (nonatomic,copy) NSString *ptId;
@property (nonatomic,copy) NSString *equipmentTypeName;
@property (nonatomic,copy) NSString *epcId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int weight;
@property (nonatomic,assign) int useTimes;
@property (nonatomic,copy) NSString *picturePath;
@property (nonatomic,copy) NSString *insStatus;
@property (nonatomic,copy) NSString *modifyTime;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *vendorId;
@property (nonatomic,copy) NSString *vendorName;
@property (nonatomic,assign) BOOL isExist;
@property (nonatomic,assign) BOOL isEdit;

+ (NSArray *)findStart:(NSInteger)start andEnd:(NSInteger)end;
+ (NSString *)searchNewDate;
@end
