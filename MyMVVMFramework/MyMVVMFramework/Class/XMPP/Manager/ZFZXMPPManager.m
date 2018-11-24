//
//  ZFZXMPPManager.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/14.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZXMPPManager.h"
#import "XMPPConfig.h"
#import "JDStatusBarNotification.h"
#import <AVFoundation/AVFoundation.h>
#import <sys/utsname.h>
#import "ZFZRoomManager.h"

typedef enum : NSUInteger {
    ConnectLogin,
    ConnectRegister,
} ConnectType;//链接目的

@interface ZFZXMPPManager ()<XMPPStreamDelegate,XMPPRosterDelegate>
///  自动重连模块
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
///  心跳检测模块
@property (nonatomic, strong) XMPPAutoPing *xmppAutoPing;
///  文件接收功能模块
@property (nonatomic, strong) XMPPIncomingFileTransfer *xmppIncomingFileTransfer;
//记录登陆密码
@property (nonatomic,copy) NSString * loginPassword;
//记录注册密码
@property (nonatomic,copy) NSString * regPassword;



//记录一下连接的目的
@property (nonatomic,assign) ConnectType connectType;

@end



@implementation ZFZXMPPManager
static ZFZXMPPManager * manager = nil;

+ (instancetype)sharedManager{
    //gcd 创建单例对象
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZFZXMPPManager alloc] init];
        
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}


- (void)activateFunction
{
    // 激活自动重连功能
    [self.xmppReconnect activate:self.stream];
    // 激活心跳检测模块
    //    [self.xmppAutoPing activate:self.xmppStream];
    // 激活好友功能模块
    [self.roster activate:self.stream];
    // 激活聊天信息功能模块
    [self.messageArchiving activate:self.stream];
    // 激活文件接收功能模块
    //[self.xmppIncomingFileTransfer activate:self.stream];
    // 激活我的个人资料功能模块
    //[self.xmppvCardTempModule activate:self.stream];
    // 激活别人的个人资料功能模块
    //[self.xmppvCardAvatarModule activate:self.stream];
    //开启回执
    //设置发送消息时自动请求回执为Yes,当发送消息后获取回执请求
    [self.messageDeliveryReceipts activate:self.stream];
}

//登陆
- (void)xmppManagerLoginWithUserName:(NSString *)userName password:(NSString *)password{
    //记录登陆密码
    self.loginPassword = password;
    //记录链接的目的
    self.connectType = ConnectLogin;
    
    [self connectWithUserName:userName];
}
//注册
- (void)xmppManagerRegisterWithUserName:(NSString *)username password:(NSString *)password{
    //记录注册密码
    self.regPassword = password;
    //记录链接的目的
    self.connectType = ConnectRegister;
    //链接服务器
    [self connectWithUserName:username];
}

//xmpp 协议规定,链接时可以不告诉服务器密码,但是一定要告诉服务器是谁在链接它
- (void)connectWithUserName:(NSString *)userName{
    //根据一个用户名构造一个xmppjid
    XMPPJID *myjid = [XMPPJID jidWithUser:userName domain:kDomin resource:kResource];
    //设置通信管道的jid
    self.stream.myJID = myjid;
    //链接服务器
    [self connectToServer];
    
}
//XMPPJid - xmpp系统中的用户类
//链接服务器
- (void)connectToServer{
    
    //先判断一下是否链接过服务器
    if ([_stream isConnected]) {
        NSLog(@"已经链接过了,先断开,再链接");
        [_stream disconnect];
    }
    //发起链接
    BOOL result = [_stream connectWithTimeout:30 error:nil];
    if (result) {
                NSLog(@"链接服务器成功");
        // 激活模块
        [self activateFunction];
    }else{
                NSLog(@"链接服务器失败");
    }
}

#pragma mark - XMPPStreamDelegate
//链接服务器成功的回调方法
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"链接服务器成功-回调方法");
    switch (self.connectType) {
        case ConnectLogin:
            //在链接成功后发起登陆事件
            [_stream authenticateWithPassword:self.loginPassword error:nil];
            break;
        case ConnectRegister:
            //在链接成功后进行注册
            [_stream registerWithPassword:self.regPassword error:nil];
            break;
        default:
            NSLog(@"一定是忘记 记录链接目的了");
            break;
    }
}
//链接超时的回调方法
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"链接超时--回调方法");
}
//断开链接(或者链接失败)的回调方法
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"断开链接--回调方法");
    if (error) {
        NSLog(@"%@",error);
    }
    //离线消息(下线通知)
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    //发送离线通知
    [self.stream sendElement:presence];
}

