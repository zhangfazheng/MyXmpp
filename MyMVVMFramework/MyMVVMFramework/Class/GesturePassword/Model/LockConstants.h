//
//  LockConstants.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/7/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LockController.h"




#define LABEL_HEIGHT 20
#define INFO_VIEW_WIDTH 30
#define  BUTTON_SPACE 50
#define TOP_MARGIN (([UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width) / 2 + 30)
#define ITEM_MARGIN 36
#define PASSWORD_KEY @"gesture_password_key_"

typedef void(^handle)();
typedef void(^strHandle)(NSString *str);
typedef void(^boolHandle)(BOOL selected);


@interface LockConstants : NSObject


@end
