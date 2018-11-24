//
//  ZFZRoomListViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/8.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRoomListViewController.h"
#import "ZFZRoomListViewModel.h"
#import "UITableView+CellClass.h"
#import "ZFZRoomInfoCell.h"
#import "ZFZChatTableViewController.h"
#import "ZFZChatViewModel.h"
#import "ZFZRoomManager.h"

@interface ZFZRoomListViewController ()
@property (nonatomic,strong,readonly) ZFZRoomListViewModel *viewModel;
@property (nonatomic,strong) NSArray<CellDataAdapter *> *roomList;
@end

@implementation ZFZRoomListViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setup{
    [super setup];
    [self.tableview registerCellsClass:@[cellClass(@"ZFZRoomInfoCell", @"ZFZRoomInfoCell")]];
}

//- (instancetype)initWithViewModel:(BaseViewModel *)viewModel{
//    if (self = [super initWithViewModel:viewModel]) {
//        @weakify(self)
//        
//        [self.viewModel.roomListCommand execute:nil];
//        
//        [[[self.viewModel.roomListCommand executionSignals]switchToLatest]subscribeNext:^(NSArray<CellDataAdapter *> * x) {
//            @strongify(self)
//            self.roomList = x;
//            [self.tableview reloadData];
//        }];
//        
//        [self.viewModel.roomListSubject subscribeNext:^(NSArray<CellDataAdapter *> * x) {
//            @strongify(self)
//            self.roomList = x;
//            //[self.tableview reloadData];
//        }];
//        RAC(self,roomList) = RACObserve(self.viewModel, roomList);
//
//    }
//    return self;
//}

- (void)bindViewModel{
    [super bindViewModel];

    @weakify(self)
//    
//    [self.viewModel.roomListCommand execute:nil];
//    
//    [[[self.viewModel.roomListCommand executionSignals]switchToLatest]subscribeNext:^(NSArray<CellDataAdapter *> * x) {
//        @strongify(self)
//        //self.roomList = x;
//        [self.tableview reloadData];
//    }];
    
//    [self.viewModel.roomListSubject subscribeNext:^(NSArray<CellDataAdapter *> * x) {
//        @strongify(self)
//        self.roomList = x;
//        //[self.tableview reloadData];
//    }];
    RAC(self,roomList) = [RACObserve(self.viewModel, roomList) doNext:^(NSArray * x) {
        @strongify(self)
        [self.tableview reloadData];
    }];
}

#pragma mark ----------UITabelViewDataSource----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.roomList) {
        return 0;
    }
    return  self.roomList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZFZRoomInfoCell *cell = (ZFZRoomInfoCell *)[tableView dequeueAndLoadContentReusableCellFromAdapter:self.roomList[indexPath.row] indexPath:indexPath controller:self];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击跳转到聊天页面
    id data = self.roomList[indexPath.row].data;
    if (data && [data isKindOfClass:[ZFZRoomModel class]]) {
        ZFZRoomModel * model = (ZFZRoomModel *)data;
        //激活聊天室
        XMPPJID *roomjid = [XMPPJID jidWithString:model.roomjid];
//        [[ZFZRoomManager shareInstance] JoinOrCreateRoomWithRoomJID:roomjid andNickName:@"李四"];
        
        
        //创建一个聊天控制器
        NSDictionary *patern = @{@"userJid":roomjid};
        ZFZChatViewModel * viewModel = [[ZFZChatViewModel alloc]initWithServices:nil params:patern];
        viewModel.chatType = ZFZChatGroup;
        ZFZChatTableViewController *chatVc = [[ZFZChatTableViewController alloc]initWithViewModel:viewModel];
        [self.navigationController pushViewController:chatVc animated:YES];
    }

    
    
}

@end