//登陆成功的回调事件
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    //    NSLog(@"登陆成功");
    
    //出席消息(上线通知)
    [self goOnline];
//    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
//    self.loginJid = sender.myJID;
//    //发送上线通知
//    [_stream sendElement:presence];
}
//登陆失败的回调事件
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"登陆失败 : %@",error);
}

//注册成功的回调事件
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
}
//注册失败回调事件
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败 ,error:%@",error);
}

#pragma mark - XMPPRosterDelegate

- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item{
    
}

- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender{
    
}
/** 收到出席订阅请求（代表对方想添加自己为好友) */
//接收到好友请求
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    //查询好验证，如果存在则不再创建消息
    XMPPJID * validation = [XMPPJID jidWithUser:FriendsValidation domain:presence.from.user resource:FriendsValidation];
    
    //同意并添加对方为好友
    [self.roster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
    
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    // 实体 -->从哪里获取数据
//    XMPPMessageArchivingCoreDataStorage *storage = self.messageArchivingCoreDataStorage;
//    
//    request.entity = [NSEntityDescription entityForName:storage.messageEntityName inManagedObjectContext:storage.mainThreadManagedObjectContext];
//    
//    // 谓词 -->获取哪些数据   不用写谓词 因为要获取所有的最近联系人的数据
//    NSString *myJid = [self.stream myJID].bare;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@ AND streamBareJidStr like %@", validation.bare,myJid];
//    request.predicate = predicate;
//    // 排序  升序
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
//    request.sortDescriptors = @[sort];
//    NSError *error;
//    if ([storage.mainThreadManagedObjectContext executeFetchRequest:request error:&error].count > 0) {
//        return;
//    }
    
    //创建一个好友验证的消息
    NSString *message = [NSString stringWithFormat:@"%@请求添加你为好友",presence.from.user];

    NSXMLElement *bodyElement = [[NSXMLElement alloc]initWithName:@"body" stringValue:message];
    
    [bodyElement addAttributeWithName:@"friendJid" stringValue:presence.from.bareJID.full];
    
    XMPPMessage *addFriendMessage = [[XMPPMessage alloc]initWithType:@"addfriend" to:[XMPPJID jidWithString:presence.from.full] elementID:nil child:bodyElement];

    
    [addFriendMessage addAttributeWithName:@"from" stringValue:validation.full];
    [addFriendMessage addAttributeWithName:@"status" integerValue:0];
    
    NSLog(@"%@",addFriendMessage);
    //保存邀请消息
    XMPPStream *stream = self.stream;
    [self.messageArchivingCoreDataStorage archiveMessage:addFriendMessage outgoing:NO xmppStream:stream];
    
}

-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
//    NSLog(@"消息：%@",message);
    if (![message.from isEqualToJID: sender.myJID]) {
        [JDStatusBarNotification showWithStatus:@"收到一条消息" dismissAfter:2];
        
        if(!isEmptyString(self.curDeliveryReceiptsJid) && [self.curDeliveryReceiptsJid isEqualToString:message.from.bare]){
            return;
        }else{
            [self receiveDelalineMessage:message];
        }
    }
    
}

#pragma mark  XMPPIncomingFileTransferDelegate

///  文件接收失败时调用
///
///  @param error  错误信息
- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender
                didFailWithError:(NSError *)error
{
    NSLog(@"接收文件失败");
}

XMPPJID *_sendJID;
///  是否允许接收文件
///
///  @param offer  详情信息
- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender
               didReceiveSIOffer:(XMPPIQ *)offer
{
    
    NSLog(@"是否允许接收文件");
    _sendJID = offer.from;
    // 允许接收文件
    [sender acceptSIOffer:offer];
}

//AVAudioPlayer *_player;
///  文件接收成功后调用
///
///  @param data   文件的二进制
///  @param name   文件的名称
- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender
              didSucceedWithData:(NSData *)data
                           named:(NSString *)name
{
    //    if ([name rangeOfString:@".mp3"].location != NSNotFound) {
    //        // 播放音乐
    //        _player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    //        [_player prepareToPlay];
    //        [_player play];
    //    }
    NSLog(@"文件接收成功 %@",name);
    
    // 1.保存二进制文件
    // 1.1获取沙盒路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name];
    // 1.2保存数据到沙盒中
    [data writeToFile:path atomically:YES];
    
    // 2.保存在CoreData数据库中  (使用数据库最大的好处:方便查找数据)  数据库中放的大部分都是数据的路径
    // 使用XMPPMessage必须包含:1.聊天类型  2.to(给谁发的)   3.from(谁发的)   4.body  5.文件类型
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.stream.myJID];
    //    3.from
    [message addAttributeWithName:@"from" stringValue:_sendJID.bare];
    // 4.body
    [message addBody:name];
    // 5.文件类型
    [message addSubject:@"FILE"];
    // 保存message到数据库
    [[XMPPMessageArchivingCoreDataStorage sharedInstance] archiveMessage:message outgoing:NO xmppStream:self.stream];
}

