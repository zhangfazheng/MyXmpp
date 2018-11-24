//
//  DepartmentSelectTableViewCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/12/18.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "DepartmentSelectTableViewCell.h"
#import "DepartmentModel.h"
#import <Masonry/Masonry.h>
#import <ChameleonFramework/Chameleon.h>


@interface DepartmentSelectTableViewCell()
@property (strong,nonatomic) UIButton *selectButton;
@property (strong,nonatomic) UILabel *departmentLable;
@property (strong,nonatomic) UIButton *subDepartmentButton;
@end

@implementation DepartmentSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)buildSubview{
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.departmentLable];
    
    WeakSelf
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(16);
        make.centerY.equalTo(weakSelf.contentView);
        make.width.height.mas_equalTo(21);
    }];
    
    [_departmentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.selectButton.mas_right).offset(8);
        make.top.equalTo(weakSelf.contentView).offset(8);
        make.bottom.equalTo(weakSelf.contentView).offset(-8);
        make.height.mas_equalTo(28).priorityHigh();
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)loadContent{
    if (self.data) {
        DepartmentModel *dept = (DepartmentModel *)self.data;

        if (dept.childCount>0) {
            self.subDepartmentButton.tag = 1000 + self.indexPath.row;
            //self.accessoryType = UITableViewCellAccessoryNone;
            self.accessoryView = self.subDepartmentButton;
            
            //创建一个单复用时就不再发送消息的信号
            self.openDataSignal = [[_subDepartmentButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_prepareForReuseSignal];
        }else{
            self.accessoryView = nil;
        }
        [self.departmentLable setText:dept.deptName];
    }
}


#pragma mark- 懒加载控件
- (UIButton *)selectButton{
    if (!_selectButton) {
        _selectButton = [[UIButton alloc]init];
        [_selectButton setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"checkbox_unable"] forState:UIControlStateHighlighted];
        [_selectButton setImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateSelected];
    }
    return _selectButton;
}

- (UILabel *)departmentLable{
    if (!_departmentLable) {
        _departmentLable = [UILabel new];
        [_departmentLable setFont:Font_Medium_Title];
    }
    return _departmentLable;
}



- (UIButton *)subDepartmentButton{
    if (!_subDepartmentButton) {
        _subDepartmentButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 44)];
        UIImage *image = [UIImage imageNamed:@"icon_new_next_deptrament"];
        [_subDepartmentButton setImage:[UIImage imageNamed:@"icon_new_next_deptrament"] forState:UIControlStateNormal];
        [_subDepartmentButton setImage:[UIImage imageNamed:@"icon_new_next_deptrament"] forState:UIControlStateHighlighted];
        [_subDepartmentButton setTitle:@"下级" forState:UIControlStateNormal];
        [_subDepartmentButton.titleLabel setFont:Font_Medium_Title];
        [_subDepartmentButton setTitleColor:FlatSkyBlue forState:UIControlStateNormal];
        [_selectButton setContentMode:UIViewContentModeRight];
    }
    return _subDepartmentButton;
}

@end
