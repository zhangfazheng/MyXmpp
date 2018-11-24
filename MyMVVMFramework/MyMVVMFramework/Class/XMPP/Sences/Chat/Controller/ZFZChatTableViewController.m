//
//  ZFZChatTableViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/15.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZChatTableViewController.h"
#import "UITableView+CellClass.h"
#import "ZFZMessageCell.h"
#import "ZFZChatViewModel.h"
#import "ZFZMessageCell.h"
#import "ExpressionKeyboard.h"
#import "ZFZRoomManager.h"
#import "XMPPConfig.h"
#import "ZFZRoomManageViewController.h"
#import "ZFZRoomManageViewModel.h"
#import "UIView+Frame.h"
#import "ReadeStatusViewController.h"

@interface ZFZChatTableViewController ()<ZFZMessageCellReadeStatusDelegate>
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * items;

@property (strong, nonatomic) ZFZChatViewModel *viewModel;
//表情键盘
@property (nonatomic, weak) ExpressionKeyboard *keyboard;
//当前消息条数
@property (nonatomic, assign) NSInteger messageCount;
//@property (nonatomic,strong) NSMutableArray <NSIndexPath *> *updateIndexPaths;

@end

@implementation ZFZChatTableViewController
//@dynamic告诉编译器,属性的setter与getter方法由用户自己实现，不自动生成
@dynamic viewModel;

//全局聊天界面
//static ZFZChatTableViewController *shardChatTableViewController;

- (void)viewDidLoad {
    //关闭预估行高
    self.notEstimatedRowHeight =YES;
    //开启下拉加载更多
    self.allowRefresh = YES;
    [super viewDidLoad];
    
}


//+ (instancetype)sharedChatTableViewControllerWithServices:(id)services params:(NSDictionary *)patern chatType:(ZFZChatType) chatType{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        ZFZChatViewModel * viewModel = [[ZFZChatViewModel alloc]initWithServices:nil params:patern];
//        viewModel.chatType = chatType;
//        shardChatTableViewController = [[ZFZChatTableViewController alloc]init];
//    });
//    
//    return shardChatTableViewController;
//}

- (void)setup{
    [super setup];
    
    //开启自动消息回执
    //[ZFZXMPPManager sharedManager].messageDeliveryReceipts.autoSendMessageDeliveryReceipts = YES;
    
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0" withAlpha:1];
    
    [self.view addSubview:self.keyboard];
    
    [self.tableview registerCellsClass:@[cellClass(@"ZFZMessageCell", nil)]];
    // 1.获取最近联系人的数据
    // 1.1执行请求
    // 设置代理
    //[[ZFZXMPPManager sharedManager].xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //如果是群聊添加群聊管理按钮
    if(self.viewModel.chatType == ZFZChatGroup){
        //添加好友到群聊天
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushToAddMUCChat)];
        [self.navigationItem setRightBarButtonItem:addItem];
    }
    //添加隐藏键盘的事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyBoardHidden)];
    [self.tableview addGestureRecognizer:tap];
}

//隐藏键盘
- (void)keyBoardHidden{
    [self.keyboard endEditing];
}

//当页面消失时收起键盘
- (void)viewWillDisappear:(BOOL)animated{
    [self.keyboard endEditing];
    [super viewWillDisappear:animated];
    //关闭自动消息回执
    //[ZFZXMPPManager sharedManager].messageDeliveryReceipts.autoSendMessageDeliveryReceipts = NO;
}

