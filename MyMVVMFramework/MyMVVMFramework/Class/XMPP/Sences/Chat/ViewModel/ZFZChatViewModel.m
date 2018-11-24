//
//  ZFZChatViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/23.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZChatViewModel.h"
#import "ZFZMessageFrame.h"
#import "NSDate+Helper.h"
#import "ZFZMessageCell.h"
#import "UIImage+RoundImage.h"
#import <ChameleonFramework/Chameleon.h>
#import "ZFZRoomManager.h"
#import "XMPPMessage+XEP_0184.h"
#import "XMPPFramework.h"
#import "ZFZRoomManager.h"


//定义一个全局时间，如果是连续时间不显示
static NSDate *curDate;

@interface ZFZChatViewModel ()<NSFetchedResultsControllerDelegate,XMPPRoomDelegate,XMPPStreamDelegate>
///  从数据库中请求数据的类
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
///记录上一个消息的id，以免重复发送同一条消息
@property (nonatomic, copy) NSString *nextElementID;

@property (nonatomic, strong) XMPPRoom *room;

@end

@implementation ZFZChatViewModel
- (void)initialize{
    //删除缓存
    [NSFetchedResultsController deleteCacheWithName:@"Message"];
    // 1.获取最近联系人的数据
    // 1.1执行请求
    [self.fetchedResultsController performFetch:nil];
    // 1.2获取数据
    self.items = (NSMutableArray <CellDataAdapter *> *)[self messageDataFormatting:self.fetchedResultsController.fetchedObjects];
    //设置头像更新代理
    [[ZFZXMPPManager sharedManager].xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[ZFZXMPPManager sharedManager].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    _room = [ZFZRoomManager shareInstance].RoomDict[self.userJid.bare] ;
    
    //关闭后台运行当前房间的消息回执
    [ZFZXMPPManager sharedManager].curDeliveryReceiptsJid = self.userJid.bare;
    
    //遍历房间数组，找到当前房间
    for (NSInteger i= 0; i<[ZFZRoomManager shareInstance].roomList.count; i++) {
        if ([[ZFZRoomManager shareInstance].roomList[i].roomjid isEqualToString:self.userJid.bare]) {
            self.curRoom = [ZFZRoomManager shareInstance].roomList[i];
            break;
        }
    }
}


//对最近聊天记录进行格式化
- (NSArray *)messageDataFormatting:(NSArray<XMPPMessageArchiving_Message_CoreDataObject *> *)messageDataList{
    NSMutableArray * tempArry = [NSMutableArray arrayWithCapacity:messageDataList.count];
    //消息按时间做降序排列，做反转遍历
    if (messageDataList && messageDataList.count > 0) {
        for (NSInteger i = messageDataList.count-1; i>=0; i--) {
            //判断是否是自己发给自己的聊天
            CellDataAdapter * message;
            
            //如果是最后一条消息让其显示时间
            if (i == messageDataList.count-1) {
                message = [self messageFormatting:messageDataList[i] isLast:YES];
            }else{
                message = [self messageFormatting:messageDataList[i] isLast:NO];
            }
            
            
            [tempArry addObject:message];
        }
    }
    return [tempArry mutableCopy];
}

//聊天信息数据转模型
//- (CellDataAdapter *)messageFormatting:(XMPPMessageArchiving_Message_CoreDataObject *)messageData{
//
//    //创建一个最近聊天记录
//    ZFZMessageModel *message        = [ZFZMessageModel new];
//    ZFZMessageFrame *messageFrame   = [[ZFZMessageFrame alloc]init];
//
//    //获取用户名片
//    //XMPPvCardTemp *cardTemp = [[ZFZXMPPManager sharedManager].xmppvCardTempModule vCardTempForJID:messageData.bareJid shouldFetch:YES];
//
//
//    //isOutgoing为YES时说明是自己发送的消息，反之为别人发送的消息
//    message.type = messageData.isOutgoing ? ZFZMessageTypeMe : ZFZMessageTypeOther ;
//    //如果是群聊并且是其他人显示昵称
//    //如果是单聊
//    NSString *friendName = self.params[@"friendName"];
//    if(messageData.isOutgoing){
//        friendName = @"me";
//    }else if(self.chatType == ZFZChatGroup && !messageData.isOutgoing){
//        XMPPJID *fromJid = [messageData.message from];
//        message.name = fromJid.resource;
//        friendName = fromJid.resource;
//    }
//    NSString *iconText =[NSString string];
//    if (friendName.length > 2) {
//        iconText= [iconText substringWithRange:NSMakeRange((friendName.length-2), 2)];
//    }else{
//        iconText = friendName;
//    }
//
//    UIImage *image = [UIImage drawImageRadius:RadiusMake(25, 25, 25, 25) size:CGSizeMake(50, 50) backgroundColor:RandomFlatColor text:iconText];
//    message.iconImage = image;
//    message.text = messageData.body;
//    NSString *readStatus = [[messageData.message attributeForName:@"readStatus"]stringValue];
//    //如果是未读消息，发送回执
//    if (isEmptyString(readStatus) && !messageData.isOutgoing) {
//        XMPPMessage *receiptMessage = [self generateReceiptResponse:messageData.message];
//        [[ZFZXMPPManager sharedManager].stream sendElement:receiptMessage];
//        //更新消息状态
//        [self receiveMessageUpdateStatus:messageData.message];
//    }
//    if (messageData.isOutgoing && !isEmptyString(readStatus)) {
//        message.readStatus = readStatus;
//    }
//
//    message.elementId = messageData.message.elementID;
//
//
//    //判断是否是连续聊天
//    if (![self isCurDate:messageData.timestamp]) {
//        message.time = [self transfromDate:messageData.timestamp];
//        message.timeHiden = NO;
//    }else{
//        message.timeHiden = YES;
//    }
//    curDate = messageData.timestamp;
//
//    messageFrame.message = message;
//
//    return [ZFZMessageCell dataAdapterWithCellReuseIdentifier:nil data:messageFrame cellHeight:100 type:0];
//}


- (NSString *)getNameByMessage:(NSString *)messageStr{
    NSError *error;
    DDXMLElement *element = [[DDXMLElement alloc]initWithXMLString:messageStr error:&error];
    if (error) {
        NSLog(@"消息解析错误：%@",error);
        return nil;
    }else{
        XMPPMessage *message =[XMPPMessage messageFromElement:element];
        NSString *name = [message from].resource;
        return name;
    }
    
}


- (CellDataAdapter *)messageFormatting:(XMPPMessageArchiving_Message_CoreDataObject *)messageData isLast:(BOOL)isLast{
    //创建一个最近聊天记录
    ZFZMessageModel *message        = [ZFZMessageModel new];
    ZFZMessageFrame *messageFrame   = [[ZFZMessageFrame alloc]init];
    //isOutgoing为YES时说明是自己发送的消息，反之为别人发送的消息
    message.type = messageData.isOutgoing ? ZFZMessageTypeMe : ZFZMessageTypeOther ;
    //如果是单聊
     NSString *friendName = self.params[@"friendName"];
    if(messageData.isOutgoing){
        friendName = @"me";
    }else if(self.chatType == ZFZChatGroup && !messageData.isOutgoing){
        XMPPJID *fromJid = [messageData.message from];
        message.name = fromJid.resource;
        friendName = fromJid.resource;
    }
    NSString *iconText =[NSString string];
    if (friendName.length > 2) {
        iconText= [friendName substringWithRange:NSMakeRange((friendName.length-2), 2)];
    }else{
        iconText = friendName;
    }
    
    UIImage *image = [UIImage drawImageRadius:RadiusMake(25, 25, 25, 25) size:CGSizeMake(50, 50) backgroundColor:RandomFlatColor text:iconText];
    message.iconImage = image;
    message.text = messageData.body;
    NSString *readStatus = [NSString string];
    //并且该消息是别人发的，而且需要消息回执的，那么就发送消息回执，并将状态直接修改为已读进行显示
    if (!messageData.isOutgoing && [messageData.message hasReceiptRequest]){
        //如果是单聊，设置聊天读取状态
        if (self.chatType == ZFZChatSignal) {
            //并且该消息是别人发的，而且需要消息回执的，那么就发送消息回执
            readStatus = [[messageData.message attributeForName:@"readStatus"]stringValue];
            if (isEmptyString(readStatus)) {
                //创建回执消息并发送
                XMPPMessage *receiptMessage = [self generateReceiptResponse:messageData.message];
                [[ZFZXMPPManager sharedManager].stream sendElement:receiptMessage];
                //更新数据库消息状态
                [self receiveMessageUpdateStatus:messageData.message];
            }
        }else if (self.chatType == ZFZChatGroup){
            //获取消息已读人员集合
            DDXMLElement *readPersonnel = [messageData.message elementForName:@"readPersonnel"];
            if (readPersonnel) {
                NSInteger i;
                for (i = 0; i<[readPersonnel elementsForName:@"readerItem"].count;i++) {
                    DDXMLElement *read = [readPersonnel elementsForName:@"readerItem"][i];
                    NSString *readJid = read.stringValue;
                    //NSString *mjid =[ZFZXMPPManager sharedManager].stream.myJID.bare;
                    // 归档"获取"
                    NSUserDefaults   *defaults = [ NSUserDefaults standardUserDefaults ];
                    NSString *myNickName = [defaults valueForKey:@"userNickName"];

                    //如果不包含本人，说明本人未读过
                    if ([readJid isEqualToString:myNickName]) {
                        break;
                    }
                }
                //如果不包含本人。发送回执
                if (i >= [readPersonnel elementsForName:@"readerItem"].count) {
                    XMPPMessage *receiptMessage = [XMPPMessage messageWithType:@"groupchat" to:self.userJid];
                    NSXMLElement *received = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
                    [received addAttributeWithName:@"id" stringValue:messageData.message.elementID];
                    [receiptMessage addChild:received];
                    [[ZFZXMPPManager sharedManager].stream sendElement:receiptMessage];
                    //此处不用作消息状态变更，因为我们给会议发回执发消息时，会议会给所有人发这条消息，我们只要在处理这条消息的方法中来作消息回执发送状态（是否包含读取人）即可
//                    XMPPMessage *receiptMessage = [self generateReceiptResponse:messageData.message];
//                    [_room sendMessage:receiptMessage];
                }
            }
        }
    }else if ([messageData.message hasReceiptRequest]){//如果是自己发的，该消息是有回执的，则显示回执
//#warning 此外测试，为了让它发回执
//        if (self.chatType == ZFZChatGroup) {
//            //获取消息已读人员集合
//            DDXMLElement *readPersonnel = [messageData.message elementForName:@"readPersonnel"];
//            if (readPersonnel) {
//                NSInteger i;
//                for (i = 0; i<[readPersonnel elementsForName:@"readerItem"].count;i++) {
//                    DDXMLElement *read = [readPersonnel elementsForName:@"readerItem"][i];
//                    NSString *readJid = read.stringValue;
//                    NSString *mjid =[ZFZXMPPManager sharedManager].stream.myJID.bare;
//                    //如果不包含本人，说明本人未读过
//                    if ([readJid isEqualToString:mjid]) {
//                        break;
//                    }
//                }
//                //如果不包含本人。发送回执
//                NSInteger count = [readPersonnel elementsForName:@"readerItem"].count;
//                if (i >= count) {
//                    XMPPMessage *receiptMessage = [XMPPMessage messageWithType:@"groupchat" to:self.userJid];
//                    NSXMLElement *received = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
//                    [received addAttributeWithName:@"id" stringValue:messageData.message.elementID];
//                    [receiptMessage addChild:received];
//                    [[ZFZXMPPManager sharedManager].stream sendElement:receiptMessage];
////                    [_room sendMessage:receiptMessage];
//                }
//            }
//        }
        //判断是否是统计消息
        if (self.chatType == ZFZChatGroup) {
            message.isStatistics = YES;
            //获取消息已读人员集合
            DDXMLElement *readPersonnel = [messageData.message elementForName:@"readPersonnel"];
            if (readPersonnel) {
                NSMutableArray *readerMember = [NSMutableArray arrayWithCapacity:readPersonnel.childCount];
                NSInteger i;
                for (i = 0; i<[readPersonnel elementsForName:@"readerItem"].count;i++) {
                    DDXMLElement *read = [readPersonnel elementsForName:@"readerItem"][i];
                    NSString *readJid = read.stringValue;
                    [readerMember addObject:readJid];
                }
                message.readerMemberArray = [readerMember copy];
            }
            message.curRoom = self.curRoom;
            
        }else{
            message.isStatistics = NO;
        }
        
        readStatus = [[messageData.message elementForName:@"readStatus"] stringValue];
        message.readStatus = readStatus;
    }
    
    
    //判断是否是连续聊天
    if (![self isCurDate:messageData.timestamp] || isLast) {
        message.time = [self transfromDate:messageData.timestamp];
        message.timeHiden = NO;
    }else{
        message.timeHiden = YES;
    }
    curDate = messageData.timestamp;
    message.elementId = messageData.message.elementID;
    
    messageFrame.message = message;
    
    return [ZFZMessageCell dataAdapterWithCellReuseIdentifier:nil data:messageFrame cellHeight:messageFrame.cellHeight type:0];
}

#pragma mark - 时间处理方法
- (NSString *)transfromDate:(NSDate *)date{
    NSString * dateString;
    //创建时间模型
    NSDateFormatter *dateFormatter = [NSDate sharedDateFormatter];
    // 2. 借助于日历,对时间进行比较
    
    // 2.1 获取一个日历对象
    NSCalendar *cal = [NSDate sharedCalendar];
    
    // 2.2 设置一下时间比较的 枚举类型
    // 2016-08-04 09:09:46 +0000 -- 现在时间
    // 2015-08-04 09:09:46 +0000 -- 获取的时间
    //NSCalendarUnit unit = NSCalendarUnit arrayLiteral: .Year,.Month,.Day,.Hour,.Minute)
    
    // 2.3 比较时间

    //计算两个日期的差值
    NSDateComponents *comp = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  | NSCalendarUnitMinute) fromDate:date toDate:[NSDate date] options:NSCalendarWrapComponents];
    if ([cal isDateInToday:date]) {
        dateFormatter.dateFormat = @"ah:mm";
        [dateFormatter setAMSymbol:@"上午"];
        [dateFormatter setPMSymbol:@"下午"];
        return [dateFormatter stringFromDate:date];
    }else if ([cal isDateInYesterday:date]){
        dateFormatter.dateFormat = @"ah:mm";
        [dateFormatter setAMSymbol:@"上午"];
        [dateFormatter setPMSymbol:@"下午"];
        NSString *dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
        return dateStr;
    }else if ([cal isDateInWeekend:date]){
        dateFormatter.dateFormat = @"eee ah:mm";
        NSArray *weekdayAry = [NSArray arrayWithObjects:@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
        [dateFormatter setAMSymbol:@"上午"];
        [dateFormatter setPMSymbol:@"下午"];
        [dateFormatter setShortWeekdaySymbols:weekdayAry];
        return [dateFormatter stringFromDate:date];
    }else if (comp.day >= 7 && comp.year < 1){
        dateFormatter.dateFormat = @"MM-dd ah:mm";
        [dateFormatter setAMSymbol:@"上午"];
        [dateFormatter setPMSymbol:@"下午"];
        return [dateFormatter stringFromDate:date];
    }else{
        dateFormatter.dateFormat = @"yy-MM-dd ah:mm";
        [dateFormatter setAMSymbol:@"上午"];
        [dateFormatter setPMSymbol:@"下午"];
        return [dateFormatter stringFromDate:date];
    }
    
//    if (comp.year >= 1) {
//        dateFormatter.dateFormat = @"yy-MM-dd ah:mm";
//        [dateFormatter setAMSymbol:@"上午"];
//        [dateFormatter setPMSymbol:@"下午"];
//        return [dateFormatter stringFromDate:date];
//    }else if (comp.day >= 7){
//        dateFormatter.dateFormat = @"MM-dd ah:mm";
//        [dateFormatter setAMSymbol:@"上午"];
//        [dateFormatter setPMSymbol:@"下午"];
//        return [dateFormatter stringFromDate:date];
//    }else if (comp.day>=2){
//        dateFormatter.dateFormat = @"eee ah:mm";
//         NSArray *weekdayAry = [NSArray arrayWithObjects:@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
//        [dateFormatter setAMSymbol:@"上午"];
//        [dateFormatter setPMSymbol:@"下午"];
//        [dateFormatter setShortWeekdaySymbols:weekdayAry];
//        return [dateFormatter stringFromDate:date];
//    }else if ([cal isDateInYesterday:date]){
//        dateFormatter.dateFormat = @"ah:mm";
//        [dateFormatter setAMSymbol:@"上午"];
//        [dateFormatter setPMSymbol:@"下午"];
//        NSString *dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
//        return dateStr;
//    }else{
//        dateFormatter.dateFormat = @"ah:mm";
//        [dateFormatter setAMSymbol:@"上午"];
//        [dateFormatter setPMSymbol:@"下午"];
//        return [dateFormatter stringFromDate:date];
//    }
//    else if (comp.minute >= 1){
//        dateFormatter.dateFormat = @"ah:mm";
//        [dateFormatter setAMSymbol:@"上午"];
//        [dateFormatter setPMSymbol:@"下午"];
//        return [dateFormatter stringFromDate:date];
//    }else{
//        return @"刚刚";
//    }
    
    return dateString;
}

