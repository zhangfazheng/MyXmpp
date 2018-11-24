//
//  ZFZRoomInvitationModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/25.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"
#import "ZFZXMPPManager.h"

typedef enum : NSUInteger {
    ZFZUnprocessed, //未处理
    ZFZAgreeWith,
    ZFZReject,
} ZFZAgreementStatus;

typedef enum : NSUInteger {
    ZFZFriendInvitation,
    ZFZGroupsInvitation

} ZFZInvitationType;

@interface ZFZInvitationModel : BaseModel
@property(nonatomic,strong) XMPPJID *roomJid;
@property(nonatomic,strong) XMPPJID *inviterJid;
@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *reason;
@property(nonatomic,assign) ZFZAgreementStatus agreementStatus;
@property(nonatomic,strong) XMPPMessage *message;
@property(nonatomic,copy) NSString *nickName;
@property(nonatomic,copy) NSString *groupName;
@property(nonatomic,assign) ZFZInvitationType invitationType;
@end
