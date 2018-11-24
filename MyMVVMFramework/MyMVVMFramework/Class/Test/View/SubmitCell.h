//
//  SubmitCell.h
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/20.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "BaseCell.h"

@protocol SubmitCellDelegate <NSObject>

- (void)submitButtonAction;

@end

@interface SubmitCell : BaseCell
@property (weak,nonatomic) id<SubmitCellDelegate> submitDelegate;
@end
