//
//  ZFZChatViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/23.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"
#import "UITableView+CellClass.h"
#import "ZFZXMPPManager.h"
#import "ZFZMemberModel.h"

typedef enum : NSUInteger {
    ZFZChatSignal,
    ZFZChatGroup,
    ZFZGroupInvitation,
    ZFZFriendsValidation
   
} ZFZChatType;

@class ZFZRoomModel;
@interface ZFZChatViewModel : BaseViewModel
//消息更新时的信号
@property (nonatomic, strong, readwrite) RACCommand *updateMessageCommand;
//加载消息时的操作
@property (nonatomic, strong, readwrite) RACCommand *loadMessageCommand;
//收到消息时的信号
@property (nonatomic, strong, readwrite) RACCommand *receiveMessageCommand;

////消息回执状态改变时的信号
//@property (nonatomic, strong, readwrite) RACCommand *messageDeliveryCommand;
//消息回执状态改变时的信号
@property (nonatomic, strong, readwrite) RACSubject *messageDeliverySubject;
//数据集合
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * items;
//好友jid
@property (nonatomic,strong) XMPPJID *userJid;

@property (nonatomic,assign) ZFZChatType chatType;

//发送消息的command
@property (nonatomic, strong, readwrite) RACCommand *sendMessageCommand;

@property (nonatomic, strong) ZFZRoomModel* curRoom;
//发送消息的subject
//@property (nonatomic, strong, readwrite) RACSubject *sendMessageSubject;


@end
