//
//  AppDelegate.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/5/26.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewModelServicesImpl.h"
#import "EquipmentDetailsViewController.h"
#import "TestViewModel.h"
#import "LoginViewModel.h"
#import "ChatViewController.h"
#import "ExpressionViewController.h"
//#import "ChatView1Controller.h"
#import "IQKeyboardManager.h"
#import "GuestureViewController.h"
//#import "ImageViewController.h"
#import "ZFZRecentlyViewModel.h"
#import "ZFZChatTableViewController.h"
#import "NSString+path.h"
#import "CustomNavigationController.h"
#import "CustomTabBarController.h"
#import "LoginViewController.h"
#import "ZFZSearchViewController.h"
#import "ZFZAddFriendInfoViewController.h"
#import "HomePageViewController.h"
#import "LoginSuccessViewController.h"
#import "ZFZSelectedGroupsListViewController.h"
#import "ZFZRoomManager.h"
#import "VCardInfoViewController.h"



@interface AppDelegate ()
@property (nonatomic, strong) ViewModelServicesImpl *services;
@property (nonatomic, strong) BaseViewModel *viewModel;
@property (nonatomic, strong) RealReachability *reachability;

@property (nonatomic, strong, readwrite) NavigationControllerStack *navigationControllerStack;
@property (nonatomic, assign, readwrite) ReachabilityStatus networkStatus;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureReachability];
    
    //设置全局主题
    [Chameleon setGlobalThemeUsingPrimaryColor:FlatSkyBlue withSecondaryColor:FlatYellowDark andContentStyle:UIContentStyleLight];
    
//    [[NSUserDefaults standardUserDefaults]setObject:@"42E4D775-822F-4F70-B3BC-F688F28E48C2" forKey:@"UUID"];
    //[NSThread sleepForTimeInterval:3];
    
    //禁用IQKeyboardManager的类
    [[[IQKeyboardManager sharedManager]disabledDistanceHandlingClasses]addObject:[ExpressionViewController class]];
    [[[IQKeyboardManager sharedManager]disabledDistanceHandlingClasses]addObject:[ZFZChatTableViewController class]];
    [[[IQKeyboardManager sharedManager]disabledDistanceHandlingClasses]addObject:[ZFZSearchViewController class]];
    //NSUserDefaults   *defaults = [ NSUserDefaults standardUserDefaults ];
//    [defaults setObject:@"lisi" forKey:@"userName"];
    //[IQKeyboardManager sharedManager].enableDebugging = YES;
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    self.services = [[ViewModelServicesImpl alloc] init];
    //创建一个Navigation栈来管理navigation的跳转
    self.navigationControllerStack = [[NavigationControllerStack alloc] initWithServices:self.services];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //self.window.rootViewController = [[CustomTabBarController alloc]init];
   NSString *deviceId = [[NSUserDefaults standardUserDefaults]objectForKey:@"UUID"];
//    [self.services resetRootViewModel:[[LoginViewModel alloc]initWithServices:self.services params:nil]];
    if (isEmptyString(deviceId)) {
        self.window.rootViewController = [[LoginViewController alloc]init];
        
//        [self.services resetRootViewModel:[[LoginViewModel alloc]initWithServices:self.services params:nil]];
    }else{
        UINavigationController *mainTapVc = [[UINavigationController alloc]initWithRootViewController:[[LoginSuccessViewController alloc]init]];
        self.window.rootViewController = mainTapVc;
    }

    
//    HomePageViewModel *viewModel = [[HomePageViewModel alloc]initWithServices:nil params:nil];
//    HomePageViewController *HomePageVc = [[HomePageViewController alloc]initWithViewModel:viewModel];
//    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:HomePageVc] ;
//    ZFZSelectedGroupsListViewController *groupListVc = [[ZFZSelectedGroupsListViewController alloc]init];
//    groupListVc.groupsListArry = [@[@"我的好友",@"同事",@"同学",@"家人"] mutableCopy];
//    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]] ;
//    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[HomePageViewController alloc]initWithStyle:UITableViewStyleGrouped]];
//
//    [self.services resetRootViewModel:[[ZFZRecentlyViewModel alloc]initWithServices:self.services params:nil]];
    
//        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mainTapVc];
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)configureReachability {
    /** 注册全局网络监测 */
    //[GLobalRealReachability startNotifier];
    self.reachability = GLobalRealReachability;
    WeakSelf
    RAC(self, networkStatus) = [[[[[NSNotificationCenter defaultCenter]
                                   rac_addObserverForName:kRealReachabilityChangedNotification object:nil]
                                  map:^(NSNotification *notification) {
                                      return @([notification.object currentReachabilityStatus]);
                                  }]
                                 startWith:@(weakSelf.reachability.currentReachabilityStatus)]
                                distinctUntilChanged];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf.reachability startNotifier];
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //暂时离开房间
    [[ZFZRoomManager shareInstance]presenceOutLine];
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"MyMVVMFramework"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


@end
