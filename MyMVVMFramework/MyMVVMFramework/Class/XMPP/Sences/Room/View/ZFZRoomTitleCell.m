//
//  ZFZRoomTitleCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/14.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRoomTitleCell.h"
#import "Chameleon.h"
#import <Masonry/Masonry.h>

@interface ZFZRoomTitleCell ()
@property (nonatomic,strong) UILabel *nameLable;
//@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UISwitch *switchButton;
@end

@implementation ZFZRoomTitleCell

-(void)setType:(ZFZRightButtonType)type{
    _type = type;

    if (type == ZFZMessageTypeSwitch) {
        self.accessoryView = self.switchButton;
    }
}

- (void)buildSubview{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setNameString:(NSString *)nameString{
    _nameString = nameString;
    if (!_nameLable) {
        [self.contentView addSubview:self.nameLable];
        WeakSelf
        [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.contentView);
            make.right.equalTo(weakSelf.contentView).offset(-8);
        }];
    }
    
    [_nameLable setText:nameString];
    
    
}

- (void)loadContent{
    if (self.data) {
        NSDictionary *dict = (NSDictionary *)self.data;
        NSString *title     = dict[@"title"];
        NSString *name      = dict[@"name"];
        
        if (!isEmptyString(title)) {
            [self.textLabel setText:title];
        }
        
        if (!isEmptyString(name)) {
            self.nameString = name;
        }
        
    }
}

#pragma  mark- 懒加载控件
- (UILabel *)nameLable{
    if (!_nameLable) {
        UILabel *lable = [UILabel new];
        
        [lable setTextColor:FlatGray];
        [lable setFont:Font_Medium_Title];
        _nameLable = lable;
    }
    return _nameLable;
}

- (UISwitch *)switchButton{
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc]init];
    }
    return _switchButton;
}

//- (UIButton *)rightButton{
//    if (!_rightButton) {
//        UIButton * button = [UIButton new];
//        
//        [button setImage:[UIImage imageNamed:@"cell_rigth_icon"] forState:UIControlStateNormal];
//        
//        _rightButton = button;
//    }
//    return _rightButton;
//}

@end
