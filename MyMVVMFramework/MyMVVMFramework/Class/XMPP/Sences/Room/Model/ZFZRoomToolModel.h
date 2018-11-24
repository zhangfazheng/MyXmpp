//
//  ZFZRoomToolModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/14.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"

typedef void(^toolActionBlock)(NSInteger);

@interface ZFZRoomToolModel : BaseModel
//图标
@property (nonatomic,copy) NSString *icon;

//工具名
@property (nonatomic,copy) NSString *toolName;

//行动
@property (nonatomic,copy) toolActionBlock toolAction;

@end
