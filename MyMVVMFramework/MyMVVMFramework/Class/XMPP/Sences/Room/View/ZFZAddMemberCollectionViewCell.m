//
//  ZFZAddMemberCollectionViewCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/19.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZAddMemberCollectionViewCell.h"

@interface ZFZAddMemberCollectionViewCell ()
@property (nonatomic,strong) UIImageView *iconImageView;
@end

@implementation ZFZAddMemberCollectionViewCell

- (void)buildSubview{
    [self.contentView addSubview:self.iconImageView];
    
    _iconImageView.frame = self.bounds;
}

- (void)setIcon:(UIImage *)icon{
    _icon = icon;
    [self.iconImageView setImage:icon];
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *imageView = [UIImageView new];
        
        _iconImageView = imageView;
    }
    return _iconImageView;
}

@end
