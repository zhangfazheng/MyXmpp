//
//  LockController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/7/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LockController.h"
#import "LockInfoView.h"
#import "LockLabel.h"
#import "LockConstants.h"
#import "UIView+Frame.h"
#import "LockCenter.h"



@interface LockController ()
@property (nonatomic,strong) LockInfoView *infoView;
@property (nonatomic,strong) LockLabel *lockLable;
@property (nonatomic,strong) LockView *lockView;
@property (nonatomic,strong) UIBarButtonItem *resetItem;
@end

@implementation LockController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.options=[LockCenter shareLockCenter].options;
        self.setSuccessSubject      = [[RACSubject alloc]init];
        self.verSuccessSubject      = [[RACSubject alloc]init];
        self.overrunTimesSubject    = [[RACSubject alloc]init];
    }
    return self;
}

- (instancetype)initWithType:(CoreLockType)type{
    self = [super init];
    if (self) {
        self.options=[LockCenter shareLockCenter].options;
        self.setSuccessSubject      = [[RACSubject alloc]init];
        self.verSuccessSubject      = [[RACSubject alloc]init];
        self.overrunTimesSubject    = [[RACSubject alloc]init];
        self.type                   = type;
    }
    return self;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self onPrepare];
    [self controllerPrepare];
    [self dataTransfer];
    [self event];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onPrepare{
    if (self.type == set) {
        self.lockLable.top = CGRectGetMinY(_lockLable.frame)+30;
        
        self.infoView = [[LockInfoView alloc]initWithOptions:self.options frame:CGRectMake((self.view.width-INFO_VIEW_WIDTH) / 2, CGRectGetMinY(self.lockLable.frame)-50, INFO_VIEW_WIDTH, INFO_VIEW_WIDTH)];
        
        [self.view addSubview:_infoView];
    }
    
    _lockView = [[LockView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.lockLable.frame)+15, self.view.width, self.view.height) options:self.options];
    
    [self.view addSubview:_lockView];
    [self.view addSubview:_lockLable];
    //添加顺序不要反 因为lockView的背景颜色不为透明
}


- (void)controllerPrepare{
    [self.view setBackgroundColor:self.options.backgroundColor];
    self.navigationItem.rightBarButtonItem = nil;
    
    _modifyCurrentTitle = self.options.enterOldPassword;
    if (_type == modify) {
        if (_isDirectModify) { return; }
        self.navigationItem.leftBarButtonItem =[self getBarButton:@"关闭"];
    } else if( _type == set ){
        if (_isDirectModify) {
            return;
        }
        self.navigationItem.leftBarButtonItem = [self getBarButton:@"取消"];
        _resetItem.enabled = NO;
        self.navigationItem.rightBarButtonItem = _resetItem;
    }

}

- (void)dataTransfer{
    [self.lockLable showNormal:_message];
    _lockView.type =_type;
}


#pragma mark- 懒加载控件
- (UIBarButtonItem *)resetItem{
    if (!_resetItem) {
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"重绘" style:UIBarButtonItemStylePlain target:self action:@selector(redraw:)];
        _resetItem =barItem;
    }
    return _resetItem;
}

- (LockInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[LockInfoView alloc]initWithOptions:self.options frame:CGRectMake(0, (ScreenHeight- ScreenWidth)/2+30, self.view.frame.size.width, LABEL_HEIGHT)];
    }
    
    return _infoView;
}

- (LockLabel *)lockLable{
    if (!_lockLable) {
        _lockLable = [[LockLabel alloc]initWithOptions:self.options frame:CGRectMake(0, TOP_MARGIN, self.view.width, LABEL_HEIGHT)];
    }
    return _lockLable;
}

- (UIBarButtonItem *)getBarButton:(NSString *)title{
    return [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];
}

- (void)event{
    @weakify(self)
    [_lockView.passwordTooShortSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.lockLable showWarn:[NSString stringWithFormat: @"请连接至少%zd个点",self.options.passwordMinCount]];
        [self redraw:self.resetItem];
    }];
    
    [_lockView.verifyHandleSubject subscribeNext:^(NSString * x) {
        @strongify(self)
        [self passwordVerifyIWithPassword:x];
    }];
    
    [_lockView.passwordTwiceDifferentSubject subscribeNext:^(NSString *x) {
        @strongify(self)
        if (!isEmptyString(x)) {
            [self.lockLable showNormal: @"密码设置成功"];
            [[NSUserDefaults standardUserDefaults]setObject:x forKey:self.options.passwordKeySuffix];
            [self.setSuccessSubject sendNext:nil];
        }else{
            [self.lockLable showWarn: @"两次输入密码不一致"];
        }
        
    }];
    
    [_lockView.passwordFirstRightSubject subscribeNext:^(NSString * x) {
        @strongify(self)
        // 在这里绘制infoView路径
        [self.infoView showSelectedItems:x];
        [self.lockLable showWarn: @"请再次输入密码"];
    }];
    
    [_lockView.modifySubject subscribeNext:^(NSString *x) {
        @strongify(self)
        if (self.isDirectModify) {
            LockController *lockVC = [[LockController alloc]initWithType:set];
            lockVC.isDirectModify = YES;
            [self.navigationController pushViewController:lockVC animated:YES];
        }else{
            if ([self passwordVerifyIWithPassword:x]) {
                LockController *lockVC = [[LockController alloc]initWithType:set];
                //lockVC.isDirectModify = YES;
                [self.navigationController pushViewController:lockVC animated:YES];
            }
        }
        
    }];
}

#pragma mark-密码验证
- (BOOL)passwordVerifyIWithPassword:(NSString *)password{
    NSString *pwdLocal=[[NSUserDefaults standardUserDefaults]stringForKey:self.options.passwordKeySuffix];
    if ([password isEqualToString:pwdLocal]) {
        [self.lockLable showNormal: @"密码验证成功"];
        [self.verSuccessSubject sendNext:nil];
        return YES;
    }else{
        if (self.errorTimes < self.options.errorTimes) {
            [self.lockLable showWarn: [NSString stringWithFormat:@"您还可以尝试%zd次",self.options.errorTimes - self.errorTimes]];
            self.errorTimes += 1;
        }else{
            [self.lockLable showWarn: @"错误次数已达上限"];
            [self.overrunTimesSubject sendNext:nil];
        }
        return NO;
    }
}


- (void)dismissAction{
    [self dismiss:1];
}

- (void)dismiss:(NSTimeInterval) interval{
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
    
    
}

- (void)setType:(CoreLockType)type{
    _type = type;
    switch (type) {
        case set:
            self.message = self.options.setPassword;
            break;
            
        case verify:
            self.message = self.options.enterPassword;
            break;
            
        case modify:
            self.message = self.options.enterOldPassword;
            break;
    }
}
- (void)redraw:(UIBarButtonItem*)sender {
    sender.enabled = NO;
    [_infoView resetItems];
    [_lockLable showNormal:_options.secondPassword];
    [_lockView resetPassword];
}


@end