- (BOOL)isCurDate:(NSDate *)date{
    if (!curDate) {
        return NO;
    }
    
    NSCalendar *cal = [NSDate sharedCalendar];
    
    // 2.2 设置一下时间比较的 枚举类型
    // 2016-08-04 09:09:46 +0000 -- 现在时间
    // 2015-08-04 09:09:46 +0000 -- 获取的时间
    //NSCalendarUnit unit = NSCalendarUnit arrayLiteral: .Year,.Month,.Day,.Hour,.Minute)
    
    // 2.3 比较时间
    
    //计算两个日期的差值
    NSDateComponents *comp = [cal components:(NSCalendarUnitMinute) fromDate:curDate toDate:date options:NSCalendarWrapComponents];
    if (comp.minute < 1) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 数据库数据更新代理方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // 1.获取最新的数据
    //self.recentlyDataList = self.fetchedResultsController.fetchedObjects;
    
    XMPPMessageArchiving_Message_CoreDataObject *message = [controller.fetchedObjects firstObject];
    NSString *curElementId = message.message.elementID;
    //当对方在编辑消息时，会发送对方下正在编辑的消息，消息会在数据库中存储之后又将会被删除
    if (isEmptyString(message.body)||[curElementId isEqualToString:self.nextElementID]||isEmptyString(curElementId)) {
        return;
    }
    self.nextElementID = curElementId;
    // 2.刷新表格
    [self.receiveMessageCommand execute:[self messageFormatting:message isLast:NO]];
//    [self.receiveMessageSubject sendNext:[self messageFormatting:message]];
//    [self.receiveMessageSubject sendCompleted];
}


