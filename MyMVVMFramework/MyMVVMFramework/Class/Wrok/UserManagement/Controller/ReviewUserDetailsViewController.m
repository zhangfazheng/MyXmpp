//
//  ReviewUserDetailsViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/27.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ReviewUserDetailsViewController.h"
#import "TileCellModel.h"
#import "EquipmentTextCell.h"
#import "EquipmentTextFieldCell.h"
#import "EquipmentPatternSelectCell.h"
#import "ReviewUserModel.h"
#import "ReviewUserViewModel.h"


@interface ReviewUserDetailsViewController ()<EquipmentTextFieldCellDelgate>
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * items;
//请求参数
@property (nonatomic, strong) NSMutableDictionary *operations;
//不能为空的参数关键字数组
@property (nonatomic, strong) NSMutableArray *requiredParametersArry;
@property (nonatomic, strong) ReviewUserModel *curUser;
@property (strong, nonatomic) ReviewUserViewModel *viewModel;
@end

@implementation ReviewUserDetailsViewController
@dynamic viewModel;

- (void)loadView{
    //显示分隔线
    self.showSeparator = YES;
    //如果启用头尾视图
    self.useHeader = YES;
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setup{
    [super setup];
    self.tableview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    //self.tableview.sectionHeaderHeight = 10;
    
    [self.tableview registerCellsClass:@[cellClass(@"EquipmentTextCell", nil),cellClass(@"EquipmentTextFieldCell", nil),cellClass(@"EquipmentPatternSelectCell", nil)]];
    
    //添加隐藏键盘的事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyBoardHidden)];
    [self.tableview addGestureRecognizer:tap];
    
}


//隐藏键盘
- (void)keyBoardHidden{
    [self.view endEditing:YES];
}

- (void)bindViewModel{
    [super bindViewModel];
    self.items = self.viewModel.curUserItems;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueAndLoadContentReusableCellFromAdapter:_items[indexPath.row] indexPath:indexPath controller:self];
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10.0;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-懒加载
- (NSMutableArray<CellDataAdapter *> *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
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
