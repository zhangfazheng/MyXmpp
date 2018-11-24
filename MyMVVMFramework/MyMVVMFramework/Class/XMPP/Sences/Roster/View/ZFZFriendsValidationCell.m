//
//  ZFZFriendsValidationCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/26.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZFriendsValidationCell.h"
#import "ZFZFriendsValidationModel.h"
#import "UIImage+RoundImage.h"
#import <Masonry/Masonry.h>

@interface ZFZFriendsValidationCell ()
@property (nonatomic,strong) UIImageView* iconImageView;
@property (nonatomic,strong) UILabel * inviterNameLable;
@property (nonatomic,strong) UILabel * inviteReasonLable;
@property (nonatomic,strong) UIButton * agreementButton;

@end

@implementation ZFZFriendsValidationCell

#pragma mark - 懒加载控件
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImage *icon = [UIImage imageNamed:@"army6"];
        icon = [icon setRadius:27 size:CGSizeMake(55, 55)];
        
        _iconImageView = [[UIImageView alloc]initWithImage:icon];
    }
    return _iconImageView;
}


-(void)buildSubview{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.inviterNameLable];
    [self.contentView addSubview:self.inviteReasonLable];
    [self.contentView addSubview:self.agreementButton];
    
    WeakSelf
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf).offset(8);
        make.bottom.equalTo(weakSelf).offset(-8);
        make.width.height.mas_equalTo(50).priorityHigh();
    }];
    
    [self.inviterNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(8);
        make.top.equalTo(weakSelf).offset(8);
    } ];
    
    [self.inviteReasonLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.inviterNameLable);
        make.trailing.equalTo(weakSelf.inviterNameLable);
        make.top.equalTo(weakSelf.inviterNameLable.mas_bottom).offset(8);
    }];
    
    [self.agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.inviterNameLable.mas_right).offset(8);
        make.right.equalTo(weakSelf.contentView).offset(-8);
        make.width.mas_equalTo(80).priorityHigh();
        make.height.mas_equalTo(32);
    }];
    
}

- (void)loadContent{
    if (self.data) {
        ZFZFriendsValidationModel *friendsValidation = (ZFZFriendsValidationModel *)self.data;
        
        [self.inviterNameLable setText: friendsValidation.friendJid.user];
        [self.inviteReasonLable setText:friendsValidation.reason];
        
        switch (friendsValidation.agreementStatus) {
            case ZFZUnprocessed:
            {
                
                [_agreementButton setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.5]];
                break;
            }
            case ZFZAgreeWith:
            {
                _agreementButton.enabled = NO;
                [_agreementButton setBackgroundColor:[UIColor clearColor]];
                [_agreementButton setTitle:@"已同意" forState:UIControlStateDisabled];
                break;
            }
            case ZFZReject:
            {
                _agreementButton.enabled = NO;
                [_agreementButton setBackgroundColor:[UIColor clearColor]];
                [_agreementButton setTitle:@"已拒绝" forState:UIControlStateDisabled];
                break;
            }
                
            default:
                break;
        }
    }
}


- (UILabel *)inviterNameLable{
    if (!_inviterNameLable) {
        _inviterNameLable = [[UILabel alloc]init];
    }
    return _inviterNameLable;
}

- (UILabel *)inviteReasonLable{
    if (!_inviteReasonLable) {
        _inviteReasonLable = [[UILabel alloc]init];
    }
    return _inviteReasonLable;
}

- (UIButton *)agreementButton{
    if (!_agreementButton) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"同意" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.5]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //关键语句
        button.layer.cornerRadius = 2.0;//2.0是圆角的弧度，根据需求自己更改
               
        _agreementButton = button;
        
    }
    return _agreementButton;
}



@end
