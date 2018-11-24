//
//  EquipmentDetailsViewController.m
//  OperationEquipment
//
//  Created by 张发政 on 2017/2/21.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "EquipmentDetailsViewController.h"
#import "UITableView+CellClass.h"
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
#import "EquipmentsModel.h"
#import "TileCellModel.h"
#import "SubmitCell.h"
#import "EquipmentTextCell.h"
#import "EquipmentTextFieldCell.h"
#import "TestViewModel.h"


@interface EquipmentDetailsViewController ()<EpcEditCellDelegate,SubmitCellDelegate,RHTableViewAdapterDelegate,UIGestureRecognizerDelegate>
{
    BOOL plugged;
    CFURLRef		soundFileURLRef;
    SystemSoundID	soundFileObject;
    int prev_battery;
    RHTableView *_epcTableView;
    RHTableViewAdapter *_tableAdapter;
}

@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * items;
@property (nonatomic,strong) NSMutableArray *curEpcList;
@property (nonatomic,strong) UIView  *cover;
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) TestViewModel *viewModel;
@property (nonatomic, strong) UIBarButtonItem *composeBont;

@end

@implementation EquipmentDetailsViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];

    //self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
    [self configureDataSource];
    //添加监听
    [self creatTableView];
}



#pragma mark - TableView Related.

- (void)configureDataSource{
//    self.tableview.estimatedRowHeight=100;
//    self.tableview.rowHeight=UITableViewAutomaticDimension;

    [self.view setBackgroundColor:[UIColor grayColor]];
    
    [self.tableview registerCellsClass:@[cellClass(@"EquipmentTextCell", nil),cellClass(@"EquipmentTextFieldCell", nil),cellClass(@"EpcEditCell", nil),cellClass(@"SubmitCell", nil),cellClass(@"EquipmentPatternSelectCell", nil)]];

}


- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self)
//    [[[RACObserve(self.viewModel, items)
//     distinctUntilChanged]
//    deliverOnMainThread]
//subscribeNext:^(id x) {
//    
//    self.items = x;
//    [self.tableview reloadData];
//    
//}];
    
    [[[RACObserve(self.viewModel, isEidtModel)distinctUntilChanged]deliverOnMainThread]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x boolValue]) {
            [self.composeBont setTitle:@"查看模式"];
        }else{
            [self.composeBont setTitle:@"编辑模式"];
        }

    }];
    
    self.composeBont.rac_command = self.viewModel.itemsDataCommand;
    
    
    [[self.viewModel.itemsDataCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.items = (NSMutableArray<CellDataAdapter *> *)x;
        [self.tableview reloadData];
    }];
    
//    [[[self.viewModel.itemsDataCommand executionSignals]switchToLatest]subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        self.items = (NSMutableArray<CellDataAdapter *> *)x;
//        [self.tableview reloadData];
//    }];
    [self.viewModel.itemsDataCommand execute:@1];
    
    
}


- (void)setup{
    [super setup];
    self.managerStyle = ManagerEditStyle;
    
    self.tableview.estimatedSectionFooterHeight = 44;
    self.tableview.sectionFooterHeight = UITableViewAutomaticDimension;
    
    [self addrightButton];
}


