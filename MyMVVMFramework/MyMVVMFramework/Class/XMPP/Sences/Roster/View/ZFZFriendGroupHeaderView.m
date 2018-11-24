//
//  ZFZFriendGroupHeaderView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZFriendGroupHeaderView.h"
#import <ChameleonFramework/Chameleon.h>
#import <Masonry/Masonry.h>

@interface ZFZFriendGroupHeaderView ()

//@property (nonatomic, strong) UILabel *groupNameLabel;
@property (nonatomic, strong) UILabel *coutLabel;

@end

@implementation ZFZFriendGroupHeaderView

- (void)buildSubview{
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.openButton];
    //[self.contentView addSubview:self.groupNameLabel];
    [self.contentView addSubview:self.coutLabel];
    
    WeakSelf
    [_openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(8);
        make.width.mas_equalTo(250);
        //make.top.equalTo(weakSelf.contentView).offset(8);
        make.height.mas_equalTo(28).priorityHigh();
        //make.bottom.equalTo(weakSelf.contentView).offset(-8);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [_coutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-8);
        make.width.mas_equalTo(25);
        make.centerY.equalTo(weakSelf.openButton);
    }];
    
    
}

- (void)setGroup:(ZFZFriendGroupModel *)group{
    _group = group;
    if (group) {
        [self.openButton setTitle:group.name forState:UIControlStateNormal];
        
        
        NSString *coutString = [NSString stringWithFormat:@"%zd/%zd",group.onlineCount,group.friends.count];
        [self.coutLabel setText:coutString];
        
        self.openButton.tag = self.section;
        

        
        if (self.group.isOpened) { // 当前组展开后把图片旋转90度
            self.openButton.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        } else {
            self.openButton.imageView.transform = CGAffineTransformIdentity;
        }
    }
}


#pragma mark- 懒加载控件
- (UIButton *)openButton{
    if (!_openButton) {
        UIButton *button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"cell_rigth_icon"] forState:UIControlStateNormal];
        // 设置文字颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button.titleLabel setFont:Font_Medium_Title];
        
        // 设置按钮内部为水平左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 设置按钮内容的内边距
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        // 设置按钮内文字的内边距
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        //        btn.imageEdgeInsets
        // 设置按钮内的图片不拉伸
        button.imageView.contentMode = UIViewContentModeCenter;
        // 设置按钮内图片超出边框不裁剪
        button.imageView.clipsToBounds = NO;
        //button.tag = self.section+1000;
        
        WeakSelf
//        self.openSignal = [[[button rac_signalForControlEvents:UIControlEventTouchUpInside]doNext:^(UIButton *x) {
//            // 1.改为模型数据
//            @strongify(self)
//            self.group.opened = !self.group.isOpened;
//        }]take:1];
        self.openSignal = [[[button rac_signalForControlEvents:UIControlEventTouchUpInside]  takeUntil:self.rac_prepareForReuseSignal]doNext:^(UIButton *x) {
            // 1.改为模型数据
            weakSelf.group.opened = !weakSelf.group.isOpened;
        }];
        
        _openButton = button;
    }
    return _openButton;
}

//- (UILabel *)groupNameLabel{
//    if (!_groupNameLabel) {
//        _groupNameLabel = [UILabel new];
//        [_groupNameLabel setFont:Font_Medium_Text];
//    }
//    return _groupNameLabel;
//}

- (UILabel *)coutLabel{
    if (!_coutLabel) {
        UILabel *lable = [UILabel new];
        [lable setTextColor:FlatGray];
        [lable setFont:Font_Medium_Title];
        
        
        _coutLabel = lable;
    }
    return _coutLabel;
}

@end
