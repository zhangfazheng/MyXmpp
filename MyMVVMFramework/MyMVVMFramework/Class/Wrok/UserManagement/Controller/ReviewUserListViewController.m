//
//  ReviewUserListViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/23.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ReviewUserListViewController.h"
#import "UITableView+CellClass.h"
#import "ReviewUserTableViewCell.h"
#import "ReviewUserViewModel.h"
#import "ReviewUserDetailsViewController.h"
#import "MMComBoBoxView.h"
#import "MMItem.h"
#import "MMHeader.h"
#import "MMAlternativeItem.h"
#import "MMSelectedPath.h"

@interface ReviewUserListViewController ()<MMComBoBoxViewDataSource, MMComBoBoxViewDelegate>
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * userList;
@property (strong, nonatomic) ReviewUserViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *mutableArray;
@end

@implementation ReviewUserListViewController
//@dynamic告诉编译器,属性的setter与getter方法由用户自己实现，不自动生成
@dynamic viewModel;

- (void)viewDidLoad {
    //开启上拉加载更多
    self.allowLoadMaore = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setup{
    [super setup];
    [self.tableview registerCellsClass:@[cellClass(@"ReviewUserTableViewCell", nil)]];
    
    [self buildComoBox];
//    NSDictionary *user1 = @{@"name":@"张三"};
//    NSDictionary *user2 = @{@"name":@"李四"};
//    NSDictionary *user3 = @{@"name":@"王五"};
//    NSDictionary *user4= @{@"name":@"赵六"};
//    
//    CellDataAdapter *userAdapter1 = [ReviewUserTableViewCell dataAdapterWithCellReuseIdentifier:@"ReviewUserTableViewCell" data:user1 cellHeight:100 type:0];
//    CellDataAdapter *userAdapter2 = [ReviewUserTableViewCell dataAdapterWithCellReuseIdentifier:@"ReviewUserTableViewCell" data:user2 cellHeight:100 type:0];
//    CellDataAdapter *userAdapter3 = [ReviewUserTableViewCell dataAdapterWithCellReuseIdentifier:@"ReviewUserTableViewCell" data:user3 cellHeight:100 type:0];
//    CellDataAdapter *userAdapter4 = [ReviewUserTableViewCell dataAdapterWithCellReuseIdentifier:@"ReviewUserTableViewCell" data:user4 cellHeight:100 type:0];
//    
//    [self.userList addObject:userAdapter1];
//    [self.userList addObject:userAdapter2];
//    [self.userList addObject:userAdapter3];
//    [self.userList addObject:userAdapter4];
}


#pragma mark- 创建下拉筛选组件
- (void)buildComoBox{
    MMItem *rootItem1 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"全部"];
    rootItem1.selectedType = MMPopupViewMultilSeMultiSelection;
    //first floor
    for (int i = 0; i < 20; i ++) {
        [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"蛋糕系列%d",i] subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
    }
    
    //second root
    MMItem *rootItem2 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"排序"];
    //first floor
    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"创建日期"]]];
    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"姓名"]]];
    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"年龄"]]];
    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"入职时间"]]];
    
    
    //third root
    MMItem *rootItem3 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"部门"];
    for (int i = 0; i < 30; i++){
        MMItem *item3_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[NSString stringWithFormat:@"部门%d",i]];
        [rootItem3 addNode:item3_A];
        for (int j = 0; j < random()%30; j ++) {
            if (i == 0 &&j == 0) {
                [item3_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"部门%d部%d",i,j]subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
            }else{
                [item3_A addNodeWithoutMark:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"部门%d部%d",i,j]subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
            }
        }
    }
    
    //fourth root
    MMItem *rootItem4 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"筛选"];
    MMAlternativeItem *alternativeItem1 = [MMAlternativeItem itemWithTitle:@"只看未审核" isSelected:NO];
    MMAlternativeItem *alternativeItem2 = [MMAlternativeItem itemWithTitle:@"只看未启用" isSelected:YES];
    [rootItem4.alternativeArray addObject:alternativeItem1];
    [rootItem4.alternativeArray addObject:alternativeItem2];
    
    NSArray *arr = @[@{@"审核状态":@[@"不限",@"通过",@"不通过",@"未审核"]},
                     @{@"启用状态":@[@"不限",@"启用",@"未启用"]},
                     @{@"性别":@[@"不限",@"男",@"女"]} ];
    
    for (NSDictionary *itemDic in arr) {
        MMItem *item4_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[itemDic.allKeys lastObject]];
        [rootItem4 addNode:item4_A];
        for (NSString *title in [itemDic.allValues lastObject]) {
            [item4_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:title]];
        }
    }
    
    [self.mutableArray addObject:rootItem1];
    [self.mutableArray addObject:rootItem2];
    [self.mutableArray addObject:rootItem3];
    [self.mutableArray addObject:rootItem4];
    
    //===============================================Init===============================================
    
    MMComBoBoxView *comBoBox = [[MMComBoBoxView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    comBoBox.dataSource = self;
    comBoBox.delegate = self;
    [self.view addSubview:comBoBox];
    [comBoBox reload];
    
    self.tableview.frame = CGRectMake(self.tableview.left, self.tableview.top+40, self.tableview.width, self.tableview.height-40);
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, view.bottom, self.view.width, self.view.height - 64)];
//    imageView.image = [UIImage imageNamed:@"1.jpg"];
//    [self.view addSubview:imageView];
    
}

