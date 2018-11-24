//
//  ZFZInvitationValidationFooterView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/26.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZInvitationValidationFooterView.h"
#import <ChameleonFramework/Chameleon.h>
#import <Masonry/Masonry.h>

@interface ZFZInvitationValidationFooterView ()
@property (nonatomic,strong) UIButton *agreeButton;
@property (nonatomic,strong) UIButton *rejectButton;
@property (nonatomic,strong) UILabel *ifonLable;


@end

@implementation ZFZInvitationValidationFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withStatus:(ZFZAgreementStatus) status{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self buildSubview];
        
    }
    
    return self;
}

- (void)setAgreementStatus:(ZFZAgreementStatus)agreementStatus{
    _agreementStatus = agreementStatus;
    if (_agreementStatus == ZFZUnprocessed) {
        [self.contentView addSubview:self.agreeButton];
        [self.contentView addSubview:self.rejectButton];
        
        WeakSelf
        [_agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(20);
            make.top.equalTo(weakSelf.contentView).offset(8);
            make.height.mas_equalTo(30).priorityHigh();
            make.bottom.mas_equalTo(weakSelf.contentView).offset(-10);
        }];
        
        [_rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.agreeButton);
            make.left.equalTo(weakSelf.agreeButton.mas_right).offset(20);
            make.right.equalTo(weakSelf.contentView).offset(-20);
            make.width.height.equalTo(weakSelf.agreeButton);
        }];
        //[self.agreeButton addTarget:self action:@selector(jionRoomAction) forControlEvents:UIControlEventTouchUpInside];
        //[self.rejectButton addTarget:self action:@selector(rejectJionAction) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        if (_agreeButton) {
            [_agreeButton removeFromSuperview];
        }
        if (_rejectButton) {
            [_rejectButton removeFromSuperview];
        }
        
        if (_agreementStatus == ZFZReject){
            [self.ifonLable setText:@"已拒绝该申请"];
        }else{
            [self.ifonLable setText:@"已同意该申请"];
        }
        [self.contentView addSubview:self.ifonLable];
        
        WeakSelf
        [_ifonLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView).offset(10);
            make.centerX.equalTo(weakSelf.contentView);
            make.bottom.equalTo(weakSelf.contentView).offset(-10);
        }];
        
    }
}

//- (void)rejectJionAction{
//    [_rejectJionRoomCommand execute:self.invitation];
//}
//
//- (void)jionRoomAction{
//    [_jionRoomCommand execute:self.invitation];
//}

- (void)buildSubview{
    
}

#pragma mark- 懒加载控件
- (UIButton *)agreeButton{
    if (!_agreeButton) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"同意" forState:UIControlStateNormal];
        [button setBackgroundColor:FlatSkyBlue];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //关键语句
        button.layer.cornerRadius = 5.0;//2.0是圆角的弧度，根据需求自己更改
        
        //button.rac_command = self.tableView.
        
        _agreeButton = button;
        
        self.agreeWithSignal = [_agreeButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton;
}

- (UIButton *)rejectButton{
    if (!_rejectButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"拒绝" forState:UIControlStateNormal];
        [button setBackgroundColor:FlatRed];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //关键语句
        button.layer.cornerRadius = 5.0;//2.0是圆角的弧度，根据需求自己更改
        
        _rejectButton = button;
        self.rejectJSignal = [_rejectButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    }
    return _rejectButton;
}

- (UILabel *)ifonLable{
    if (!_ifonLable) {
        _ifonLable = [[UILabel alloc]init];
        [_ifonLable setTextColor:FlatGray];
        [_ifonLable setFont:Font_Small_Title];
    }
    return _ifonLable;
}


@end
