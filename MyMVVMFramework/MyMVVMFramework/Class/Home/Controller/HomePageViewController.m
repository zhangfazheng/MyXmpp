//
//  HomePageViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "HomePageViewController.h"
#import "UITableView+CellClass.h"
#import "CExpandHeader.h"
#import "UINavigationBar+Awesome.h"
#import "HomePageToolCell.h"
#import "HomePageViewModel.h"
#import "HomePageToolCellModel.h"
#import "AnnouncementHeaderView.h"
#import "OrganizationalStructureViewModel.h"
#import "ZFZFindFriendViewController.h"
#import "ReviewUserListViewController.h"
#import "ReviewUserViewModel.h"


#define NAVBAR_CHANGE_POINT 200

@interface HomePageViewController ()<HomePageToolCellDelegate>
@property (nonatomic,strong) CExpandHeader *header;
@property (nonatomic,strong) NSMutableArray <NSArray<CellDataAdapter *>*> * items;
@property (nonatomic,weak) HomePageViewModel *viewModel;
@end

@implementation HomePageViewController

@dynamic viewModel;
- (void)loadView{
    //禁用自动计算行高
    self.notEstimatedRowHeight = YES;
    //关闭自动计算布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    //隐藏底部tabBar
    self.hidesBottomBar = YES;
    //启用头尾视图
    //self.useForter = YES;
    [super loadView];
    
}

//重写初始化方法
- (instancetype)initWithViewModel:(HomePageViewModel *)viewModel{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.viewModel = viewModel;
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self loadData];
}

- (void)setup{
    [super setup];
    
    //初始化本地数据
    self.items = self.viewModel.apps;
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //
    [self.tableview registerCellsClass:@[cellClass(@"HomePageToolCell", nil),cellClass(@"ZFZRoomTitleCell", nil),cellClass(@"ZFZRoomMembersCell", nil)]];
    
    //注册headView
    [self.tableview registerClass:[AnnouncementHeaderView class] forHeaderFooterViewReuseIdentifier:@"AnnouncementHeaderView"];
    
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

- (void)bindViewModel{
    [super bindViewModel];
    if (self.viewModel) {
        WeakSelf
        [[[self.viewModel.requestDataCommand executionSignals]switchToLatest]subscribeNext:^(NSMutableArray <NSArray<CellDataAdapter *>*> *x) {
            weakSelf.items = x;
            if(x && x.count > 0){
                [MBProgressHUD showNoImageMessage:@"权限发生变化"];
                [weakSelf.tableview reloadData];
            }
                
            
        }];
        
        
        //查询用户信息的请求信号订阅
//        [[[self.viewModel.getUserInfoDataCommand executionSignals]switchToLatest]subscribeNext:^(id  _Nullable x) {
//            //获取用户信息跳转到用户信息界面
//            VCardInfoViewController *vCardVc = [[VCardInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
//            vCardVc.userInfo = x;
//            [weakSelf.navigationController pushViewController:vCardVc animated:YES];
//        }];
        [self.viewModel.requestDataCommand execute:nil];
    }
}


- (void)loadData{
    //第一组数据加载
    [self loadToolDataWithTile:@"管理员控制台" subTitle:@"(仅管理员可见)" fileName:@"HomeManageSetting"];
    //考勤
    [self loadToolDataWithTile:@"考勤管理" subTitle:@"" fileName:@"HomeAttendanceSetting"];
    //报表
    [self loadToolDataWithTile:@"业务汇报" subTitle:@"" fileName:@"HomeReportSetting"];
    //统计
    [self loadToolDataWithTile:@"统计" subTitle:@"" fileName:@"HomeStatisticsSetting"];
    //财务
    [self loadToolDataWithTile:@"财务管理" subTitle:@"" fileName:@"HomeFinanceSetting"];
    //行政管理
    [self loadToolDataWithTile:@"行政管理" subTitle:@"" fileName:@"HomeAdministrationSetting"];
    //其他
   [self loadToolDataWithTile:@"其他" subTitle:@"" fileName:@"HomeOtherSetting"];
    
    
}

//加载工具栏数据
- (void)loadToolDataWithTile:(NSString *)title subTitle:(NSString*)subTitle fileName:(NSString *)fileName{
    // 1.获取plist文件的全路径
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    // 2.读取plist
    NSArray *toolArry = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *tools = [NSMutableArray arrayWithCapacity:toolArry.count];
    
    for (NSDictionary *dic in toolArry) {
        HomePageToolModel * tool = [HomePageToolModel initWithInfoDic:dic];
        [tools addObject:tool];
    }
    
    CGFloat topButtonInset      = 15;
    CGFloat lineSpace           = 20;
    // 格子的宽高
    CGFloat appViewWH = 70;
    CGFloat toolTileHeight = 44;
    // 每列有三个格子
    NSInteger column = 4;
    
    HomePageToolCellModel * roomToolCellModel = [[HomePageToolCellModel alloc]init];
    
    roomToolCellModel.toolViewWH        = appViewWH;
    roomToolCellModel.showCount         = 4;
    roomToolCellModel.rowCount          = (int)column;
    roomToolCellModel.lineSpace         = lineSpace;
    roomToolCellModel.topBottomSpace    = topButtonInset;
    roomToolCellModel.homeToolArry      = tools;
    roomToolCellModel.toolTitle         = title;
    roomToolCellModel.toolSubtitle      = subTitle;
    
    CGFloat toolHeight = ((tools.count+3)/column)*appViewWH+((tools.count+3)/column-1)*lineSpace+topButtonInset*2+toolTileHeight;
    roomToolCellModel.toolHeight =toolHeight-toolTileHeight;
    
    CellDataAdapter *adapter=[HomePageToolCell dataAdapterWithCellReuseIdentifier:nil data:roomToolCellModel cellHeight:toolHeight type:0];
    NSArray * ToolCellData = @[adapter];
    [self.items addObject:ToolCellData];
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
        HomePageToolModel * tool = [HomePageToolModel initWithInfoDic:dic];
        [tools addObject:tool];
    }
    
    CGFloat topButtonInset      = 15;
    CGFloat lineSpace           = 20;
    // 格子的宽高
    CGFloat appViewWH = 70;
    // 每列有三个格子
    NSInteger column = 4;
    
    HomePageToolCellModel * roomToolCellModel = [[HomePageToolCellModel alloc]init];
    
    roomToolCellModel.toolViewWH        = appViewWH;
    roomToolCellModel.showCount         = 4;
    roomToolCellModel.rowCount         = (int)column;
    roomToolCellModel.lineSpace         = lineSpace;
    roomToolCellModel.topBottomSpace    = topButtonInset;
    roomToolCellModel.homeToolArry      = tools;
    
    CGFloat toolHeight = ((roomToolCellModel.showCount+3)/column)*appViewWH+((roomToolCellModel.showCount+3)/column-1)*lineSpace+topButtonInset*2+44;
    
    CellDataAdapter *adapter=[HomePageToolCell dataAdapterWithCellReuseIdentifier:nil data:roomToolCellModel cellHeight:toolHeight type:0];
    NSArray * ToolCellData = @[adapter];
    [self.items addObject:ToolCellData];
}


