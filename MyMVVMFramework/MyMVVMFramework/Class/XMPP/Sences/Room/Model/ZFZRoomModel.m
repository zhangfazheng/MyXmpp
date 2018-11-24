//
//  ZFZRoomModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/15.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRoomModel.h"

@implementation ZFZRoomModel

- (NSMutableArray<ZFZMemberModel *> *)roomMembers{
    if (!_roomMembers) {
        _roomMembers = [NSMutableArray array];
    }
    return _roomMembers;
}
@end
