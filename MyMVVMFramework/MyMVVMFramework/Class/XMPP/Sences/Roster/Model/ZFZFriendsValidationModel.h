//
//  ZFZFriendsValidationModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/26.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"
#import "ZFZXMPPManager.h"
#import "ZFZInvitationModel.h"

@interface ZFZFriendsValidationModel : BaseModel
@property(nonatomic,strong) XMPPJID *friendJid;
@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *reason;
@property(nonatomic,assign) ZFZAgreementStatus agreementStatus;
@property(nonatomic,strong) XMPPMessage *message;
@end
