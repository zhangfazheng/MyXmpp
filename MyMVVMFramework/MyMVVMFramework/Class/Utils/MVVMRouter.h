//
//  MVVMRouter.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/5/27.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"
#import "BaseViewController.h"

@interface MVVMRouter : NSObject
/// Retrieves the shared router instance.
///
/// Returns the shared router instance.
+ (instancetype)sharedInstance;

/// Retrieves the view corresponding to the given view model.
///
/// viewModel - The view model
///
/// Returns the view corresponding to the given view model.
- (BaseViewController *)viewControllerForViewModel:(BaseViewModel *)viewModel;
@end
