//
//  ZFZFriendsValidationListViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/26.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"
#import "UITableView+CellClass.h"
#import "ZFZXMPPManager.h"

@interface ZFZFriendsValidationListViewModel : BaseViewModel
//数据集合
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * items;
//好友jid
@property (nonatomic,strong) XMPPJID *validationJid;

@property (nonatomic, strong, readwrite) RACSubject *updateFriendsValidationSubject;

@property (nonatomic,strong, readwrite) RACCommand *addFriendCommand;
@property (nonatomic,strong, readwrite) RACSubject *addFriendSubject;
@property (nonatomic,strong, readwrite) RACCommand *rejectAddFriendCommand;
@end
