//
//  ZFZSeachMemberHeaderView.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/19.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFZFriendModel.h"

@interface ZFZSeachMemberHeaderView : UIView
@property (nonatomic,strong) NSMutableArray <ZFZFriendModel *> *addMembersList;
@property (nonatomic,strong) RACSubject *removeMemberSubject;

//- (void)reloadMembersList;
- (void)reMoveMember:(ZFZFriendModel *)member;
//- (void)moveToTranin;
- (void)addMember:(ZFZFriendModel *)member;

@end
