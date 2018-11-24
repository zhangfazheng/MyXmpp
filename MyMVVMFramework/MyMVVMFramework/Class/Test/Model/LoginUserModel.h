//
//  SLoginUserModel.h
//  SilverValley
//
//  Created by 张发政 on 16/10/8.
//  Copyright © 2016年 Beijing Oriental Silver Valley Investment Management Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractModel.h"

@interface LoginUserModel : AbstractModel
@property (nonatomic,copy) NSString *realName;
@property (nonatomic,copy) NSString *sessionId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,assign,getter=isLogin) BOOL login;

+ (LoginUserModel *)getUserModelInstance;


- (void)setUserInfoWithName:(NSString *) userName realName:(NSString *)realName;


- (void)saveLoginStatu:(BOOL)statu;

@end
