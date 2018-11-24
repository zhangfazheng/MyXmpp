//
//  EmotionTextAttachment.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/11.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "EmotionTextAttachment.h"

#define emotionRate 1.0

@implementation EmotionTextAttachment
//在这个方法里返回附件的位置
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    
    //    self.emotionRect = CGRectMake(position.x, position.y + 0.5, _emojiSize.width * emotionRate, _emojiSize.height * emotionRate);
    
    return CGRectMake(0, -4, _emojiSize.width * emotionRate, _emojiSize.height * emotionRate);
}

@end
