//
//  EquipmentDetailsViewController.h
//  OperationEquipment
//
//  Created by 张发政 on 2017/2/21.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "BaseTableViewController.h"

typedef enum : NSUInteger {
    ManagerNormalStyle,
    ManagerEditStyle
} EquipmentManagerStyle;

@interface EquipmentDetailsViewController : BaseTableViewController
@property (assign,nonatomic) EquipmentManagerStyle managerStyle;
@end



