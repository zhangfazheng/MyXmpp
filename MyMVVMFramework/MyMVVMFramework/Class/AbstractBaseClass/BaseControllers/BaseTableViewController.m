//
//  BaseTableViewController.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()
@property(nonatomic) NSInteger next_page;//下一页
@property(nonatomic) NSInteger list_count;//总页数
@property (nonatomic, strong) UIView *noneView;
@property (nonatomic, strong) BaseViewModel *viewModel;
@end

@implementation BaseTableViewController
@dynamic viewModel;
-(id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.showSeparator = YES;
        self.tableStyle = style;
        self.ifrespErr = NO;
        self.isInit = NO;
    }
    return self;
}

- (instancetype)initWithViewModel:(BaseViewModel *)viewModel Style:(UITableViewStyle)style{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.showSeparator = YES;
        self.tableStyle = style;
        self.ifrespErr = NO;
        self.isInit = NO;
        self.viewModel = viewModel;
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        self.showSeparator = YES;
        self.tableStyle = UITableViewStylePlain;
        self.ifrespErr = NO;
        self.isInit = NO;
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    //开启网络监测
    //self.isListenNet=YES;
    
    //tableView 基本初始化
    if (!self.tableview) {
        //重新设置tableView的frame
        [self setUpTableViewFrame];
        //如果没有禁止预估行高
        if(!self.notEstimatedRowHeight){
            self.tableview.estimatedRowHeight = 44;
            self.tableview.rowHeight = UITableViewAutomaticDimension;
        }
        
        //如果启用头尾视图
        if(self.useHeader){
            self.tableview.estimatedSectionHeaderHeight = 44;
            self.tableview.sectionHeaderHeight = UITableViewAutomaticDimension;
        }
        
        if (self.useForter) {
            self.tableview.estimatedSectionFooterHeight = 44;
            self.tableview.sectionFooterHeight = UITableViewAutomaticDimension;
        }
        
        
        self.tableview.dataSource = self;
        self.tableview.delegate = self;
        self.tableview.backgroundColor =[UIColor whiteColor];
        self.tableview.showsVerticalScrollIndicator = NO;
        self.tableview.showsHorizontalScrollIndicator = NO;
        //禁用tableview的选中按钮
        //self.tableview.allowsSelection=NO;
        //self.tableview.separatorColor = COLOR_BACKGROUND;
        [self.view addSubview:self.tableview];
        /**
         * 去除页面上边距
         */
        self.edgesForExtendedLayout = UIRectEdgeBottom;
        //去除多余分隔线
        [self.tableview setTableFooterView:[UIView new]];
    }
    //不显示cell分割线
    if (!self.showSeparator) {
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        //[self.tableview setSeparatorColor:[UIColor blackColor]];
    }
}

//重新设置tableView的frame
- (void)setUpTableViewFrame{
    CGRect vFrame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    if (self.navigationController) {
        if (self.automaticallyAdjustsScrollViewInsets) {
            vFrame.size.height = ( self.navigationController.navigationBarHidden)?vFrame.size.height:vFrame.size.height-NAVIGATION_BAR_HEIGHT;
        }else{
//            vFrame.size.height = ( self.navigationController.navigationBarHidden)?vFrame.size.height:vFrame.size.height-NAVIGATION_BAR_HEIGHT;
            vFrame.origin.y = -NAVIGATION_BAR_HEIGHT;
        }
        
        if(!self.hidesBottomBarWhenPushed && !self.hidesBottomBar){
            vFrame.size.height = ( (!self.tabBarController) ||self.tabBarController.tabBar.hidden)?vFrame.size.height:vFrame.size.height-TABBAR_HEIGHT;
        }
    }
    
    
    
    self.tableview = [[UITableView alloc] initWithFrame:vFrame style:self.tableStyle];
    //self.tableview = [[UITableView alloc]init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.allowRefresh) {
        [self allow_RefreshControl];
    }
    if (self.allowLoadMaore) {
        [self allow_LoadMaoreControl];
    }
    [self configureDataSource];
}

#pragma mark - TableView Related.

- (void)configureDataSource{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.isInit){
        [self.tableview reloadData];
    }
}

