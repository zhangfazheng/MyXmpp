//
//  MVVMRouter.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/5/27.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "MVVMRouter.h"
#import "LoginViewModel.h"
#import "LoginViewController.h"

@interface MVVMRouter ()

@property (nonatomic, copy) NSDictionary *viewModelViewMappings; // viewModel到view的映射

@end

@implementation MVVMRouter
+ (instancetype)sharedInstance {
    static MVVMRouter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BaseViewController *)viewControllerForViewModel:(BaseViewModel *)viewModel {
    NSString *viewController = self.viewModelViewMappings[NSStringFromClass(viewModel.class)];
    
    NSParameterAssert([NSClassFromString(viewController) isSubclassOfClass:[UIViewController class]]);
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);
    //return [[LoginViewController alloc]init];
    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}

- (NSDictionary *)viewModelViewMappings {
    return @{
             @"TestViewModel": @"EquipmentDetailsViewController",
             @"LoginViewModel": @"LoginViewController",
             @"ZFZRecentlyViewModel": @"ZFZRecentlyTableViewController"
             
             };
}

@end
