//
//  ZFZRoomAddMemberViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/18.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRoomAddMemberViewController.h"
#import "ZFZFriendsListViewModel.h"
#import "UITableView+CellClass.h"
#import "ZFZSeachMemberHeaderView.h"
#import "ZFZManageMemberCell.h"
#import "ZFZFriendGroupHeaderView.h"
#import "ZFZFriendGroupModel.h"
#import "ZFZRoomManager.h"
#import "XMPPConfig.h"

@interface ZFZRoomAddMemberViewController ()
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * contactsList;
@property (nonatomic,strong) NSMutableArray <ZFZFriendGroupModel *> * groupList;
@property (nonatomic,weak) ZFZSeachMemberHeaderView *seachMemberHeaderView;
@property (nonatomic,strong) UIBarButtonItem *complectionItemButton;
@property (nonatomic,strong) NSMutableArray <XMPPJID *> * memberJidList;

@property (strong, nonatomic, readonly) ZFZFriendsListViewModel *viewModel;
@end

@implementation ZFZRoomAddMemberViewController

@dynamic viewModel;


- (void)loadView{
    self.useHeader = YES;
    self.showSeparator = YES;
    [super loadView];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}


- (void)setup{
    [self.tableview registerCellsClass:@[cellClass(@"ZFZManageMemberCell", @"ZFZManageMemberCell")]];
    [self.tableview registerClass:[ZFZFriendGroupHeaderView class] forHeaderFooterViewReuseIdentifier:@"ZFZFriendGroupHeaderView"];
    
    [self.navigationItem setRightBarButtonItem:self.complectionItemButton];
    
    //设置头视图
    ZFZSeachMemberHeaderView *seachMemberHeaderView = [[ZFZSeachMemberHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 61)];
    _seachMemberHeaderView = seachMemberHeaderView;
    [self.tableview setTableHeaderView:_seachMemberHeaderView];
    
    @weakify(self)
    [self.seachMemberHeaderView.removeMemberSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSInteger count = [x integerValue];
        [self setcomplectionItemButtoCount:count];
        [self.memberJidList removeObject:x];
        
        [self.tableview reloadData];
    }];
    
}

//设置邀请人数设置
- (void)setcomplectionItemButtoCount:(NSInteger)count{
    if (count>0) {
        [self.complectionItemButton setTitle:[NSString stringWithFormat:@"完成(%zd)",count]];
        self.complectionItemButton.enabled = YES;
        
    }else{
        [self.complectionItemButton setTitle:@"完成"];
        self.complectionItemButton.enabled = NO;
    }

}


- (void)bindViewModel{
    [super bindViewModel];
    //RAC(self,contactsList) = RACObserve(self.viewModel,friendsList);
    //self.roomJid = self.viewModel.params[ROOMJID];
    @weakify(self)
    [RACObserve(self.viewModel,groupList) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.groupList = x;
        [self.tableview reloadData];
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
    return  [self.groupList[section].friends count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZFZManageMemberCell *cell = (ZFZManageMemberCell *)[tableView dequeueAndLoadContentReusableCellFromAdapter:self.groupList[indexPath.section].friends[indexPath.row] indexPath:indexPath controller:self];
//    cell.isEnable =YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //ZFZManageMemberCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    ZFZFriendModel * friend = self.groupList[indexPath.section].friends[indexPath.row].data;
    //将选中成员添加到成员列表中
    if (friend.friendSelectType == ZFZUnenable) {
        return;
    }else if (friend.friendSelectType == ZFZSelected){
        friend.friendSelectType = ZFZEnable;
        //移除成员
        [_seachMemberHeaderView reMoveMember:friend];
        for (NSInteger i = 0; i < self.memberJidList.count; i++) {
            if ([self.memberJidList[i] isEqualToJID:[XMPPJID jidWithString:friend.jid]]) {
                [self.memberJidList removeObjectAtIndex:i];
                break;
            }
        }
        
    }else{
        friend.friendSelectType = ZFZSelected;
        [_seachMemberHeaderView addMember:friend];
        [self.memberJidList addObject:[XMPPJID jidWithString:friend.jid]];
        
    }
    
    //设置邀请人数
    [self setcomplectionItemButtoCount:_seachMemberHeaderView.addMembersList.count];
    
    //更新指定行数据
    [self.tableview beginUpdates];
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableview endUpdates];
    
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
    headerView.tag = section;
    // 2.给headerView传递模型
    headerView.section = section;
    headerView.group = self.groupList[section];
    
    @weakify(self)
    [headerView.openSignal subscribeNext:^(UIButton * sender) {
        @strongify(self)
        // 刷新表格
        // 1.设置当前所点击的那一组组
        //NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sender.tag];
        // 2.刷新对应的那一组
        [self.tableview reloadData];
        //[self.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    
    // 3.返回headerView.
    return headerView;
    
}

- (NSMutableArray<XMPPJID *> *)memberJidList{
    if (!_memberJidList) {
        _memberJidList = [NSMutableArray array];
    }
    return _memberJidList;
}


- (UIBarButtonItem *)complectionItemButton{
    
    if (!_complectionItemButton) {
        _complectionItemButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(inviteUsers)];
        
        _complectionItemButton.enabled = NO;
    }
    return _complectionItemButton;
}

#pragma mark- 邀请好友进组
- (void)inviteUsers{
    if (self.memberJidList && _memberJidList.count>0) {
        NSString *myName = [ZFZXMPPManager sharedManager].stream.myJID.user;
        NSString *message = [NSString stringWithFormat:@"%@邀请你加入%@",myName,self.roomJid.user];
        XMPPRoom*curRoom = [ZFZRoomManager shareInstance].RoomDict[[self.roomJid bare]];
        if (curRoom) {
            [curRoom inviteUsers:_memberJidList withMessage:message];
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inviteUsers:(NSArray<XMPPJID *> *)users withMessage:(NSString *)message{
    [[ZFZRoomManager shareInstance].RoomDict[[self.roomJid bare]] inviteUsers:users withMessage:message];
}

@end
