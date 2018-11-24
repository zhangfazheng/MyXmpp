//
//  ZFZRoomManageViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/15.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"
#import "ZFZXMPPManager.h"
#import "ZFZMemberModel.h"

@interface ZFZRoomManageViewModel : BaseViewModel
//房间jid
@property (nonatomic,strong) XMPPJID *roomJid;
//房间成员
@property (nonatomic,strong) NSMutableArray<ZFZMemberModel *>  *roomMembers;
@end
