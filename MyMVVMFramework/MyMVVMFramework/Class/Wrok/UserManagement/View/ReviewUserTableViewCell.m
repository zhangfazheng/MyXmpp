//
//  ReviewUserTableViewCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/23.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ReviewUserTableViewCell.h"
#import <ChameleonFramework/Chameleon.h>
#import <Masonry/Masonry.h>
#import "UIImage+RoundImage.h"
#import "ReviewUserModel.h"

@interface ReviewUserTableViewCell ()
@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UIButton *auditButton;
@property (nonatomic,strong) UIButton *enableButton;
@property (nonatomic,strong) UILabel *auditStatusLable;
@end

@implementation ReviewUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (instancetype)init{
//    if (self = [super init]) {
//        self.accessoryType = UITableViewCellAccessoryDetailButton;
//    }
//    return self;
//}

- (void)buildSubview{
    //设置辅助视图
    self.accessoryType = UITableViewCellAccessoryDetailButton;
    
    [self.contentView addSubview:self.iconImage];
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.enableButton];
    [self.contentView addSubview:self.auditButton];
    [self.contentView addSubview:self.auditStatusLable];
    
    WeakSelf
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY .equalTo(weakSelf.contentView);
        make.width.height.mas_equalTo(50);
        make.left.equalTo(weakSelf.contentView).offset(8);
    }];
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(8);
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(8);
    }];
    
    
    [_enableButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.nameLable);
        make.top.equalTo(weakSelf.nameLable.mas_bottom).offset(8);
        make.bottom.equalTo(weakSelf.contentView).offset(-8);
    }];
    
    [_auditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.enableButton);
        make.left.equalTo(weakSelf.enableButton.mas_right).offset(10);
    }];
    
    [_auditStatusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY .equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView).offset(-8);
    }];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)loadContent{
    if (self.data) {
        ReviewUserModel *user = (ReviewUserModel *)self.data;
        NSString *auditStatus;
        NSString *name = user.realName;
        if (user.dealState == 1) {
            if (user.userState == 1) {
                auditStatus = @"已启用";
                [self.auditStatusLable setTextColor:FlatGreen];
                self.enableButton.selected = YES;
            }else{
                auditStatus = @"未启用";
                [self.auditStatusLable setTextColor:FlatSkyBlue];
                self.enableButton.selected = NO;
            }
            self.auditButton.selected = YES;
        }else if(user.dealState == 2){
            auditStatus = @"审核不通过";
            [self.auditStatusLable setTextColor:FlatRed];
            self.auditButton.selected = NO;
            [self.auditButton setTitle:@"审核不通过" forState:UIControlStateNormal];
        }else{
            auditStatus = @"待审核";
            [self.auditStatusLable setTextColor:FlatGray];
            self.auditButton.selected = NO;
            [self.auditButton setTitle:@"待审核" forState:UIControlStateNormal];
        }
        
        
        NSString *iconText =[NSString string];
        if (name.length > 2) {
            iconText= [name substringWithRange:NSMakeRange((name.length-2), 2)];
        }else{
            iconText = name;
        }
        
        UIImage *image = [UIImage drawImageRadius:RadiusMake(25, 25, 25, 25) size:CGSizeMake(50, 50) backgroundColor:RandomFlatColor text:iconText];
        [self.iconImage setImage:image];
        
        [self.nameLable setText:name];
        
        
        //if(!isEmptyString(auditStatus))
        [self.auditStatusLable setText:auditStatus];
    }
}


#pragma mark- 懒加载控件
- (UIImageView *)iconImage{
    if (!_iconImage) {
        UIImageView *imageView = [[UIImageView alloc]init];
        _iconImage = imageView;
    }
    return _iconImage;
}

- (UILabel *)nameLable{
    if (!_nameLable) {
        UILabel *lable = [[UILabel alloc]init];
        _nameLable = lable;
    }
    return _nameLable;
}

- (UIButton *)auditButton{
    if (!_auditButton) {
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"user_manage_btn_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"user_manage_btn_selected"] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button setTitle:@"待审核" forState:UIControlStateNormal];
        [button setTitle:@"已审核" forState:UIControlStateSelected];
        [button setTitleColor:FlatGray forState:UIControlStateNormal];
        [button setTitleColor:FlatGreen forState:UIControlStateSelected];
        _auditButton = button;
    }
    return _auditButton;
}

- (UIButton *)enableButton{
    if (!_enableButton) {
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"user_manage_btn_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"user_manage_btn_selected"] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button setTitle:@"未启用" forState:UIControlStateNormal];
        [button setTitle:@"已启用" forState:UIControlStateSelected];
        [button setTitleColor:FlatGray forState:UIControlStateNormal];
        [button setTitleColor:FlatGreen forState:UIControlStateSelected];
        _enableButton = button;
    }
    return _enableButton;
}

- (UILabel *)auditStatusLable{
    if (!_auditStatusLable) {
        UILabel *lable = [[UILabel alloc]init];
        _auditStatusLable = lable;
    }
    return _auditStatusLable;
}

@end
