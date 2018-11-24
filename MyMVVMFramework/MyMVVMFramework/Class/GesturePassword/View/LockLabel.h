//
//  LockLabel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/7/5.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockOptions.h"

@interface LockLabel : UILabel
@property(nonatomic,strong) LockOptions *options;

- (instancetype)initWithOptions:(LockOptions *) options frame :(CGRect) frame;
- (void)showNormal:(NSString *)message;
- (void)showWarn:(NSString *)message;
@end
