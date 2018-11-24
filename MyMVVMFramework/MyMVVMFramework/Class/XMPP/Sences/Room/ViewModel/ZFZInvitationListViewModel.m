//
//  ZFZInvitationListViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/22.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZInvitationListViewModel.h"
#import "ZFZInvitationModel.h"
#import "ZFZRoomInvitationCell.h"
#import "ZFZRoomManager.h"
#import "UIImage+RoundImage.h"
#import "XMPPConfig.h"

@interface ZFZInvitationListViewModel ()<NSFetchedResultsControllerDelegate,XMPPRoomDelegate>
///  从数据库中请求数据的类
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) ZFZInvitationModel *curInvitation;
@end

@implementation ZFZInvitationListViewModel
- (void)initialize{
    //删除缓存
    [NSFetchedResultsController deleteCacheWithName:@"InvitationMessage"];
    // 1.获取最近联系人的数据
    // 1.1执行请求
    [self.fetchedResultsController performFetch:nil];
    // 1.2获取数据
    self.items = (NSMutableArray <CellDataAdapter *> *)[self invitationDataFormatting:self.fetchedResultsController.fetchedObjects];
    //设置头像更新代理
    [[ZFZXMPPManager sharedManager].xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //[[ZFZRoomManager shareInstance] loadRooms];
    
    
}


- (NSMutableArray <CellDataAdapter *> *)invitationDataFormatting:(NSArray<XMPPMessageArchiving_Message_CoreDataObject *> *)invitationDataList{
    NSMutableArray * tempArry = [NSMutableArray arrayWithCapacity:invitationDataList.count];
    if (invitationDataList && invitationDataList.count > 0) {
        for (XMPPMessageArchiving_Message_CoreDataObject *invitation in invitationDataList) {
            //创建房间邀请
            ZFZInvitationModel *roomInvitationModel = [[ZFZInvitationModel alloc]init];
            
            //roomInvitationModel.roomJid = invitation.bareJid;
            
            XMPPMessage *invitationMessage = invitation.message;
            XMPPJID *fromJid;
            NSString *reasonStr;
            roomInvitationModel.agreementStatus = [invitationMessage attributeIntegerValueForName:@"status"];
            roomInvitationModel.message = invitationMessage;
            roomInvitationModel.invitationType = ZFZGroupsInvitation;
            for (DDXMLElement *invite in invitationMessage.children){
                //获取邀请对象
                if ([invite.name isEqualToString:@"invite"]) {
                    //解析邀请消息
                    NSString *fromStr = [invite attributeStringValueForName:@"from"];
                    fromJid = [XMPPJID jidWithString:fromStr];
                    roomInvitationModel.inviterJid = fromJid;
                    NSString *roomJidStr = [invite attributeStringValueForName:@"roomJid"];
                    roomInvitationModel.roomJid = [XMPPJID jidWithString:roomJidStr];
                    //获取邀请理由
                    for (DDXMLElement *reason in invite.children) {
                        if ([reason.name isEqualToString:@"reason"]) {
                            reasonStr = reason.stringValue;
                            roomInvitationModel.reason = reasonStr;
                            break;
                        }
                    }
                    
                    break;
                }
            }
            //roomInvitationModel.agreementStatus = ZFZUnprocessed;
            
            CellDataAdapter * roomInvtation = [self invitationFormatting:roomInvitationModel];
            
            [tempArry addObject:roomInvtation];
        }
    }
    return [tempArry mutableCopy];

}

- (CellDataAdapter *)invitationFormatting:(ZFZInvitationModel *)invitation{
    return [ZFZRoomInvitationCell dataAdapterWithCellReuseIdentifier:nil data:invitation cellHeight:100 type:0];
}

#pragma mark - 数据库数据更新代理方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // 1.获取最新的数据
    //self.recentlyDataList = self.fetchedResultsController.fetchedObjects;
    // 2.刷新表格
    self.items = [self invitationDataFormatting:self.fetchedResultsController.fetchedObjects];
    [self.updateInvitationSubject sendNext:self.items];
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@ AND streamBareJidStr like %@", self.invitationJid.bare,myJid];
        request.predicate = predicate;
        // 排序  升序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
        request.sortDescriptors = @[sort];
        // 创建请求数据的控制器
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:storage.mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"InvitationMessage"];
        
        
        //        NSError *error = nil;
        //        NSArray *fetchedObjects = [storage.mainThreadManagedObjectContext executeFetchRequest:request error:&error];
        //        if (fetchedObjects != nil) {
        //            NSArray *testDataArry = [self messageDataFormatting: fetchedObjects];
        //            //        [NSMutableArray arrayWithArray:fetchedObjects];
        //        }
        
        // 设置代理
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

- (XMPPJID *)invitationJid{
    return self.params[@"inviterJid"];
}

