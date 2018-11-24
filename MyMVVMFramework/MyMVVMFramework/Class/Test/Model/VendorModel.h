//
//  VendorModel.h
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/24.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "DBModel.h"

@interface VendorModel : DBModel
@property (nonatomic,copy) NSString *vendorId;
@property (nonatomic,copy) NSString *vendorName;
@end
