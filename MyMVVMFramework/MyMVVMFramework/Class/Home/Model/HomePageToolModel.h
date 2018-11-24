//
//  HomePageToolModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"

typedef void(^HomeToolActionBlock)(NSString *);

@interface HomePageToolModel : BaseModel
//图标
@property (nonatomic,copy) NSString *icon;

//工具名
@property (nonatomic,copy) NSString *toolName;

//行动
@property (nonatomic,copy) HomeToolActionBlock toolAction;
@end
