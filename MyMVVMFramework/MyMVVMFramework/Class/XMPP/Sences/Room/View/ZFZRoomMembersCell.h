//
//  ZFZRoomMembersCell.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/14.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseCell.h"
#import "ZFZRoomMemberCellModel.h"

@interface ZFZRoomMembersCell : BaseCell
@property (assign,nonatomic) NSInteger membersCount;
@property (weak,nonatomic) RACSignal *addMemberSignal;

@end
