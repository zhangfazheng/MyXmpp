//
//  EmotionTextAttachment.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/11.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    //gif
    EmotionTypeGif,
    //静态图
    EmotionTypePng,
    
} EmotionImageType;

@interface EmotionTextAttachment : NSTextAttachment
//@property(nonatomic, copy)   NSString *imageName;

///用来记录区分表情
@property(nonatomic, strong) NSString *emojiTag;

///表情尺寸
@property(nonatomic, assign) CGSize   emojiSize;

//@property(nonatomic, assign) CGRect   emotionRect;

//@property(nonatomic, assign) LiuqsEmotionType emotionType;
@end
