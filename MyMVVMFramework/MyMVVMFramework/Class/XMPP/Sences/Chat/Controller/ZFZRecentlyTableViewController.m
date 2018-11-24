//
//  ZFZRecentlyTableViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/15.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRecentlyTableViewController.h"
#import "UITableView+CellClass.h"
#import "ZFZXMPPManager.h"
#import "ZFZRecentlyTableViewCell.h"
#import "ZFZChatTableViewController.h"
#import "ZFZChatViewModel.h"
#import "ZFZRecentlyModel.h"
#import "XMPPConfig.h"
#import "ZFZInvitationListViewController.h"
#import "ZFZInvitationListViewModel.h"
#import "ZFZFriendsValidationListViewModel.h"
#import "ZFZFriendsValidationListViewController.h"

@interface ZFZRecentlyTableViewController ()
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * items;

/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) ZFZRecentlyViewModel *viewModel;
@end


@implementation ZFZRecentlyTableViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)setup{
    [super setup];
    
    [self.tableview registerCellsClass:@[cellClass(@"ZFZRecentlyTableViewCell", nil)]];
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
    
    [self.viewModel.updateArchivingSubject subscribeNext:^(id  _Nullable x) {
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
    
    ZFZRecentlyTableViewCell *cell = (ZFZRecentlyTableViewCell *)[tableView dequeueAndLoadContentReusableCellFromAdapter:_items[indexPath.row] indexPath:indexPath controller:self];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //获取当前被选中的聊天jid
    id data = self.items[indexPath.row].data;
    if (data && [data isKindOfClass:[ZFZRecentlyModel class]]) {
         ZFZRecentlyModel * model = (ZFZRecentlyModel *)data;
        //清零消息条数计数器
        model.infoCount = 0;
        //更新数据
        [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //如果是一个群通知，则创建一个群通知页面
        if (model.chatType == ZFZGroupInvitation) {
            //创建一个群邀请信息控制器
            NSDictionary *patern = @{@"inviterJid":model.userJid};
            ZFZInvitationListViewModel* viewModel = [[ZFZInvitationListViewModel alloc]initWithServices:nil params:patern];
            ZFZInvitationListViewController *invitationVc = [[ZFZInvitationListViewController alloc]initWithViewModel:viewModel];
//            chatVc.in = model.userJid;
            [self.navigationController pushViewController:invitationVc animated:YES];
        }else if(model.chatType == ZFZFriendsValidation){
            //创建一个好友验证控制器
            NSDictionary *patern = @{@"validationJid":model.userJid};
            ZFZFriendsValidationListViewModel* viewModel = [[ZFZFriendsValidationListViewModel alloc]initWithServices:nil params:patern];
            ZFZFriendsValidationListViewController *validationVc = [[ZFZFriendsValidationListViewController alloc]initWithViewModel:viewModel];
            //            chatVc.in = model.userJid;
            [self.navigationController pushViewController:validationVc animated:YES];
            
        }else{
            //创建一个聊天控制器
            NSDictionary *patern = @{@"userJid":model.userJid,@"friendName":model.name,@"chatType":@(model.chatType)};
            ZFZChatViewModel * viewModel = [[ZFZChatViewModel alloc]initWithServices:nil params:patern];
            //BaseViewController *curvc= self.navigationController.childViewControllers[1];
            //NSLog(@"当前子控制器个数：%zd",self.navigationController.childViewControllers.count);
            ZFZChatTableViewController *chatVc = [[ZFZChatTableViewController alloc]initWithViewModel:viewModel];
            chatVc.userJid = model.userJid;
            chatVc.title = model.name;
            [self.navigationController pushViewController:chatVc animated:YES];
        }
        
        
    }
    
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

- (void)dealloc{
    NSLog(@"聊天ViewModel销毁了");
}



@end
