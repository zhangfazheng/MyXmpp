//
//  EpcEditCell.m
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/2.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "EpcEditCell.h"
#import "Masonry.h"

@interface EpcEditCell ()

@property (nonatomic,strong) UIButton * scanButton;
@property (nonatomic,strong) UILabel * epcTitlelable;
@property (nonatomic,strong) UILabel * epcValueLable;

@end

@implementation EpcEditCell

- (void)buildSubview{
    [super buildSubview];
    
    //self.backgroundColor=[UIColor blackColor];
    
    [self.contentView addSubview:self.epcTitlelable];
    [self.contentView addSubview:self.epcValueLable];
    [self.contentView addSubview:self.scanButton];
    
    [self.scanButton addTarget:self action:@selector(sacnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.epcTitlelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.centerY.equalTo(self.epcValueLable);
        //make.height.mas_equalTo(34);
        make.width.mas_equalTo(80);
    }];
    
    [self.epcValueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.epcTitlelable.mas_right).offset(8);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.greaterThanOrEqualTo(@34).priorityHigh();
        make.trailing.equalTo(self.contentView).offset(-44);
    }];
    
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.epcValueLable.mas_right).offset(8);
        make.centerY.equalTo(self.epcTitlelable);
        make.width.height.mas_equalTo(30);
    }];
}

- (void)loadContent{
    if (self.dataAdapter.data) {
        
        EpcEditCellModel *item  = self.dataAdapter.data;
        self.epcValueLable.text = item.epcId;
        self.scanButton.hidden = !item.isEdit;
        
        self.scavDelegate = item.scavDelegate;
    }
    
}
//扫描事件
- (void)sacnAction{
    NSLog(@"开始扫描");
    if ([self.scavDelegate respondsToSelector:@selector(scanEpcAction)]) {
        [self.scavDelegate scanEpcAction];
    }
}


#pragma 懒加载控件
- (UILabel *)epcTitlelable{
    if (!_epcTitlelable) {
        UILabel *lable = [[UILabel alloc]init];
        lable.text = @"EPC编码";
        
        _epcTitlelable = lable;
    }
    return _epcTitlelable;
}

- (UILabel *)epcValueLable{
    if (!_epcValueLable) {
        UILabel *lable = [[UILabel alloc]init];
        lable.numberOfLines=0;
        _epcValueLable = lable;
    }
    return _epcValueLable;

}

- (UIButton *)scanButton{
    {
        if (!_scanButton) {
            UIButton *button = [[UIButton alloc]init];
            [button setTintColor:[UIColor blackColor]];
            //[button setBackgroundColor:[UIColor blackColor]];
            
            [button setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
            
            _scanButton=button;
            //button.hidden=YES;
        }
        return _scanButton;
    }

}


@end

@implementation EpcEditCellModel


@end

