//
//  ZFZInvitationValidationViewController.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/26.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ZFZInvitationModel.h"
#import "ZFZInvitationListViewModel.h"

@interface ZFZInvitationValidationViewController : BaseTableViewController
@property(nonatomic,strong) ZFZInvitationModel *invitation;
@property (nonatomic,weak, readwrite) RACSubject *agreeWithSubject;
@property (nonatomic,weak, readwrite) RACSubject *rejectSubject;
@property (nonatomic, strong, readwrite) RACSubject *updateInvitationStatusSubject;

@end