//懒加载数据库更新监听对象
- (NSFetchedResultsController *)fetchedResultsController{
    if (!_fetchedResultsController) {
        // 创建请求对象
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        // 实体 -->从哪里获取数据
        XMPPMessageArchivingCoreDataStorage *storage = [ZFZXMPPManager sharedManager].messageArchivingCoreDataStorage;
//        request.entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        request.entity = [NSEntityDescription entityForName:storage.messageEntityName inManagedObjectContext:storage.mainThreadManagedObjectContext];
        
        // 谓词 -->获取哪些数据   不用写谓词 因为要获取所有的最近联系人的数据
        //        request.predicate = [NSPredicate predicateWithFormat:@""];
        NSString *myJid = [[ZFZXMPPManager sharedManager].stream myJID].bare;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@ AND streamBareJidStr like %@", self.userJid.bare,myJid];
        [request setFetchLimit:1];
//        [request setFetchOffset:0];
        request.predicate = predicate;
        // 排序  升序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
        request.sortDescriptors = @[sort];
        // 创建请求数据的控制器
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:storage.mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"Message"];
        
        // 设置代理
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}


- (NSArray *)resultsMessageWithLimit:(NSInteger)count offset:(NSInteger)offset{
    // 创建请求对象
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 实体 -->从哪里获取数据
    XMPPMessageArchivingCoreDataStorage *storage = [ZFZXMPPManager sharedManager].messageArchivingCoreDataStorage;
    //        request.entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
    request.entity = [NSEntityDescription entityForName:storage.messageEntityName inManagedObjectContext:storage.mainThreadManagedObjectContext];
    
    // 谓词 -->获取哪些数据   不用写谓词 因为要获取所有的最近联系人的数据
    //        request.predicate = [NSPredicate predicateWithFormat:@""];
    NSString *myJid = [[ZFZXMPPManager sharedManager].stream myJID].bare;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@ AND streamBareJidStr like %@", self.userJid.bare,myJid];
    [request setFetchLimit:count];//读取多少条
    [request setFetchOffset:offset];//读取数据库的游标偏移量，从游标开始读取数据
    request.predicate = predicate;
    // 排序  升序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    request.sortDescriptors = @[sort];
    
    
    NSError *error = nil;
    
    NSArray *fetchedObjects = [storage.mainThreadManagedObjectContext executeFetchRequest:request error:&error];
    
    if (fetchedObjects != nil) {
        return [self messageDataFormatting: fetchedObjects];
        
    }else{
        return nil;
    }
    
}
#pragma mark-当收到一条回执消息时对消息状态进行改变
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    //是否有消息回执，如果有更新消息状态
    NSString *elementId = [[[message elementForName:@"received"] attributeForName:@"id"]stringValue];
    if ([[message elementForName:@"received"].xmlns isEqualToString:@"urn:xmpp:receipts"] && !isEmptyString(elementId)) {
        
        // 保存message到数据库
        XMPPMessageArchivingCoreDataStorage *storage = [ZFZXMPPManager sharedManager].messageArchivingCoreDataStorage;
        //上下文
        NSManagedObjectContext *context =storage.mainThreadManagedObjectContext;
        NSEntityDescription *messageEntity = [NSEntityDescription entityForName:storage.messageEntityName inManagedObjectContext:context];
        
        
        NSString *predicateFrmt = @"bareJidStr == %@ AND outgoing == %@ AND streamBareJidStr == %@";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,
                                  message.from.bare, @(1),
                                  message.to.bare];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = messageEntity;
        fetchRequest.predicate = predicate;
        fetchRequest.sortDescriptors = @[sortDescriptor];
        //fetchRequest.fetchLimit = 1;
        
        NSError *error = nil;
        NSArray *results = [storage.mainThreadManagedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if (results != nil || !error)
        {
            //遍历消息
            for(XMPPMessageArchiving_Message_CoreDataObject *messageData in results){
                if([messageData.message.elementID isEqualToString:elementId]){
//                    XMPPMessage *generatedReceiptResponse = [self generateReceiptResponse:message];
//                    [sender sendElement:generatedReceiptResponse];
                    //更新消息回执状态
                    //NSString *messageStr = messageData.messageStr;
                    XMPPMessage *messageModel = messageData.message;
                    //如果是单聊，添加已读状态
                    if ([messageModel.type isEqualToString:@"chat"]) {
                        [[messageModel elementForName:@"readStatus"] setStringValue:@"已读"];
                    }else if ([messageModel.type isEqualToString:@"groupchat"]){//如果是群聊
                        //创建一个已读人节点
                        //XMPPJID *myjid = [ZFZXMPPManager sharedManager].stream.myJID;
                        NSString *name = message.from.resource;
                        DDXMLElement *readerItem = [[DDXMLElement alloc]initWithName:@"readerItem" stringValue:name];
                        //判断是否已经添加过
                        NSArray<DDXMLElement *> *readerArray = (NSArray<DDXMLElement *> *)[[messageModel elementForName:@"readPersonnel"] children];
                        
                        //查询已读数组中是否包含该成员
                        NSInteger i;
                        for(i=0;i < readerArray.count;i++){
                            if ([[readerArray[i] stringValue] isEqualToString:name]) {
                                break;
                            }
                        }
                        if (i < readerArray.count) {
                            //已经添加到已读数组不再添加
                            return;
                        }
                        [readerArray containsObject:readerItem];
                        
                        [[messageModel elementForName:@"readPersonnel"]addChild:readerItem];
                        //获取当前房间成员人数
                        NSInteger sum;
                        if (self.curRoom.roomMembers && self.curRoom.roomMembers.count>0) {
                            sum = self.curRoom.roomMembers.count-1;
                        }else{
                            sum = 0;
                        }
                        
                        //获取已读人数
                        NSInteger readerCount = [[messageModel elementForName:@"readPersonnel"] childCount];
                        [[messageModel elementForName:@"readStatus"] setStringValue:[NSString stringWithFormat:@"%zd人未读",sum - readerCount]];
                    }
                    
                    //如果是群聊，添加已读成员jid
                    messageData.message = messageModel;
                    
                    [context save:nil];
                    
                    NSLog(@"发送改变已读状态的信号，已经发送信号：%@",messageModel.body);
                    //发通知更新页面
//                    [self.messageDeliveryCommand execute:[self messageFormatting:messageData isLast:NO]];
                    [self.messageDeliverySubject sendNext:[self messageFormatting:messageData isLast:NO]];
                    break;
                }
            }
        }
    }
}

