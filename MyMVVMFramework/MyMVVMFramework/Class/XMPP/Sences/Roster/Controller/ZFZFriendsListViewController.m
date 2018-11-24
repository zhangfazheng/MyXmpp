//
//  ZFZFriendsListViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/1.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZFriendsListViewController.h"
#import "ZFZFriendsListViewModel.h"
#import "UITableView+CellClass.h"
#import "ZFZFriendCell.h"
#import "ZFZFriendGroupHeaderView.h"
#import "ZFZFriendGroupModel.h"
#import "ZFZChatViewModel.h"
#import "ZFZChatTableViewController.h"
#import "CustomNavigationController.h"


@interface ZFZFriendsListViewController ()
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * contactsList;
@property (nonatomic,strong) NSMutableArray <ZFZFriendGroupModel *> * groupList;

@property (strong, nonatomic, readonly) ZFZFriendsListViewModel *viewModel;
@end

@implementation ZFZFriendsListViewController
@dynamic viewModel;


//- (void)loadView{
//    self.useHeader = YES;
//    [super loadView];
//}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.tableview registerCellsClass:@[cellClass(@"ZFZFriendCell", @"ZFZFriendCell")]];
    [self.tableview registerClass:[ZFZFriendGroupHeaderView class] forHeaderFooterViewReuseIdentifier:@"ZFZFriendGroupHeaderView"];
    // Do any additional setup after loading the view.
}


- (void)bindViewModel{
    [super bindViewModel];
    //RAC(self,contactsList) = RACObserve(self.viewModel,friendsList);
    WeakSelf
    RAC(self,groupList) = [RACObserve(self.viewModel,groupList) doNext:^(id  _Nullable x) {
        [weakSelf.tableview reloadData];
    }];
    
    [self.viewModel.updateContactsSubject subscribeNext:^(id  _Nullable x) {
        [weakSelf.tableview reloadData];
    }];

}




#pragma mark ----------UITabelViewDataSource----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.groupList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.groupList[section].isOpened) {
        return 0;
    }
    return  self.groupList[section].friends.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZFZFriendCell *cell = (ZFZFriendCell *)[tableView dequeueAndLoadContentReusableCellFromAdapter:self.groupList[indexPath.section].friends[indexPath.row] indexPath:indexPath controller:self];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZFZFriendModel *model = (ZFZFriendModel *)self.self.groupList[indexPath.section].friends[indexPath.row].data;
    if (model) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        CustomNavigationController *vc =[self.tabBarController.childViewControllers firstObject];
        [self.tabBarController setSelectedIndex:0];
        
        //创建一个聊天控制器
         XMPPJID *jid = [XMPPJID jidWithString:model.jid];
        NSDictionary *patern = @{@"userJid":jid,@"friendName":model.name};
        ZFZChatViewModel * viewModel = [[ZFZChatViewModel alloc]initWithServices:nil params:patern];
        viewModel.chatType = ZFZChatSignal;
        ZFZChatTableViewController *chatVc = [[ZFZChatTableViewController alloc]initWithViewModel:viewModel];
       
        chatVc.userJid = jid;
        chatVc.title = model.name;
        [vc pushViewController:chatVc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

#pragma mark ----------UITabelViewDelegate----------


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ZFZMessageFrame * frame  = (ZFZMessageFrame *)_items[indexPath.row];
//    if (frame) {
//        return frame.cellHeight;
//    }else{
//        return 0;
//    }
//    
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 1.创建headerView
    static NSString *headerID = @"ZFZFriendGroupHeaderView";
    ZFZFriendGroupHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (headerView == nil) {
        headerView = [[ZFZFriendGroupHeaderView alloc] initWithReuseIdentifier:headerID];
        
    }
    //NSLog(@"section:%zd",section);
    // 设置代理
    headerView.tag = 1000 + section;
    // 2.给headerView传递模型
    headerView.section = section;
    headerView.group = self.groupList[section];
    headerView.openButton.tag = 1000 + section;

    
    
    @weakify(self)
    [headerView.openSignal subscribeNext:^(UIButton * sender) {
        @strongify(self)
        // 刷新表格
        // 1.设置当前所点击的那一组组
        if (sender.tag-1000>=0) {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sender.tag-1000];
            // 2.刷新对应的那一组
            //[self.tableview reloadData];
            [self.tableview beginUpdates];
            [self.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableview endUpdates];
        }
        
    }];
    
    
    // 3.返回headerView.
    return headerView;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
