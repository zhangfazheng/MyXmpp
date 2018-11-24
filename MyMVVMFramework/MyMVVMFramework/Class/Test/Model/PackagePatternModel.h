//
//  PackagePatternModel.h
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/30.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "DBModel.h"

@interface PackagePatternModel : DBModel
@property (nonatomic,copy) NSString *packagePatternId;
@property (nonatomic,copy) NSString *ptName;
@property (nonatomic,copy) NSString *createTime;

@end
