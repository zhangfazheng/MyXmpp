//
//  VCardHeadInfoCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "VCardHeadInfoCell.h"
#import <Masonry/Masonry.h>
#import "UIImage+RoundImage.h"
#import "UIView+Shadow.h"


@interface VCardHeadInfoCell ()
@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UIImageView *iconImageView;
/*职位*/
@property (nonatomic,strong) UILabel *positionLable;
@property (nonatomic,strong) UIView *mainView;
@end

@implementation VCardHeadInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)buildSubview{
    //UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(16, 16, ScreenWidth-32, 200)];
    UIView *mainView = [[UIView alloc]init];
    
    [self.contentView addSubview:mainView];
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(180).priorityHigh();
        make.top.left.equalTo(self.contentView).offset(16);
        make.bottom.right.equalTo(self.contentView).offset(-16);
    }];
    
    [mainView addSubview:self.nameLable];
    [mainView addSubview:self.iconImageView];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(mainView).offset(16);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView).offset(16);
        make.right.equalTo(mainView).offset(-16);
    }];
    
    [mainView addShadowColor:fontNomalColor offset:CGSizeMake(0, 5)];
    
}

- (void)loadContent{
    if (self.data) {
        NSDictionary *cellData = (NSDictionary *)self.data;
        
        if (cellData[@"titleName"]) {
            [self.nameLable setText:cellData[@"titleName"]];
        }
        
    }
}


#pragma mark - 懒加载控件
- (UILabel *)nameLable{
    if (!_nameLable) {
        UILabel *lable = [[UILabel alloc]init];
        [lable setFont:Font_Large_Text];
        _nameLable = lable;
    }
    return _nameLable;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        UIImage *image = [UIImage imageNamed:@"army6"];
        [imageView setImage:[image setRadius:30 size:CGSizeMake(60, 60)]];
        _iconImageView = imageView;
    }
    return _iconImageView;
}

@end
