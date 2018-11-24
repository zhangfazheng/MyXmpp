//
//  ZFZFriendsListViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/1.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZFriendsListViewModel.h"
#import "ZFZXMPPManager.h"
#import "UIImage+RoundImage.h"
#import "ZFZFriendCell.h"
#import "ZFZMemberModel.h"
#import <ChameleonFramework/Chameleon.h>


@interface ZFZFriendsListViewModel ()<NSFetchedResultsControllerDelegate,XMPPRosterDelegate>
///  从数据库中请求数据的类
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic , strong)XMPPRoster *currentRoster;
@property (nonatomic , strong)XMPPPresence *currentPresence;
@end

@implementation ZFZFriendsListViewModel

- (void)initialize{
    //删除缓存
    [NSFetchedResultsController deleteCacheWithName:@"Contacts"];
    //拿到工具类单例 多播代理
    [[ZFZXMPPManager sharedManager].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //好友模块多播代理
    [[ZFZXMPPManager sharedManager].roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [[ZFZXMPPManager sharedManager].xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //执行查询结果控制器
    [self.fetchedResultsController performFetch:nil];
    
    // 执行了上面的代码，游离态数据我们可以立即拿到~
    //self.friendsList = (NSMutableArray <CellDataAdapter *> *)[self friendDataFormatting:self.fetchedResultsController.fetchedObjects];
    
    //NSMutableArray * groupList = [NSMutableArray arrayWithCapacity:1];
    //ZFZFriendGroupModel *group = [self friendGroupFormatting:self.friendsList];
    //[groupList addObject:group];
    self.groupList = [self groupListFormatting:self.fetchedResultsController.fetchedObjects];
   

}

//对最近聊天记录进行格式化
- (NSArray *)friendDataFormatting:(NSSet<XMPPUserCoreDataStorageObject *> *)messageDataList{
    NSMutableArray * tempArry = [NSMutableArray arrayWithCapacity:messageDataList.count];
    if (messageDataList && messageDataList.count > 0) {
        for (XMPPUserCoreDataStorageObject *messageData in messageDataList) {
            CellDataAdapter * friend = [self friendFormatting:messageData];
            
            [tempArry addObject:friend];
        }
    }
    return [tempArry mutableCopy];
}

- (ZFZFriendGroupModel *)friendGroupFormatting:(NSMutableArray <CellDataAdapter *> *)friendGroup name:(NSString *)name onlineCount:(NSInteger) onlineCount{
    ZFZFriendGroupModel *group = [[ZFZFriendGroupModel alloc]init];
    group.friends = friendGroup;
    group.name = name;
    group.onlineCount = onlineCount;
    
    return group;
    
}


//聊天信息数据转模型
- (CellDataAdapter *)friendFormatting:(XMPPUserCoreDataStorageObject *)friendData{
    //创建一个最近聊天记录
    ZFZFriendModel *friendInstance        = [ZFZFriendModel new];
    
    
    //获取用户名片
    //XMPPvCardTemp *cardTemp = [[ZFZXMPPManager sharedManager].xmppvCardTempModule vCardTempForJID:messageData.bareJid shouldFetch:YES];
    friendInstance.jid = friendData.jidStr;
    //获取用户头像
    friendInstance.name = friendData.nickname ? friendData.nickname : friendData.jid.user;
//    if (!friendData.photo) {
//        UIImage * iconImage = [[UIImage imageNamed:@"army6"] setRadius:27 size:CGSizeMake(55, 55)];
//        friendInstance.phton = iconImage;
//    }else{
//        friendInstance.phton = [friendData.photo setRadius:27 size:CGSizeMake(55, 55)];
//    }
    NSString *iconText = [friendInstance.name substringWithRange:NSMakeRange((friendInstance.name.length-2), 2)];
    UIImage *image = [UIImage drawImageRadius:RadiusMake(25, 25, 25, 25) size:CGSizeMake(50, 50) backgroundColor:RandomFlatColor text:iconText];
    friendInstance.phton = image;
    
    friendInstance.isEnable =YES;
    
    //选择类型设置
    NSArray<ZFZMemberModel *> *oldFriendArry = self.params[@"oldFriend"];
    if (oldFriendArry && oldFriendArry.count) {
        for (ZFZMemberModel *member in oldFriendArry) {
            //如果成员是否已经被添加为好友
            if ([member.jid isEqualToString:friendData.jidStr]) {
                friendInstance.friendSelectType = ZFZUnenable;
                break;
            }
        }
    }
    
    XMPPResourceCoreDataStorageObject *friendResource = friendData.primaryResource;
    NSString *show = friendResource.show;
    
    if([show isEqualToString:@"online"]){
        friendInstance.isPresence = YES;
        friendInstance.presenceStatus = [NSString stringWithFormat:@"%@在线",friendResource.status];
    }else{
        if (friendResource.presence) {
            friendInstance.isPresence = YES;
            friendInstance.presenceStatus = friendResource.presence.status;
        }else{
            friendInstance.presenceStatus = @"离线";
            friendInstance.isPresence = NO;
        }
        
    }
    NSCAssert(!isEmptyString(self.params[@"cellReuseIdentifier"]), @"%s viewModel的params的缺少cellReuseIdentifier键值",__PRETTY_FUNCTION__);
    
    CellDataAdapter *adapter = [ZFZFriendCell dataAdapterWithCellReuseIdentifier:self.params[@"cellReuseIdentifier"] data:friendInstance cellHeight:100 type:0];
    
    return adapter;
}

//懒加载数据库更新监听对象
- (NSFetchedResultsController *)fetchedResultsController{
    if (!_fetchedResultsController) {
        // 创建请求对象
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        // 实体 -->从哪里获取数据
        XMPPRosterCoreDataStorage *storage = [ZFZXMPPManager sharedManager].xmppRosterCoreDataStorage;
        //        request.entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        //注意这里必须有排序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        request.sortDescriptors = @[sort];
        
        request.entity = [NSEntityDescription entityForName:@"XMPPGroupCoreDataStorageObject" inManagedObjectContext:storage.mainThreadManagedObjectContext];
        
        // 创建请求数据的控制器
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:storage.mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"Contacts"];
        
        // 设置代理
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

//- (NSFetchedResultsController *)fetchedResultsController{
//    if (!_fetchedResultsController) {
//        // 创建请求对象
//        NSFetchRequest *request = [[NSFetchRequest alloc] init];
//        // 实体 -->从哪里获取数据
//        XMPPRosterCoreDataStorage *storage = [ZFZXMPPManager sharedManager].xmppRosterCoreDataStorage;
//        //        request.entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
//        request.entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:storage.mainThreadManagedObjectContext];
//        
//        // 谓词 -->获取哪些数据   不用写谓词 因为要获取所有的最近联系人的数据
//        //        request.predicate = [NSPredicate predicateWithFormat:@""];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"subscription = %@", @"both"];
//        request.predicate = predicate;
//        //注意这里必须有排序
//        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"jidStr" ascending:YES];
//        request.sortDescriptors = @[sort];
//        // 创建请求数据的控制器
//        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:storage.mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"Contacts"];
//        
//        // 设置代理
//        _fetchedResultsController.delegate = self;
//    }
//    return _fetchedResultsController;
//}


- (RACSubject *)updateContactsSubject{
    if (!_updateContactsSubject) {
        _updateContactsSubject = [RACSubject subject];
    }
    return _updateContactsSubject;
}

#warning 查询控制器代理方法
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
//    NSMutableArray <CellDataAdapter *> * friendsList = (NSMutableArray <CellDataAdapter *> *)[self friendDataFormatting:self.fetchedResultsController.fetchedObjects];
//    ZFZFriendGroupModel *group = [self friendGroupFormatting:friendsList];
//    self.groupList = @[group];
    NSArray *groups = self.fetchedResultsController.fetchedObjects;
    
    self.groupList = [self groupListFormatting:groups];
    
//    NSMutableArray <CellDataAdapter *> * friendsList = (NSMutableArray <CellDataAdapter *> *)[self friendDataFormatting:self.fetchedResultsController.fetchedObjects];
//    ZFZFriendGroupModel *group = [self friendGroupFormatting:friendsList name:group.name];
//    self.groupList = @[group];

}

- (NSArray <ZFZFriendGroupModel *> *)groupListFormatting:(NSArray<XMPPGroupCoreDataStorageObject *>*)groupData{
    NSMutableArray *groupModelArry = [NSMutableArray arrayWithCapacity:groupData.count];
    for (XMPPGroupCoreDataStorageObject *group in groupData) {
        NSMutableArray <CellDataAdapter *> * friendsList = (NSMutableArray <CellDataAdapter *> *)[self friendDataFormatting:group.users];
        
        //遍历好友计算在线好友人数
        NSInteger onlineCount = 0;
        for (CellDataAdapter *data in friendsList) {
            ZFZFriendModel * friend = (ZFZFriendModel *)data.data;
            if (friend.isPresence) {
                onlineCount++;
            }
        }
        
        ZFZFriendGroupModel *groupModel = [self friendGroupFormatting:friendsList name:group.name onlineCount:onlineCount];
        [groupModelArry addObject:groupModel];
        
    }
    return [groupModelArry copy];
}

#pragma mark- 收到好友出席状态
//收到对方取消定阅我得消息
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    //收到对方取消定阅我得消息
    if ([presence.type isEqualToString:@"unsubscribe"]) {
        //从我的本地通讯录中将他移除
        [[ZFZXMPPManager sharedManager].roster removeUser:presence.from];
    }else{
        if (presence.from && self.groupList.count > 0) {
            for (ZFZFriendGroupModel *group in self.groupList) {
                if (group.friends.count>0) {
                    for (CellDataAdapter *data in group.friends) {
                        ZFZFriendModel * friend = (ZFZFriendModel *) data.data;
                        if ([presence.from.bare isEqualToString:friend.jid]) {
                            if ([presence.type isEqualToString:@"unavailable"] && ![friend.presenceStatus isEqualToString:@"离线"]) {
                                friend.presenceStatus = @"离线";
                                group.onlineCount -= 1;
                                [self.updateContactsSubject sendNext:nil];
                                [self.updateContactsSubject sendCompleted];
                            }else if(!friend.isPresence){
                                friend.presenceStatus = presence.status;
                                group.onlineCount += 1;
                                [self.updateContactsSubject sendNext:nil];
                                [self.updateContactsSubject sendCompleted];
                            }
                            
                            break;
                        }
                        
                    }
                }
                
            }
        }
        
    }
}



//- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item{
//    NSLog(@"收到好友列表:%@",item);
//}
//
//-(void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule didReceivePhoto:(UIImage *)photo forJID:(XMPPJID *)jid
//{
//    
//}

//添加好友
- (void)addFriend:(XMPPJID *)jid nickName:(NSString *)name toGroup:(NSString *)group{
    if (isEmptyString(group)) {
        group = @"我的好友";
    }
    [[ZFZXMPPManager sharedManager].roster addUser:jid withNickname:name groups:@[group]];
}


@end
