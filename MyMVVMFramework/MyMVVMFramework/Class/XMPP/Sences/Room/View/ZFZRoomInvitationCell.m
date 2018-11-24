//
//  ZFZRoomInvitationCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/25.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRoomInvitationCell.h"
#import "ZFZInvitationModel.h"
#import "UIImage+RoundImage.h"
#import <Masonry/Masonry.h>
#import "ZFZInvitationListViewController.h"
#import "ZFZInvitationListViewModel.h"

@interface ZFZRoomInvitationCell ()
@property (nonatomic,strong) UIImageView* iconImageView;
@property (nonatomic,strong) UILabel * inviterNameLable;
@property (nonatomic,strong) UILabel * inviteReasonLable;
@property (nonatomic,strong) UIButton * agreementButton;
@property (nonatomic,strong) RACCommand * agreementCommand;
@end

@implementation ZFZRoomInvitationCell

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
        make.left.top.equalTo(weakSelf.contentView).offset(8);
        make.bottom.equalTo(weakSelf.contentView).offset(-8);
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
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.inviterNameLable.mas_right).offset(8);
        make.right.equalTo(weakSelf.contentView).offset(-8);
        make.width.mas_equalTo(80).priorityHigh();
        make.height.mas_equalTo(32);
    }];
    
    ZFZInvitationListViewController *invc =  (ZFZInvitationListViewController *)self.controller;
    ZFZInvitationListViewModel * viewModel = (ZFZInvitationListViewModel *)invc.viewModel;
    _agreementCommand = viewModel.jionRoomCommand;
}

- (void)loadContent{
    if (self.data) {
        ZFZInvitationModel *invitation = (ZFZInvitationModel *)self.data;
        
        [self.inviterNameLable setText: invitation.inviterJid.user];
        [self.inviteReasonLable setText:invitation.reason];
    
        switch (invitation.agreementStatus) {
            case ZFZUnprocessed:
            {
                
                [_agreementButton setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.5]];
                [_agreementButton addTarget:self action:@selector(agreementInvite) forControlEvents:UIControlEventTouchUpInside];
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

- (void)agreementInvite{
    [_agreementCommand execute:self.data];
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
        button.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blackColor]);//设置边框颜色
        button.layer.borderWidth = 1.0f;//设置边框颜色
        
        _agreementButton = button;
        
    }
    return _agreementButton;
}


@end
