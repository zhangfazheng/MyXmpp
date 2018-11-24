//
//  EquipmentTextFieldCell.h
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/20.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "BaseCell.h"
#import "TestViewModel.h"

//typedef void(^EquipmentTextFieldBlock)(NSString *value,NSString *key);
@protocol EquipmentTextFieldCellDelgate <NSObject>

- (void)editEndActionWithValue:(NSString *)value andKey:(NSString *)key andRow:(NSInteger) row;

@end


@interface EquipmentTextFieldCell : BaseCell
//单位
@property (nonatomic,copy) NSString * units;
//关键字，当输入完后会将该字段作为参数的关键字
@property (nonatomic,copy) NSString * strKey;
//编辑完成后的回调
@property (nonatomic,weak) id<EquipmentTextFieldCellDelgate> textFieldCellDelgate;

@property (nonatomic,strong) TestViewModel *viewModel;

@property (nonatomic,strong) RACSignal *valueSignal;

@end
