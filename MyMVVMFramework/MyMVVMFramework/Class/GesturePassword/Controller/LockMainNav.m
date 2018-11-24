//
//  LockMainNav.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/7/5.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "LockMainNav.h"
#import "LockOptions.h"
#import "LockCenter.h"
#import "UINavigationBar+Awesome.h"

@interface LockMainNav ()

@end

@implementation LockMainNav

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LockCenter *LockManager = [LockCenter shareLockCenter];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:LockManager.options.barTittleColor, NSFontAttributeName: LockManager.options.barTittleFont}];
    
    
    if (LockManager.options.barBackgroundColor) {
        [self.navigationBar lt_setBackgroundColor:LockManager.options.barBackgroundColor];
    }
    [self.navigationBar setTintColor:LockManager.options.barTintColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
