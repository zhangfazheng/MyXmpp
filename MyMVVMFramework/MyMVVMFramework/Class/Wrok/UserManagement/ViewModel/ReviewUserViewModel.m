//
//  ReviewUserDetailsViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/28.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ReviewUserViewModel.h"
#import "TileCellModel.h"
#import "EquipmentTextCell.h"
#import "EquipmentTextFieldCell.h"
#import "EquipmentPatternSelectCell.h"
#import "ReviewUserModel.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
#import "Interface.h"
#import "ReviewUserTableViewCell.h"

@interface ReviewUserViewModel ()<EquipmentTextFieldCellDelgate>
//请求参数
@property (nonatomic, strong) NSMutableDictionary *operations;
//不能为空的参数关键字数组
@property (nonatomic, strong) NSMutableArray *requiredParametersArry;
@property (nonatomic,assign) NSInteger curPage;
@property (nonatomic,assign) NSInteger total;
@end

@implementation ReviewUserViewModel

- (instancetype)initWithServices:(id<ViewModelServices>)services params:(NSDictionary *)params{
    self = [super initWithServices:services params:params];
    if (self) {
        self.curPage = 0;
        self.total = 1;
    }
    return self;
}

- (RACSignal *)executeRequestDataSignal:(id)input{
    WeakSelf
    //[MBProgressHUD showMessage:@"数据加载中"];
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        if(weakSelf.curPage >= weakSelf.total){
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            [MBProgressHUD showNoImageMessage:@"没有更多数据"];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }
        
        //设置请求参数
        NSMutableDictionary *paraments = (NSMutableDictionary *)input;
        
        [paraments setObject:@(weakSelf.curPage) forKey:@"offset"];
        [paraments setObject:@(10) forKey:@"limit"];
        
        [[NetWorkManager shareManager]requestWithType:HttpRequestTypePost withUrlString:GetUserPageResult withParaments:paraments withSuccessBlock:^(NSDictionary *object) {
            
            //[MBProgressHUD hideHUD];
            NSDictionary *data      = object[@"data"];
            weakSelf.total          = [data[@"total"] integerValue];
            
            NSArray<NSDictionary *> *userList       = data[@"rows"];
            [weakSelf configureUserList:userList];
            weakSelf.curPage = weakSelf.items.count;
            [subscriber sendNext:weakSelf.items];
            [subscriber sendCompleted];
            
        } withFailureBlock:^(NSError *error) {
            //[MBProgressHUD hideHUD];
            //[MBProgressHUD showNoImageMessage:@"数据加载失败"];
            [subscriber sendError:error];
            [subscriber sendCompleted];
        } progress:^(float progress) {
            
        }];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    return signal;
}

//用户数据解析与包装
- (void)configureUserList:(NSArray<NSDictionary *> *)userList{
    for (NSDictionary *dict in userList) {
        ReviewUserModel * user = [ReviewUserModel initWithInfoDic:dict];
        CellDataAdapter * adapter = [ReviewUserTableViewCell dataAdapterWithCellReuseIdentifier:@"ReviewUserTableViewCell" data:user cellHeight:100 type:0];
        [self.items addObject:adapter];
    }
}

