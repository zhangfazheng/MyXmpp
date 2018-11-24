//
//  TileCellModel.h
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/20.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EquipmentTextFieldCell.h"
#import "TestViewModel.h"

@interface TileCellModel : NSObject
@property (nonatomic,copy) NSString *tilleString;
@property (nonatomic,copy) NSString *valueString;
@property (nonatomic,copy) NSString * units;
//关键字，当输入完后会将该字段作为参数的关键字
@property (nonatomic,copy) NSString * strKey;
@property (nonatomic,strong) id<EquipmentTextFieldCellDelgate> delgate;
@property (nonatomic,strong) TestViewModel *viewModel ;
@property (nonatomic,assign) UIKeyboardType keyBordType;
//是否是必填项
@property (nonatomic,assign) BOOL isRequired;
@property (nonatomic,strong) RACSignal *valueSignal;

@end
