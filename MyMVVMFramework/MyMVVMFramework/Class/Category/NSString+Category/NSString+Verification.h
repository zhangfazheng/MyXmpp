//
//  NSString+Verification.h
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/13.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Verification)
#pragma mark - 验证手机号码是否合法
+ (BOOL)stringValidateMobile:(NSString *)mobileNum;


//验证IP是否合法
- (BOOL)stringValidateIP;

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)isNotBlank;
//获取手机型号
+ (NSString *)iphoneType;
//获取UUID
+ (NSString *)createUUID;
@end
