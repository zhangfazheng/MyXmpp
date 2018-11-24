//
//  SubmitCell.m
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/20.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "SubmitCell.h"
#import "Masonry.h"
#import "Chameleon.h"

@interface SubmitCell ()
@property (nonatomic,strong) UIButton * submitButton;
@end

@implementation SubmitCell

- (void)setupCell{
    [self.contentView addSubview:self.submitButton];
    
    WeakSelf
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(18);
        make.bottom.right.equalTo(weakSelf.contentView).offset(-18);
        make.height.offset(44).priorityHigh();
    }];
    
    [self.submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submitButtonClick{
    
    if ([self.submitDelegate respondsToSelector:@selector(submitButtonAction)]) {
        [self.submitDelegate submitButtonAction];
    }
}

#pragma mark-懒加载控件
- (UIButton *)submitButton{
    if(!_submitButton){
        UIButton *button=[[UIButton alloc]init];
        
        [button setTitle:@"确认提交" forState:UIControlStateNormal];
        //[button setTitle:@"停止查验" forState:UIControlStateSelected];
        button.layer.cornerRadius=5;
        
        [button setBackgroundColor:FlatSkyBlueDark];
        
        
        _submitButton=button;
    }
    return _submitButton;
}

@end
