//
//  LockController.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/7/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockOptions.h"
#import "LockView.h"

typedef NS_ENUM(NSInteger,CoreLockType) {
    set,
    verify,
    modify,
};

@interface LockController : UIViewController

@property(nonatomic,strong) LockOptions *options;
@property(nonatomic,assign) int errorTimes;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,copy) NSString * modifyCurrentTitle;
@property(nonatomic,assign) BOOL isDirectModify;
@property(nonatomic,assign) CoreLockType type;
@property(nonatomic,strong) UIViewController *controller;
@property(nonatomic,strong) RACSubject *setSuccessSubject;
@property(nonatomic,strong) RACSubject *verSuccessSubject;
@property(nonatomic,strong) RACSubject *overrunTimesSubject;

- (instancetype)initWithType:(CoreLockType)type;

@end