//添加编辑/查看切换右按钮
- (void)addrightButton{
    _composeBont    = [[UIBarButtonItem alloc]initWithTitle:@"编辑模式" style:UIBarButtonItemStyleDone target:self action:nil];
    _composeBont.tintColor           =        [UIColor blackColor];
    
    [self.navigationItem setRightBarButtonItem:_composeBont];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //如果是编辑模式
    if (self.managerStyle == ManagerEditStyle) {
        return  2;
    }else{
        return  1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return  self.items.count;
    }else{
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell=[tableView dequeueAndLoadContentReusableCellFromAdapter:_items[indexPath.row] indexPath:indexPath controller:self];
//    if ([_items[indexPath.row] isKindOfClass: [EpcEditCellModel class]]) {
//        EpcEditCell *epcCell=(EpcEditCell *)cell;
//        epcCell.scavDelegate = self;
//        
//        return epcCell;
//    }else{
//        return cell;
//    }
    if (indexPath.section==1) {
        CellDataAdapter  *submitCellAdapter=[SubmitCell dataAdapterWithCellReuseIdentifier:nil data:nil cellHeight:100 type:0];
        SubmitCell *cell = (SubmitCell *)[tableView dequeueAndLoadContentReusableCellFromAdapter:submitCellAdapter indexPath:indexPath controller:self];
        cell.submitDelegate = self;
        return cell;
    }else{
        return [tableView dequeueAndLoadContentReusableCellFromAdapter:_items[indexPath.row] indexPath:indexPath controller:self];
    }
    
    
}


#pragma mark-点击提交时的代理方法
- (void)submitButtonAction{
    NSLog(@"确认提交");
}

#pragma mark 读写RFID的代理方法
- (void)epcReceived:(NSData *)epc{
    dispatch_async(dispatch_get_main_queue(),^{
        
        NSMutableString* tag = [[NSMutableString alloc] init];
        unsigned char* ptr= (unsigned char*) [epc bytes];
        
        for(int i = 0; i < epc.length; i++) {
            [tag appendFormat:@"%02X", *ptr++ & 0xFF ];
        }
        
        //创建扫描到的epc列表
        //[self creatTableView];
        
        EpcEditCellModel *item0=[[EpcEditCellModel alloc]init];
        item0.epcId=tag;
        item0.scavDelegate=self;
        
        [MBProgressHUD showNoImageMessage:tag];
        
        [self.items replaceObjectAtIndex:0 withObject:[EpcEditCell dataAdapterWithCellReuseIdentifier:nil data:item0 cellHeight:100 type:0]];
        
        [self.tableview reloadData];
        
        //[self stopRead];
    });
}

//创建一个扫描器材展示列表
- (void)creatTableView{
    //普通table view
    _epcTableView                  = [[RHTableView alloc] init];
    _epcTableView.frame            = CGRectMake(25, 60, ScreenWidth-50, ScreenHeight-NAVIGATION_BAR_HEIGHT - 120);
    _epcTableView.backgroundColor  = [UIColor whiteColor];
    _epcTableView.hidden           = YES;
    [self.view addSubview:self.cover];
    
    //注册cell
    [_epcTableView registerCellsClass:@[cellClass(@"EPCInfoListCell", nil),cellClass(@"EPCNoInfoListCell", nil)]];
    
    _tableAdapter = [[RHTableViewAdapter alloc] init];
    _tableAdapter.delegate = self;
    
    
    [_epcTableView setTableViewAdapter:_tableAdapter];
    
}

//普通table view
- (void)refreshNormalTableView:(NSArray *)dataList
{
    [_tableAdapter.dataArray removeAllObjects];
    [_tableAdapter.dataArray addObjectsFromArray:dataList];
    [_epcTableView reloadData];
}


//展示一个EPC编码
- (void)creatEpcLable:(NSString *)epcId{
    RHTableViewCellModel *model = [[RHTableViewCellModel alloc] init];
    
    //如果epc有对应的器材
//    if(epcId){
//        
//    }
    
    //epc有对应的器材
    EquipmentsModel *infoListCellModel  = [EquipmentsModel new];
    infoListCellModel.epcId             = epcId;
    infoListCellModel.name              = @"手术刀（1型）";
    
    model.cellData                      = infoListCellModel;
    [model setHeightForRowBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath, id cellData) {
        return 50.0f;
    }];
    [model setCellForRowBlock:^RHTableViewCell *(UITableView *tableView, NSIndexPath *indexPath, id cellData) {
//        EPCInfoListCell *cell = [EPCInfoListCell tableView:tableView reusedCellOfClass:[EPCInfoListCell class]];
        EPCInfoListCell *cell = [EPCInfoListCell tableView:tableView reusedCellOfType:0];
        [cell updateViewWithData:cellData];
        return cell;
    }];
    [model setCellForSelectBlock:^(UITableView *tableView, NSIndexPath *indexPath, id cellData) {
        //NSLog(@"setCellForSelectBlock: %@", cellData);
    }];
    [self.curEpcList addObject:model];
    
    [self refreshNormalTableView:self.curEpcList];
}

//- (void)pcEpcRssiReceived:(NSData *)pcEpc rssi:(int8_t)rssi{
//    dispatch_async(dispatch_get_main_queue(),^{
//        //        AudioServicesPlaySystemSound (soundFileObject);
//        
//        NSMutableString* tag = [[NSMutableString alloc] init];
//        unsigned char* ptr= (unsigned char*) [pcEpc bytes];
//        
//        for(int i = 0; i < pcEpc.length; i++) {
//            [tag appendFormat:@"%02X", *ptr++ & 0xFF ];
//        }
//        
//        [self.items replaceObjectAtIndex:0 withObject:[EpcEditCell dataAdapterWithCellReuseIdentifier:nil data:tag cellHeight:100 type:0]];
//        
//        [self.tableview reloadData];
//    });
//}






#pragma  mark-点击扫描时的代理 方法
- (void)scanEpcAction{
//    if ([self.rcpRfid isOpened]) {
//        [self startRead];
//        
//        
//        //三秒后关闭扫描
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self stopRead];
//        });
//        
//    }else{
//        [MBProgressHUD showNoImageMessage:@"请确认读卡器是否已经接好"];
//    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform =CGAffineTransformMakeScale(0.95, 0.95);
    }];
    self.cover.hidden = !self.cover.hidden;
    
    _epcTableView.hidden = self.cover.hidden;
    [self creatEpcLable:@"104786A394389BF090D09C00C776F6E8"];
    [self creatEpcLable:@"1047865664389767BF456A456D76F6E8"];
}

#pragma mark-弹出EpctableView的代理方法
- (void)didTableViewSelectIndexPath:(NSIndexPath *)indexPath{
    WeakSelf
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.view.transform = CGAffineTransformIdentity;
        weakSelf.cover.hidden = YES;
    }];
    
    EpcEditCellModel *item0         =[[EpcEditCellModel alloc]init];
    RHTableViewCellModel *curModel  = self.curEpcList[indexPath.row];
    EquipmentsModel *curEpc         = curModel.cellData;
    item0.epcId                     = curEpc.epcId;
    item0.scavDelegate              = self;
 
    
    [self.items replaceObjectAtIndex:0 withObject:[EpcEditCell dataAdapterWithCellReuseIdentifier:nil data:item0 cellHeight:100 type:0]];
    
    [self.tableview reloadData];
}

- (void)didTableViewCellSelect:(id)cellData{
    
}

#pragma mark-懒加载
- (NSMutableArray *)curEpcList{
    if (!_curEpcList) {
        _curEpcList = [NSMutableArray array];
    }
    return _curEpcList;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_epcTableView.frame, point)){
        return NO;
    }
    return YES;
}


- (void)tapCover:(UITapGestureRecognizer *)tap{
    
    self.view.transform = CGAffineTransformIdentity;
    self.cover.hidden = YES;
}



- (UIView *)cover{
    
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_cover addSubview:_epcTableView];

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
        _cover.hidden = YES;
    }
    return _cover;
}



@end



