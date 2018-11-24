//
//  UIImageView+RoundImage.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/26.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+RoundImage.h"

@interface UIImageView (RoundImage)
- (void)setImageWithCornerRadius:(CGFloat)radius
                           imageURL:(NSURL *)imageURL
                        placeholder:(NSString *)placeholder
                               size:(CGSize)size;

- (void)setImageWithCornerRadius:(CGFloat)radius
                           imageURL:(NSURL *)imageURL
                        placeholder:(NSString *)placeholder
                        contentMode:(UIViewContentMode)contentMode
                               size:(CGSize)size;

- (void)setImageWithHTRadius:(ImageRadius)radius
                       imageURL:(NSURL *)imageURL
                    placeholder:(NSString *)placeholder
                    contentMode:(UIViewContentMode)contentMode
                           size:(CGSize)size;

- (void)setImageWithHTRadius:(ImageRadius)radius
                       imageURL:(NSURL *)imageURL
                    placeholder:(NSString *)placeholder
                    borderColor:(UIColor *)borderColor
                    borderWidth:(CGFloat)borderWidth
                backgroundColor:(UIColor *)backgroundColor
                    contentMode:(UIViewContentMode)contentMode
                           size:(CGSize)size;
@end
