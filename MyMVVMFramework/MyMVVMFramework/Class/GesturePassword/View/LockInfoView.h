//
//  LockInfoView.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/7/5.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockOptions.h"

@interface LockInfoView : UIView


- (instancetype)initWithOptions:(LockOptions *) options frame :(CGRect) frame;
- (void)resetItems;
- (void)showSelectedItems:(NSString *)passwordStr;
@end