- (void)pushToAddMUCChat{
    XMPPJID *roomjid = self.viewModel.userJid;
//    [[ZFZRoomManager shareInstance] JoinOrCreateRoomWithRoomJID:roomjid andNickName:@"李四"];
    //XMPPRoom *curRoom = [ZFZRoomManager shareInstance].RoomDict[roomjid.bare];
    
    //XMPPJID *userjid = [XMPPJID jidWithUser:@"zhangsan" domain:kDomin resource:nil];
//    [curRoom inviteUser:[XMPPJID jidWithUser:@"zhangsan" domain:kDomin resource:nil] withMessage:@"我来找你了"];
    NSDictionary *params = @{ROOMJID:roomjid};
    
    ZFZRoomManageViewModel *roomViewModel = [[ZFZRoomManageViewModel alloc]initWithServices:nil params:params];
    ZFZRoomManageViewController *roomManageVc = [[ZFZRoomManageViewController alloc]initWithViewModel:roomViewModel];
    
    [self.navigationController pushViewController:roomManageVc animated:YES];
}



- (void)bindViewModel{
    [super bindViewModel];
    

    self.items = self.viewModel.items;
    self.messageCount = self.items.count;
    //@weakify(self)
    WeakSelf
     [[[self.viewModel.loadMessageCommand executionSignals]switchToLatest]subscribeNext:^(id  _Nullable x) {
         if (x) {
             NSMutableArray * messageArry = [(NSArray<CellDataAdapter *> *)x mutableCopy];
             if (messageArry.count>0) {
//                 @strongify(self)
                 
                 //更新当前消息条数
                 weakSelf.messageCount += messageArry.count;
                 
                 NSRange range = NSMakeRange(0, [messageArry count]);
                 NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                 [weakSelf.items insertObjects:x atIndexes:indexSet];
                 
                 
                 //如果当前是正在刷新的状态
                 if (weakSelf.tableview.mj_header.state == MJRefreshStateRefreshing) {
                     [weakSelf.tableview.mj_header endRefreshing];
                     NSMutableArray< NSIndexPath *> *indexPathArry = [NSMutableArray arrayWithCapacity:messageArry.count];
                     for (NSInteger i=0;i<messageArry.count;i++) {
                         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                         [indexPathArry addObject:indexPath];
                     }
                     [weakSelf.tableview reloadData];
//                     [weakSelf.tableview insertRowsAtIndexPaths:indexPathArry withRowAnimation:UITableViewRowAnimationNone];
                     
                     //滚动到第10 条数据
                     NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:messageArry.count-1 inSection:0];
                     //设置滚动范围
                     CGRect curRect = [weakSelf.tableview rectForRowAtIndexPath:lastIndexPath];
                     
                     CGRect visibleRect = CGRectMake(0, curRect.origin.y+curRect.size.height, weakSelf.tableview.size.width,weakSelf.tableview.size.height);
                     
                     [weakSelf.tableview scrollRectToVisible:visibleRect animated:NO];
                     
                     
                 }else{
                     //如果不是下拉加载的数据，而是首次加载的数据，则不为空就加载数据并滚动到最后一条
                     [weakSelf.tableview reloadData];
                     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(weakSelf.items.count-1) inSection:0];
                     //滚动下最后一条
                     [weakSelf.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                     
                 }
             }else{
                 NSLog(@"已经无更多消息");
                 [weakSelf.tableview.mj_header endRefreshing];
             }
         }else{
             NSLog(@"未收到消息");
             [weakSelf.tableview.mj_header endRefreshing];
         }
         
         
     }];
    
    [[[self.viewModel.updateMessageCommand executionSignals]switchToLatest] subscribeNext:^(id  _Nullable x) {
        if (x) {
            NSMutableArray * messageArry = [(NSArray<CellDataAdapter *> *)x mutableCopy];
            if (messageArry.count>0) {
                //@strongify(self)
                weakSelf.items = messageArry;
                
                weakSelf.messageCount = weakSelf.items.count;
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(weakSelf.items.count-1) inSection:0];
                
                [weakSelf.tableview reloadData];
                
                [weakSelf.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        
    }];
    
    //接收到消息时插入并更新消息列表
    [[[self.viewModel.receiveMessageCommand executionSignals] switchToLatest] subscribeNext:^(CellDataAdapter * x) {
        if (x) {
//            ZFZMessageFrame *tagMessage = (ZFZMessageFrame *)x.data;
//            NSString *tagElementId = tagMessage.message.elementId;
//            //遍历数据源，找到改变的条目
//            ZFZMessageFrame *curMessage = (ZFZMessageFrame *)[weakSelf.items lastObject].data;
//            NSString *curElementId = curMessage.message.elementId;
//            if ([curElementId isEqualToString:tagElementId]) return ;
            
            
            ///////////////////
            [weakSelf.items addObject:x];
            weakSelf.messageCount ++;
            
            if (weakSelf.items.count>2) {
                NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:(weakSelf.items.count-1) inSection:0];
                NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:(weakSelf.items.count-2) inSection:0];
                
                weakSelf.tableview.hidden = YES;
                [weakSelf.tableview reloadData];
                // 动画之前先滚动到倒数第二个消息
                [weakSelf.tableview scrollToRowAtIndexPath:indexPath2 atScrollPosition:UITableViewScrollPositionNone animated:NO];
                
                // 添加向上顶出最后一个消息的动画
                [weakSelf.tableview scrollToRowAtIndexPath:indexPath1 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                weakSelf.tableview.hidden = NO;
                
            }else{
                [weakSelf.tableview reloadData];
            }

            
        }
        
        
        
    }];
    
    
    //消息回执状态改变时的信号
//    [[[self.viewModel.messageDeliveryCommand executionSignals]switchToLatest] subscribeNext:^(CellDataAdapter * x) {
//        if (x) {
//            ZFZMessageFrame *tagMessage = (ZFZMessageFrame *)x.data;
//            NSString *tagElementId = tagMessage.message.elementId;
//            //遍历数据源，找到改变的条目
//            for (NSInteger i = weakSelf.items.count-1;i>0;i--) {
//                ZFZMessageFrame *curMessage = (ZFZMessageFrame *)weakSelf.items[i].data;
//                NSString *curElementId = curMessage.message.elementId;
//                if ([curElementId isEqualToString:tagElementId]) {
//                    [weakSelf.items replaceObjectAtIndex:i withObject:x];
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                    [weakSelf.updateIndexPaths addObject:indexPath];
//                    NSLog(@"当前更新行：%zd",indexPath.row);
//
//                    //为了使动画效果更流畅，延时2秒刷新数据
//                    [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(messageDeliveryReladData:) object:weakSelf.updateIndexPaths];
//
//                    [weakSelf performSelector:@selector(messageDeliveryReladData:) withObject:weakSelf.updateIndexPaths afterDelay:2];
//
//                    break;
//                }
//            }
//        }
//
//    }];
    
    [self.viewModel.messageDeliverySubject subscribeNext:^(CellDataAdapter * x) {
        if (x) {
            ZFZMessageFrame *tagMessage = (ZFZMessageFrame *)x.data;
            NSString *tagElementId = tagMessage.message.elementId;
            //遍历数据源，找到改变的条目
            for (NSInteger i = weakSelf.items.count-1;i>0;i--) {
                ZFZMessageFrame *curMessage = (ZFZMessageFrame *)weakSelf.items[i].data;
                NSString *curElementId = curMessage.message.elementId;
                if ([curElementId isEqualToString:tagElementId]) {
                    [weakSelf.items replaceObjectAtIndex:i withObject:x];
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                    [weakSelf.updateIndexPaths addObject:indexPath];
//                    NSLog(@"当前更新行：%zd",indexPath.row);
                    
                    //为了使动画效果更流畅，延时2秒刷新数据
                    [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(messageDeliveryReladData) object:nil];
                    
                    [weakSelf performSelector:@selector(messageDeliveryReladData) withObject:nil afterDelay:2];
                    
                    break;
                }
            }
        }
    }];

    [self.viewModel.loadMessageCommand execute:@1];
}