- (void)loadTool2Data{
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
        HomePageToolModel * tool = [HomePageToolModel initWithInfoDic:dic];
        [tools addObject:tool];
    }
    
    CGFloat topButtonInset      = 15;
    CGFloat lineSpace           = 20;
    // 格子的宽高
    CGFloat appViewWH = 80;
    // 每列有三个格子
    NSInteger column = 4;
    
    HomePageToolCellModel * roomToolCellModel = [[HomePageToolCellModel alloc]init];
    
    roomToolCellModel.toolViewWH        = appViewWH;
    roomToolCellModel.showCount         = (int)toolArry.count;
    roomToolCellModel.rowCount         = (int)column;
    roomToolCellModel.lineSpace         = lineSpace;
    roomToolCellModel.topBottomSpace    = topButtonInset;
    roomToolCellModel.homeToolArry      = tools;
    
    CGFloat toolHeight = ((roomToolCellModel.showCount+3)/column)*appViewWH+((roomToolCellModel.showCount+3)/column-1)*lineSpace+topButtonInset*2+44;
    
    CellDataAdapter *adapter=[HomePageToolCell dataAdapterWithCellReuseIdentifier:nil data:roomToolCellModel cellHeight:toolHeight type:0];
    NSArray * ToolCellData = @[adapter];
    [self.items addObject:ToolCellData];
}


