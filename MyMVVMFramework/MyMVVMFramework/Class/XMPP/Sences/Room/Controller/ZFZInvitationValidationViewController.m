//
//  ZFZInvitationValidationViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/26.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZInvitationValidationViewController.h"
#import "ZFZRoomInvitationCell.h"
#import "UITableView+CellClass.h"
#import "ZFZInvitationValidationFooterView.h"
#import "ZFZAddFriendInfoViewController.h"

@interface ZFZInvitationValidationViewController ()
@property(nonatomic,weak) ZFZInvitationListViewModel *viewModel;
@end

@implementation ZFZInvitationValidationViewController

@dynamic viewModel;

- (void)loadView{
    self.useForter = YES;
    [super loadView];
}

- (void)setup{
    [super setup];
    
    [self.tableview registerCellsClass:@[cellClass(@"ZFZRoomInvitationCell", nil)]];
    [self.tableview registerClass:[ZFZInvitationValidationFooterView class] forHeaderFooterViewReuseIdentifier:@"ZFZInvitationValidationFooterView"];
    // 1.获取最近联系人的数据
    // 1.1执行请求
    // 设置代理
    //[[ZFZXMPPManager sharedManager].xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //self.tableview.tableFooterView = [[ZFZInvitationValidationFooterView alloc]initWithReuseIdentifier:@"ZFZInvitationValidationFooterView" withStatus:ZFZUnprocessed];
    
    [self.updateInvitationStatusSubject subscribeNext:^(ZFZInvitationModel *x) {
        //self.invitation.agreementStatus;
//        NSLog(@"status:%zd",self.invitation.agreementStatus);
//        NSLog(@"curStatus:%zd",x.agreementStatus);
        [self.tableview reloadData];
    }];
}


//- (void)bindViewModel{
//    [super bindViewModel];
//    //@weakify(self)
//    
//    
//}






#pragma mark ----------UITabelViewDataSource----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellDataAdapter *data = [ZFZRoomInvitationCell dataAdapterWithCellReuseIdentifier:nil data:_invitation cellHeight:100 type:0];
    ZFZRoomInvitationCell *cell = (ZFZRoomInvitationCell *)[tableView dequeueAndLoadContentReusableCellFromAdapter:data indexPath:indexPath controller:self];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    ZFZInvitationValidationFooterView * footerView =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ZFZInvitationValidationFooterView"];
    footerView.agreementStatus = self.invitation.agreementStatus;
    footerView.invitation = self.invitation;
    
    //设置响应事件
    [footerView.agreeWithSignal subscribeNext:^(id  _Nullable x) {
        //弹出一个好友设置
        if (self.invitation.invitationType == ZFZFriendInvitation) {
            ZFZAddFriendInfoViewController *addFriendVc = [[ZFZAddFriendInfoViewController alloc]init];
            addFriendVc.invitation = self.invitation;
            addFriendVc.addFriendSubject = self.agreeWithSubject;
            [ self.navigationController pushViewController: addFriendVc animated:YES];
        }else{
            [self.agreeWithSubject sendNext:self.invitation];
        }
        

    }];
    
    
    return footerView;
}



#pragma mark ----------UITabelViewDelegate----------



@end
