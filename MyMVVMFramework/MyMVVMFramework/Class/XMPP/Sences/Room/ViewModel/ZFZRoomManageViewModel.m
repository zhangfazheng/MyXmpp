//
//  ZFZRoomManageViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/15.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRoomManageViewModel.h"
#import "ZFZRoomManager.h"
#import "XMPPConfig.h"


@interface ZFZRoomManageViewModel ()<XMPPRoomDelegate>
@property (nonatomic ,strong) XMPPRoom *room;

@end

@implementation ZFZRoomManageViewModel

- (void)initialize{

    //获取房间
    //如果示登录房间进行登录
    if (!self.room ||!self.room.isJoined) {
        NSUserDefaults   *defaults = [ NSUserDefaults standardUserDefaults ];
        NSString *userNickName = [defaults valueForKey: @"userNickName"];
        [[ZFZRoomManager shareInstance] JoinOrCreateRoomWithRoomJID:self.roomJid andNickName:userNickName];
    }
    //设置代理
    [self.room addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //接收好群成员
    [self.room fetchMembersList];
    [self.room fetchModeratorsList];
}




#pragma mark - xmppRoom代理方法
//- (void)xmppRoomDidJoin:(XMPPRoom *)sender
//{
//    NSLog(@"加入房间成功");
//    
//    //    [sender fetchConfigurationForm];
//    //    [sender fetchBanList];
//    [sender fetchMembersList];
//    [sender fetchModeratorsList];
//}



- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
    NSLog(@"configForm:%@",configForm);
}

// 收到禁止名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items
{
    NSLog(@"%s",__func__);
}

// 收到成员名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
    for (NSXMLElement * member in items) {
        
        if ([member.name isEqualToString:@"item"]) {
            ZFZMemberModel *memberModel = [ZFZMemberModel new];
            memberModel.affiliation = [member attributeStringValueForName:@"affiliation"];
            NSString *jidStr = [member attributeStringValueForName:@"jid"];
            memberModel.jid = jidStr;
            memberModel.name = [member attributeStringValueForName:@"nick"];
            memberModel.role = [member attributeStringValueForName:@"role"];
            [self.roomMembers addObject:memberModel];
        }
        
    }
    //NSLog(@"%s",__func__);
}

// 收到主持人名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
    for (NSXMLElement * member in items) {
        
        if ([member.name isEqualToString:@"item"]) {
            ZFZMemberModel *memberModel = [ZFZMemberModel new];
            memberModel.affiliation = [member attributeStringValueForName:@"affiliation"];
            NSString *jidStr = [member attributeStringValueForName:@"jid"];
            memberModel.jid = jidStr;
            memberModel.name = [member attributeStringValueForName:@"nick"];
            memberModel.role = [member attributeStringValueForName:@"role"];
            [self.roomMembers addObject:memberModel];
        }
        
    }

    //NSLog(@"%s",__func__);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError
{
    NSLog(@"%s",__func__);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError
{
    NSLog(@"%s",__func__);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError
{
    NSLog(@"%s",__func__);
}



- (XMPPJID *)roomJid{
    return self.params[ROOMJID];
}

- (XMPPRoom *)room{
    if (!_room) {
        _room =[ZFZRoomManager shareInstance].RoomDict[self.roomJid.bare];
    }
    return [ZFZRoomManager shareInstance].RoomDict[self.roomJid.bare];
}

- (NSMutableArray<ZFZMemberModel *> *)roomMembers{
    if (!_roomMembers) {
        _roomMembers = [NSMutableArray array];
    }
    return _roomMembers;
}

@end
