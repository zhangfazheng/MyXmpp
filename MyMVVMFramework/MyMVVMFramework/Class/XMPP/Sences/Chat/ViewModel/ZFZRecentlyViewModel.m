//
//  ZFZRecentlyViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/15.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRecentlyViewModel.h"
#import "ZFZXMPPManager.h"
#import "ZFZRecentlyTableViewCell.h"
#import "ZFZRecentlyModel.h"
#import "NSDate+Helper.h"
#import "XMPPConfig.h"
#import "ZFZRoomManager.h"
#import "UIImage+RoundImage.h"
#import <ChameleonFramework/Chameleon.h>
#import "ViewControllerHelper.h"
#import "ZFZChatTableViewController.h"

@interface ZFZRecentlyViewModel ()<NSFetchedResultsControllerDelegate>
///  从数据库中请求数据的类
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
/////  最近联系人的所有数据
@property (nonatomic, strong) NSMutableDictionary *recentlyDataDict;

///好友列表
//@property (nonatomic, retain) NSMutableArray    *contacts;

@end

@implementation ZFZRecentlyViewModel

- (void)initialize{
    // 1.获取最近联系人的数据
    // 1.1执行请求
    [self.fetchedResultsController performFetch:nil];
    // 1.2获取数据
    self.items = (NSMutableArray <CellDataAdapter *> *)[self recentlyDataFormatting:self.fetchedResultsController.fetchedObjects];
    //设置头像更新代理
    [[ZFZXMPPManager sharedManager].xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //[[ZFZRoomManager shareInstance] loadRooms];
    
}


//设置数据请求信号
//- (RACSignal *)executeRequestDataSignal:(id)input{
//    RACSignal *getDataSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        
//        // 1.获取最近联系人的数据
//        // 1.1执行请求
//        [self.fetchedResultsController performFetch:nil];
//        // 1.2获取数据
//        self.recentlyDataList = self.fetchedResultsController.fetchedObjects;
//        
//        [subscriber sendNext:self.fetchedResultsController.fetchedObjects];
//        [subscriber sendCompleted];
//        
//        return [RACDisposable disposableWithBlock:^{
//            
//        }];
//        
//    }];
//    
//    return getDataSignal;
//}

//#pragma mark - 获取好友列表代理方法
///**
// * 开始同步服务器发送过来的自己的好友列表
// **/
//- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
//{
//    
//}
//
///**
// * 同步结束
// **/
////收到完好好友列表后会进入的方法，并且已经存入我的存储器
//- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
//{
//    //从存储器中取出我得好友数组，更新数据源
//    self.contacts = [NSMutableArray arrayWithArray:[ZFZXMPPManager sharedManager].xmppRosterMemoryStorage.unsortedUsers];
//}
//
////收到每一个好友
//- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item
//{
//    
//}

//// 如果不是初始化同步来的roster,那么会自动存入我的好友存储器
//- (void)xmppRosterDidChange:(XMPPRosterMemoryStorage *)sender
//{
//    //从存储器中取出我得好友数组，更新数据源
//    self.contacts = [NSMutableArray arrayWithArray:[ZFZXMPPManager sharedManager].xmppRosterMemoryStorage.unsortedUsers];
//}


#pragma mark- NSFetchedResultsControllerDelegate
- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        // 创建请求对象
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        // 实体 -->从哪里获取数据
        request.entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        
        // 谓词 -->获取哪些数据   不用写谓词 因为要获取所有的最近联系人的数据
        NSString *myJid = [[ZFZXMPPManager sharedManager].stream myJID].bare;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@", myJid];
        [request setPredicate:predicate];
        // 排序  降序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"mostRecentMessageTimestamp" ascending:NO];
        request.sortDescriptors = @[sort];
        // 创建请求数据的控制器
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        // 设置代理
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // 1.获取最新的数据
    //self.recentlyDataList = self.fetchedResultsController.fetchedObjects;
    // 2.刷新表格
    NSArray *recentlyData = [self recentlyDataFormatting:self.fetchedResultsController.fetchedObjects];
    [self.updateArchivingSubject sendNext:recentlyData];
}


