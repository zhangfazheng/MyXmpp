//
//  ZFZFriendGroupModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"
#import "CellDataAdapter.h"

@class ZFZFriendModel;
@interface ZFZFriendGroupModel : BaseModel
// 数据中应该装我们的frined模型
@property (nonatomic, strong) NSArray<CellDataAdapter *> *friends;
// 组名
@property (nonatomic, copy) NSString *name;
// 在线人数
@property (nonatomic, assign) NSInteger onlineCount;
// 是否展开  isOpened 为YES是就是展开  为NO就是不展开
@property (nonatomic, assign, getter = isOpened) BOOL opened;

@end
