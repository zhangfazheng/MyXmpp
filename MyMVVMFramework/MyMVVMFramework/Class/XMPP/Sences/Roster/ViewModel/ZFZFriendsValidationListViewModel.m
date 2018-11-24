//
//  ZFZFriendsValidationListViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/26.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZFriendsValidationListViewModel.h"
#import "ZFZFriendsValidationModel.h"
#import "ZFZFriendsValidationCell.h"

@interface ZFZFriendsValidationListViewModel ()<NSFetchedResultsControllerDelegate>
///  从数据库中请求数据的类
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ZFZFriendsValidationListViewModel
- (void)initialize{
    //删除缓存
    [NSFetchedResultsController deleteCacheWithName:@"FriendsValidationMessage"];
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
            ZFZFriendsValidationModel *friendsValidationModel = [[ZFZFriendsValidationModel alloc]init];
            
            //roomInvitationModel.roomJid = invitation.bareJid;
            
            XMPPMessage *invitationMessage = invitation.message;
            friendsValidationModel.agreementStatus = [invitationMessage attributeIntegerValueForName:@"status"];
            friendsValidationModel.message = invitationMessage;
            
            XMPPJID *fromJid;
            NSString *reasonStr;
            for (DDXMLElement *body in invitationMessage.children){
                //获取邀请对象
                if ([body.name isEqualToString:@"body"]) {
                    //解析邀请消息
                    NSString *friendJidStr = [body attributeStringValueForName:@"friendJid"];
                    fromJid = [XMPPJID jidWithString:friendJidStr];
                    friendsValidationModel.friendJid = fromJid;
                    reasonStr = body.stringValue;
                    friendsValidationModel.reason = reasonStr;
                    
                    break;
                }
            }
            //friendsValidationModel.agreementStatus = ZFZUnprocessed;
            
            CellDataAdapter * friendsValidation = [self invitationFormatting:friendsValidationModel];
            
            [tempArry addObject:friendsValidation];
        }
    }
    return [tempArry mutableCopy];
    
}

- (CellDataAdapter *)invitationFormatting:(ZFZFriendsValidationModel *)invitation{
    return [ZFZFriendsValidationCell dataAdapterWithCellReuseIdentifier:nil data:invitation cellHeight:100 type:0];
}

#pragma mark - 数据库数据更新代理方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // 1.获取最新的数据
    //self.recentlyDataList = self.fetchedResultsController.fetchedObjects;
    // 2.刷新表格
    NSArray *invitationData = [self invitationDataFormatting:self.fetchedResultsController.fetchedObjects];
    [self.updateFriendsValidationSubject sendNext:invitationData];
}


//懒加载数据库更新监听对象
- (NSFetchedResultsController *)fetchedResultsController{
    if (!_fetchedResultsController) {
        // 创建请求对象
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        // 实体 -->从哪里获取数据
        XMPPMessageArchivingCoreDataStorage *storage = [ZFZXMPPManager sharedManager].messageArchivingCoreDataStorage;

        request.entity = [NSEntityDescription entityForName:storage.messageEntityName inManagedObjectContext:storage.mainThreadManagedObjectContext];
        
        // 谓词 -->获取哪些数据   不用写谓词 因为要获取所有的最近联系人的数据

        NSString *myJid = [[ZFZXMPPManager sharedManager].stream myJID].bare;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@ AND streamBareJidStr like %@", self.validationJid.bare,myJid];
        request.predicate = predicate;
        // 排序  升序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
        request.sortDescriptors = @[sort];
        // 创建请求数据的控制器
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:storage.mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"FriendsValidationMessage"];
        
        
        // 设置代理
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

- (XMPPJID *)validationJid{
    return self.params[@"validationJid"];
}

- (RACCommand *)addFriendCommand{
    if (!_addFriendCommand) {
        _addFriendCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(ZFZInvitationModel* input) {
            //            @strongify(self)
            
            
            //加入房间成功后返回消息
            RACSignal *addsuccessSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                //加入房间
                XMPPJID *friendJid = input.roomJid;
                NSString *nickName = [ZFZXMPPManager sharedManager].stream.myJID.user;
                NSString *groupName = input.groupName;
                
                NSLog(@"加入好友:%@,nickName:%@",friendJid.user,nickName);
                
                //将好友添加到好友列表
                [[ZFZXMPPManager sharedManager].roster addUser:friendJid withNickname:nickName groups:@[groupName] subscribeToPresence:YES];
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
            return addsuccessSignal;
        }];

    }
    return _addFriendCommand;
}

- (RACSubject *)addFriendSubject{
    if (!_addFriendSubject) {
        _addFriendSubject = [[RACSubject alloc]init];
        [_addFriendSubject subscribeNext:^(ZFZInvitationModel*  x) {
            //加入房间
            XMPPJID *friendJid = x.inviterJid;
            NSString *nickName = x.nickName;
            NSString *groupName = x.groupName;
            
            NSLog(@"加入好友:%@,nickName:%@",friendJid.user,nickName);
            
            //将好友添加到好友列表
            
            [[ZFZXMPPManager sharedManager].roster addUser:friendJid withNickname:nickName groups:@[groupName] subscribeToPresence:NO];
            XMPPMessage *message = x.message;
            [message removeAttributeForName:@"status"];
            [message addAttributeWithName:@"status" integerValue:ZFZAgreeWith];
            
            //更新状态
            //[[ZFZXMPPManager sharedManager].messageArchivingCoreDataStorage arc
            [[ZFZXMPPManager sharedManager].messageArchivingCoreDataStorage archiveUpdateMessage:message outgoing:NO xmppStream:[ZFZXMPPManager sharedManager].stream];
        }];
    }
    return _addFriendSubject;
}

@end
