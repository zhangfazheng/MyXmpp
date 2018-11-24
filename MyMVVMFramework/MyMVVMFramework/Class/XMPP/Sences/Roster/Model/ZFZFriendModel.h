//
//  ZFZFriendModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/1.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"
#import "UserVCardModel.h"

typedef enum : NSUInteger {
    ZFZEnable,
    ZFZSelected,
    ZFZUnenable,
} ZFZFriendSelectType;

@interface ZFZFriendModel : BaseModel
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *presenceStatus;
@property (nonatomic,assign) BOOL isPresence;
@property (nonatomic,copy) NSString *jid;
@property (nonatomic,copy) NSString *groupName;
@property (nonatomic,strong) UIImage *phton;
@property (nonatomic,copy) NSString *iconPath;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) BOOL isEnable;
@property (nonatomic,assign) ZFZFriendSelectType friendSelectType;
@property (nonatomic,strong) UserVCardModel *userVcard;

@end
