//
//  EquipmentTextCell.m
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/20.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "EquipmentTextCell.h"
#import "Masonry.h"
#import "TileCellModel.h"

@interface EquipmentTextCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *valueLabel;
@property (nonatomic,strong) UILabel *uitsLable;
@end

@implementation EquipmentTextCell
- (void)setupCell {
    
    //self.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    //cell被选中时的颜色
    //self.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    //    self.layer.shadowColor = [UIColor grayColor].CGColor;
    //    self.layer.shadowRadius = 5;
    //    self.layer.shadowOpacity = .5f;
}

- (void)buildSubview {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.uitsLable];
    
    WeakSelf
    //self.contentView setLayoutMargins:<#(UIEdgeInsets)#>
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.valueLabel);
        make.left.equalTo(weakSelf.contentView).offset(18);
        make.width.mas_equalTo(80);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(8);
        make.left.equalTo(weakSelf.titleLabel.mas_right).offset(8);
        make.bottom.equalTo(weakSelf.contentView).offset(-8);
        make.height.mas_greaterThanOrEqualTo(30).priorityHigh();
        //make.right.equalTo(weakSelf.contentView).offset(-8);
    }];
    
    [self.uitsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLabel);
        make.height.equalTo(weakSelf.titleLabel);
        make.width.mas_equalTo(20);
        make.left.equalTo(weakSelf.valueLabel.mas_right).offset(8);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-16);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(weakSelf);
    }];
}

- (void)loadContent{
    if (self.dataAdapter.data) {
        
        TileCellModel *item  = self.dataAdapter.data;
        self.titleLabel.text = item.tilleString;
        self.valueLabel.text = item.valueString ;
        
        if (!isEmptyString(item.units)) {
            self.uitsLable.hidden=NO;
            self.uitsLable.text = item.units;
            
        }else{
            self.uitsLable.hidden=YES;
            //            WeakSelf
            //            [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            //                make.left.equalTo(weakSelf.titleLabel.mas_right).offset(8);
            //                make.centerY.equalTo(weakSelf.titleLabel);
            //                make.height.mas_equalTo(34);
            //                make.right.equalTo(weakSelf.contentView).offset(-44);
            //            }];
        }
    }
    
    //self.backgroundColor = FlatWhite;
    
    //    if (self.indexPath.row % 2) {
    //
    //        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.05f];
    //
    //    } else {
    //
    //        self.backgroundColor = [UIColor whiteColor];
    //    }
    
}

//懒加载控件
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]init];
    }
    return _titleLabel;
}

- (UILabel *)valueLabel{
    if(!_valueLabel){
        _valueLabel = [[UILabel alloc]init];
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.numberOfLines = 0;
    }
    return _valueLabel;
}

- (UILabel *)uitsLable{
    if (!_uitsLable) {
        _uitsLable=[[UILabel alloc]init];
        _uitsLable.textAlignment=NSTextAlignmentRight;
        _uitsLable.hidden=YES;
    }
    return _uitsLable;
}

@end
