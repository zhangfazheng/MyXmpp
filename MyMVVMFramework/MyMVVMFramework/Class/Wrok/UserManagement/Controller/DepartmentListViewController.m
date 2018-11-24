//
//  DepartmentListViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/12/18.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "DepartmentListViewController.h"
#import "DepartmentManageViewModel.h"
#import "UITableView+CellClass.h"
#import "DepartmentTitleLable.h"
#import "DepartmentModel.h"
#import "DepartmentSelectTableViewCell.h"

@interface DepartmentListViewController ()
@property (nonatomic, strong) UIScrollView *titleScrollView;

@property (nonatomic, strong) UIView *searchHeadView;
/** 部门数据 */
@property (nonatomic, strong) NSArray<NSArray<CellDataAdapter *> *> *dataArray;

/** 所以标题宽度数组 */
@property (nonatomic, strong) NSMutableArray *titleWidths;
/** 标题总长 */
@property (nonatomic, assign) CGFloat totalWidth;

/** 计算上一次选中角标 */
@property (nonatomic, assign) NSInteger selIndex;
/** 所以标题数组 */
@property (nonatomic, strong) NSMutableArray *titleLabels;
//返回按钮
@property (nonatomic)UIBarButtonItem* customBackBarItem;
//关闭按钮
@property (nonatomic)UIBarButtonItem* closeButtonItem;

@property (strong, nonatomic, readonly) DepartmentManageViewModel *viewModel;

@end


static NSString *const CellIdentifier = @"WEICHAT_ID";
static CGFloat titleHeight = 44;
@implementation DepartmentListViewController
@dynamic viewModel;

- (void)loadView{
    self.showSeparator = YES;
    [super loadView];
}

- (instancetype)initWithdataAdapterName:(NSArray *) dataAdapterNameArray data:(NSArray *)data{
    if (self = [super init]) {
        self.titles             = [dataAdapterNameArray mutableCopy];
        self.dataArray          = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setup{
    [super setup];
    [self.tableview setTableHeaderView:self.titleScrollView];
    [self setUpTitle];
    [self.tableview registerCellsClass:@[cellClass(@"DepartmentSelectTableViewCell", nil)]];
    
    //添加关闭按钮
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -6.5;
    [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.customBackBarItem,self.closeButtonItem]];
}

- (void)closeItemClicked{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)customBackItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bindViewModel{
    [super bindViewModel];
    if (self.viewModel) {
        WeakSelf
        [[[self.viewModel.requestDataCommand executionSignals]switchToLatest]subscribeNext:^(NSArray * x) {
            weakSelf.dataArray = x;
            [weakSelf.tableview reloadData];
        }];
        
        [self.viewModel.requestDataCommand execute:nil];
    }
    
}

#pragma mark - 添加标题方法
// 计算所有标题宽度
- (void)setUpTitle{
    // 遍历所有的子控制器
    NSUInteger count = _titles.count;
    // 计算所有标题的宽度
    for (int i = 0; i < count; i++) {
        
        if (!isEmptyString(_titles[i])) {
            CGRect titleBounds = [_titles[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Font_Large_Text} context:nil];
            
            CGFloat width = titleBounds.size.width;
            
            [self.titleWidths addObject:@(width)];
            
            _totalWidth += width;
            // 添加所有的标题
            CGFloat labelW = 0;
            CGFloat labelH = titleHeight;
            CGFloat labelX = 0;
            CGFloat labelY = 0;
            CGFloat leftMargin = 8;
            CGFloat rightLableWith = 12;
            
            UILabel *label = [[DepartmentTitleLable alloc] init];
            
            
            label.tag = i+1;
            
            // 设置按钮的文字颜色
            if (i == count-1) {
                label.textColor = FlatGray;
            }else{
                label.textColor = FlatSkyBlue;
                label.userInteractionEnabled = YES;
            }
            
            
            label.font = Font_Large_Text;
            
            // 设置按钮标题
            label.text = _titles[i];
            
            labelW = width;
            
            // 设置按钮位置
            UILabel *lastLabel = [self.titleLabels lastObject];
            
            if (!lastLabel) {
                labelX = leftMargin;
            }else{
                //添加箭头
                UIImageView *rowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_rigth_icon"]];
                rowImageView.frame = CGRectMake(CGRectGetMaxX(lastLabel.frame)+8, (titleHeight-rightLableWith)/2, 8, rightLableWith);
                [self.titleScrollView addSubview:rowImageView];
                labelX = CGRectGetMaxX(rowImageView.frame)+8;
            }
            
            label.frame = CGRectMake(labelX, labelY, labelW, labelH);
            
            // 监听标题的点击
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
            [label addGestureRecognizer:tap];
            // 保存到数组
            [self.titleLabels addObject:label];
            
            [self.titleScrollView addSubview:label];
            
            //            if (i == _selectIndex) {
            //                [self titleClick:tap];
            //            }
        }
    }
    UILabel *lastLabel = self.titleLabels.lastObject;
    _titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame), 0);
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    //滚动到最后一个
    //    CGFloat scrollx = CGRectGetMaxX(lastLabel.frame)-_titleScrollView.width;
    //    [_titleScrollView scrollRectToVisible:CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, _titleScrollView.width, _titleScrollView.height) animated:YES];
}


