//
//  SingleSelectionTableViewCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/27.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "SingleSelectionTableViewCell.h"
#import <Masonry/Masonry.h>

@interface SingleSelectionTableViewCell ()

@property (nonatomic,strong) UILabel *titleLable;

@end

@implementation SingleSelectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)buildSubview{
    [self.contentView addSubview:self.titleLable];
    
    WeakSelf
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView).offset(18);
        
        //make.height.mas_equalTo(34);
        make.width.mas_equalTo(80);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)loadContent{
    if (self.dataAdapter.data) {
        
        SingleSelectionTableViewCellModel *item   = self.dataAdapter.data;
        self.titleLable.text                    = item.tilleString;
        
        for (UIView *sender in self.contentView.subviews) {
            if ([sender isKindOfClass:[UIButton class]]) {
                [sender removeFromSuperview];
            }
        }
        
        for (NSString *selection in item.selectionsArray) {
            
        }
        
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



@end


@implementation SingleSelectionTableViewCellModel

@end