#pragma mark- 收到消息时发送回执后变更消息已读状态
- (void)receiveMessageUpdateStatus:(XMPPMessage *)recevieMessage{
    NSString *elementId = recevieMessage.elementID;
    if (isEmptyString(elementId)) {
        return;
    }
    
    XMPPMessageArchivingCoreDataStorage *storage = [ZFZXMPPManager sharedManager].messageArchivingCoreDataStorage;
    //上下文
    NSManagedObjectContext *context =storage.mainThreadManagedObjectContext;
    NSEntityDescription *messageEntity = [NSEntityDescription entityForName:storage.messageEntityName inManagedObjectContext:context];
    
    
    NSString *predicateFrmt = @"bareJidStr == %@ AND outgoing == %@ AND streamBareJidStr == %@";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,
                              recevieMessage.from.bare, @(0),
                              recevieMessage.to.bare];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = messageEntity;
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[sortDescriptor];
    //fetchRequest.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *results = [storage.mainThreadManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (results != nil || !error)
    {
        //遍历消息
        for(XMPPMessageArchiving_Message_CoreDataObject *messageData in results){
            if([messageData.message.elementID isEqualToString:elementId]){
                //发送消息回执
                //                    XMPPMessage *generatedReceiptResponse = [self generateReceiptResponse:message];
                //                    [sender sendElement:generatedReceiptResponse];
                //更新消息回执状态
                //NSString *messageStr = messageData.messageStr;
                XMPPMessage *messageModel = messageData.message;
                [messageModel addAttributeWithName:@"readStatus" stringValue:@"已读"];
                messageData.message = messageModel;
                
                [context save:nil];
                //发通知更新页面
                //NSLog(@"发送改变已读状态的信号，已经发送信号：%@",messageModel.body);
//                [self.messageDeliveryCommand execute:[self messageFormatting:messageData isLast:NO]];
                break;
            }
        }
    }
}


