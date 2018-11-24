//
//  TestViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/5/31.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "TestViewModel.h"
#import "Masonry.h"
#import "EpcEditCell.h"
#import <AudioToolBox/AudioServices.h>
#import "MBProgressHUD+MJ.h"
#import "EquipmentPatternSelectCell.h"
#import "RHTableView.h"
#import "RHTableViewAdapter.h"
#import "RHTableViewCellModel.h"
#import "RHTableViewCell.h"
#import "EPCInfoListCell.h"
#import "EPCNoInfoListCell.h"
#import "TileCellModel.h"
#import "SubmitCell.h"
#import "EquipmentTextCell.h"
#import "EquipmentTextFieldCell.h"
#import "NSArray+Log.h"

@interface TestViewModel ()<EpcEditCellDelegate,SubmitCellDelegate,RHTableViewAdapterDelegate,UIGestureRecognizerDelegate>
//请求参数
@property (nonatomic, strong) NSMutableDictionary *operations;
//不能为空的参数关键字数组
@property (nonatomic, strong) NSMutableArray *requiredParametersArry;

@property (nonatomic,assign) NSInteger  curPatternSelectCellRow;
@property (nonatomic,assign) NSInteger  curVendorSelectCellRow;
@property (nonatomic,assign) NSInteger  curEquipmentNameCellRow;
@property (nonatomic,strong) NSArray *equipmentPatternSelectArry;
@end

@implementation TestViewModel
- (instancetype)initWithServices:(id<ViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        
        _items          = [NSMutableArray array];
        _curEpcList     = [NSMutableArray array];
        _isEidtModel    = YES;
    }
    return self;
}


- (void)initialize
{
    [super initialize];
    @weakify(self)
    _itemsDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        self.isEidtModel = !self.isEidtModel;
        return [[self getItemsDataSignal] doNext:^(id  _Nullable result) {
            
            self.items = result;
            
        }];
        //return [self getItemsDataSignal];
    }];
    
    _itemsConnectionErrors = _itemsDataCommand.errors;
    
}

//设置信号
- (void)setInsNameSignal:(RACSignal *)insNameSignal{
    _insNameSignal = insNameSignal;
    [_insNameSignal subscribeNext:^(NSString *x) {
        NSLog(@"%@",x);
    }];

}

- (void)setInsWeightSignal:(RACSignal *)insWeightSignal{
    _insWeightSignal = insWeightSignal;
    [_insWeightSignal subscribeNext:^(NSString *x) {
        NSLog(@"%@",x);
    }];

}

- (void)setVIdSignal:(RACSignal *)vIdSignal{
    _vIdSignal = vIdSignal;
    [_vIdSignal subscribeNext:^(NSString *x) {
        NSLog(@"%@",x);
    }];

}

- (void)setGetValueSignal:(RACSignal *)getValueSignal{
    _getValueSignal = getValueSignal;
    [_getValueSignal subscribeNext:^(NSDictionary * x) {
        NSLog(@"%@",[x descriptionWithLocale:nil]);
    }];
}


