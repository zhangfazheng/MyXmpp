//
//  UIView+Shadow.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Shadow)
-(void)addShadow;
- (void)addShadowColor:(UIColor *)color;
-(void)addShadowColor:(UIColor *)color offset:(CGSize)offsert;
@end