//对最近聊天记录进行格式化
- (NSArray *)recentlyDataFormatting:(NSArray<XMPPMessageArchiving_Contact_CoreDataObject *> *)recentlyDataList{
    NSMutableArray * tempArry = [NSMutableArray arrayWithCapacity:recentlyDataList.count];
    if (recentlyDataList && recentlyDataList.count > 0) {
        for (XMPPMessageArchiving_Contact_CoreDataObject *recentlyData in recentlyDataList) {
            //获取当前字典中的消息对象，如果存在
            ZFZRecentlyModel *recently;
            if (self.recentlyDataDict[recentlyData.bareJidStr]) {
                recently = self.recentlyDataDict[recentlyData.bareJidStr];
            }else{
                //创建一个最近聊天记录
                recently = [ZFZRecentlyModel new];
            }
            
            //获取用户名片
            //XMPPvCardTemp *cardTemp = [[ZFZXMPPManager sharedManager].xmppvCardTempModule vCardTempForJID:recentlyData.bareJid shouldFetch:YES];
            
            //获取用户头像
            //NSData *dataavator = [[ZFZXMPPManager sharedManager].xmppvCardAvatarModule photoDataForJID:recentlyData.bareJid];
            
            XMPPUserCoreDataStorageObject *user = [self seachFriendInfoWithJid:recentlyData.bareJid];
            
            
            
            //如果不是同一条消息,并且不在聊天页面，则消息计数加1
            UIViewController *vc = [ViewControllerHelper currentViewController];
            if (![recently.dateTime isEqualToDate:recentlyData.mostRecentMessageTimestamp] && ![vc isKindOfClass:[ZFZChatTableViewController class]]) {
                recently.infoCount ++;
                recently.dateTime = recentlyData.mostRecentMessageTimestamp;
            }
            recently.infoString = recentlyData.mostRecentMessageBody;
            
            //获取好友昵称
            if([recentlyData.bareJid.user isEqualToString:GroupNotice]){
                recently.name = @"群通知";
                recently.jid = recentlyData.bareJid.bare;
                recently.userJid = recentlyData.bareJid;
                recently.chatType = ZFZGroupInvitation;
            }else if([recentlyData.bareJid.user isEqualToString:FriendsValidation]){
                recently.name = @"好友验证";
                recently.jid = recentlyData.bareJid.user;
                
                recently.userJid = recentlyData.bareJid;
                recently.chatType = ZFZFriendsValidation;
                
            }else{
                recently.jid = recentlyData.bareJidStr;
                recently.userJid = recentlyData.bareJid;
                if (user) {
                    recently.name = user.nickname?user.nickname:recentlyData.bareJid.user;
                }else{
                    recently.name = recentlyData.bareJid.user;
                }
                NSString *iconText;
                if (recently.name.length>=2) {
                    iconText = [recently.name substringWithRange:NSMakeRange((recently.name.length-2), 2)];
                }else{
                    iconText = recently.name;
                }
                
                recently.iconImage = [UIImage drawImageRadius:RadiusMake(25, 25, 25, 25) size:CGSizeMake(50, 50) backgroundColor:RandomFlatColor text:iconText];
                
                //判断是否是群聊
                NSString *baseMessage = recentlyData.bareJid.domain;
                if ([[[baseMessage componentsSeparatedByString:@"."] firstObject] isEqualToString:kSubDomin]) {
                    recently.chatType = ZFZChatGroup;
                }else{
                    recently.chatType = ZFZChatSignal;
                }
            }
            
            //创建时间模型
            NSDateFormatter *dateFormatter = [NSDate sharedDateFormatter];
            dateFormatter.dateFormat = @"HH:mm";
            recently.time = [dateFormatter stringFromDate:recentlyData.mostRecentMessageTimestamp];
            
            [self.recentlyDataDict setObject:recently forKey:recently.jid];
            
            [tempArry addObject:[ZFZRecentlyTableViewCell dataAdapterWithCellReuseIdentifier:nil data:recently cellHeight:100 type:0]];
        }
    }
    return [tempArry copy];
}

#pragma mark- 好友昵称查询
- (XMPPUserCoreDataStorageObject *)seachFriendInfoWithJid:(XMPPJID *)jid{
    // 创建请求对象
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 实体 -->从哪里获取数据
    XMPPRosterCoreDataStorage *storage = [ZFZXMPPManager sharedManager].xmppRosterCoreDataStorage;
    //        request.entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
    request.entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:storage.mainThreadManagedObjectContext];
    
     //谓词 -->获取哪些数据   不用写谓词 因为要获取所有的最近联系人的数据
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jidStr like[cd] %@", jid.bare];
    [request setPredicate:predicate];
    //注意这里必须有排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"jidStr" ascending:YES];
    request.sortDescriptors = @[sort];
    
    NSError *error;
    NSArray *result = [storage.mainThreadManagedObjectContext executeFetchRequest:request error:&error];
//    XMPPUserCoreDataStorageObject *obj =  [storage userForJID:jid xmppStream:[ZFZXMPPManager sharedManager].stream managedObjectContext:storage.mainThreadManagedObjectContext];
//    XMPPUserCoreDataStorageObject *obj =  [storage userForJID:jid xmppStream:nil managedObjectContext:storage.mainThreadManagedObjectContext];
    
    
//    return obj;
    return [result lastObject];
}


#pragma mark - 头像更改代理方法
-(void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule didReceivePhoto:(UIImage *)photo forJID:(XMPPJID *)jid
{
    // 1.2获取数据
    // 2.刷新表格
    NSArray *recentlyData = [self recentlyDataFormatting:self.fetchedResultsController.fetchedObjects];
    [self.updateArchivingSubject sendNext:recentlyData];
    
}

- (RACSubject *)updateArchivingSubject{
    if (!_updateArchivingSubject) {
        _updateArchivingSubject = [RACSubject subject];
    }
    return _updateArchivingSubject;
}

#pragma mark - 懒加载对象
- (NSMutableDictionary *)recentlyDataDict{
    if (!_recentlyDataDict) {
        _recentlyDataDict = [NSMutableDictionary dictionary];
    }
    return _recentlyDataDict;
}

@end