//生成回执消息
- (XMPPMessage *)generateReceiptResponse:(XMPPMessage *)recevieMessage
{
    // Example:
    //
    // <message to="juliet">
    //   <received xmlns="urn:xmpp:receipts" id="ABC-123"/>
    // </message>
    
    NSXMLElement *received = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    
    NSString *type = [recevieMessage type];
    
    if (type) {
        [message addAttributeWithName:@"type" stringValue:type];
    }
    
    NSString *to = [recevieMessage fromStr];
    if (to)
    {
        [message addAttributeWithName:@"to" stringValue:to];
    }
    
    NSString *msgid = [recevieMessage elementID];
    if (msgid)
    {
        [received addAttributeWithName:@"id" stringValue:msgid];
    }
    
    [message addChild:received];
    
    return [XMPPMessage messageFromElement:message];
}

#pragma mark-发送信息
- (void)sendMessage:(NSString *)messageString statistics:(BOOL) statistics{
    //发送textField  内容 发给curJID
    XMPPMessage * msg;
    //如果是群聊
    if (self.chatType == ZFZChatGroup) {
        if (statistics) {
            msg = [self sendGroupPublicMessage:messageString];
        }else{
            NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            msg = [XMPPMessage messageWithType:@"groupchat" to:self.userJid elementID:timeSp];
            [msg addBody:messageString];
        }
        if(_room){
            [_room sendMessage:msg];
        }
            
        
    }else{
        //msg = [XMPPMessage messageWithType:@"chat" to:self.userJid];
        NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        msg = [XMPPMessage messageWithType:@"chat" to:self.userJid elementID:timeSp];
        DDXMLElement *readStatus = [[DDXMLElement alloc]initWithName:@"readStatus" stringValue:@"已送达"];
        [msg addChild:readStatus];
        [msg addBody:messageString];
        [[ZFZXMPPManager sharedManager].stream sendElement:msg];
    }
    
    
    
}

