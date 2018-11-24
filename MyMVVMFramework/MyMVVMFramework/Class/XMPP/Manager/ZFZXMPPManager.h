//
//  ZFZXMPPManager.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/14.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@import XMPPFramework;
/**
 *  xmpp 管理类
 */
@interface ZFZXMPPManager : NSObject

/**
 *  xmpp 登录用户jid
 *
 */
@property (nonatomic,strong) XMPPJID * loginJid;
/**
 *  xmpp 通信管道(就像是电话中的电话线)
 *  通信管道的另一端是服务器
 */
@property (nonatomic,strong) XMPPStream * stream;

/**
 *  好友花名册,用来处理和好友相关的事件
 */
@property (nonatomic,strong) XMPPRoster * roster;
@property (nonatomic, strong) XMPPRosterMemoryStorage *xmppRosterMemoryStorage;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterCoreDataStorage;

/**
 *  消息归档处理类
 *  程序关闭后,下次打开还可以再次查看以前的聊天记录
 */
@property (nonatomic,strong) XMPPMessageArchiving * messageArchiving;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *messageArchivingCoreDataStorage;


///  我的个人资料功能模块
@property (nonatomic, strong) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong) XMPPvCardCoreDataStorage *vCardCoreDataStorage;

///  别人的个人资料功能模块
@property (nonatomic, strong) XMPPvCardAvatarModule *xmppvCardAvatarModule;

/**
 *  coredata 上下文,用来获取通过messageArchiving 归档后存储起来的消息
 */
@property (nonatomic,strong) NSManagedObjectContext * context;
//消息回执
@property (nonatomic,strong) XMPPMessageDeliveryReceipts * messageDeliveryReceipts;

//当前正在处理的jid,后台运行时的回执消息处理关闭
@property (nonatomic,copy) NSString * curDeliveryReceiptsJid;

/**
 *  单例方法
 *
 *  @return 单例对象
 */
+ (instancetype)sharedManager;

/**
 *  登陆方法
 *
 *  @param userName 登陆用户名
 *  @param password 登陆密码
 */
- (void)xmppManagerLoginWithUserName:(NSString *)userName password:(NSString *)password;

/**
 *  注册事件
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)xmppManagerRegisterWithUserName:(NSString *)username password:(NSString *)password;
@end
