//
//  ZFZAddFriendViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/6.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZAddFriendViewController.h"
#import "ZFZFindFriendViewController.h"

@interface ZFZAddFriendViewController ()

@end

@implementation ZFZAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup{
    [super setup];
    
    [self setupView];
    
    [self addAllChildVc];
    
}

- (void)addAllChildVc
{
    //如果扫描到包个数不为0
    ZFZFindFriendViewController * vc1 = [ZFZFindFriendViewController new];
    vc1.title = @"找人";
    [self addChildViewController:vc1];
    
    BaseViewController * vc2 = [BaseViewController new];
    vc2.title = @"找群";
    [self addChildViewController:vc2];
    
}

- (void)setupView{
    
}

@end
