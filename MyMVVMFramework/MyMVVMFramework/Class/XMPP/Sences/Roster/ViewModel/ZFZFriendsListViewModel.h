//
//  ZFZFriendsListViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/1.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"
#import "ZFZFriendModel.h"
#import "CellDataAdapter.h"
#import "ZFZFriendGroupModel.h"

@interface ZFZFriendsListViewModel : BaseViewModel
//数据集合
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * friendsList;

@property (nonatomic,strong) NSArray <ZFZFriendGroupModel *> * groupList;

//消息更新时的信号
@property (nonatomic, strong, readwrite) RACSubject *updateContactsSubject;

@end
