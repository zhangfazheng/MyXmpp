//
//  ZFZFriendGroupHeaderView.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseHeaderFooterView.h"
#import "ZFZFriendGroupModel.h"

@interface ZFZFriendGroupHeaderView : BaseHeaderFooterView
@property (nonatomic, strong) ZFZFriendGroupModel *group;
@property (nonatomic, strong) RACSignal * openSignal;
@property (nonatomic, strong) UIButton *openButton;
@end
