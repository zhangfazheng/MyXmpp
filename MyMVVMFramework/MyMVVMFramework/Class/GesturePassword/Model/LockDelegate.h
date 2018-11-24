//
//  LockDelegate.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/30.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol LockDelegate <NSObject>
- (BOOL)hideBarBottomLine;

- (UIColor *)barTintColor;

- (UIColor *)barTittleColor;

- (UIFont *)barTittleFont;

- (UIColor *)barBackgroundColor;

- (UIStatusBarStyle)statusBarStyle;

@end