#pragma mark - 懒加载XMPP对象
//--------------配置通信管道-----------
- (XMPPStream *)stream
{
    if (!_stream) {
        //  创建流对象
        _stream = [[XMPPStream alloc] init];
        //设置通信管道个目标服务器地址
        _stream.hostName = kHostName;
        //设置目标服务器的xmpp server的端口
        _stream.hostPort = kHostPort;
        
        //设置代理,在主线程里面触发回调事件
        [_stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _stream;
}

- (XMPPReconnect *)xmppReconnect
{
    if (!_xmppReconnect) {
        // 创建自动重连对象 -->在有网络的情况下自动登录
        _xmppReconnect = [[XMPPReconnect alloc] initWithDispatchQueue:dispatch_get_main_queue()];
        // 设置属性 (可选)
        // 是否自动重连  默认值就是YES
        //        _xmppReconnect.autoReconnect = YES;
        // 设置代理 (可选)
        //        [_xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppReconnect;
}


- (XMPPAutoPing *)xmppAutoPing
{
    if (!_xmppAutoPing) {
        // 创建对象
        _xmppAutoPing = [[XMPPAutoPing alloc] initWithDispatchQueue:dispatch_get_main_queue()];
        // 设置属性
        // ping的频率
        _xmppAutoPing.pingInterval = 2000;
        // 超时时间
        _xmppAutoPing.pingTimeout = 60000;
        // 设置代理
        [_xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppAutoPing;
}

//-------------用户花名册---------------------
- (XMPPRoster *)roster
{
    if (!_roster) {
        
        _xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc] init];
        // 创建好友功能模块对象
//        _roster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterMemoryStorage dispatchQueue:dispatch_get_main_queue()];
        _roster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        //设置好友同步策略,XMPP一旦连接成功，同步好友到本地
        _roster.autoFetchRoster = YES;
        // 用户离线时清除所有数据
        _roster.autoClearAllUsersAndResources = NO;
        // 自动接收出席定略请求 (自动添加好友)
        _roster.autoAcceptKnownPresenceSubscriptionRequests = YES;
        // 设置代理  (可选)
        [_roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _roster;
}



//----------------初始化 XMPPMessageArchiving-----
//xmppMessageArchiving 主要功能: 1. 通过通讯管道获取到服务器发送过来的消息,2.讲消息存储到指定的XMPPMessageArchivingCoreDataStorage
- (XMPPMessageArchiving *)messageArchiving
{
    if (!_messageArchiving) {
        // 创建对象
        _messageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.messageArchivingCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        
        
        // 设置属性 (可选)
        
        // 设置代理 (可选)
        
    }
    return _messageArchiving;
}
#pragma mark - 消息回执
//--------------消息回执管道-----------
- (XMPPMessageDeliveryReceipts *)messageDeliveryReceipts{
    if (!_messageDeliveryReceipts) {
        _messageDeliveryReceipts = [[XMPPMessageDeliveryReceipts alloc]initWithDispatchQueue:dispatch_get_main_queue()];
        
        //设置发送消息时自动请求回执为Yes,当发送消息后获取回执请求
        _messageDeliveryReceipts.autoSendMessageDeliveryRequests = YES;
        //设置接收消息时自动发送回执为No,自己来发送回执，实现消息的已读与未读
        _messageDeliveryReceipts.autoSendMessageDeliveryReceipts =NO;
    }
    return _messageDeliveryReceipts;
}

- (XMPPMessageArchivingCoreDataStorage *)messageArchivingCoreDataStorage{
    if (!_messageArchivingCoreDataStorage) {
        _messageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    }
    return _messageArchivingCoreDataStorage;
}

//让我们创建的上下文直接等于消息归档类存储的coredata仓库的上下文
- (NSManagedObjectContext *)context{
    if (!_context) {
        _context = [XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext;
    }
    return _context;
}

- (XMPPIncomingFileTransfer *)xmppIncomingFileTransfer
{
    if (!_xmppIncomingFileTransfer) {
        // 创建文件接收功能模块对象
        _xmppIncomingFileTransfer = [[XMPPIncomingFileTransfer alloc] initWithDispatchQueue:dispatch_get_main_queue()];
        // 设置属性
        // 自动文件转换
        _xmppIncomingFileTransfer.autoAcceptFileTransfers = YES;
        // 设置代理
        [_xmppIncomingFileTransfer addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppIncomingFileTransfer;
}

- (XMPPvCardTempModule *)xmppvCardTempModule
{
    if (!_xmppvCardTempModule) {
        // 创建个人资料功能模块对象
        //_xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:self.vCardCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        _xmppvCardTempModule = [[XMPPvCardTempModule alloc]initWithvCardStorage:self.vCardCoreDataStorage];
        // 设置属性(可选)
        // 设置代理(可选)
    }
    return _xmppvCardTempModule;
}

- (XMPPvCardCoreDataStorage *)vCardCoreDataStorage{
    if (!_vCardCoreDataStorage) {
        _vCardCoreDataStorage = [XMPPvCardCoreDataStorage sharedInstance];
    }
    return _vCardCoreDataStorage;
}

//共名册数据库
- (XMPPRosterCoreDataStorage *)xmppRosterCoreDataStorage{
    if (!_xmppRosterCoreDataStorage) {
        _xmppRosterCoreDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
    }
    return _xmppRosterCoreDataStorage;
}

- (XMPPRosterMemoryStorage *)xmppRosterMemoryStorage{
    if (!_xmppRosterMemoryStorage) {
        _xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc]init];
    }
    return _xmppRosterMemoryStorage;
}

//个人头像
- (XMPPvCardAvatarModule *)xmppvCardAvatarModule
{
    if (!_xmppvCardAvatarModule) {
        // 创建别人的个人资料功能模块_xmppvcardtempmodule
        _xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.xmppvCardTempModule dispatchQueue:dispatch_get_main_queue()];
        // 设置属性(可选)
        // 设置代理(可选)
//        [_xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];

    }
    return _xmppvCardAvatarModule;
}

- (void)goOnline
{
    // 发送一个<presence/> 默认值avaliable 在线 是指服务器收到空的presence 会认为是这个
    // status ---自定义的内容，可以是任何的。
    // show 是固定的，有几种类型 dnd、xa、away、chat，在方法XMPPPresence 的intShow中可以看到
    XMPPPresence *presence = [XMPPPresence presence];
    
    NSString *platform = [self getDeviceName];
    platform = [[platform componentsSeparatedByString:@","]firstObject];
    [presence addChild:[DDXMLNode elementWithName:@"status" stringValue:platform]];
    [presence addChild:[DDXMLNode elementWithName:@"show" stringValue:@"online"]];
    
    [self.stream sendElement:presence];
}

// 获取设备型号然后手动转化为对应名称
- (NSString *)getDeviceName
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}


/**
 *  退出登录
 */
- (void)logout
{
    [self.stream disconnect];
    [self.stream removeDelegate:self];
    self.xmppReconnect.autoReconnect = NO;
    [self.xmppReconnect deactivate];
    [self.xmppAutoPing deactivate];
    [self.roster deactivate];
    [self.messageArchiving deactivate];
    [self.xmppIncomingFileTransfer deactivate];
    self.stream = nil;
}

/**
 *程序后台运行时的回执消息处理
 * message 回执消息
 */
- (void)receiveDelalineMessage:(XMPPMessage *)message{
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
                        
                        //遍历房间数组，找到当前房间
                        ZFZRoomModel *curRoom;
                        for (NSInteger i= 0; i<[ZFZRoomManager shareInstance].roomList.count; i++) {
                            if ([[ZFZRoomManager shareInstance].roomList[i].roomjid isEqualToString:message.from.bare]) {
                                curRoom = [ZFZRoomManager shareInstance].roomList[i];
                                break;
                            }
                        }
                        
                        //获取当前房间成员人数
                        NSInteger sum;
                        if (curRoom.roomMembers && curRoom.roomMembers.count>0) {
                            sum = curRoom.roomMembers.count-1;
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
  
                    break;
                }
            }
        }
    }
}


///****************** -------- 接收到头像更改 -------- ******************/
//
//- (void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule didReceivePhoto:(UIImage *)photo forJID:(XMPPJID *)jid {
//    NSLog(@"修改头像");
//}
//
///****************** -------- 上传头像成功 -------- ******************/
//- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule {
//    NSLog(@"修改头像成功");
//}




@end
