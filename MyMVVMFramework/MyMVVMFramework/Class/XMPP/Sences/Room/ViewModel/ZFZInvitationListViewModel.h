//
//  ZFZInvitationListViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/22.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"
#import "UITableView+CellClass.h"
#import "ZFZXMPPManager.h"

@interface ZFZInvitationListViewModel : BaseViewModel
//数据集合
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * items;
//好友jid
@property (nonatomic,strong) XMPPJID *invitationJid;

@property (nonatomic, strong, readwrite) RACSubject *updateInvitationSubject;
@property (nonatomic, strong, readwrite) RACSubject *updateInvitationStatusSubject;
@property (nonatomic, strong, readwrite) RACSubject *reloadDataSubject;

@property (nonatomic,strong, readwrite) RACCommand *jionRoomCommand;
@property (nonatomic,strong, readwrite) RACCommand *rejectJionRoomCommand;
@property (nonatomic,strong, readwrite) RACSubject *jionRoomSubject;
@property (nonatomic,strong, readwrite) RACSubject *rejectJionRoomSubject;
@end
