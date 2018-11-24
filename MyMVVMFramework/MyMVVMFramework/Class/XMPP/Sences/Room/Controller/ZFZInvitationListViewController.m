//
//  ZFZInvitationListViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/22.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZInvitationListViewController.h"
#import "UITableView+CellClass.h"
#import "ZFZXMPPManager.h"
#import "ZFZRoomInvitationCell.h"
#import "ZFZInvitationListViewModel.h"
#import "ZFZInvitationValidationViewController.h"

@interface ZFZInvitationListViewController ()
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * items;
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) ZFZInvitationListViewModel *viewModel;
@end

@implementation ZFZInvitationListViewController
@dynamic viewModel;


- (void)setup{
    [super setup];
    
    [self.tableview registerCellsClass:@[cellClass(@"ZFZRoomInvitationCell", nil)]];
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
    
    [self.viewModel.updateInvitationSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.items = [(NSMutableArray<CellDataAdapter *> *)x mutableCopy];
        [self.tableview reloadData];
    }];
    
    [self.viewModel.reloadDataSubject subscribeNext:^(id  _Nullable x) {
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
    return  [self.items count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZFZRoomInvitationCell *cell = (ZFZRoomInvitationCell *)[tableView dequeueAndLoadContentReusableCellFromAdapter:_items[indexPath.row] indexPath:indexPath controller:self];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZFZInvitationModel *invitationModel = (ZFZInvitationModel *)(self.items[indexPath.row].data);
    //创建一个邀请验证控制器
    ZFZInvitationValidationViewController *invitationValidationVc = [[ZFZInvitationValidationViewController alloc]initWithStyle:UITableViewStyleGrouped];
    invitationValidationVc.invitation = invitationModel;
    invitationValidationVc.agreeWithSubject = self.viewModel.jionRoomSubject;
    invitationValidationVc.rejectSubject = self.viewModel.rejectJionRoomSubject;
    invitationValidationVc.updateInvitationStatusSubject = self.viewModel.updateInvitationStatusSubject;
    
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
