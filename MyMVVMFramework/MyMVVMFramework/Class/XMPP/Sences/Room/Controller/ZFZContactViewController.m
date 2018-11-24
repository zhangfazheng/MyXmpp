//
//  ZFZContactViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/8.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZContactViewController.h"
#import "ZFZFriendsListViewController.h"
#import "ZFZFriendsListViewModel.h"
#import "ZFZRoomListViewController.h"
#import "ZFZRoomListViewModel.h"
#import "ZFZFindFriendViewController.h"
#import "OrganizationalStructureViewModel.h"

@interface ZFZContactViewController ()

@end

@implementation ZFZContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setup{
    [super setup];
    [self setupView];
    [self addAllChildVc];
    
}

- (void)addAllChildVc
{
    NSDictionary *params = @{@"cellReuseIdentifier":@"ZFZFriendCell"};
    ZFZFriendsListViewModel *friendViewModel = [[ZFZFriendsListViewModel alloc]initWithServices:nil params:params];
    //如果扫描到包个数不为0
    ZFZFriendsListViewController * findFriendVc = [[ZFZFriendsListViewController alloc]initWithViewModel:friendViewModel];
    findFriendVc.title = @"好友";
    [self addChildViewController:findFriendVc];
    
    ZFZRoomListViewModel *roomViewModel = [[ZFZRoomListViewModel alloc]initWithServices:nil params:nil];
    ZFZRoomListViewController * roomVc = [[ZFZRoomListViewController alloc]initWithViewModel:roomViewModel];
    roomVc.title = @"群";
    [self addChildViewController:roomVc];
    
}


- (void)setupView{
    // 设置标题栏样式
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight) {
        *titleScrollViewColor = [UIColor whiteColor];
        *norColor = [UIColor darkGrayColor];
        *selColor = FlatSkyBlueDark;
        *titleHeight = TabTitlesViewH;
    }];
    // 设置下标
    [self setUpUnderLineEffect:^(BOOL *isShowUnderLine, BOOL *isDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor) {
        
        *isShowUnderLine = YES;
        *underLineColor = FlatSkyBlueDark;
    }];
    
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushToAddFriendView)];
    [self.navigationItem setRightBarButtonItem:addItem];
}

- (void)pushToAddFriendView{
    OrganizationalStructureViewModel *viewModel = [[OrganizationalStructureViewModel alloc]initWithServices:nil params:nil];
//    ZFZFindFriendViewController *addVc = [[ZFZFindFriendViewController alloc]initWithViewModel:viewModel];
    ZFZFindFriendViewController *addVc = [[ZFZFindFriendViewController alloc]initWithViewModel:viewModel Style:UITableViewStyleGrouped];
    addVc.titles = [@[@"新脉远望"] mutableCopy];
    [self.navigationController pushViewController:addVc animated:YES];
}


@end
