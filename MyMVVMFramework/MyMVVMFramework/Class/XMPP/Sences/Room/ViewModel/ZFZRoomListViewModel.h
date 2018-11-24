//
//  ZFZRoomListViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/8.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"
#import "ZFZFriendModel.h"
#import "CellDataAdapter.h"

@interface ZFZRoomListViewModel : BaseViewModel
@property (nonatomic,strong) NSArray <CellDataAdapter *> * roomList;
@property (strong ,nonatomic) RACCommand *roomListCommand;
@property (strong ,nonatomic) RACSubject *roomListSubject;
@end