- (void)bindViewModel{
    [super bindViewModel];
    self.userList = self.viewModel.items;
    
    NSMutableDictionary *input = [NSMutableDictionary dictionary];
    WeakSelf
    [[self.viewModel.requestDataCommand execute:input] subscribeNext:^(id  _Nullable x) {
        if (x) {
            [weakSelf.tableview reloadData];
        }
        
    }];
}

//上拉加载更多
- (void)loadMore_data{
    NSMutableDictionary *input = [NSMutableDictionary dictionary];
    WeakSelf
    [[self.viewModel.requestDataCommand execute:input] subscribeNext:^(id  _Nullable x) {
        if (x) {
            [weakSelf.tableview reloadData];
        }
        [weakSelf.tableview.mj_footer endRefreshing];
    }];
}

#pragma mark ----------UITabelViewDataSource----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.userList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReviewUserTableViewCell *cell = (ReviewUserTableViewCell *)[tableView dequeueAndLoadContentReusableCellFromAdapter:self.userList[indexPath.row] indexPath:indexPath controller:self];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.viewModel.curUser = self.viewModel.items[indexPath.row].data;
    ReviewUserDetailsViewController *reviewUserDetailsVc = [[ReviewUserDetailsViewController alloc]initWithViewModel:self.viewModel Style:UITableViewStyleGrouped];
//    ReviewUserDetailsViewController *reviewUserDetailsVc = [[ReviewUserDetailsViewController alloc]initWithViewModel:self.viewModel];
    
    [self.navigationController pushViewController:reviewUserDetailsVc animated:YES];
}


#pragma mark - MMComBoBoxViewDataSource
- (NSUInteger)numberOfColumnsIncomBoBoxView :(MMComBoBoxView *)comBoBoxView {
    return self.mutableArray.count;
}
- (MMItem *)comBoBoxView:(MMComBoBoxView *)comBoBoxView infomationForColumn:(NSUInteger)column {
    return self.mutableArray[column];
}

#pragma mark - MMComBoBoxViewDelegate
- (void)comBoBoxView:(MMComBoBoxView *)comBoBoxViewd didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index {
    MMItem *rootItem = self.mutableArray[index];
    switch (rootItem.displayType) {
        case MMPopupViewDisplayTypeNormal:
        case MMPopupViewDisplayTypeMultilayer:{
            //拼接选择项
            NSMutableString *title = [NSMutableString string];
            __block NSInteger firstPath;
            [array enumerateObjectsUsingBlock:^(MMSelectedPath * path, NSUInteger idx, BOOL * _Nonnull stop) {
                [title appendString:idx?[NSString stringWithFormat:@";%@",[rootItem findTitleBySelectedPath:path]]:[rootItem findTitleBySelectedPath:path]];
                if (idx == 0) {
                    firstPath = path.firstPath;
                }
            }];
            NSLog(@"当title为%@时，所选字段为 %@",rootItem.title ,title);
            break;}
        case MMPopupViewDisplayTypeFilters:{
            [array enumerateObjectsUsingBlock:^(MMSelectedPath * path, NSUInteger idx, BOOL * _Nonnull stop) {
                //当displayType为MMPopupViewDisplayTypeFilters时有MMAlternativeItem类型和MMItem类型两种
                if (path.isKindOfAlternative == YES) { //MMAlternativeItem类型
                    MMAlternativeItem *alternativeItem = rootItem.alternativeArray[path.firstPath];
                    NSLog(@"当title为%@时，选中状态为 %d",alternativeItem.title,alternativeItem.isSelected);
                } else {
                    MMItem *firstItem = rootItem.childrenNodes[path.firstPath];
                    MMItem *SecondItem = rootItem.childrenNodes[path.firstPath].childrenNodes[path.secondPath];
                    NSLog(@"当title为%@时，所选字段为 %@",firstItem.title,SecondItem.title);
                }
            }];
            break;}
        default:
            break;
    }
}


- (NSMutableArray<CellDataAdapter *> *)userList{
    if (!_userList) {
        _userList = [NSMutableArray array];
    }
    return _userList;
}


- (NSMutableArray *)mutableArray{
    if (!_mutableArray) {
        _mutableArray = [NSMutableArray array];
    }
    return _mutableArray;
}

@end