- (void)addCustomRefresh:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
    // 设置文字
    //    [header setTitle:@"下拉可以刷新了" forState:MJRefreshStateIdle];
    //    [header setTitle:@"松开马上刷新了" forState:MJRefreshStatePulling];
    //    [header setTitle:@"刷新中。。。" forState:MJRefreshStateRefreshing];
    //    header.arrowView.image = [UIImage imageNamed:@"ic_refresh"];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    // 设置颜色
    header.stateLabel.textColor = COLOR_TABLE_HEADER;
    // 设置刷新控件
    self.tableview.mj_header = header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)allow_RefreshControl{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh_data)];
    // 设置文字
    [header setBackgroundColor:FlatSkyBlueDark];
    [header setTitle:@"下拉可以刷新了" forState:MJRefreshStateIdle];
    [header setTitle:@"松开马上刷新了" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中。。。" forState:MJRefreshStateRefreshing];
    //    header.arrowView.image = [UIImage imageNamed:@"ic_refresh"];
    //header.lastUpdatedTimeLabel.hidden = YES;
    //header.stateLabel.hidden = YES;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    //header.automaticallyChangeAlpha = YES;
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    // 设置颜色
    header.stateLabel.textColor = COLOR_TABLE_HEADER;
    // 设置刷新控件
    self.tableview.mj_header = header;
}

#pragma mark -- 加载第一页数据 分页需调用
- (void)show_footer
{
    self.next_page = 1;
    self.list_count = 0;
    self.isInit = NO;
    self.listData = [[NSMutableArray alloc] init];
    
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    // 设置文字
    [_footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [_footer setTitle:@"松开加载更多" forState:MJRefreshStatePulling];
    [_footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [_footer setTitle:@"没有更多了哦" forState:MJRefreshStateNoMoreData];
    // 设置字体
    _footer.stateLabel.font = FONT(15);
    // 设置颜色
    _footer.stateLabel.textColor = COLOR_TABLE_HEADER;
    // 设置footer
    self.tableview.mj_footer = _footer;
    
    //self.tableview.needPlaceholder = @(1);
    
    [self getData];
    
}


#pragma mark-上拉加载更多
- (void) allow_LoadMaoreControl{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore_data)];
    // 设置文字
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了哦" forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    // 设置颜色
    footer.stateLabel.textColor = COLOR_TABLE_HEADER;
    // 设置footer
    self.tableview.mj_footer = footer;
}

- (void)loadMore_data{
    // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        
        // 结束刷新
        [self.tableview.mj_footer endRefreshing];
    });
    
}


- (void)refresh_data{
    
//    if(self.isInit){
//        _next_page = 1;
//        if(self.tableview.mj_footer){
//            [self.tableview.mj_footer resetNoMoreData];
//        }
//        [self getData];
//        
//    }
    // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        
        // 结束刷新
        [self.tableview.mj_header endRefreshing];
    });
    
}

////重写tableView键盘弹出时的事件处理方法
//- (void)textFieldOrViewBeginInput:(NSNotification *)sender{
//    if (sender != nil && [sender.object isKindOfClass:[UITextField class]]) {
//        UITextField *textFile = (UITextField *)sender.object;
//        
//        CGRect curTextFieldFrame=[[textFile superview] convertRect:textFile.frame toView:[UIApplication sharedApplication].keyWindow];
//        self.textFiledBottom = CGRectGetMaxY(curTextFieldFrame);
//        
//    }else if ([sender.object isKindOfClass:[UITextView class]]){
//        UITextView *textView = (UITextView *)sender.object;
//        
//        CGRect curTextFieldFrame=[[textView superview] convertRect:textView.frame toView:[UIApplication sharedApplication].keyWindow];
//        self.textFiledBottom = CGRectGetMaxY(curTextFieldFrame);
//    }
//}



/**
 * 获取数据
 */
