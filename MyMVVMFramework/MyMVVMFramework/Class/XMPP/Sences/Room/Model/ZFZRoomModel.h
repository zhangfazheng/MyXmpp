//
//  ZFZRoomModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/15.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"
#import "ZFZMemberModel.h"

@interface ZFZRoomModel : BaseModel
@property (nonatomic,copy) NSString *roomName;
@property (nonatomic,copy) NSString *roomjid;
@property (nonatomic,copy) UIImage *phton;
@property (nonatomic,copy) UIImage *iconPath;
//房间成员
@property (nonatomic,strong) NSMutableArray<ZFZMemberModel *>  *roomMembers;
@end
