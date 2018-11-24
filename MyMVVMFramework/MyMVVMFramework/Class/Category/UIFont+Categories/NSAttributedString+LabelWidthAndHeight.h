//
//  NSAttributedString+LabelWidthAndHeight.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/12.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*计算相应字体样式属性的字符串的宽和高**/
@interface NSAttributedString (LabelWidthAndHeight)
/**
 *  Get the string's height with the fixed width.
 *
 *  @param width     Fixed width.
 *
 *  @return String's height.
 */
- (CGFloat)heightWithFixedWidth:(CGFloat)width;

/**
 *  Get the string's width.
 *
 *  @return String's width.
 */
- (CGFloat)width;
@end
