//
//  VCardBaseInfoCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "VCardBaseInfoCell.h"
#import <Masonry/Masonry.h>

@interface VCardBaseInfoCell ()
@property (nonatomic,strong) UILabel *titleNameLable;
@property (nonatomic,strong) UILabel *titleInfoLable;
@property (nonatomic,strong) UIView *bottomLineView;
@end

@implementation VCardBaseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)buildSubview{
    [self.contentView addSubview:self.titleNameLable];
    [self.contentView addSubview:self.titleInfoLable];
    //[self.contentView addSubview:self.bottomLineView];
    
    WeakSelf
    [self.titleNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(16);
        make.top.equalTo(weakSelf.contentView).offset(10);
    }];
    
    [self.titleInfoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.titleNameLable);
        make.top.equalTo(weakSelf.titleNameLable.mas_bottom).offset(8);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
//    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(weakSelf.titleNameLable);
//        make.trailing.equalTo(weakSelf.contentView);
//        make.height.mas_equalTo(0.5);
//        make.bottom.equalTo(self.contentView).offset(-1);
//    }];
}


- (void)loadContent{
    if (self.data) {
        NSDictionary *cellData = (NSDictionary *)self.data;
        
        if (cellData[@"titleName"]) {
            [self.titleNameLable setText:cellData[@"titleName"]];
        }
        
        if (cellData[@"titleValue"]) {
            [self.titleInfoLable setText:cellData[@"titleValue"]];
        }
        
    }
}


#pragma mark - 懒加载控件
- (UILabel *)titleInfoLable{
    if (!_titleInfoLable) {
        UILabel *lable = [[UILabel alloc]init];
        [lable setFont:Font_Large_Text];
        _titleInfoLable = lable;
    }
    return _titleInfoLable;
}

- (UILabel *)titleNameLable{
    if (!_titleNameLable) {
        UILabel *lable = [[UILabel alloc]init];
        [lable setFont:Font_Medium_Text];
        [lable setTextColor:fontNomalColor];
        _titleNameLable = lable;
    }
    return _titleNameLable;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [UIView new];
        [_bottomLineView setBackgroundColor:fontNomalColor];
    }
    return _bottomLineView;
}

@end
