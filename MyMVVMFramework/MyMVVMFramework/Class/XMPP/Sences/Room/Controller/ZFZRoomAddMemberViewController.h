//
//  ZFZRoomAddMemberViewController.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/18.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ZFZXMPPManager.h"

@interface ZFZRoomAddMemberViewController : BaseTableViewController
//房间jid
@property (nonatomic,strong) XMPPJID *roomJid;
@end
