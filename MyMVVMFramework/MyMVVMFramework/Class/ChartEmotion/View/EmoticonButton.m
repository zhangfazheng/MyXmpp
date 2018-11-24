//
//  EmoticonButton.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/12.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "EmoticonButton.h"

@implementation EmoticonButton

- (void)setEmoticon:(EmoticonModel *)emoticon{
    _emoticon = emoticon;
    // 问题: 只有图片名字不行,还需要图片所对应的包的路径
    // 注意: 在分析思路的时候一定要根据线索去查找,另外一定要把线索锁定住
    if (!isEmptyString(emoticon.png) && !isEmptyString(emoticon.path)) {
        NSString *imagePath =[NSString stringWithFormat:@"%@/%@",emoticon.path,emoticon.png];
        
        [self setImage:[UIImage imageNamed:imagePath] forState:UIControlStateNormal];
    }else{
        [self setImage:nil forState:UIControlStateNormal];
    }
    
    if (!isEmptyString(emoticon.emoji)) {
        [self setTitle:emoticon.emoji forState:UIControlStateNormal];
    }else{
        [self setTitle:nil forState:UIControlStateNormal];

    }
    
    
}

@end
