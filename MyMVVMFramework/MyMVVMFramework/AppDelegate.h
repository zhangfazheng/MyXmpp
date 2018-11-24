//
//  AppDelegate.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/5/26.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RealReachability.h"
#import "NavigationControllerStack.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic, strong, readonly) NavigationControllerStack *navigationControllerStack;

@property (nonatomic, assign, readonly) ReachabilityStatus networkStatus;

- (void)saveContext;


@end