#pragma mark- 发送群公告消息，可以统计已读人数
- (XMPPMessage *)sendGroupPublicMessage:(NSString *)messageString{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    XMPPMessage * msg = [XMPPMessage messageWithType:@"groupchat" to:self.userJid elementID:timeSp];
    NSXMLElement *receiptRequest = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    //创建已读人员集合
    DDXMLElement *readPersonnel = [[DDXMLElement alloc]initWithName:@"readPersonnel"];
    [msg addChild:readPersonnel];
    //添加需要消息回执的标识
    [msg addChild:receiptRequest];
    //添加 一个消息读取信息readStatus
    
    DDXMLElement *readStatus = [[DDXMLElement alloc]initWithName:@"readStatus" stringValue:[NSString stringWithFormat:@"%zd人未读",self.curRoom.roomMembers.count-1]];
    [msg addChild:readStatus];
    [msg addBody:messageString];
    
    return msg;
}


//创建一个消息
- (CellDataAdapter *)creatMessageWithString:(NSString *)messageStr isOut:(BOOL) outgoing{
    //创建一个最近聊天记录
    ZFZMessageModel *message        = [ZFZMessageModel new];
    ZFZMessageFrame *messageFrame   = [[ZFZMessageFrame alloc]init];
    
    //获取用户名片
    //XMPPvCardTemp *cardTemp = [[ZFZXMPPManager sharedManager].xmppvCardTempModule vCardTempForJID:messageData.bareJid shouldFetch:YES];
    
    //获取用户头像
    NSData *dataavator;
    if (outgoing) {
        dataavator =[[ZFZXMPPManager sharedManager].xmppvCardTempModule myvCardTemp].photo;
    }else{
        dataavator = [[ZFZXMPPManager sharedManager].xmppvCardAvatarModule photoDataForJID:self.userJid];
    }
    
    
    //isOutgoing为YES时说明是自己发送的消息，反之为别人发送的消息
    message.type = outgoing ? ZFZMessageTypeMe : ZFZMessageTypeOther ;
    UIImage *image = [UIImage imageWithData:dataavator];
    message.iconImage = [image setRadius:27 size:CGSizeMake(55, 55)];
    message.text = messageStr;
    
    //判断是否是连续聊天
    NSDate *temDate = [NSDate date];
    
    if (![self isCurDate:temDate]) {
        message.time = [self transfromDate:temDate];
    }
    curDate = temDate;
    
    messageFrame.message = message;
    
    return [ZFZMessageCell dataAdapterWithCellReuseIdentifier:nil data:messageFrame cellHeight:100 type:0];
}


