//
//  ExpressionAddCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/22.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ExpressionAddCell.h"
#import "ExpressionHelper.h"
#import "Masonry.h"

@interface ExpressionAddCell ()
@property (nonatomic,strong) UIButton    *btnIcon;
@property (nonatomic,strong) UILabel     *lbName;
@end

@implementation ExpressionAddCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    _btnIcon = [UIButton new];
    _btnIcon.userInteractionEnabled = NO;
    [self.contentView addSubview:_btnIcon];
    
    _lbName = [UILabel new];
    _lbName.font = [UIFont systemFontOfSize:14.0];
    _lbName.textAlignment = NSTextAlignmentCenter;
    _lbName.textColor     = [UIColor blackColor];
    [self.contentView addSubview:_lbName];
    
    [self layoutUI];
}

- (void)setModel:(ExtraModel *)model{
    
    _model = model;
    
    [_btnIcon setImage:[ExpressionHelper imageNamed:_model.icon_nor] forState:UIControlStateNormal];
    [_btnIcon setImage:[ExpressionHelper imageNamed:_model.icon_sel] forState:UIControlStateSelected];
    _lbName.text = _model.name;
}

- (void)layoutUI{
    __weak typeof(self) weakSelf = self;
    [_btnIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.width.height.mas_equalTo(50);
        make.top.equalTo(weakSelf.contentView).offset(10);
    }];
    
    
    [_lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.btnIcon.mas_bottom).offset(3);
        make.left.right.equalTo(weakSelf.contentView);
    }];
}



@end
