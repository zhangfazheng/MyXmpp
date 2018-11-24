//
//  ZFZRoomInfoCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/18.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRoomInfoCell.h"
#import <Masonry/Masonry.h>
#import <ChameleonFramework/Chameleon.h>

@interface ZFZRoomInfoCell ()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel  *roomNameLable;

@end

@implementation ZFZRoomInfoCell

- (void)buildSubview{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.roomNameLable];
    
    WeakSelf
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(8);
        make.top.equalTo(weakSelf.contentView).offset(8);
        make.width.height.mas_equalTo(55).priorityHigh();
        make.bottom.equalTo(weakSelf.contentView).offset(-8);
    }];
    
    [_roomNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconImageView);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(8);
    }];
    
}


- (void)loadContent{
    if (self.data) {
        ZFZRoomModel *model = (ZFZRoomModel *)self.data;
        [self.roomNameLable setText:model.roomName];
        //[self.statusLable setText:model.];
        [self.iconImageView setImage:model.phton];
    }
}


#pragma mark- 懒加载控件
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *imageview = [[UIImageView alloc]init];
        
        _iconImageView = imageview;
    }
    return _iconImageView;
}

- (UILabel *)roomNameLable{
    if (!_roomNameLable) {
        UILabel *lable = [[UILabel alloc]init];
        [lable setFont:Font_Large_Text];
        //[lable setTextColor:FlatGray];
        
        
        _roomNameLable = lable;
    }
    return _roomNameLable;
}


@end