#pragma mark - 头像更改代理方法
-(void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule didReceivePhoto:(UIImage *)photo forJID:(XMPPJID *)jid
{
    // 1.2获取数据
    // 2.刷新表格
    NSArray *messageData = [self messageDataFormatting:self.fetchedResultsController.fetchedObjects];
//    [self.updateMessageSubject sendNext:messageData];
//    [self.updateMessageSubject sendCompleted];
    [self.updateMessageCommand execute:messageData];
    
    
}

#pragma mark- message更新信号
- (RACCommand *)updateMessageCommand{
    if (!_updateMessageCommand) {
        _updateMessageCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
            return signal;
        }];
    }
    return _updateMessageCommand;
}

#pragma mark- message回执状态改变信号
//- (RACCommand *)messageDeliveryCommand{
//    if (!_messageDeliveryCommand) {
//        _messageDeliveryCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//                [subscriber sendNext:input];
//                //[subscriber sendCompleted];
//
//                return [RACDisposable disposableWithBlock:^{
//                    NSLog(@"回执状态改变信号销毁");
//                }];
//            }];
//            return signal;
//        }];
//    }
//    return _messageDeliveryCommand;
//}

- (RACSubject *)messageDeliverySubject{
    if (!_messageDeliverySubject) {
        _messageDeliverySubject = [[RACSubject alloc]init];
    }
    return _messageDeliverySubject;
}

