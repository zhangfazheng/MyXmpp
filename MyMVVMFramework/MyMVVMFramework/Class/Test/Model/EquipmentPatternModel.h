//
//  EquipmentPatternModel.h
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/30.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "DBModel.h"

@interface EquipmentPatternModel : DBModel
@property (nonatomic,copy) NSString *equipmentPatternId;
@property (nonatomic,copy) NSString *instName;
@property (nonatomic,assign) int instWeight;
@property (nonatomic,copy) NSString *instPicture;
@property (nonatomic,assign) int instCount;
@end
