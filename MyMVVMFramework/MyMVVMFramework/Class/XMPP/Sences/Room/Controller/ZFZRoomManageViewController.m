//
//  ZFZRoomManageViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/13.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRoomManageViewController.h"
#import "UITableView+CellClass.h"
#import "CExpandHeader.h"
#import "UINavigationBar+Awesome.h"
#import "ZFZRoomToolCell.h"
#import "ZFZRoomTitleCell.h"
#import "ZFZRoomMembersCell.h"
#import "ZFZRoomManageViewModel.h"
#import "ZFZRoomAddMemberViewController.h"
#import "ZFZFriendsListViewModel.h"
#import "XMPPConfig.h"
#import "ZFZRoomManager.h"

#define NAVBAR_CHANGE_POINT 200

@interface ZFZRoomManageViewController ()
@property (nonatomic,strong) CExpandHeader *header;
@property (nonatomic,strong) NSMutableArray <NSArray<CellDataAdapter *>*> * items;
@property (nonatomic,weak) ZFZRoomManageViewModel *viewModel;
@end

@implementation ZFZRoomManageViewController
@dynamic viewModel;
- (void)loadView{
    //禁用自动计算行高
    self.notEstimatedRowHeight = YES;
    //关闭自动计算布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    //启用头尾视图
    //self.useForter = YES;
    [super loadView];
    
}

//重写初始化方法
- (instancetype)initWithViewModel:(ZFZRoomManageViewModel *)viewModel{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.viewModel = viewModel;
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

- (void)setup{
    [super setup];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//
    [self.tableview registerCellsClass:@[cellClass(@"ZFZRoomToolCell", nil),cellClass(@"ZFZRoomTitleCell", nil),cellClass(@"ZFZRoomMembersCell", nil)]];

    //self.tableview.estimatedRowHeight           = 100;
    self.tableview.backgroundColor              = [UIColor colorWithWhite:1 alpha:0.1];
    //self.tableview.sectionHeaderHeight          = 0;
//    self.tableview.sectionFooterHeight          = 10;
//    self.tableview.tableHeaderView              = [UIView new];
    //self.tableview.contentInset                 = UIEdgeInsetsMake(0, 0, 0, TabTabBarH);
    self.tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NAVBAR_CHANGE_POINT)];
    [imageView setImage:[UIImage imageNamed:@"bg"]];
    
    _header = [CExpandHeader expandWithScrollView:self.tableview expandView:imageView];
    
    [self.tableview setTableFooterView:[UIView new]];
}

- (void)loadData{
    //第一组数据加载
    [self loadToolData];
    
    //第二组数据加载
    [self loadMemberData];
    
    
}

//加载工具栏数据
- (void)loadToolData{
    //工具数组
    NSArray *toolArry   = @[@{@"toolName":@"百科全书",@"icon":@"icon-library"},
                            @{@"toolName":@"日程表",@"icon":@"icon-curriculum"},
                            @{@"toolName":@"工作计划",@"icon":@"icon-exam"},
                            @{@"toolName":@"消息查询",@"icon":@"icon-score"},
                            @{@"toolName":@"工作",@"icon":@"icon-homework-inline"},
                            @{@"toolName":@"市场",@"icon":@"icon-second-hand"},
                            @{@"toolName":@"说说",@"icon":@"icon-social"},
                            @{@"toolName":@"使用手册",@"icon":@"icon-elec"},
                            @{@"toolName":@"日程课表",@"icon":@"icon-lab"},
                            @{@"toolName":@"日历",@"icon":@"icon-calendar"},
                            @{@"toolName":@"其他",@"icon":@"icon-lost"}];
    
    NSMutableArray *tools = [NSMutableArray arrayWithCapacity:toolArry.count];

    for (NSDictionary *dic in toolArry) {
        ZFZRoomToolModel * tool = [ZFZRoomToolModel initWithInfoDic:dic];
        [tools addObject:tool];
    }
    
    CGFloat topButtonInset      = 15;
    CGFloat lineSpace           = 20;
    // 格子的宽高
    CGFloat appViewWH = 70;
    // 每列有三个格子
    NSInteger column = 4;
    
    ZFZRoomToolCellModel * roomToolCellModel = [[ZFZRoomToolCellModel alloc]init];
    
    roomToolCellModel.toolViewWH        = appViewWH;
    roomToolCellModel.showCount         = (int)column;
    roomToolCellModel.lineSpace         = lineSpace;
    roomToolCellModel.topBottomSpace    = topButtonInset;
    roomToolCellModel.roomToolArry      = tools;
    
    CGFloat toolHeight = ((toolArry.count+3)/column)*appViewWH+((toolArry.count+3)/column-1)*lineSpace+topButtonInset*2;
    
    CellDataAdapter *adapter=[ZFZRoomToolCell dataAdapterWithCellReuseIdentifier:nil data:roomToolCellModel cellHeight:toolHeight type:0];
    NSArray * ToolCellData = @[adapter];
    [self.items addObject:ToolCellData];
}

