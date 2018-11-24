//
//  ZFZInvitationValidationFooterView.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/26.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseHeaderFooterView.h"
#import "ZFZInvitationModel.h"
#import "ZFZInvitationListViewModel.h"

@interface ZFZInvitationValidationFooterView : BaseHeaderFooterView
@property(nonatomic,assign) ZFZAgreementStatus agreementStatus;
@property (nonatomic,weak, readwrite) RACSignal *agreeWithSignal;
@property (nonatomic,weak, readwrite) RACSignal *rejectJSignal;
@property(nonatomic,weak) ZFZInvitationModel *invitation;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withStatus:(ZFZAgreementStatus) status;

@end
