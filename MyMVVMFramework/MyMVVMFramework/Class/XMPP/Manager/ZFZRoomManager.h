//
//  ZFZRoomManager.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/8.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@import XMPPFramework;
#import "ZFZRoomModel.h"



@interface ZFZRoomManager : NSObject
@property (nonatomic , strong)XMPPMUC *xmppMUC;

@property (nonatomic , strong)XMPPRoom *xmppRoom;

@property (nonatomic , strong)NSMutableArray<ZFZRoomModel *> *roomList;

@property (nonatomic , strong)NSMutableDictionary *RoomDict;

+ (instancetype)shareInstance;

- (void)JoinOrCreateRoomWithRoomJID:(XMPPJID *)roomJID andNickName:(NSString *)nickname;

-(void)JoinOrCreateRoomWithRoomJID:(XMPPJID *)roomJID andNickName:(NSString *)nickname delegate:(id<XMPPRoomDelegate>)delgate;

- (void)loadRooms;
- (void)analyticDiscussionMemberWithIq:(XMPPIQ *)iq;

- (void)presenceOutLine;

//- (void)inveterUser:(XMPPJID *)jid roomJid:(XMPPJID *)roomjid invter:(NSString *)invterStr;
@end
