//
//  ZFZManageMemberCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/19.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZManageMemberCell.h"
#import <ChameleonFramework/Chameleon.h>
#import <Masonry/Masonry.h>
#import "ZFZFriendModel.h"

@interface ZFZManageMemberCell ()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel  *nikNameLable;
@property (nonatomic,strong) UIImageView *statusImageView;

@end

@implementation ZFZManageMemberCell

- (void)buildSubview{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nikNameLable];
    [self.contentView addSubview:self.statusImageView];
    
    WeakSelf
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(8);
        make.width.height.mas_equalTo(32);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.statusImageView.mas_right).offset(8);
        make.top.equalTo(weakSelf.contentView).offset(8);
        make.width.height.mas_equalTo(50).priorityHigh();
        make.bottom.equalTo(weakSelf.contentView).offset(-8);
    }];
    
    [_nikNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconImageView);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(8);
    }];
    
}



- (void)loadContent{
    if (self.data) {
        ZFZFriendModel *model = (ZFZFriendModel *)self.data;
        [self.nikNameLable setText:model.name];
        [self.iconImageView setImage:model.phton];
        
        //设置好友选择状态
        if (model.friendSelectType == ZFZUnenable) {
            [self.statusImageView setImage:[UIImage imageNamed:@"btn_unselected"]];
        }else if(model.friendSelectType == ZFZSelected){
            [self.statusImageView setImage:[UIImage imageNamed:@"btn_selected"]];
        }else{
            [self.statusImageView setImage:[UIImage imageNamed:@"btn_original_circle"]];
        }
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


- (UIImageView *)statusImageView{
    if (!_statusImageView) {
        _statusImageView = [UIImageView new];
        //self.isEnable = YES;
    }
    return _statusImageView;
}



//- (void)setIsEnable:(BOOL)isEnable{
//    _isEnable = isEnable;
//    if (!isEnable) {
//        [self.statusImageView setImage:[UIImage imageNamed:@"btn_unselected"]];
//    }else{
//        [self.statusImageView setImage:[UIImage imageNamed:@"btn_original_circle"]];
//    }
//}
//
//- (void)setIsSelected:(BOOL)isSelected{
//    _isSelected = isSelected;
//    if (_isSelected) {
//        [self.statusImageView setImage:[UIImage imageNamed:@"btn_selected"]];
//    }else{
//        [self.statusImageView setImage:[UIImage imageNamed:@"btn_original_circle"]];
//    }
//}

@end
