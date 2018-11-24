//
//  ZFZFriendCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZFriendCell.h"
#import <ChameleonFramework/Chameleon.h>
#import <Masonry/Masonry.h>
#import "ZFZFriendModel.h"


@interface ZFZFriendCell ()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel  *nikNameLable;
@property (nonatomic,strong) UILabel *statusLable;
@end

@implementation ZFZFriendCell

- (void)buildSubview{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nikNameLable];
    [self.contentView addSubview:self.statusLable];
    
    WeakSelf
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(8);
        make.top.equalTo(weakSelf.contentView).offset(8);
        make.width.height.mas_equalTo(55).priorityHigh();
        make.bottom.equalTo(weakSelf.contentView).offset(-8);
    }];
    
    [_nikNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(8);
    }];
    
    [_statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nikNameLable.mas_bottom).offset(8);
        make.leading.equalTo(weakSelf.nikNameLable);
    }];
    
}


- (void)loadContent{
    if (self.data) {
        ZFZFriendModel *model = (ZFZFriendModel *)self.data;
        [self.nikNameLable setText:model.name];
        [self.statusLable setText:model.presenceStatus];
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

- (UILabel *)nikNameLable{
    if (!_nikNameLable) {
        UILabel *lable = [[UILabel alloc]init];
        [lable setFont:Font_Large_Text];
        //[lable setTextColor:FlatGray];
        
        
        _nikNameLable = lable;
    }
    return _nikNameLable;
}

- (UILabel *)statusLable{
    if (!_statusLable) {
        UILabel *lable = [UILabel new];
        [lable setFont:Font_Medium_Text];
        [lable setTextColor:FlatGray];
        
        
        _statusLable = lable;
    }
    return  _statusLable;
}

@end
