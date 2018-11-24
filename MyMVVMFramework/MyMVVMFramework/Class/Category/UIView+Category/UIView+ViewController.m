//
//  UIView+ViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/7.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "UIView+ViewController.h"
#import "BaseViewController.h"

@implementation UIView (ViewController)
- (UIViewController *)zfz_viewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[BaseViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
@end
