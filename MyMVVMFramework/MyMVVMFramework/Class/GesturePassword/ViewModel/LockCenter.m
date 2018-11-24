//
//  LockCenter.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/7/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "LockCenter.h"
#import "LockController.h"
#import "LockMainNav.h"


static LockCenter * sharedInstance;
@implementation LockCenter


+ (instancetype)shareLockCenter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LockCenter alloc]init];
        sharedInstance.options=[[LockOptions alloc]init];
    });
    return sharedInstance;
}

- (void)hasPassword:(NSString *)passwordKey{
    
}

- (void)removePassword:(NSString *)passwordKey{
    
}

-(void)showSettingLockControllerIn:(UIViewController *)controller{
    LockController *lockVC = [self lockVC:controller];
    lockVC.title = _options.settingTittle;
    lockVC.type = set;
    [controller.navigationController pushViewController:lockVC animated:YES];
    //[controller presentViewController:lockVC animated:YES completion:nil];
}


-(void)showVerifyLockControllerIn:(UIViewController *)controller{
    LockController *lockVC = [self lockVC:controller];
    lockVC.title = _options.verifyPassword;
    lockVC.type = verify;
    [controller.navigationController pushViewController:lockVC animated:YES];
    //[controller presentViewController:lockVC animated:YES completion:nil];
    
}

-(void)showModifyLockControllerIn:(UIViewController *)controller{
    LockController *lockVC = [self lockVC:controller];
    lockVC.title = _options.modifyPassword;
    lockVC.type = modify;
    [controller.navigationController pushViewController:lockVC animated:YES];
}


- (LockController *)lockVC:(UIViewController *)controller{
    LockController *lockVC = [[LockController alloc]init];
    lockVC.controller = controller;
    return lockVC;
}

@end
