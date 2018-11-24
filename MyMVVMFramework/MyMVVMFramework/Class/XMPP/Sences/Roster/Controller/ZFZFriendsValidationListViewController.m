//
//  ZFZFriendsValidationListViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/26.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZFriendsValidationListViewController.h"
#import "UITableView+CellClass.h"
#import "ZFZXMPPManager.h"
#import "ZFZFriendsValidationCell.h"
#import "ZFZFriendsValidationListViewModel.h"
#import "ZFZInvitationValidationViewController.h"
#import "ZFZFriendsValidationModel.h"
#import "ZFZAddFriendInfoViewController.h"

@interface ZFZFriendsValidationListViewController ()
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * items;
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) ZFZFriendsValidationListViewModel *viewModel;
@end

@implementation ZFZFriendsValidationListViewController

@dynamic viewModel;


- (void)setup{
    [super setup];
    
    [self.tableview registerCellsClass:@[cellClass(@"ZFZFriendsValidationCell", nil)]];
    // 1.获取最近联系人的数据
    // 1.1执行请求
    // 设置代理
    //[[ZFZXMPPManager sharedManager].xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
}


- (void)bindViewModel{
    [super bindViewModel];
    RAC(self, items) = RACObserve(self.viewModel, items);
    self.items = self.viewModel.items;
    @weakify(self)
    
    [self.viewModel.updateFriendsValidationSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.items = [(NSMutableArray<CellDataAdapter *> *)x mutableCopy];
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
    return  [self.items count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZFZFriendsValidationCell *cell = (ZFZFriendsValidationCell *)[tableView dequeueAndLoadContentReusableCellFromAdapter:_items[indexPath.row] indexPath:indexPath controller:self];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZFZInvitationModel *invitationModel     = [[ZFZInvitationModel alloc]init];
    ZFZFriendsValidationModel *friendModel      = (ZFZFriendsValidationModel *)(self.items[indexPath.row].data);
    invitationModel.inviterJid                  = friendModel.friendJid;
    invitationModel.icon                        = friendModel.icon;
    invitationModel.agreementStatus             = friendModel.agreementStatus;
    invitationModel.reason                      = friendModel.reason;
    invitationModel.message                     = friendModel.message;
    invitationModel.invitationType              = ZFZFriendInvitation;
    
    //创建一个邀请验证控制器
    ZFZInvitationValidationViewController *invitationValidationVc = [[ZFZInvitationValidationViewController alloc]init];
    invitationValidationVc.invitation = invitationModel;
    invitationValidationVc.agreeWithSubject = self.viewModel.addFriendSubject;
    //invitationValidationVc.rejectJionRoomCommand = self.viewModel.rejectAddFriendCommand;
    invitationValidationVc.invitation = invitationModel;
    
    //收到同意时的附加操作
    
    [self.navigationController pushViewController:invitationValidationVc animated:YES];
    
}

#pragma mark ----------UITabelViewDelegate----------


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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

@end