// 加载更多
- (RACSignal *)getItemsDataSignal
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSMutableArray *temArry = [NSMutableArray array];
        //如果是编辑模式
        if (self.isEidtModel) {
            EpcEditCellModel *item0=[[EpcEditCellModel alloc]init];
            TileCellModel *item1 = [[TileCellModel alloc]init];
            TileCellModel *item2 = [[TileCellModel alloc]init];
            TileCellModel *item3 = [[TileCellModel alloc]init];
            //TileCellModel *item4 = [[TileCellModel alloc]init];
            EquipmentPatternSelectCellModel *item5 = [[EquipmentPatternSelectCellModel alloc]init];
            EquipmentPatternSelectCellModel *item6 = [[EquipmentPatternSelectCellModel alloc]init];
            
            item0.epcId = isEmptyString(self.curEquipment.epcId) ?@"":self.curEquipment.epcId;
            item0.scavDelegate=self;
            item0.isEdit = YES;
            [self.requiredParametersArry addObject:@[@"iTag",@"epc编码"]];
            //如果数据不为空，将数据加入请求参数列表
            if (!isEmptyString(item0.epcId)) {
                [self.operations setObject:item0.epcId forKey:@"iTag"];
            }
            
            
            item1.tilleString=@"名称";
            item1.valueString=isEmptyString(self.curEquipment.name) ?@"":self.curEquipment.name;
            item1.strKey =@"insNameSignal";
            item1.viewModel = self;
            [self.requiredParametersArry addObject:@[item1.strKey,item1.tilleString]];
            //如果数据不为空，将数据加入请求参数列表
            if (!isEmptyString(item1.valueString)) {
                [self.operations setObject:item1.valueString forKey:item1.strKey];
            }
            
            item2.tilleString=@"类型";
            item2.valueString=isEmptyString(self.curEquipment.equipmentTypeName) ?@"":self.curEquipment.equipmentTypeName;
            
            //        item4.tilleString=@"使用次数";
            //        item4.valueString=@"10";
            //        item4.units=@"次";
            //        item4.strKey =@"useTimes";
            //        item4.delgate = self;
            //        [self.requiredParametersArry addObject:@[item4.strKey,item4.tilleString]];
            //        //如果数据不为空，将数据加入请求参数列表
            //        if (!isEmptyString(item4.valueString)) {
            //            [self.operations setObject:item4.valueString forKey:item4.strKey];
            //        }
            
            item3.tilleString   = @"重量";
            item3.valueString   = [NSString stringWithFormat:@"%zd", self.curEquipment.weight];
            item3.units         =@"g";
            item3.strKey        =@"insWeightSignal";
            item3.viewModel       = self;
            item3.keyBordType   = UIKeyboardTypeNumberPad;
            [self.requiredParametersArry addObject:@[item3.strKey,item3.tilleString]];
            //如果数据不为空，将数据加入请求参数列表
            if (!isEmptyString(item3.valueString)) {
                [self.operations setObject:item3.valueString forKey:item3.strKey];
            }
            
            item5.tilleString = @"类型";
            item5.valueString = isEmptyString(self.curEquipment.equipmentTypeName) ?@"":self.curEquipment.equipmentTypeName;
            [self.requiredParametersArry addObject:@[@"itId",@"类型"]];
            //如果数据不为空，将数据加入请求参数列表
            if (!isEmptyString(self.curEquipment.ptId)) {
                [self.operations setObject:self.curEquipment.ptId forKey:@"itId"];
            }
            
            item6.tilleString = @"生产厂商";
            item6.valueString = isEmptyString(self.curEquipment.vendorName) ?@"":self.curEquipment.vendorName;
            //如果数据不为空，将数据加入请求参数列表
            if (!isEmptyString(self.curEquipment.vendorId)) {
                [self.operations setObject:self.curEquipment.vendorId forKey:@"vId"];
            }
            
            //_equipmentPatternSelectArry=@[@"手术刀",@"手术钳",@"手术镊"];
            
            
            
            [temArry addObject:[EpcEditCell dataAdapterWithCellReuseIdentifier:nil data:item0 cellHeight:100 type:0]];
            [temArry addObject:[EquipmentPatternSelectCell dataAdapterWithCellReuseIdentifier:nil data:item5 cellHeight:100 type:0]];
            self.curPatternSelectCellRow = 1;
            
            [temArry addObject:[EquipmentTextFieldCell dataAdapterWithCellReuseIdentifier:nil data:item1 cellHeight:100 type:0]];
            self.curEquipmentNameCellRow = 2;
            
            
            [temArry addObject:[EquipmentPatternSelectCell dataAdapterWithCellReuseIdentifier:nil data:item6 cellHeight:100 type:0]];
            self.curVendorSelectCellRow  = 3;
            
            //        [self.items addObject:[EquipmentTextFieldCell dataAdapterWithCellReuseIdentifier:nil data:item4 cellHeight:100 type:0]];
            [self.items addObject:[EquipmentTextFieldCell dataAdapterWithCellReuseIdentifier:nil data:item3 cellHeight:100 type:0]];
        }else{
            //如果不是编辑模式重新设置数据源
            EpcEditCellModel *item0=[[EpcEditCellModel alloc]init];
            TileCellModel *item1 = [[TileCellModel alloc]init];
            //        TileCellModel *item2 = [[TileCellModel alloc]init];
            TileCellModel *item3 = [[TileCellModel alloc]init];
            TileCellModel *item4 = [[TileCellModel alloc]init];
            TileCellModel *item5 = [[TileCellModel alloc]init];
            TileCellModel *item6 = [[TileCellModel alloc]init];
            
            item0.epcId=isEmptyString(self.curEquipment.epcId) ?@"":self.curEquipment.epcId;
            item0.scavDelegate=self;
            item0.isEdit = NO;
            
            item1.tilleString=@"名称";
            item1.valueString=isEmptyString(self.curEquipment.name) ?@"":self.curEquipment.name;
            
            //        item2.tilleString=@"类型";
            //        item2.valueString=isEmptyString(self.curEquipment.equipmentTypeName) ?@"":self.curEquipment.equipmentTypeName;
            
            item4.tilleString=@"使用次数";
            item4.valueString=[NSString stringWithFormat:@"%zd", self.curEquipment.useTimes];
            item4.units=@"次";
            
            item3.tilleString=@"重量";
            item3.valueString=[NSString stringWithFormat:@"%zd", self.curEquipment.weight];
            item3.units=@"g";
            
            item5.tilleString = @"类型";
            item5.valueString = isEmptyString(self.curEquipment.equipmentTypeName) ?@"":self.curEquipment.equipmentTypeName;
            
            item6.tilleString = @"生产厂商";
            item6.valueString = isEmptyString(self.curEquipment.vendorName) ?@"":self.curEquipment.vendorName;
            
            //_equipmentPatternSelectArry=@[@"手术刀",@"手术钳",@"手术镊"];
            
            
            [temArry addObject:[EpcEditCell dataAdapterWithCellReuseIdentifier:nil data:item0 cellHeight:100 type:0]];
            
            [temArry addObject:[EquipmentTextCell dataAdapterWithCellReuseIdentifier:nil data:item5 cellHeight:100 type:0]];
            self.curPatternSelectCellRow = 2;
            
            [temArry addObject:[EquipmentTextCell dataAdapterWithCellReuseIdentifier:nil data:item1 cellHeight:100 type:0]];
            
            
            [temArry addObject:[EquipmentTextCell dataAdapterWithCellReuseIdentifier:nil data:item6 cellHeight:100 type:0]];
            self.curVendorSelectCellRow  = 3;
            
            [temArry addObject:[EquipmentTextCell dataAdapterWithCellReuseIdentifier:nil data:item3 cellHeight:100 type:0]];
            
            [temArry addObject:[EquipmentTextCell dataAdapterWithCellReuseIdentifier:nil data:item4 cellHeight:100 type:0]];
        }
        self.items =temArry;
        [subscriber sendNext:temArry];
        [subscriber sendCompleted];
    
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}

- (RACSignal *)executeRequestDataSignal:(id)input
{
//    return [[[self.services getFindService] requestFindDataSignal:Find_URL] doNext:^(id  _Nullable result) {
//        
//        self.videoData = result[FindVideoDatakey];
//        self.feedData = result[FindFeedDatakey];
//        
//    }];
    
    return nil;
}
@end