// 设置所有标题
- (void)setUpAllTitleWithTitle:(NSString *)title Width:(CGFloat)width index:(NSInteger) i
{
    
    
    
}

// 标题按钮点击
- (void)titleClick:(UITapGestureRecognizer *)tap
{
    // 获取对应标题label
    UILabel *label = (UILabel *)tap.view;
    
    // 获取当前角标
    NSInteger i = label.tag;
    
    
    // 添加控制器
    UIViewController *vc = self.navigationController.childViewControllers[i];
    [self.navigationController popToViewController:vc animated:YES];
    
    _selIndex = i;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DepartmentSelectTableViewCell *cell = (DepartmentSelectTableViewCell *)[tableView dequeueAndLoadContentReusableCellFromAdapter:self.dataArray[indexPath.section][indexPath.row] indexPath:indexPath controller:self];
    WeakSelf
    [cell.openDataSignal subscribeNext:^(UIButton * x) {
        NSInteger row = x.tag;
        if (row < 1000) {
            return;
        }
        DepartmentModel *curDepat = (DepartmentModel *)weakSelf.dataArray[indexPath.section][row-1000].data;
        //如果部门中有成员
        if (curDepat.childCount>0) {
            //创建新的部门列表
            NSMutableArray *curTitleArry = [NSMutableArray arrayWithArray:weakSelf.titles];
            [curTitleArry addObject:curDepat.deptName];
            NSArray<NSArray<CellDataAdapter *> *>*curDepatArry = [DepartmentManageViewModel configAdapter:curDepat];
            DepartmentListViewController *depatVc =[[DepartmentListViewController alloc]initWithdataAdapterName:curTitleArry  data:curDepatArry];
            
            [self.navigationController pushViewController:depatVc animated:YES];
        }
        
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果是部门
    if([self.dataArray[indexPath.section][indexPath.row].data isKindOfClass:[DepartmentModel class]]){
        DepartmentModel *curDepat = (DepartmentModel *)self.dataArray[indexPath.section][indexPath.row].data;
    }
    
    
}


// 懒加载标题滚动视图
- (UIScrollView *)titleScrollView
{
    if (_titleScrollView == nil) {
        
        UIScrollView *titleScrollView = [[UIScrollView alloc] init];
        
        titleScrollView.backgroundColor = [UIColor whiteColor];
        
        titleScrollView.frame = CGRectMake(0,0, ScreenWidth, 44);
        
        _titleScrollView = titleScrollView;
        
    }
    return _titleScrollView;
}

- (NSArray<NSArray<CellDataAdapter *> *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)titleLabels{
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray arrayWithCapacity:self.titles.count];
    }
    return _titleLabels;
}

- (NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (NSMutableArray *)titleWidths{
    if (!_titleWidths) {
        _titleWidths = [NSMutableArray arrayWithCapacity:self.titles.count];
    }
    return _titleWidths;
}

-(UIBarButtonItem*)customBackBarItem{
    if (!_customBackBarItem) {
        UIImage* backItemImage = [[UIImage imageNamed:@"navigationButtonReturn"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImage* backItemHlImage = [[UIImage imageNamed:@"navigationButtonReturnClick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIButton* backButton = [[UIButton alloc] init];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        
        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _customBackBarItem;
}

-(UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}

- (UIView *)searchHeadView{
    if (!_searchHeadView) {
        _searchHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        [_searchHeadView addSubview:self.view];
        self.titleScrollView.frame = CGRectMake(0,0, ScreenWidth, 44);
        [_searchHeadView addSubview:self.titleScrollView];
    }
    return _searchHeadView;
}

@end