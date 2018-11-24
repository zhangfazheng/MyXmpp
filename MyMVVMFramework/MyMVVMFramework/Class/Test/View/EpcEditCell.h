//
//  EpcEditCell.h
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/2.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "BaseCell.h"
#import "BaseModel.h"

@protocol EpcEditCellDelegate <NSObject>

- (void)scanEpcAction;

@end

@interface EpcEditCell : BaseCell
@property (nonatomic,copy) NSString * epcId;
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,weak) id<EpcEditCellDelegate> scavDelegate;
@end


@interface EpcEditCellModel : BaseModel
@property (nonatomic,copy) NSString * epcId;
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,weak) id<EpcEditCellDelegate> scavDelegate;
@end
