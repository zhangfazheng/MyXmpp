//
//  UserVCardModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/27.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"
#import "ZFZXMPPManager.h"

@interface UserVCardModel : BaseModel
@property (nonatomic,copy) NSString *realName;
@property (nonatomic,copy) XMPPJID *jid;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *deptId;
@property (nonatomic,assign) NSInteger sex;//0:男,1:女
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,copy) NSString *mail;
@property (nonatomic,copy) NSString *postName;
@property (nonatomic,copy) NSString *address;
@end
