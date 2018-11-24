//
//  TestViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/5/31.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"
#import "UITableView+CellClass.h"
#import "EquipmentsModel.h"

@interface TestViewModel : BaseViewModel
/**
 *  编辑模式切换信号
 */
@property (strong, nonatomic) RACSignal *editModelSwitchSignal;
/**
 *  错误信号
 */
@property (strong, nonatomic) RACSignal *itemsConnectionErrors;
/**
 *  更多数据请求
 */
@property (strong, nonatomic) RACCommand *itemsDataCommand;

/**
 *  活动流数组
 */
@property (strong, nonatomic) NSMutableArray<CellDataAdapter *> * items;
/**
 *  视频数组
 */
@property (strong, nonatomic) NSMutableArray *curEpcList;
@property (nonatomic,assign) BOOL isEidtModel;
@property (strong,nonatomic) EquipmentsModel *curEquipment;

@property (copy,nonatomic) NSString *iTag;
@property (copy,nonatomic) NSString *insName;
@property (copy,nonatomic) NSString *insWeight;
@property (copy,nonatomic) NSString *itId;
@property (copy,nonatomic) NSString *vId;

@property (strong,nonatomic) RACSignal *iTagSignal;
@property (strong,nonatomic) RACSignal *insNameSignal;
@property (strong,nonatomic) RACSignal *insWeightSignal;
@property (strong,nonatomic) RACSignal *itIdSignal;
@property (strong,nonatomic) RACSignal *vIdSignal;
@property (strong,nonatomic) RACSignal *getValueSignal;

@end
