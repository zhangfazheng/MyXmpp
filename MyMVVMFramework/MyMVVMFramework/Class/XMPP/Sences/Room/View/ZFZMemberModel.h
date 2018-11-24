//
//  ZFZMemberModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/15.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"

@interface ZFZMemberModel : BaseModel
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *presenceStatus;
@property (nonatomic,copy) NSString *jid;
@property (nonatomic,copy) UIImage *phton;
@property (nonatomic,copy) UIImage *iconPath;
@property (nonatomic,copy) NSString *affiliation;
@property (nonatomic,copy) NSString *role;
@end
