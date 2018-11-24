//
//  EmoticonModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/20.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSUInteger, EmoticonType) {
    EmoticonTypeImage   = 0, ///< 图片表情
    EmoticonTypeEmoji   = 1, ///< Emoji表情
    EmotionTypeEmojiGif = 2, ///< gif表情
};

@class EmoticonGroup;
@interface EmoticonModel : BaseModel
@property (nonatomic, strong) NSString *chs;  ///< 例如 [吃惊]
@property (nonatomic, strong) NSString *cht;  ///< 例如 [吃驚]
@property (nonatomic, strong) NSString *gif;  ///< 例如 d_chijing.gif
@property (nonatomic, strong) NSString *png;  ///< 例如 d_chijing.png
@property (nonatomic, strong) NSString *code; ///< 例如 0x1f60d
@property (nonatomic, assign) EmoticonType type;
@property (nonatomic, weak) EmoticonGroup *group;
@end
