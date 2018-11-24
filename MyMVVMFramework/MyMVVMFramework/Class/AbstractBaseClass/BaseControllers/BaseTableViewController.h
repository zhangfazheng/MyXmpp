//
//  BaseTableViewController.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MJRefresh.h"
//#import "UITableView+Placeholder.h"
typedef void (^refresh_action)();//用typedef定义一个block类型

@interface BaseTableViewController : BaseViewController <UITableViewDataSource , UITableViewDelegate>

-(id)initWithStyle:(UITableViewStyle)style;

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,assign)BOOL showSeparator;//是否显示cell分割线
@property(nonatomic,assign)UITableViewStyle tableStyle;//列表样式

@property(nonatomic) BOOL ifrespErr;

@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) UIView *errView;         //错误视图

@property (nonatomic,assign) NSInteger object_count;

@property (nonatomic,assign) BOOL isInit; //是否已经初始化

@property(nonatomic,copy) NSString *errMessage;

@property (nonatomic,assign) BOOL allowRefresh; //是否开启下拉刷新

@property (nonatomic,assign) BOOL allowLoadMaore; //是否开启上拉加载更多

@property (nonatomic,assign) BOOL notEstimatedRowHeight; //是否不启用预估行高

@property (nonatomic,assign) BOOL hidesBottomBar; //是否隐藏底部tabBar

@property (nonatomic,assign) BOOL useHeader; //是否头尾视图

@property (nonatomic,assign) BOOL useForter; //是否头尾视图

@property(nonatomic,strong) MJRefreshAutoNormalFooter *footer;

@property (nonatomic, strong) refresh_action footer_action;

/** 分页需要重载的方法 -- 方法名*/
- (NSString *)method;
/** 分页需要重载的方法 -- 参数*/
- (NSDictionary *)params;
/** 分页需要重载的方法 -- 返回值*/
- (NSArray *)parseResponse:(NSArray *)respDic;

- (void)refresh_data;

- (void)loadMore_data;

- (void)hide_footer;

- (void)show_footer;
/**
 * 增加自定义下啦
 */
- (void)addCustomRefresh:(MJRefreshComponentRefreshingBlock)refreshingBlock;

/**
 * 根据tableView类型创建
 */
- (instancetype)initWithViewModel:(BaseViewModel *)viewModel Style:(UITableViewStyle)style;

/**
 * 自定义上拉加载响应
 */
- (void)set_custom_footer_action:(refresh_action)brock;

- (void)allow_RefreshControl;

/**
 * tableView数据源数据配置
 */
- (void)configureDataSource;
@end
