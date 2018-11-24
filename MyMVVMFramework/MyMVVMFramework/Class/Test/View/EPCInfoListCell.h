//
//  EPCInfoListCell.h
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/17.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "RHTableViewCell.h"

@interface EPCInfoListCell : RHTableViewCell
+ (void)load;
@end


@interface EPCInfoListCellModel : NSObject
@property (copy,nonatomic) NSString *epcId;
@property (copy,nonatomic) NSString *equipmentName;
@end
