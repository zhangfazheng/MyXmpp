//
//  ZFZGroupsSelectCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/28.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZGroupsSelectCell.h"
#import <Masonry/Masonry.h>
#import "ZFZEditTileCellModel.h"

@interface ZFZGroupsSelectCell ()
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UILabel *valueLable;
@end

@implementation ZFZGroupsSelectCell

-(void)setupCell{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self.contentView addSubview:self.titleLable];
    [self.contentView addSubview:self.valueLable];
    
    WeakSelf
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView).offset(18);
        
        //make.height.mas_equalTo(34);
        make.width.mas_equalTo(80);
    }];
    
    [self.valueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLable.mas_right).offset(8);
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.bottom.equalTo(weakSelf.contentView).offset(-10);
        make.height.mas_greaterThanOrEqualTo(34).priorityHigh();
        make.right.equalTo(weakSelf.contentView).offset(-8);
    }];
    
    //    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.top.right.bottom.equalTo(weakSelf);
    //    }];
    
}

- (void)loadContent{
    if (self.dataAdapter.data) {
        
        ZFZEditTileCellModel *item              = self.dataAdapter.data;
        self.titleLable.text                    = item.tilleString;
        self.valueLable.text                    = item.valueString ;
        
    }
    
}

#pragma mark-懒加载控件
- (UILabel *)titleLable{
    if (!_titleLable) {
        UILabel *lable          = [[UILabel alloc]init];
        lable.textAlignment     = NSTextAlignmentLeft;
        _titleLable             = lable;
    }
    return _titleLable;
}


- (UILabel *)valueLable{
    if (!_valueLable) {
        UILabel *lable          = [[UILabel alloc]init];
        //lable.textAlignment     = NSTextAlignmentRight;
        lable.numberOfLines     = 0;
        _valueLable             = lable;
    }
    return _valueLable;
}

@end
