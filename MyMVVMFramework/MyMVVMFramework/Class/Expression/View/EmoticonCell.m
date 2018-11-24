//
//  EmoticonCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/20.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "EmoticonCell.h"
#import "UIView+Frame.h"
#import "ExpressionHelper.h"

@implementation EmoticonCell

- (void)buildSubview{
    _imageView = [UIImageView new];
    _imageView.size = CGSizeMake(32, 32);
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageView];
}


- (void)setEmoticon:(EmoticonModel *)emoticon {
    if (_emoticon == emoticon) return;
    _emoticon = emoticon;
    [self updateContent];
}

- (void)setIsDelete:(BOOL)isDelete {
    if (_isDelete == isDelete) return;
    _isDelete = isDelete;
    [self updateContent];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayout];
}

- (void)updateContent {
    [_imageView cancelCurrentImageRequest];
    _imageView.image = nil;
    
    if (_isDelete) {
        _imageView.image = [ExpressionHelper imageNamed:@"compose_emotion_delete"];
    } else if (_emoticon) {
        if (_emoticon.type == EmoticonTypeEmoji) {
            NSNumber *num = [NSNumber numberWithString:_emoticon.code];
            NSString *str = [NSString stringWithUTF32Char:num.unsignedIntValue];
            if (str) {
                UIImage *img = [UIImage imageWithEmoji:str size:_imageView.width];
                _imageView.image = img;
            }
        } else if (_emoticon.group.groupID && _emoticon.png){
            NSString *pngPath = [[ExpressionHelper emoticonBundle] pathForScaledResource:_emoticon.png ofType:nil inDirectory:_emoticon.group.groupID];
            if (!pngPath) {
                NSString *addBundlePath = [[ExpressionHelper emoticonBundle].bundlePath stringByAppendingPathComponent:@"additional"];
                NSBundle *addBundle = [NSBundle bundleWithPath:addBundlePath];
                pngPath = [addBundle pathForScaledResource:_emoticon.png ofType:nil inDirectory:_emoticon.group.groupID];
            }
            if (pngPath) {
                [_imageView setImageWithURL:[NSURL fileURLWithPath:pngPath] options:YYWebImageOptionIgnoreDiskCache];
            }
        }
    }
}

- (void)updateLayout {
    _imageView.center = CGPointMake(self.width / 2, self.height / 2);
}

@end