- (void)messageDeliveryReladData{
    [self.tableview reloadData];
    //[self.tableview reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//    NSLog(@"执行刷新：%zd",indexPaths.count);
//    [self.updateIndexPaths removeAllObjects];
}

#pragma pmark-下拉加载数据的方法
- (void)refresh_data{
    // 发送消息加载数据
    //NSInteger curMessageCount = self.messageCount;
    [self.viewModel.loadMessageCommand execute:@(self.messageCount)];
}

#pragma mark ----------UITabelViewDataSource----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.items count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZFZMessageCell *cell = (ZFZMessageCell *)[tableView dequeueAndLoadContentReusableCellFromAdapter:_items[indexPath.row] indexPath:indexPath controller:self];
    cell.readeStatusDelegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark ----------UITabelViewDelegate----------


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFZMessageFrame * frame  = (ZFZMessageFrame *)_items[indexPath.row].data;
    if (frame) {
        //NSLog(@"%f", frame.cellHeight);
        return frame.cellHeight;
    }else{
        return 0;
    }
    
}

#pragma mark - Action
- (void)onRight:(UIButton*)sender{
    //ExpressionViewController *vc = [ExpressionViewController new];
    //[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - @protocol UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //[_keyboard endEditing];
    //[self.keyboard.expressionKeyboardDismisSubject sendNext:nil];
}


