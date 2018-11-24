//
//  XMPPConfig.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/15.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#ifndef XMPPConfig_h
#define XMPPConfig_h
// xmpp 文件夹只是通过 oc 代码去实现了xmpp协议,xmpp 只是协议,只是一个规则
// 在android 中也有一套实现了xmpp 协议的代码.

//这套代码通过实现了xmpp协议来给我们提过xmpp服务.
//openfire服务器IP地址
//172.21.60.255

//本地地址 - 127.0.0.1

#define  kHostName      @"124.127.86.251" //外网xmpp服务器Ip
//#define  kHostName      @"192.168.1.75"
//openfire服务器端口 默认5222
#define  kHostPort      5222
//openfire域名
//#define kDomin @"liuzhen-PC.cyberplus.com.cn"
//#define kDomin @"ruirui.cyberplus.com.cn"
#define kDomin @"cyberplus.com.cn"
//openfire子域名
#define kSubDomin @"conference"
//resource
#define kResource @"iOS"
//群通知
#define GroupNotice @"groupnotice"
//好友验证信息
#define FriendsValidation @"friendsvalidation"

#define ZFZRoomListChangNotice @"ZFZRoomListChangNotice"

#define ROOMJID @"roomJid"

#endif /* XMPPConfig_h */
