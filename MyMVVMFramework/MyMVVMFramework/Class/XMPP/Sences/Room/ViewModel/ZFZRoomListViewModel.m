//
//  ZFZRoomListViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/8.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRoomListViewModel.h"
#import "ZFZXMPPManager.h"
#import "XMPPConfig.h"
#import "ZFZRoomInfoCell.h"
#import "UIImage+RoundImage.h"
#import "ZFZRoomManager.h"

@interface ZFZRoomListViewModel ()<XMPPStreamDelegate, XMPPRoomDelegate>

@end

@implementation ZFZRoomListViewModel

- (void)initialize{
    [[ZFZXMPPManager sharedManager].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //加载房间信息
    self.roomList = [self analyticDiscussionRoom];
    //[self loadRooms];
    
//    @weakify(self)
//    self.roomListCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        @strongify(self)
//        [self loadRooms];
//        
//        //监听房间信息是否已经传回
//        RACSignal *loadRoomSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            [self loadRooms];
//            [[self rac_signalForSelector:@selector(xmppStream:didSendIQ:)]subscribeNext:^(RACTuple * _Nullable x) {
//                [subscriber sendNext:x];
//                [subscriber sendCompleted];
//            }];
//            
//            return [RACDisposable disposableWithBlock:^{
//                
//            }];
//            
//        }];
//        
//        return loadRoomSignal;
//    }];
    
    //添加监听群列表改变的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRoomAction) name:ZFZRoomListChangNotice object:nil];
    
}

//群列表改变时的操作
- (void)changeRoomAction{
    //重新获取群列表
    self.roomList = [self analyticDiscussionRoom];
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
//- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
//    //NSLog(@"iq:%@",iq);
//    // 以下两个判断其实只需要有一个就够了
//    NSString *elementID = iq.elementID;
//    if (![elementID isEqualToString:@"getMyRooms"]) {
//        return YES;
//    }
//    
//    NSArray *results = [iq elementsForXmlns:@"http://jabber.org/protocol/disco#items"];
//    if (results.count < 1) {
//        return YES;
//    }
//    NSArray<CellDataAdapter *> *roomArry = [self analyticDiscussionMemberWithIq:iq];
//    
//    self.roomList = roomArry;
//    //[self.roomListSubject sendNext:roomArry];
//    
//    return YES;
//}

#pragma mark- 解析房间信息
- (NSArray<CellDataAdapter *> *)analyticDiscussionRoom
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (ZFZRoomModel *room in [ZFZRoomManager shareInstance].roomList) {
        CellDataAdapter *adapter = [ZFZRoomInfoCell dataAdapterWithCellReuseIdentifier:@"ZFZRoomInfoCell" data:room cellHeight:100 type:0];
        [array addObject:adapter];  //array  就是你的群列表
    }
    return array;
    
}

//- (NSArray<CellDataAdapter *> *)analyticDiscussionMemberWithIq:(XMPPIQ *)iq
//{
//    NSMutableArray *array = [NSMutableArray array];
//    
//    for (DDXMLElement *element in iq.children) {
//        if ([element.name isEqualToString:@"query"]) {
//            for (DDXMLElement *item in element.children) {
//                if ([item.name isEqualToString:@"item"]) {
//                    ZFZFriendModel *disInfo = [[ZFZFriendModel alloc]init];
//                    disInfo.name = [item attributeStringValueForName:@"name"];
//                    NSString *jidStr = [item attributeStringValueForName:@"jid"];
//                    disInfo.jid = jidStr;
//                    
//                    UIImage * iconImage = [[UIImage imageNamed:@"army6"] setRadius:27 size:CGSizeMake(55, 55)];
//                    disInfo.phton = iconImage;
//                    CellDataAdapter *adapter = [ZFZFriendCell dataAdapterWithCellReuseIdentifier:@"ZFZFriendCell" data:disInfo cellHeight:100 type:0];
//                    [array addObject:adapter];  //array  就是你的群列表
//                    
//                }
//            }
//        }
//    }
//    return [array copy];
//}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
