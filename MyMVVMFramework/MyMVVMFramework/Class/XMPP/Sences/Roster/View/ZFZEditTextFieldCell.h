//
//  ZFZEditTextFieldCell.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/28.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseCell.h"
#import "ZFZFriendsValidationListViewModel.h"

@interface ZFZEditTextFieldCell : BaseCell
//单位
@property (nonatomic,copy) NSString * units;
//关键字，当输入完后会将该字段作为参数的关键字
@property (nonatomic,copy) NSString * strKey;
//编辑完成后的回调
//@property (nonatomic,weak) id<EquipmentTextFieldCellDelgate> textFieldCellDelgate;
//
@property (nonatomic,weak) ZFZFriendsValidationListViewModel *viewModel;

@property (nonatomic,strong) RACSignal *valueSignal;
@end