- (void)configureDataSource{
    //移除旧数据
    [self.curUserItems removeAllObjects];
    
    TileCellModel *item1 = [[TileCellModel alloc]init];
    TileCellModel *item2 = [[TileCellModel alloc]init];
    TileCellModel *item3 = [[TileCellModel alloc]init];
    EquipmentPatternSelectCellModel *item4 = [[EquipmentPatternSelectCellModel alloc]init];
    TileCellModel *item5 = [[TileCellModel alloc]init];
    TileCellModel *item6 = [[TileCellModel alloc]init];
    TileCellModel *item7 = [[TileCellModel alloc]init];
    EquipmentPatternSelectCellModel *item8 = [[EquipmentPatternSelectCellModel alloc]init];
    //TileCellModel *item4 = [[TileCellModel alloc]init];
    
    
    item1.tilleString=@"姓名";
    item1.valueString=isEmptyString(_curUser.realName) ?@"":_curUser.realName;
    item1.strKey =@"realname";
    item1.delgate = self;
    [self.requiredParametersArry addObject:@[item1.strKey,item1.tilleString]];
    item1.isRequired = YES;
    //如果数据不为空，将数据加入请求参数列表
    if (!isEmptyString(item1.valueString)) {
        [self.operations setObject:item1.valueString forKey:item1.strKey];
    }
    [self.curUserItems addObject:[EquipmentTextFieldCell dataAdapterWithCellReuseIdentifier:nil data:item1 cellHeight:100 type:0]];
    
    
    item2.tilleString=@"姓名拼音";
    item2.valueString=isEmptyString(_curUser.pinName) ?@"":_curUser.pinName;
    item2.strKey =@"pinName";
    item2.delgate = self;
    [self.requiredParametersArry addObject:@[item2.strKey,item2.tilleString]];
    item2.isRequired = YES;
    //如果数据不为空，将数据加入请求参数列表
    if (!isEmptyString(item2.valueString)) {
        [self.operations setObject:item2.valueString forKey:item2.strKey];
    }
    [self.curUserItems addObject:[EquipmentTextFieldCell dataAdapterWithCellReuseIdentifier:nil data:item2 cellHeight:100 type:0]];
    
    item3.tilleString   = @"职位";
    item3.valueString   = isEmptyString(_curUser.postName) ?@"":_curUser.postName;
    item3.strKey        =@"postName";
    item3.delgate       = self;
    item3.keyBordType   = UIKeyboardTypeNumberPad;
    [self.requiredParametersArry addObject:@[item3.strKey,item3.tilleString]];
    //如果数据不为空，将数据加入请求参数列表
    if (!isEmptyString(item3.valueString)) {
        [self.operations setObject:item3.valueString forKey:item3.strKey];
    }
    [self.curUserItems addObject:[EquipmentTextFieldCell dataAdapterWithCellReuseIdentifier:nil data:item3 cellHeight:100 type:0]];
    
    item4.tilleString = @"部门";
    item4.valueString = isEmptyString(_curUser.deptNameCn) ?@"":_curUser.deptNameCn;
    [self.requiredParametersArry addObject:@[@"deptId",@"部门"]];
    //如果数据不为空，将数据加入请求参数列表
    if (!isEmptyString(_curUser.deptId)) {
        [self.operations setObject:_curUser.deptId forKey:@"deptId"];
    }
    [self.curUserItems addObject:[EquipmentPatternSelectCell dataAdapterWithCellReuseIdentifier:nil data:item4 cellHeight:100 type:0]];
    
    item5.tilleString   = @"手机号";
    item5.valueString   = isEmptyString(_curUser.mobile) ?@"":_curUser.mobile;
    item5.strKey        =@"mobile";
    item5.delgate       = self;
    item5.keyBordType   = UIKeyboardTypeNumberPad;
    [self.requiredParametersArry addObject:@[item5.strKey,item5.tilleString]];
    //如果数据不为空，将数据加入请求参数列表
    if (!isEmptyString(item5.valueString)) {
        [self.operations setObject:item5.valueString forKey:item5.strKey];
    }
    [self.curUserItems addObject:[EquipmentTextFieldCell dataAdapterWithCellReuseIdentifier:nil data:item5 cellHeight:100 type:0]];
    
    item6.tilleString   = @"身份证号";
    item6.valueString   = isEmptyString(_curUser.idCard) ?@"":_curUser.idCard;
    item6.strKey        =@"idCard";
    item6.delgate       = self;
    item6.keyBordType   = UIKeyboardTypeNumberPad;
    [self.requiredParametersArry addObject:@[item6.strKey,item6.tilleString]];
    //如果数据不为空，将数据加入请求参数列表
    if (!isEmptyString(item6.valueString)) {
        [self.operations setObject:item6.valueString forKey:item6.strKey];
    }
    [self.curUserItems addObject:[EquipmentTextFieldCell dataAdapterWithCellReuseIdentifier:nil data:item6 cellHeight:100 type:0]];
    
    item7.tilleString   = @"年龄";
    item7.valueString   = [NSString stringWithFormat:@"%zd",_curUser.age];
    item7.strKey        =@"age";
    item7.delgate       = self;
    item7.keyBordType   = UIKeyboardTypeNumberPad;
    [self.requiredParametersArry addObject:@[item7.strKey,item7.tilleString]];
    //如果数据不为空，将数据加入请求参数列表
    if (!isEmptyString(item7.valueString)) {
        [self.operations setObject:item7.valueString forKey:item7.strKey];
    }
    [self.curUserItems addObject:[EquipmentTextFieldCell dataAdapterWithCellReuseIdentifier:nil data:item7 cellHeight:100 type:0]];
    
    item8.tilleString   = @"性别";
    item8.valueString   = _curUser.sex == 0?@"男":@"女";
    [self.requiredParametersArry addObject:@[@"sex",item8.tilleString]];
    //如果数据不为空，将数据加入请求参数列表
    [self.operations setObject:@(_curUser.sex) forKey:@"sex"];
    [self.curUserItems addObject:[EquipmentPatternSelectCell dataAdapterWithCellReuseIdentifier:nil data:item8 cellHeight:100 type:0]];
    
    //        [self.items addObject:[EquipmentTextFieldCell dataAdapterWithCellReuseIdentifier:nil data:item4 cellHeight:100 type:0]];
    //    [self.items addObject:[EquipmentTextFieldCell dataAdapterWithCellReuseIdentifier:nil data:item3 cellHeight:100 type:0]];
}



#pragma mark-懒加载
- (NSMutableArray<CellDataAdapter *> *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSMutableArray<CellDataAdapter *> *)curUserItems{
    if (!_curUserItems) {
        _curUserItems = [NSMutableArray array];
    }
    return _curUserItems;
}

- (void)setCurUser:(ReviewUserModel *)curUser{
    if (curUser) {
        _curUser = curUser;
        
        [self configureDataSource];
        
    }
    
}

//请求参数
- (NSMutableDictionary *)operations{
    if (!_operations) {
        _operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

//不能为空的参数列表
- (NSMutableArray *)requiredParametersArry{
    if (!_requiredParametersArry) {
        _requiredParametersArry = [NSMutableArray array];
    }
    return _requiredParametersArry;
}

@end
