//
//  NavigationControllerStack.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/5/27.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "NavigationControllerStack.h"
#import "ViewModelServices.h"
#import "MVVMRouter.h"

@interface NavigationControllerStack ()

@property (nonatomic, strong) id<ViewModelServices> services;
@property (nonatomic, strong) NSMutableArray<UINavigationController *> *navigationControllers;

@end

@implementation NavigationControllerStack

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    NavigationControllerStack *navigationControllerStack = [super allocWithZone:zone];
    
    @weakify(navigationControllerStack)
    [[navigationControllerStack
      rac_signalForSelector:@selector(initWithServices:)]
    	subscribeNext:^(id x) {
            @strongify(navigationControllerStack)
            [navigationControllerStack registerNavigationHooks];
        }];
    
    return navigationControllerStack;
}

- (instancetype)initWithServices:(id<ViewModelServices>)services {
    self = [super init];
    if (self) {
        _services = services;
        _navigationControllers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)pushNavigationController:(UINavigationController *)navigationController {
    if ([self.navigationControllers containsObject:navigationController]) return;
    [self.navigationControllers addObject:navigationController];
}

- (UINavigationController *)popNavigationController {
    UINavigationController *navigationController = self.navigationControllers.lastObject;
    [self.navigationControllers removeLastObject];
    return navigationController;
}

- (UINavigationController *)topNavigationController {
    return self.navigationControllers.lastObject;
}

- (void)registerNavigationHooks {
    WeakSelf
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(pushViewModel:animated:)]
     subscribeNext:^(RACTuple *tuple) {
         //@strongify(self)
         UIViewController *viewController = (UIViewController *)[MVVMRouter.sharedInstance viewControllerForViewModel:tuple.first];
         viewController.hidesBottomBarWhenPushed = YES;
         [weakSelf.navigationControllers.lastObject pushViewController:viewController animated:[tuple.second boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popViewModelAnimated:)]
     subscribeNext:^(RACTuple *tuple) {
        	//@strongify(self)
        	[weakSelf.navigationControllers.lastObject popViewControllerAnimated:[tuple.first boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popToRootViewModelAnimated:)]
     subscribeNext:^(RACTuple *tuple) {
         //@strongify(self)
         [weakSelf.navigationControllers.lastObject popToRootViewControllerAnimated:[tuple.first boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(presentViewModel:animated:completion:)]
     subscribeNext:^(RACTuple *tuple) {
        	//@strongify(self)
         UIViewController *viewController = (UIViewController *)[MVVMRouter.sharedInstance viewControllerForViewModel:tuple.first];
         
         UINavigationController *presentingViewController = weakSelf.navigationControllers.lastObject;
         if (![viewController isKindOfClass:UINavigationController.class]) {
             viewController = [[UINavigationController alloc] initWithRootViewController:viewController];
         }
         [weakSelf pushNavigationController:(UINavigationController *)viewController];
         
         [presentingViewController presentViewController:viewController animated:[tuple.second boolValue] completion:tuple.third];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(dismissViewModelAnimated:completion:)]
     subscribeNext:^(RACTuple *tuple) {
         //@strongify(self)
         [weakSelf popNavigationController];
         [weakSelf.navigationControllers.lastObject dismissViewControllerAnimated:[tuple.first boolValue] completion:tuple.second];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(resetRootViewModel:)]
     subscribeNext:^(RACTuple *tuple) {
         //@strongify(self)
         [weakSelf.navigationControllers removeAllObjects];
         
         UIViewController *viewController = (UIViewController *)[MVVMRouter.sharedInstance viewControllerForViewModel:tuple.first];
         
         if (![viewController isKindOfClass:[UINavigationController class]]/* && ![viewController isKindOfClass:[MRCTabBarController class]]*/) {
             viewController = [[UINavigationController alloc] initWithRootViewController:viewController];
             [weakSelf pushNavigationController:(UINavigationController *)viewController];
         }
         
         SharedAppDelegate.window.rootViewController = viewController;
     }];
}
@end
