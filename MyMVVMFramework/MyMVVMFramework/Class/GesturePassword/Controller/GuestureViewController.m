//
//  GuestureViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/7/5.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "GuestureViewController.h"
#import "LockCenter.h"

@interface GuestureViewController ()

@end

@implementation GuestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//     [[LockCenter shareLockCenter]showSettingLockControllerIn:self];
    [[LockCenter shareLockCenter]showVerifyLockControllerIn:self];
}

@end
