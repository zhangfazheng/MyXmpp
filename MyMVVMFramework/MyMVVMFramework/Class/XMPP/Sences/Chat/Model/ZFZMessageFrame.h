//
//  ZFZMessageFrame.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/23.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"
#import "ZFZMessageModel.h"
#define textFont     [UIFont systemFontOfSize:17]

@interface ZFZMessageFrame : BaseModel
@property (nonatomic, strong) ZFZMessageModel *message;
/** 聊天时间 */
@property (nonatomic, assign, readonly) CGRect timeF;
/** 昵称 */
@property (nonatomic, assign, readonly) CGRect nameF;
/** 头像 */
@property (nonatomic, assign, readonly) CGRect iconF;
/** 消息内容 */
@property (nonatomic, assign, readonly) CGRect textF;
/** 消息状态 */
@property (nonatomic, assign, readonly) CGRect statusF;
/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@end