- (void)getData{
    
    if(_footer_action){
        _footer_action();
    }else{
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        if ([self params]== nil) {
            //传page
            paramDic[@"currPage"] = [NSString stringWithFormat:@"%zd",_next_page];
            paramDic[@"pageSize"] = [NSString stringWithFormat:@"%zd",TABLE_PAGE_SIZE];
        }else{
            //合并(page + params)
            [paramDic setDictionary:[self params]];
            paramDic[@"currPage"] = [NSString stringWithFormat:@"%zd",_next_page];
            paramDic[@"pageSize"] = [NSString stringWithFormat:@"%zd",TABLE_PAGE_SIZE];
            
        }
        /*[ServiceRequest loadWithMethodName:[self method] andHttpMethod:HttpMethodPost andParams:paramDic successed:^(id respDic, NSString *code, NSString *message) {
            if(!_isInit){
                _isInit = YES;
            }
            self.noneView.hidden = YES;
            self.tableview.hidden = NO;
            [self calculateListCount:respDic[@"listInfo"]];
            if(_object_count < 10){
                self.tableview.mj_footer = nil;
            }else{
                if(!self.tableview.mj_footer){
                    
                    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getData)];
                    // 设置文字
                    [_footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
                    [_footer setTitle:@"松开加载更多" forState:MJRefreshStatePulling];
                    [_footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
                    [_footer setTitle:@"没有更多了哦" forState:MJRefreshStateNoMoreData];
                    // 设置字体
                    _footer.stateLabel.font = FONT(15);
                    // 设置颜色
                    _footer.stateLabel.textColor = COLOR_TABLE_HEADER;
                    // 设置footer
                    self.tableview.mj_footer = _footer;
                    
                }
            }
            NSArray * items;
            items = [self parseResponse:respDic[@"list"]];
            //        NSArray * items = [self parseResponse:respDic[@"workorderlist"]];
            if (items && [items count]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(_next_page == 2){
                        _listData = [NSMutableArray array];
                    }
                    _listData = [[_listData arrayByAddingObjectsFromArray:items] mutableCopy];
                    [_tableview reloadData];
                });
            }
            [CustomHud hiddenAllHudAfter:0];
            _ifrespErr = NO;
            
            [self.tableview reloadData];
        } failed:^(id respDic, NSString *code, NSString *message) {
            if(!_isInit){
                _isInit = YES;
            }
            [CustomHud hiddenAllHudAfter:0];
            if(_object_count < 10){
                self.tableview.mj_footer = nil;
            }
            if (self.tableview.mj_footer) {
                if([code isEqualToString:NO_MORE_DATA]){
                    [self.tableview.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableview.mj_footer endRefreshing];
                }
            }
            if (self.tableview.mj_header) {
                [self.tableview.mj_header endRefreshing];
            }
            
            _ifrespErr = YES;
            if ([code isEqualToString:NO_INTERNET_ERR_CODE]){
                self.object_count = 0;
                self.list_count = 0;
                self.next_page = 1;
                self.tableview.hidden = YES;
                [self.view addSubview:self.noneView];
                self.noneView.hidden = NO;
                
            }
            [_tableview reloadData];
        }];*/
    }
}

- (void)turnToPromptPage{
    //NetBrokenViewController *brokenVC = [[NetBrokenViewController alloc] init];
    //[self.navigationController pushViewController:brokenVC animated:YES];
}

- (void)hide_footer{
    if(self.tableview.mj_footer){
        self.tableview.mj_footer = nil;
    }
}

//重新刷新页面
- (void)resetLoad{
    [self getData];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - tableview datasource && tableview delegate
//常规表格的数据和委托

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 0.5;
//    
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 8;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 8;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * LOAD_MORE_CELL = @"LOAD_MORE_CELL_IDENTIFITY";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:LOAD_MORE_CELL];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LOAD_MORE_CELL];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableview) {
        if (_next_page -1 < _list_count && nil != self.method && _object_count > 0) {
            if (indexPath.section == self.listData.count - 1 || indexPath.row ==self.listData.count - 1) {
                [self getData];
            }
        }
    }
}

//计算总个数
- (void)calculateListCount:(NSDictionary *)respDic{
    
    _list_count = [respDic[@"pageNum"] integerValue];
    _next_page = [respDic[@"currPage"] integerValue] + 1;
    _object_count = [respDic[@"recordNum"] integerValue];
    
    if (_next_page > _list_count) {
        if (self.tableview.mj_footer) {
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.tableview.mj_header) {
            [self.tableview.mj_header endRefreshing];
        }
    }else if(_object_count == 0){
        [self hide_footer];
    }else{
        if (self.tableview.mj_footer) {
            [self.tableview.mj_footer endRefreshing];
        }
        if (self.tableview.mj_header) {
            [self.tableview.mj_header endRefreshing];
        }
    }
}

#pragma mark - 当状态栏变化时执行更新frame
//- (void)setNeedsStatusBarAppearanceUpdate{
//    if (self.tableview) {
//        //重新设置tableView的frame
//        [self setUpTableViewFrame];
//    }
//}

#pragma mark - 基本方法(需要分页的页面 重写)

- (NSString *)method{
    return nil;
}

- (NSDictionary *)params{
    return nil;
}

//解析返回的数据
- (NSArray *)parseResponse:(NSArray *)respDic
{
    return nil;
}

- (void)set_custom_footer_action:(refresh_action)brock{
    self.footer_action = brock;
}

@end
