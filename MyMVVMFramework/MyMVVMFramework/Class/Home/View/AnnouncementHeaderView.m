//
//  AnnouncementHeaderView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/10.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "AnnouncementHeaderView.h"
#import <Masonry/Masonry.h>

@interface AnnouncementHeaderView ()
@property (strong,nonatomic) UIImageView *iconImageView;
@property (strong,nonatomic) UILabel *announcementLable;
@property (strong,nonatomic) UIButton *moreButton;
@end

@implementation AnnouncementHeaderView

- (void)buildSubview{
    [self setHeaderFooterViewBackgroundColor:[UIColor whiteColor]];
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.announcementLable];
    [self.contentView addSubview:self.moreButton];
    
    WeakSelf
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(8);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [_announcementLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(8);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-8);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    //添加底部线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
    [lineView setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.1]];
    [self.contentView addSubview:lineView];
}


#pragma mark -  懒加载控件
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        [_iconImageView setImage:[UIImage imageNamed:@"Group7"]];
    }
    return _iconImageView;
}

- (UILabel *)announcementLable{
    if (!_announcementLable) {
        _announcementLable = [[UILabel alloc]init];
        [_announcementLable setText:@"公告内容"];
        [_announcementLable setTextColor:[UIColor grayColor]];
        [_announcementLable setFont:Font_Medium_Text];
    }
    return _announcementLable;
}

- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc]init];
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreButton setFont:Font_Medium_Text];
        [_moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _moreButton;
}

@end
