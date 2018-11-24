//
//  ZFZEditTileCellModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/28.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"

@interface ZFZEditTileCellModel : BaseModel
@property (nonatomic,copy) NSString *tilleString;
@property (nonatomic,copy) NSString *valueString;
@property (nonatomic,copy) NSString * units;
//关键字，当输入完后会将该字段作为参数的关键字
@property (nonatomic,copy) NSString * strKey;
//@property (nonatomic,strong) id<EquipmentTextFieldCellDelgate> delgate;
//@property (nonatomic,strong) TestViewModel *viewModel ;
@property (nonatomic,assign) UIKeyboardType keyBordType;
@property (nonatomic,strong) RACSignal *valueSignal;

@end
