//
//  LockItemView.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/30.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockOptions.h"

typedef enum : NSUInteger {
    DirectTop = 1,
    DirectRightTop,
    DirectRight,
    DirectRightBottom,
    DirectBottom,
    DirectLeftBottom,
    DirectLeft,
    DirectLeftTop
} LockItemViewDirect;


@interface LockItemView : UIView
@property(nonatomic,assign)LockItemViewDirect direct;
@property(nonatomic,assign) BOOL selected;

- (instancetype)initWithOptions:(LockOptions *)options;
@end
