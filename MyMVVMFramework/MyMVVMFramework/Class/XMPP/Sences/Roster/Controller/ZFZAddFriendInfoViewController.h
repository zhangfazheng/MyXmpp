//
//  ZFZAddFriendInfoViewController.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/28.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ZFZFriendModel.h"
#import "ZFZInvitationModel.h"

@interface ZFZAddFriendInfoViewController : BaseTableViewController
@property (nonatomic,weak)ZFZFriendModel *curFriend;
@property (weak,nonatomic) RACSignal *nickNameSignal;
@property (nonatomic,weak)ZFZInvitationModel *invitation;
@property (nonatomic,strong, readwrite) RACSubject *addFriendSubject;


@end