//群昵称修改数据加载
- (CellDataAdapter *)roomNickNameData{
    NSUserDefaults   *defaults = [ NSUserDefaults standardUserDefaults ];
    NSString *nickName = [defaults stringForKey:@"userNickName"];
    NSDictionary *dict = @{@"title":@"群名片",@"name":nickName};
    CellDataAdapter *adapter=[ZFZRoomTitleCell dataAdapterWithCellReuseIdentifier:nil data:dict cellHeight:44 type:0];
    
    return adapter;
}

//群成员列表数据加载
- (void)loadMemberData{
    NSMutableArray * memberCellData = [NSMutableArray array];
    
    //群昵称修改数据加载
    CellDataAdapter *roomNickNameAdapter = [self roomNickNameData];
    
    [memberCellData addObject:roomNickNameAdapter];
    
    NSMutableArray *memberModelArry =[NSMutableArray array];
    //成员数组
    NSArray<ZFZRoomModel *> *roomList = [ZFZRoomManager shareInstance].roomList;
    for (NSInteger i = 0; i<roomList.count; i++) {
        if ([roomList[i].roomjid isEqualToString:self.viewModel.roomJid.bare]) {
            memberModelArry = roomList[i].roomMembers;
            break;
        }
    }
    
//    NSArray *memberArry   = @[@{@"toolName":@"百科全书",@"icon":@"icon-library"},
//                            @{@"toolName":@"日程表",@"icon":@"icon-curriculum"},
//                            @{@"toolName":@"工作计划",@"icon":@"icon-exam"},
//                            @{@"toolName":@"消息查询",@"icon":@"icon-score"},
//                            @{@"toolName":@"工作",@"icon":@"icon-homework-inline"},
//                            @{@"toolName":@"市场",@"icon":@"icon-second-hand"},
//                            @{@"toolName":@"说说",@"icon":@"icon-social"},
//                            @{@"toolName":@"使用手册",@"icon":@"icon-elec"},
//                            @{@"toolName":@"日程课表",@"icon":@"icon-lab"},
//                            @{@"toolName":@"日历",@"icon":@"icon-calendar"},
//                            @{@"toolName":@"其他",@"icon":@"icon-lost"}];
//
//
//    for (NSDictionary *dic in memberArry) {
//        ZFZFriendModel * member = [ZFZFriendModel initWithInfoDic:dic];
//        [memberModelArry addObject:member];
//    }

    // 格子的宽高
    CGFloat appViewWH = 60;
    // 顶部与底部间距
    CGFloat topBottomSpace = 8;
    
    //文字预留宽度
    CGFloat titleWidth          = 130;
    CGFloat leftInset           = 56;

    ZFZRoomMemberCellModel *roomMemberCellModel = [[ZFZRoomMemberCellModel alloc]init];
    roomMemberCellModel.memberViewWH            = appViewWH;
    roomMemberCellModel.topBottomSpace          = topBottomSpace;
    roomMemberCellModel.titleWidth              = titleWidth;
    roomMemberCellModel.leftInset               = leftInset;
    roomMemberCellModel.rightInset              = 40;
    roomMemberCellModel.membersArry             = memberModelArry;
    roomMemberCellModel.iconPath                = @"tabBar_friendTrends_icon";
    
    CGFloat memeberHeight = appViewWH + topBottomSpace*2;
    
    CellDataAdapter *memberAdapter=[ZFZRoomMembersCell dataAdapterWithCellReuseIdentifier:nil data:roomMemberCellModel cellHeight:memeberHeight type:0];
    [memberCellData addObject:memberAdapter];
    
    
    [self.items addObject:memberCellData];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 1;
//    }else{
//        return 2;
//    }
    return self.items[section].count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==0) {
//        
//        CellDataAdapter *adapter=[ZFZRoomToolCell dataAdapterWithCellReuseIdentifier:nil data:@"ns" cellHeight:100 type:0];
//        
//        return [tableView dequeueAndLoadContentReusableCellFromAdapter:adapter indexPath:indexPath controller:self];
//    }else{
//        if (indexPath.row == 0) {
//            ZFZRoomTitleCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"ZFZRoomTitleCell" forIndexPath:indexPath];
//            [cell.textLabel setText:@"群名片"];
//            cell.type = ZFZRightButtonTypeEdit;
//            cell.nameString = @"李四";
//            
//            return cell;
//        }else{
//            CellDataAdapter *adapter=[ZFZRoomMembersCell dataAdapterWithCellReuseIdentifier:nil data:@"ns" cellHeight:100 type:0];
//            
//            ZFZRoomMembersCell * cell = (ZFZRoomMembersCell *)[tableView dequeueAndLoadContentReusableCellFromAdapter:adapter indexPath:indexPath controller:self];
//            [cell.imageView setImage: [UIImage imageNamed:@"tabBar_friendTrends_icon"]];
//            return cell;
//
//        }
//        
//    }
    CellDataAdapter * adapter = self.items[indexPath.section][indexPath.row];
    BaseCell *cell = [tableView dequeueAndLoadContentReusableCellFromAdapter:adapter indexPath:indexPath controller:self];
   
    //如果是添加好友
    WeakSelf
    if([cell isKindOfClass:[ZFZRoomMembersCell class]]){
        [((ZFZRoomMembersCell *)cell).addMemberSignal subscribeNext:^(id  _Nullable x) {
            NSArray<ZFZMemberModel *> *oldFriendArry = weakSelf.viewModel.roomMembers;
            NSDictionary *params = @{@"oldFriend":oldFriendArry,@"cellReuseIdentifier":@"ZFZManageMemberCell",ROOMJID:weakSelf.viewModel.roomJid};
            
            ZFZFriendsListViewModel *viewModel =[[ZFZFriendsListViewModel alloc]initWithServices:nil params:params];
            ZFZRoomAddMemberViewController * vc = [[ZFZRoomAddMemberViewController alloc]initWithViewModel:viewModel];
            vc.roomJid = weakSelf.viewModel.roomJid;
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
         
         
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        CGFloat toolHeight = ((11+3)/4)*70+((11+3)/4-1)*20+15*2;
//
//        return toolHeight;
//    }else if(indexPath.section == 1 && indexPath.row == 1){
//        return 60+8*2;
//    }else{
//        return 44;
//    }
    CellDataAdapter * adapter = self.items[indexPath.section][indexPath.row];
    return adapter.cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}


-(void)dealloc{
    //[self setStatusBarStyle:UIStatusBarStyleLightContent];
    //[CoreJPush removeJPushListener:self];
    //UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}



-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"ViewController: %@",userInfo);
    
}


#pragma mark- headview不随tableView滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    //NSLog(@"%f",offsetY);
    if (offsetY > -64) {
        CGFloat alpha = MIN(1, 1 - ((- offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

- (NSMutableArray<NSArray<CellDataAdapter *> *> *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

@end