//- (RACSubject *)updateMessageSubject{
//    if (!_updateMessageSubject) {
//        _updateMessageSubject = [RACSubject subject];
//    }
//    return  _updateMessageSubject;
//}

- (XMPPJID *)userJid{
    if (!_userJid) {
        _userJid = self.params[@"userJid"];
    }
    return _userJid;
}


- (RACCommand *)sendMessageCommand{
    if (!_sendMessageCommand) {
//        @weakify(self)
        WeakSelf
        _sendMessageCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                //@strongify(self)
                [weakSelf sendMessage:input statistics:NO];
                [subscriber sendCompleted];
                return [RACDisposable disposableWithBlock:^{
                    NSLog(@"发送表情的信号被销毁了");
                }];
            }]takeUntil:weakSelf.rac_willDeallocSignal];
            
            return signal;
        }];
    }
    return _sendMessageCommand;
}

//- (RACSubject *)sendMessageSubject{
//    //@weakify(self)
//    WeakSelf
//    if (!_sendMessageSubject) {
//        _sendMessageSubject = [RACSubject subject];
//        [_sendMessageSubject subscribeNext:^(id  _Nullable x) {
//            //@strongify(self)
//            [weakSelf sendMessage:x];
//        }];
//    }
//    return _sendMessageSubject;
//}



- (RACCommand *)receiveMessageCommand{
    if (!_receiveMessageCommand) {
        WeakSelf
        _receiveMessageCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                
                return [RACDisposable disposableWithBlock:^{
                    NSLog(@"接收消息的信号被销毁了");
                }];
            }]takeUntil:weakSelf.rac_willDeallocSignal];
            return signal;
        }];
    }
    return  _receiveMessageCommand;
    
}

#pragma mark-加载数据的操作
- (RACCommand *)loadMessageCommand{
    if (!_loadMessageCommand) {
        WeakSelf
        _loadMessageCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSInteger start = [input integerValue];
                NSArray *messageArry = [weakSelf resultsMessageWithLimit:10 offset:start];
                [subscriber sendNext:messageArry];
                [subscriber sendCompleted];
                
                return [RACDisposable disposableWithBlock:^{
                    NSLog(@"加载数据的信号被销毁了");
                }];
            }] takeUntil:weakSelf.rac_willDeallocSignal];
            return signal;
        }];
    }
    return _loadMessageCommand;
}

- (ZFZChatType)chatType{
    return [self.params[@"chatType"] integerValue];
}

- (void)dealloc{
    NSLog(@"销毁了聊天ViewMoodel");
    //开启后台运行当前房间的消息回执
    [ZFZXMPPManager sharedManager].curDeliveryReceiptsJid = nil;
}

@end