//工具点击事件
- (void)toolClickAction:(NSInteger)tag{
    switch (tag) {
        case 101:{
            //组织架构
            OrganizationalStructureViewModel *viewModel = [[OrganizationalStructureViewModel alloc]initWithServices:nil params:nil];
            //    ZFZFindFriendViewController *addVc = [[ZFZFindFriendViewController alloc]initWithViewModel:viewModel];
            ZFZFindFriendViewController *addVc = [[ZFZFindFriendViewController alloc]initWithViewModel:viewModel Style:UITableViewStyleGrouped];
            addVc.titles = [@[@"新脉远望"] mutableCopy];
            [self.navigationController pushViewController:addVc animated:YES];
            break;
        }
        case 104:{
            ReviewUserViewModel *viewModel = [[ReviewUserViewModel alloc]initWithServices:nil params:nil];
            ReviewUserListViewController *reviewVc = [[ReviewUserListViewController alloc]initWithViewModel:viewModel];
            [self.navigationController pushViewController:reviewVc animated:YES];
            break;
        }
           
            
        default:
            NSLog(@"点击了：%zd",tag);
            break;
    }
}


//群昵称修改数据加载
- (CellDataAdapter *)roomNickNameData{
    
    NSDictionary *dict = @{@"title":@"群名片",@"name":@"李四"};
    CellDataAdapter *adapter=[HomePageToolCell dataAdapterWithCellReuseIdentifier:nil data:dict cellHeight:44 type:0];
    
    return adapter;
}

//群成员列表数据加载
- (void)loadMemberData{
    NSMutableArray * memberCellData = [NSMutableArray array];
    
//    //群昵称修改数据加载
//    CellDataAdapter *roomNickNameAdapter = [self roomNickNameData];
//    
//    [memberCellData addObject:roomNickNameAdapter];
//    
//    
//    //成员数组
//    NSArray *memberArry   = @[@{@"toolName":@"百科全书",@"icon":@"icon-library"},
//                              @{@"toolName":@"日程表",@"icon":@"icon-curriculum"},
//                              @{@"toolName":@"工作计划",@"icon":@"icon-exam"},
//                              @{@"toolName":@"消息查询",@"icon":@"icon-score"},
//                              @{@"toolName":@"工作",@"icon":@"icon-homework-inline"},
//                              @{@"toolName":@"市场",@"icon":@"icon-second-hand"},
//                              @{@"toolName":@"说说",@"icon":@"icon-social"},
//                              @{@"toolName":@"使用手册",@"icon":@"icon-elec"},
//                              @{@"toolName":@"日程课表",@"icon":@"icon-lab"},
//                              @{@"toolName":@"日历",@"icon":@"icon-calendar"},
//                              @{@"toolName":@"其他",@"icon":@"icon-lost"}];
//    NSMutableArray *memberModelArry =[NSMutableArray array];
//    
//    for (NSDictionary *dic in memberArry) {
//        ZFZFriendModel * member = [ZFZFriendModel initWithInfoDic:dic];
//        [memberModelArry addObject:member];
//    }
//    
//    // 格子的宽高
//    CGFloat appViewWH = 60;
//    // 顶部与底部间距
//    CGFloat topBottomSpace = 8;
//    
//    //文字预留宽度
//    CGFloat titleWidth          = 130;
//    CGFloat leftInset           = 56;
//    
//    ZFZRoomMemberCellModel *roomMemberCellModel = [[ZFZRoomMemberCellModel alloc]init];
//    roomMemberCellModel.memberViewWH            = appViewWH;
//    roomMemberCellModel.topBottomSpace          = topBottomSpace;
//    roomMemberCellModel.titleWidth              = titleWidth;
//    roomMemberCellModel.leftInset               = leftInset;
//    roomMemberCellModel.rightInset              = 40;
//    roomMemberCellModel.membersArry             = memberModelArry;
//    roomMemberCellModel.iconPath                = @"tabBar_friendTrends_icon";
//    
//    CGFloat memeberHeight = appViewWH + topBottomSpace*2;
//    
//    CellDataAdapter *memberAdapter=[ZFZRoomMembersCell dataAdapterWithCellReuseIdentifier:nil data:roomMemberCellModel cellHeight:memeberHeight type:0];
//    [memberCellData addObject:memberAdapter];
//    
//    
//    [self.items addObject:memberCellData];
    
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
    if ([cell isKindOfClass:[HomePageToolCell class]]) {
        HomePageToolCell *curCell = (HomePageToolCell *)cell;
        curCell .toolCelldelegate = self;
        return curCell;
    }else{
        return cell;
    }
    
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
    if (section == 0) {
        AnnouncementHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"AnnouncementHeaderView"];
        return headView;
    }else{
         return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return  44;
    }else{
        return 0;
    }
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
