//
//  UILabel+SizeToFit.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SizeToFit)

- (void)sizeToFitWithText:(NSString *)text config:(void (^)(UILabel *label))configBlock;

- (void)sizeToFitWithAttributedText:(NSAttributedString *)text config:(void (^)(UILabel *label))configBlock;

@end
