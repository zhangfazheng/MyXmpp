//
//  ZFZAddFriendInfoViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/28.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZAddFriendInfoViewController.h"
#import "UITableView+CellClass.h"
#import "ZFZEditTextFieldCell.h"
#import "ZFZGroupsSelectCell.h"
#import "ZFZEditTileCellModel.h"
#import "ZFZSelectedGroupsListViewController.h"

@interface ZFZAddFriendInfoViewController ()
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * items;

//请求参数
@property (nonatomic, strong) NSMutableDictionary *operations;
//不能为空的参数关键字数组
@property (nonatomic, strong) NSMutableArray *requiredParametersArry;

@property (nonatomic,assign) NSInteger  curGroupSelectCellRow;
@property (nonatomic,assign) NSInteger  curNickNameCellRow;

@property (nonatomic, strong) UIBarButtonItem *composeBont;
@end

@implementation ZFZAddFriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - TableView Related.

- (void)configureDataSource{
    //设置必填参数
    [self.tableview registerCellsClass:@[cellClass(@"ZFZEditTextFieldCell", nil),cellClass(@"ZFZGroupsSelectCell", nil)]];
    
    ZFZEditTileCellModel *nickNameItem = [[ZFZEditTileCellModel alloc]init];
    
    nickNameItem.tilleString = @"备注";
    nickNameItem.strKey = @"nickName";
    if (isEmptyString(self.curFriend.name)) {
        nickNameItem.valueString = self.invitation.inviterJid.user;
    }else{
        nickNameItem.valueString = self.curFriend.name;
        [self.operations  setObject:nickNameItem.valueString forKey:nickNameItem.strKey];
    }
    
    [self.requiredParametersArry addObject:@[nickNameItem.strKey,nickNameItem.tilleString]];
    [self.items addObject:[ZFZEditTextFieldCell dataAdapterWithCellReuseIdentifier:nil data:nickNameItem cellHeight:100 type:0]];
    self.curNickNameCellRow = 0;
    
    
    ZFZEditTileCellModel *groupItem = [[ZFZEditTileCellModel alloc]init];
    groupItem.tilleString = @"分组";
    groupItem.strKey      = @"groupName";
    if (isEmptyString(self.curFriend.groupName)) {
        groupItem.valueString = @"";
    }else{
        groupItem.valueString = self.curFriend.groupName;
    }
    [self.requiredParametersArry addObject:@[groupItem.strKey,groupItem.tilleString]];
    [self.items addObject:[ZFZGroupsSelectCell dataAdapterWithCellReuseIdentifier:nil data:groupItem cellHeight:100 type:0]];
    self.curGroupSelectCellRow = 1;

}


- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self)
    
//    self.composeBont.rac_command = self.viewModel.itemsDataCommand;
//    
//    
//    [[self.viewModel.itemsDataCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        self.items = (NSMutableArray<CellDataAdapter *> *)x;
//        [self.tableview reloadData];
//    }];
//    
//
//    [self.viewModel.itemsDataCommand execute:@1];
//    
    
}


- (void)setup{
    [super setup];
    [self.view setBackgroundColor:[UIColor grayColor]];
    [self configureDataSource];
    
    [self addrightButton];
}


//添加编辑/查看切换右按钮
- (void)addrightButton{
    _composeBont    = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(complectionAddFriendAction)];
    _composeBont.tintColor           =        [UIColor blackColor];
    
    [self.navigationItem setRightBarButtonItem:_composeBont];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  2;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView dequeueAndLoadContentReusableCellFromAdapter:_items[indexPath.row] indexPath:indexPath controller:self];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _curGroupSelectCellRow) {
        ZFZSelectedGroupsListViewController *groupListVc = [[ZFZSelectedGroupsListViewController alloc]init];
        groupListVc.groupsListArry = @[@"我的好友",@"同事",@"同学",@"家人"];
        @weakify(self)
        [groupListVc.groupNameSubject subscribeNext:^(NSString * x) {
            //NSString *groupName = x;
            @strongify(self)
            ZFZEditTileCellModel *cellModel = self.items[self.curGroupSelectCellRow].data;
            cellModel.valueString = x;
            self.invitation.groupName = x;
            [self.tableview reloadData];
        }];
        
        [self.navigationController pushViewController:groupListVc animated:YES];
    }
}

- (void)complectionAddFriendAction{
    if (isEmptyString(self.invitation.groupName)) {
        self.invitation.groupName = @"我的好友";
    }else if (isEmptyString(self.invitation.nickName)){
        self.invitation.nickName = self.invitation.inviterJid.user;
    }
    [self.addFriendSubject sendNext:self.invitation];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark- 懒加载
- (NSMutableArray<CellDataAdapter *> *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSMutableDictionary *)operations{
    if (!_operations) {
        _operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

- (NSMutableArray *)requiredParametersArry{
    if (!_requiredParametersArry) {
        _requiredParametersArry = [NSMutableArray array];
    }
    return _requiredParametersArry;
}

- (void)setNickNameSignal:(RACSignal *)nickNameSignal{
    _nickNameSignal = nickNameSignal;
    @weakify(self)
    [nickNameSignal subscribeNext:^(NSString * x) {
        @strongify(self)
        //[self.operations setObject:x[1] forKey:x[0]];
        ZFZEditTileCellModel *cellModel = self.items[self.curNickNameCellRow].data;
        cellModel.valueString = x;

        self.invitation.nickName = x;
    }];
}



@end
