//
//  ZFZMessageModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/23.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"
typedef enum {
    ZFZMessageTypeOther = 0,    // 别人发的
    ZFZMessageTypeMe  // 自己发的
} ZFZMessageType;

@class ZFZMemberModel;
@class ZFZRoomModel;
@interface ZFZMessageModel : BaseModel
// 消息ID
@property (nonatomic, copy) NSString *elementId;
// 聊天内容
@property (nonatomic, copy) NSString *text;
// 昵称
@property (nonatomic, copy) NSString *name;
// 消息时间
@property (nonatomic, copy) NSString *time;
// 消息读取状态
@property (nonatomic, copy) NSString *readStatus;
// 消息类型
@property (nonatomic, assign) ZFZMessageType type;
// 是否隐藏相同时间
@property (nonatomic, assign ,getter=isTimeHiden) BOOL timeHiden;
//头像图片
@property (nonatomic, strong) UIImage *iconImage;

@property(nonatomic, strong)NSMutableAttributedString *attributedText;
//是否是统计消息
@property (nonatomic, assign) BOOL isStatistics;

//已读成员数组
@property (nonatomic, strong) NSArray *readerMemberArray;

//当前房间
@property (nonatomic, strong) ZFZRoomModel *curRoom;

@end
