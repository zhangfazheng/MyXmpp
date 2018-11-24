//
//  ZFZRoomManager.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/8.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRoomManager.h"
#import "ZFZXMPPManager.h"
#import "XMPPConfig.h"
#import "UIImage+RoundImage.h"


@interface ZFZRoomManager ()<XMPPMUCDelegate, XMPPRoomDelegate, XMPPStreamDelegate>


@end

@implementation ZFZRoomManager
static ZFZRoomManager *shareInstance;

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [ZFZRoomManager new];
        [shareInstance.xmppMUC activate:[ZFZXMPPManager sharedManager].stream];
        [[ZFZXMPPManager sharedManager].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    });
    return shareInstance;
}
-(NSMutableDictionary *)RoomDict
{
    if (_RoomDict == nil) {
        _RoomDict = [NSMutableDictionary dictionary];
    }
    return _RoomDict;
}
-(XMPPMUC *)xmppMUC
{
    if (_xmppMUC == nil) {
        _xmppMUC = [[XMPPMUC alloc]init];
        
        [_xmppMUC addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppMUC;
}

-(XMPPRoom *)xmppRoom
{
    if (_xmppRoom == nil) {
        _xmppRoom = [[XMPPRoom alloc]initWithDispatchQueue:dispatch_get_main_queue()];
        [_xmppRoom activate:[ZFZXMPPManager sharedManager].stream];
    }
    return _xmppRoom;
}
//登陆聊天室
-(void)JoinOrCreateRoomWithRoomJID:(XMPPJID *)roomJID andNickName:(NSString *)nickname
{
    
    XMPPRoom *room = [[XMPPRoom alloc]initWithRoomStorage:[XMPPRoomCoreDataStorage sharedInstance] jid:roomJID];
    //把房间存在字典里，按照房间名
    self.RoomDict[roomJID.bare] = room;
    [room addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [room activate:[ZFZXMPPManager sharedManager].stream];
    
    //避免重复发送离线群消息，需要加一个history
    NSXMLElement *history = [NSXMLElement elementWithName:@"history"];
    //查询上次收到的最后一条消息时间
    NSDate *dateTime = [self qureLastMessageTimeWith:roomJID];
    if (!dateTime) {
        dateTime = [NSDate date];
    }
    [history addAttributeWithName:@"since" stringValue:[dateTime xmppDateTimeString]];
    //[history addAttributeWithName:@"maxstanzas" stringValue:10];
    //加入聊天室occupantsForRoom
    [room joinRoomUsingNickname:nickname history:history];
    
}

-(void)JoinOrCreateRoomWithRoomJID:(XMPPJID *)roomJID andNickName:(NSString *)nickname delegate:(id<XMPPRoomDelegate>)delgate
{
    
    XMPPRoom *room = [[XMPPRoom alloc]initWithRoomStorage:[XMPPRoomCoreDataStorage sharedInstance] jid:roomJID];
    //把房间存在字典里，按照房间名
    self.RoomDict[roomJID.bare] = room;
    [room addDelegate:delgate delegateQueue:dispatch_get_main_queue()];
    [room activate:[ZFZXMPPManager sharedManager].stream];
    
    //避免重复发送离线群消息，需要加一个history
    NSXMLElement *history = [NSXMLElement elementWithName:@"history"];
    //查询上次收到的最后一条消息时间
    NSDate *dateTime = [self qureLastMessageTimeWith:roomJID];
    if (!dateTime) {
        dateTime = [NSDate date];
    }
    [history addAttributeWithName:@"since" stringValue:[dateTime xmppDateTimeString]];
    //[history addAttributeWithName:@"maxstanzas" stringValue:0];
    //加入聊天室occupantsForRoom
    [room joinRoomUsingNickname:nickname history:history];
    
}

#pragma mark - 查询上次收到的最后一条消息时间
- (NSDate *)qureLastMessageTimeWith:(XMPPJID *)roomJid{
    // 创建请求对象
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 实体 -->从哪里获取数据
    XMPPMessageArchivingCoreDataStorage *storage = [ZFZXMPPManager sharedManager].messageArchivingCoreDataStorage;
    request.entity = [NSEntityDescription entityForName:storage.messageEntityName inManagedObjectContext:storage.mainThreadManagedObjectContext];
    
    // 谓词 -->获取哪些数据   不用写谓词 因为要获取所有的最近联系人的数据
    NSString *myJid = [[ZFZXMPPManager sharedManager].stream myJID].bare;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@ AND streamBareJidStr like %@", roomJid.bareJID,myJid];
    [request setFetchLimit:1];
    [request setFetchOffset:0];
    request.predicate = predicate;
    // 排序  升序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    request.sortDescriptors = @[sort];
    NSError *error = nil;
    
    NSArray *fetchedObjects = [storage.mainThreadManagedObjectContext executeFetchRequest:request error:&error];
    
    XMPPMessageArchiving_Message_CoreDataObject *lastMessage = [fetchedObjects firstObject];
    if (lastMessage) {
        NSDate *dateTime = lastMessage.timestamp;
        return dateTime;
    }else{
        return nil;
    }
}

#pragma mark - xmppRoom代理方法
- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    NSLog(@"加入房间成功");

    //    [sender fetchConfigurationForm];
    //    [sender fetchBanList];
    [sender fetchMembersList];
    [sender fetchModeratorsList];
}



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
            //遍历所有 房间，找到对应的房间添加成员
            for (NSInteger i = self.roomList.count-1; i>=0; i--) {
                if ([self.roomList[i].roomjid isEqualToString:sender.roomJID.bare]) {
                    [self.roomList[i].roomMembers addObject:memberModel];
                }
            }
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
            if ([[self.roomList lastObject].roomjid isEqualToString:sender.roomJID.bare]) {
                [[self.roomList lastObject].roomMembers addObject:memberModel];
            }
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
//#pragma mark - 邀请好友
//- (void)inveterUser:(XMPPJID *)jid roomJid:(XMPPJID *)roomjid invter:(NSString *)invterStr{
//    /***<message
//    from='crone1@shakespeare.lit/desktop'
//    to='darkcave@chat.shakespeare.lit'>
//    <x xmlns='http://jabber.org/protocol/muc#user'>
//    <invite to='hecate@shakespeare.lit'>
//    <reason>
//    Hey Hecate, this is the place for all good witches!
//        </reason>
//        </invite>
//        </x>
//        </message>*/
//    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:XMPPMUCUserNamespace];
//    
//    NSXMLElement *invite = [self inviteElementWithJid:jid invitationMessage:@"快来加入吧"];
//    [x addChild:invite];
//    
//    XMPPMessage *message = [XMPPMessage message];
//    [message addAttributeWithName:@"from" stringValue:invterStr];
//    [message addAttributeWithName:@"to" stringValue:[roomjid full]];
//    [message addChild:x];
//    
//    [[ZFZXMPPManager sharedManager].stream sendElement:message];
//    
//}
//
//- (NSXMLElement *)inviteElementWithJid:(XMPPJID *)jid invitationMessage:(NSString *)invitationMessage{
//    NSXMLElement *invite = [NSXMLElement elementWithName:@"invite"];
//    
//    [invite addAttributeWithName:@"to" stringValue:[jid full]];
//    
//    if ([invitationMessage length] > 0) {
//        [invite addChild:[NSXMLElement elementWithName:@"reason" stringValue:invitationMessage]];
//    }
//    return invite;
//}


-(void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    [sender configureRoomUsingOptions:nil];
    
    //[sender inviteUser:[XMPPJID jidWithUser:@"wwh" domain:@"wanwenhao.local" resource:nil] withMessage:@"我来找你了"];
}



#pragma mark- 请求获取房间列表
- (void)loadRooms
{
    NSXMLElement *queryElement= [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"];
    NSXMLElement *iqElement = [NSXMLElement elementWithName:@"iq"];
    [iqElement addAttributeWithName:@"type" stringValue:@"get"];
    [iqElement addAttributeWithName:@"from" stringValue:[ZFZXMPPManager sharedManager].stream.myJID.bare];
    NSString *service = [NSString stringWithFormat:@"%@.%@",kSubDomin,kDomin];
    [iqElement addAttributeWithName:@"to" stringValue:service];
    [iqElement addAttributeWithName:@"id" stringValue:@"getMyRooms"];
    [iqElement addChild:queryElement];
    [[ZFZXMPPManager sharedManager].stream sendElement:iqElement];
}

#pragma 接收到聊天组
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    //NSLog(@"iq:%@",iq);
    // 以下两个判断其实只需要有一个就够了
    NSString *elementID = iq.elementID;
    if (![elementID isEqualToString:@"getMyRooms"]) {
        return YES;
    }
    
    NSArray *results = [iq elementsForXmlns:@"http://jabber.org/protocol/disco#items"];
    if (results.count < 1) {
        return YES;
    }
    [self analyticDiscussionMemberWithIq:iq];

    return YES;
}

#pragma mark- 解析房间信息
- (void)analyticDiscussionMemberWithIq:(XMPPIQ *)iq
{
    
    for (DDXMLElement *element in iq.children) {
        if ([element.name isEqualToString:@"query"]) {
            //移除旧数据
            [self.roomList removeAllObjects];
            for (DDXMLElement *item in element.children) {
                if ([item.name isEqualToString:@"item"]) {
                    ZFZRoomModel *room = [[ZFZRoomModel alloc]init];
                    room.roomName = [item attributeStringValueForName:@"name"];
                    NSString *jidStr = [item attributeStringValueForName:@"jid"];
                    room.roomjid = jidStr;
                    
//                    XMPPStream *strem = [ZFZXMPPManager sharedManager].stream;
//                    
//                    XMPPRoomCoreDataStorage *storage = [XMPPRoomCoreDataStorage sharedInstance];
//                    
//                    XMPPRoomOccupantCoreDataStorageObject *occupantStorage =[storage occupantForJID:strem.myJID stream:strem inContext:storage.mainThreadManagedObjectContext];
//                    XMPPRoomOccupantCoreDataStorageObject *occupantStorage =[self selectDataWithRoomJid:jidStr];
                    
                    NSUserDefaults   *defaults = [ NSUserDefaults standardUserDefaults ];
                    NSString *nickName = [defaults stringForKey : @"userNickName" ];
                    //登录到房间
                    [self JoinOrCreateRoomWithRoomJID:[XMPPJID jidWithString:jidStr] andNickName:nickName];
                    
                    UIImage * iconImage = [[UIImage imageNamed:@"army6"] setRadius:27 size:CGSizeMake(55, 55)];
                    room.phton = iconImage;

                    [self.roomList addObject:room];  //array  就是你的群列表
                    
                }
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:ZFZRoomListChangNotice object:nil];
        }
    }
}

//根据条件查询数据；查询结果是固定不变的所以用NSArray;
-(XMPPRoomOccupantCoreDataStorageObject * )selectDataWithRoomJid:(NSString *)roomJid;
{
    XMPPRoomCoreDataStorage *storage = [XMPPRoomCoreDataStorage sharedInstance];
    XMPPJID *myJid = [[ZFZXMPPManager sharedManager].stream myJID];
    NSManagedObjectContext *context = storage.mainThreadManagedObjectContext;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"roomJIDStr like[cd] %@",roomJid];
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:storage.occupantEntityName  inManagedObjectContext:context]];
    [request setPredicate:predicate];
    NSSortDescriptor * sort = [[NSSortDescriptor alloc]initWithKey:@"roomJIDStr" ascending:YES];
    
    [request setSortDescriptors:@[sort]];
    //这里相当于sqlite中的查询条件，具体格式参考苹果文档 //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    //这里获取到的是一个数组，你需要取出你要更新的那个obj
    return [result lastObject];
}
#pragma  mark- 离开房间方法
- (void)presenceOutLine{
    for (XMPPRoom *curRoom in self.roomList) {
        [curRoom leaveRoom];
    }
}

