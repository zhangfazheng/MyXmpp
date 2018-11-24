//
//  CustomTabBarController.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/6.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "CustomTabBarController.h"
#import "CustomTabBar.h"
#import "CustomNavigationController.h"
#import "BaseViewController.h"
#import "ZFZRecentlyTableViewController.h"
#import "ZFZChatTableViewController.h"
#import "ZFZFriendsListViewController.h"
#import "ZFZFriendsListViewModel.h"
#import "ZFZContactViewController.h"
#import "HomePageViewController.h"


@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

//只加载一次
#pragma mark - 设置tabBar字体格式
+(void)load
{
    //UITabBarItem *titleItem = [UITabBarItem appearanceWhenContainedIn:self, nil];
    //UITabBarItem *titleItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    //正常
//    NSMutableDictionary *normalDict = [NSMutableDictionary dictionary];
//    normalDict[NSFontAttributeName] = [UIFont systemFontOfSize:13];
//    normalDict[NSForegroundColorAttributeName] = [UIColor grayColor];
//    [titleItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
//    //选中
//    NSMutableDictionary *selectedDict = [NSMutableDictionary dictionary];
//    selectedDict[NSForegroundColorAttributeName] = [UIColor blackColor];
//    [titleItem setTitleTextAttributes:selectedDict forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加子控制器
    [self setUpAllChildView];
    //添加所有按钮内容
    //[self setUpTabBarBtn];
    //更换系统tabbar
    [self setUpTabBar];
}

#pragma mark - 更换系统tabbar
-(void)setUpTabBar
{
    CustomTabBar *tabBar = [[CustomTabBar alloc] init];
    tabBar.backgroundColor = [UIColor whiteColor];
    //把系统换成自定义
    [self setValue:tabBar forKey:@"tabBar"];
}

#pragma mark - 添加所有按钮内容
-(void)setUpTabBarBtn
{
//    CustomNavigationController *nav = self.childViewControllers[0];
//    nav.tabBarItem.title = @"精选";
//    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
//    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_click_icon"];
//    
//    CustomNavigationController *nav1 = self.childViewControllers[1];
//    nav1.tabBarItem.title = @"新帖";
//    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
//    nav1.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_new_click_icon"];
//    
//    
//    CustomNavigationController *nav2 = self.childViewControllers[2];
//    nav2.tabBarItem.title = @"关注";
//    nav2.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
//    nav2.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_friendTrends_click_icon"];
//    
//    
//    CustomNavigationController *nav3 = self.childViewControllers[3];
//    nav3.tabBarItem.title = @"我";
//    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
//    nav3.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_me_click_icon"];
    
}

#pragma mark - 添加子控制器
-(void)setUpAllChildView
{
    //最近联系人
    ZFZRecentlyTableViewController *essence =[[ZFZRecentlyTableViewController alloc]initWithViewModel: [[ZFZRecentlyViewModel alloc]initWithServices:nil params:nil]];
    //essence.isListenNet = YES;
    [self addChildViewController:essence imageName:@"tab_recently_normal" titleString:@"联系人"];
    //好友与群
    ZFZContactViewController *new = [[ZFZContactViewController alloc] init];
   [self addChildViewController:new imageName:@"tab_contacts_normal" titleString:@"好友"];
    
    //好友
    HomePageViewController *work = [[HomePageViewController alloc] initWithStyle:UITableViewStyleGrouped];
   [self addChildViewController:work imageName:@"tab_work_normal" titleString:@"工作"];
    
    //我
    //UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([CustomNavigationController class]) bundle:nil];
    BaseViewController *me = [[BaseViewController alloc] init];
    [self addChildViewController:me imageName:@"tab_me_normal" titleString:@"我"];
    
}
/*
 把刚才的代码,重载到 addChildViewController 这个方法里
 重载: 方法名相同,参数个数不同
 */

- (void)addChildViewController: (UIViewController *) childController imageName:(NSString *)imageName titleString: (NSString *) titleString {
    
    
    // 设置一下图片
    childController.tabBarItem.image = [[UIImage imageNamed: imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    // 设置选中的图片
    childController.tabBarItem.selectedImage =  [UIImage imageNamed:imageName];
    
    // 设置一下渲染模式
    self.tabBar.tintColor = [UIColor orangeColor];
    // 这个也可以同样实现
    //        UITabBar.appearance().tintColor = UIColor.orangeColor()
    
    // 设置tabBarItem标题 --
    //        home.tabBarItem.title = "首页"
    
    // 设置nav的标题
    childController.title = titleString;
    
    // 把自控制添加到nav
    CustomNavigationController * nav = [[CustomNavigationController alloc]initWithRootViewController:childController];
    // 这样不可以实现
    //        nav.title = "首页"
    
    //添加子控制器
    [self addChildViewController:nav];
    
}


@end
