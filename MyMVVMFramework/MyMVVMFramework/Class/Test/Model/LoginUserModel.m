//
//  SLoginUserModel.m
//  SilverValley
//
//  Created by 张发政 on 16/10/8.
//  Copyright © 2016年 Beijing Oriental Silver Valley Investment Management Co.,Ltd. All rights reserved.
//

#import "LoginUserModel.h"
#import "NSString+path.h"
#import <YYKit/NSObject+YYModel.h>

@implementation LoginUserModel
//static NSString *filePath = [self filePathWithFileName:@"gd.abc"];

+ (LoginUserModel *)getUserModelInstance
{
     //程序启动的时候 删除本地保存数据 方便测试
    NSString *filePath = [@"person.plist" appendDocuments];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (blHave){
        LoginUserModel *cur =[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (!cur) {
            cur =[[LoginUserModel alloc]init];
        }
        return cur;
    }else{
        LoginUserModel *cur =[[LoginUserModel alloc]init];
        return cur;
    }
    
}

- (void)encodeWithCoder:(NSCoder *)encoder {

        [encoder encodeObject:self.realName forKey:@"realName"];

        [encoder encodeObject:self.userName forKey:@"userName"];

        [encoder encodeObject:self.sessionId forKey:@"sessionId"];

        [encoder encodeBool:self.login forKey:@"login"];
    
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        
        self.realName = [decoder decodeObjectForKey:@"realName"];
        self.userName = [decoder decodeObjectForKey:@"userName"];
        self.sessionId = [decoder decodeObjectForKey:@"sessionId"];
        self.login = [decoder decodeBoolForKey:@"login"];
        
    }
    return self;
}


#pragma mark-设置用户基本信息
- (void)setUserInfoWithName:(NSString *) userName realName:(NSString *)realName{
    if(!isEmptyString(userName)){
       self.userName=userName;
    }
    if(!isEmptyString(realName)){
        self.realName=realName;
    }
    // 拼接文件路径
    NSString *filePath = [@"person.plist" appendDocuments];
    // 归档"保存"
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}




#pragma mark-设置用户登录状态
- (void)saveLoginStatu:(BOOL)statu{
    self.login=statu;
    // 拼接文件路径
    NSString *filePath = [@"person.plist" appendDocuments];
    // 归档"保存"
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

#pragma mark-清除cookei信息
- (void)cleanCookei{
    NSString *filePath = [@"org.skyfox.cookie" appendDocuments];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (blHave){
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

@end
