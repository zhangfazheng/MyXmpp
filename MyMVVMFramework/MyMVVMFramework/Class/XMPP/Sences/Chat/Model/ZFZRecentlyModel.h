//
//  ZFZRecentlyModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/17.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"
#import "ZFZChatViewModel.h"

@class XMPPJID;
@interface ZFZRecentlyModel : BaseModel
//头像
@property (nonatomic, strong) UIImage *iconImage;
//标题昵称
@property (nonatomic, copy) NSString *name;
//jid
@property (nonatomic, copy) NSString *jid;

@property (nonatomic, strong) XMPPJID *userJid;

//在线
@property (nonatomic, assign) BOOL isOnLine;
//消息数量
@property (nonatomic, assign) NSInteger infoCount;
//时间
@property (nonatomic, copy) NSString *time;

//时间
@property (nonatomic, copy) NSDate *dateTime;

//消息信息
@property (nonatomic, copy) NSString *infoString;

@property (nonatomic,assign) ZFZChatType chatType;
@end
