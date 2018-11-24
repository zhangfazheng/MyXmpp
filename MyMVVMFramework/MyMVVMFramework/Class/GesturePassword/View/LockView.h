//
//  LockView.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/7/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockConstants.h"
#import "LockController.h"

typedef NS_ENUM(NSInteger,LockCoreLockType) {
    CoreLockSet,
    CoreLockVerify,
    CoreLockModify,
};

@interface LockView : UIView
@property (nonatomic,assign) LockCoreLockType type;
@property(nonatomic,strong) RACSubject *passwordTooShortSubject;
@property(nonatomic,strong) RACSubject *verifyHandleSubject;
@property(nonatomic,strong) RACSubject *passwordTwiceDifferentSubject;
@property(nonatomic,strong) RACSubject *passwordFirstRightSubject;
@property(nonatomic,strong) RACSubject *modifySubject;

- (instancetype)initWithFrame:(CGRect)frame options:(LockOptions *)option;
- (void)resetPassword;
@end
