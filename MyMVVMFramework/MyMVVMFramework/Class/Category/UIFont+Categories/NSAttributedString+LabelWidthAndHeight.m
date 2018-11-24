//
//  NSAttributedString+LabelWidthAndHeight.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/12.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "NSAttributedString+LabelWidthAndHeight.h"

@implementation NSAttributedString (LabelWidthAndHeight)
- (CGFloat)heightWithFixedWidth:(CGFloat)width {
    
    CGFloat height = 0;
    
    if (self.length) {
        
        CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                         context:nil];
        
        height = rect.size.height;
    }
    
    return height;
}

- (CGFloat)width {
    
    CGFloat width = 0;
    
    if (self.length) {
        
        CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                         context:nil];
        
        width = rect.size.width;
    }
    
    return width;
}
@end