#pragma  mark- XMPPMUCDelegate代理方法
- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitation:(XMPPMessage *)message{
    NSLog(@"%@",message);
    if (![message.type isEqualToString: @"error"]) {
//
//        NSString *toJidStr = message.toStr;
//        NSString *roomJid = message.fromStr;
//        NSString *fromStr;
//        NSString *bodyStr;
//        NSXMLElement *inviteElement;
//        NSXMLElement *bodyElement;
//
//
//
//
//        //解析邀请消息获取邀请理由
//        for (DDXMLElement *element in message.children){
//            if ([element.name isEqualToString:@"x"]) {
//                for (DDXMLElement *invite in element.children){
//                    //获取邀请对象
//                    if ([invite.name isEqualToString:@"invite"]) {
//                        //解析邀请消息
//                        inviteElement = invite;
//                        fromStr = [invite attributeStringValueForName:@"from"];
//                        XMPPJID *fromJid = [XMPPJID jidWithString:fromStr];
//
//                        bodyStr = [NSString stringWithFormat:@"%@ 邀请你加入 %@",fromJid.user,roomJID.user];
//
//                    }
//                }
//
//
//            }
//        }
//
//        bodyElement = [[NSXMLElement alloc]initWithName:@"body" stringValue:bodyStr];
//        XMPPMessage *inviteMessage = [[XMPPMessage alloc]initWithType:@"groupInvite" to:[XMPPJID jidWithString:toJidStr] elementID:nil child:bodyElement];
//        //XMPPJID *groupnoticJid =[XMPPJID jidWithUser:GroupNotice domain:kDomin resource:kResource];
//        //XMPPJID * groupnoticJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@-%@",GroupNotice,roomJid]];
//        //XMPPJID * groupnoticJid = [XMPPJID jidWithString:roomJid];
//        XMPPJID * groupnoticJid = [XMPPJID jidWithUser:GroupNotice domain:kDomin resource:kResource];
//        [inviteElement addAttributeWithName:@"roomJid" stringValue:roomJid];
//        [inviteMessage addAttributeWithName:@"from" stringValue:groupnoticJid.full];
//        [inviteMessage addAttributeWithName:@"status" integerValue:0];
//        [inviteMessage addChild:[inviteElement copy]];
//
//        NSLog(@"%@",inviteMessage);
//        //保存邀请消息
//        XMPPMessageArchivingCoreDataStorage *archiving =[ZFZXMPPManager sharedManager].messageArchivingCoreDataStorage;
//        XMPPStream *stream = [ZFZXMPPManager sharedManager].stream;
//        [archiving archiveMessage:inviteMessage outgoing:NO xmppStream:stream];

        
        XMPPRoom * xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:[XMPPRoomCoreDataStorage sharedInstance] jid:roomJID];
        //[xmppRoom activate:[ZFZXMPPManager sharedManager].stream];
        [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [xmppRoom joinRoomUsingNickname:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] history:nil];
    }
    
}
- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitationDecline:(XMPPMessage *)message{
    NSLog(@"%@",message);
}

- (NSMutableArray<ZFZRoomModel *> *)roomList{
    if (!_roomList) {
        _roomList = [NSMutableArray array];
    }
    return  _roomList;
}


@end
