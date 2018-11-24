//
//  Target_A.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/5.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface Target_A : NSObject

- (UIView *)Action_nativeFetchNoneView:(NSDictionary *)params;
- (id)Action_showAlert:(NSDictionary *)params;

@end
