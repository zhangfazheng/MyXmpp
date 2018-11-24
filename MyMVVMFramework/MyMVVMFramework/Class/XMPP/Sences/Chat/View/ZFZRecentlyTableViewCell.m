//
//  ZFZRecentlyTableViewCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/15.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRecentlyTableViewCell.h"
#import "UIImageView+RoundImage.h"
#import "ZFZXMPPManager.h"
#import "ZFZRecentlyModel.h"
#import "UIImage+RoundImage.h"

@interface ZFZRecentlyTableViewCell ()
/**
 好友头像
 */
@property (nonatomic,strong)UIImageView *headImage;

/**
 好友姓名
 */
@property (nonatomic,strong)UILabel *titleLabel;

/**
 最后一次聊天内容
 */
@property (nonatomic,strong)UILabel *detailLabel;

/**
 最后一次聊天时间
 */
@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,strong)UILabel *numLabel;

@end

@implementation ZFZRecentlyTableViewCell

- (void)buildSubview{
    [super buildSubview];
    
    //头像
    UIImageView *headImage = [[UIImageView alloc] init];
    headImage.frame = CGRectMake(10, 10, 50, 50);
    self.headImage=headImage;
    [self addSubview:headImage];
    //标题昵称
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(70, 10, ScreenWidth-90-70, 25);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor =fontBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.numberOfLines = 0;
    self.titleLabel=titleLabel;
    [self addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.frame = CGRectMake(70, 35, ScreenWidth-100, 25);
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.textColor =fontHightColor;
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.numberOfLines = 0;
    self.detailLabel=detailLabel;
    [self addSubview:detailLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.frame = CGRectMake(ScreenWidth-90, 10,80, 25);
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = fontHightColor;
    timeLabel.text = @"2017/09/16";
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textAlignment=NSTextAlignmentRight;
    timeLabel.numberOfLines = 0;
    self.timeLabel=timeLabel;
    [self addSubview:timeLabel];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.frame = CGRectMake(ScreenWidth-35,40,20,15);
    numLabel.backgroundColor = [UIColor redColor];
    numLabel.textColor =[UIColor whiteColor];
 
    numLabel.font = [UIFont systemFontOfSize:10];
    numLabel.textAlignment=NSTextAlignmentCenter;
    numLabel.numberOfLines = 0;
    numLabel.layer.cornerRadius=7.5;
    numLabel.layer.masksToBounds=YES;
    self.numLabel = numLabel;
    [self addSubview:numLabel];
    
}

- (void)loadContent{
    if (self.dataAdapter.data) {
        ZFZRecentlyModel *chat  = self.dataAdapter.data;
        if (!chat.iconImage) {
            [self.headImage setImageWithHTRadius:RadiusMake(25, 25, 25, 25) imageURL:[NSURL URLWithString:@""] placeholder:@"army6" contentMode:UIViewContentModeScaleToFill size:CGSizeMake(50, 50)];
        }else{
            [self.headImage setImage:chat.iconImage];
        }
        
        NSInteger num = chat.infoCount;
        if (num <= 0){
            _numLabel.hidden=YES;
        }else {
            _numLabel.hidden=NO;
        }
        
        _numLabel.text =[NSString stringWithFormat:@"%zd",num];
//        if (chat.isONLine) //在线
//        {
//            self.headImage.alpha=1;
//        }else //离线
//        {
//            self.headImage.alpha=0.2;
//        }
        
        self.titleLabel.text=chat.name;
        self.detailLabel.text=chat.infoString;
        self.timeLabel.text =chat.time;
    }
}

@end
