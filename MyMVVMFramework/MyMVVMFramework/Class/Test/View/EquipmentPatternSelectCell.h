//
//  EquipmentPatternSelectCell.h
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/14.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "BaseCell.h"

@interface EquipmentPatternSelectCell : BaseCell

@end


@interface EquipmentPatternSelectCellModel : NSObject
@property (nonatomic,copy) NSString *tilleString;
@property (nonatomic,copy) NSString *valueString;
@property (nonatomic,copy) NSString * units;

@end