- (RACCommand *)jionRoomCommand{
    if (!_jionRoomCommand) {
//        @weakify(self)
        _jionRoomCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(ZFZInvitationModel* input) {
//            @strongify(self)
            
            
            //加入房间成功后返回消息
            RACSignal *jionsuccessSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                //加入房间
                XMPPJID *roomJid = input.roomJid;
                NSString *nickName = [ZFZXMPPManager sharedManager].stream.myJID.user;
                
                NSLog(@"加入房间:%@,nickName:%@",roomJid.user,nickName);
                
                [[ZFZRoomManager shareInstance]JoinOrCreateRoomWithRoomJID:roomJid andNickName:nickName];
                XMPPMessage *message = input.message;
                [message removeAttributeForName:@"status"];
                [message addAttributeWithName:@"status" integerValue:ZFZAgreeWith];
                
                //更新状态
                //[[ZFZXMPPManager sharedManager].messageArchivingCoreDataStorage arc
                [[ZFZXMPPManager sharedManager].messageArchivingCoreDataStorage archiveUpdateMessage:message outgoing:NO xmppStream:[ZFZXMPPManager sharedManager].stream];
                
                [subscriber sendNext:@1];
                [subscriber sendCompleted];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
            return jionsuccessSignal;
        }];
    }
    return _jionRoomCommand;
}

- (RACCommand *)rejectJionRoomCommand{
    if (!_rejectJionRoomCommand) {
        _rejectJionRoomCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            
            RACSignal *rejectJionsuccessSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSString *inviterJid = input[@"inviterJid"];
                NSString *reason = input[@"reason"];
                
                DDXMLElement *body = [[DDXMLElement alloc]initWithName:@"body" xmlns:reason];
                XMPPMessage *message = [XMPPMessage messageWithType:@"Decline" elementID:@"body" child:body];
                [message addAttributeWithName:@"from" stringValue:inviterJid];
                [[ZFZXMPPManager sharedManager].stream sendElement:message];
                
                [subscriber sendNext:0];
                [subscriber sendCompleted];
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
            return rejectJionsuccessSignal;
        }];
    }
    return _rejectJionRoomCommand;
}

- (RACSubject *)jionRoomSubject{
    if (!_jionRoomSubject) {
        @weakify(self)
        _jionRoomSubject = [[RACSubject alloc]init];
        [_jionRoomSubject subscribeNext:^(ZFZInvitationModel* input) {
            @strongify(self)
            //加入房间
            XMPPJID *roomJid = input.roomJid;
            NSString *nickName = [ZFZXMPPManager sharedManager].stream.myJID.user;
            
            NSLog(@"加入房间:%@,nickName:%@",roomJid.user,nickName);
            
            self.curInvitation = input;
            [[ZFZRoomManager shareInstance]JoinOrCreateRoomWithRoomJID:roomJid andNickName:nickName delegate:self];
            
        }];
    }
    return _jionRoomSubject;
}

- (RACSubject *)rejectJionRoomSubject{
    if (!_rejectJionRoomSubject) {
        _rejectJionRoomSubject = [[RACSubject alloc]init];
        
        [_rejectJionRoomSubject subscribeNext:^(id  _Nullable x) {
            NSString *inviterJid = x[@"inviterJid"];
            NSString *reason = x[@"reason"];
            
            DDXMLElement *body = [[DDXMLElement alloc]initWithName:@"body" xmlns:reason];
            XMPPMessage *message = [XMPPMessage messageWithType:@"Decline" elementID:@"body" child:body];
            [message addAttributeWithName:@"from" stringValue:inviterJid];
            [[ZFZXMPPManager sharedManager].stream sendElement:message];
        }];
    }
    return _rejectJionRoomSubject;
}

//加入房间成功
- (void)xmppRoomDidJoin:(XMPPRoom *)sender{
    if ([sender.roomJID.user isEqualToString:self.curInvitation.roomJid.user]) {
        XMPPMessage *message = self.curInvitation.message;
        [message removeAttributeForName:@"status"];
        [message addAttributeWithName:@"status" integerValue:ZFZAgreeWith];
        self.curInvitation.agreementStatus = 1;
        
        //更新状态
        //[[ZFZXMPPManager sharedManager].messageArchivingCoreDataStorage arc
        [[ZFZXMPPManager sharedManager].messageArchivingCoreDataStorage archiveUpdateMessage:message outgoing:NO xmppStream:[ZFZXMPPManager sharedManager].stream];
        
        //将房间加入房间列表
        ZFZRoomModel *room = [[ZFZRoomModel alloc]init];
        room.roomName = sender.roomJID.user;
        room.roomjid = sender.roomJID.full;
        UIImage * iconImage = [[UIImage imageNamed:@"army6"] setRadius:27 size:CGSizeMake(55, 55)];
        room.phton = iconImage;
        
        [[ZFZRoomManager shareInstance].roomList addObject:room];  //array  就是你的群列表
        
        [self.reloadDataSubject sendNext:nil];
        [self.updateInvitationStatusSubject sendNext:self.curInvitation];
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:ZFZRoomListChangNotice object:nil];
    }
    
}

- (RACSubject *)updateInvitationStatusSubject{
    if (!_updateInvitationStatusSubject) {
        _updateInvitationStatusSubject = [[RACSubject alloc]init];
    }
    return _updateInvitationStatusSubject;
}

- (RACSubject *)reloadDataSubject{
    if (!_reloadDataSubject) {
        _reloadDataSubject = [[RACSubject alloc]init];
    }
    return _reloadDataSubject;
}

@end