#pragma mark - @protocol YHExpressionKeyboardDelegate
- (void)didSelectExtraItem:(NSString *)itemName{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:itemName message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)sendBtnDidTap:(NSString *)text{
    NSLog(@"最新的发送信息");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载

- (NSMutableArray<CellDataAdapter *> *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (ExpressionKeyboard *)keyboard{
    
    if (!_keyboard) {
        //表情键盘
        ExpressionKeyboard *board = [ExpressionKeyboard shardExpressionKeyboardWithViewController:self aboveView:self.tableview];
//        ExpressionKeyboard *board = [[ExpressionKeyboard alloc] initWithViewController:self aboveView:self.tableview];
        
        //设置信号处理方法，来发送信息
        //@weakify(self)
        
        
        
        _keyboard = board;
        WeakSelf
        //_keyboard是单例，不会被销毁，所以当退出时取消订阅，避免重复订阅
        RACSignal *newSigal = [_keyboard.sendMessageSignal takeUntil:weakSelf.rac_willDeallocSignal];
        [newSigal subscribeNext:^(id  _Nullable x) {
            //@strongify(self)
            if (isEmptyString(board.sendMessageString)) {
                return ;
            }
            //            [self.viewModel.sendMessageSubject sendNext:board.sendMessageString];
            [weakSelf.viewModel.sendMessageCommand execute:board.sendMessageString];
            //NSLog(@"发送信号:%@",board.sendMessageString);
            [board clearMessage];
            
        }];
        
        [_keyboard.returnSendMessageSubject subscribeNext:^(id  _Nullable x) {
            //@strongify(self)
            //            [self.viewModel.sendMessageSubject sendNext:board.sendMessageString];
            [weakSelf.viewModel.sendMessageCommand execute:board.sendMessageString];
            //NSLog(@"发送信号:%@",board.sendMessageString);
        }];
    }
    return _keyboard;
}

#pragma mark- 消息状态查看代理方法
- (void)searchReadeStatus:(NSArray *)readerMemberArray{
    //跳转到已消息读取情况视图
    ReadeStatusViewController *vc = [[ReadeStatusViewController alloc]init];
    vc.curRoom = self.viewModel.curRoom;
    vc.readerStatusArray = readerMemberArray;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc{
    [self.keyboard.returnSendMessageSubject sendCompleted];
    [self.viewModel.messageDeliverySubject sendCompleted];
}

//- (NSMutableArray<NSIndexPath *> *)updateIndexPaths{
//    if (!_updateIndexPaths) {
//        _updateIndexPaths = [NSMutableArray array];
//    }
//    return _updateIndexPaths;
//}

@end
