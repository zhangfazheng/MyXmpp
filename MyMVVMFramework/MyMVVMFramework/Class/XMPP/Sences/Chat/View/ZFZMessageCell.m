//
//  ZFZMessageCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/23.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZMessageCell.h"
#import "UIImage+Resizeable.h"
#import <ChameleonFramework/Chameleon.h>

@interface ZFZMessageCell ()
// 消息时间
@property (nonatomic, weak) UILabel *timeLabel;
// 昵称
@property (nonatomic, weak) UILabel *nameLabel;
// 头像
@property (nonatomic, weak) UIImageView *iconView;
// 聊天内容
@property (nonatomic, weak) UIButton *textButton;
// 消息已读状态
@property (nonatomic, weak) UILabel *readStatusLable;

@end


@implementation ZFZMessageCell

- (void)setupCell{
    [super setupCell];
    
    // 给cell添加内部所有子控件
    // 消息时间Label
    UILabel *timeLabel = [[UILabel alloc] init];
    //        timeLabel.backgroundColor = [UIColor greenColor];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    //昵称标签
    UILabel *nameLabel = [[UILabel alloc] init];
    //        timeLabel.backgroundColor = [UIColor greenColor];
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //消息读取状态
    UILabel *statusLable = [[UILabel alloc] init];
    //statusLable.backgroundColor = FlatSkyBlue;
    statusLable.textColor = [UIColor whiteColor];
    statusLable.font = Font_Small_Title;
    statusLable.layer.cornerRadius = 5;
    statusLable.layer.masksToBounds = YES;
    statusLable.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:statusLable];
    self.readStatusLable = statusLable;
    
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 添加内容
    UIButton *textButton = [[UIButton alloc] init];
    
    [textButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    textButton.titleLabel.numberOfLines = 0;
    textButton.titleLabel.font = textFont;
    textButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.contentView addSubview:textButton];
    self.textButton = textButton;
    
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    //添加读取状态lable的点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchReadeStatusTapAction)];
    [self.readStatusLable addGestureRecognizer:tap];
    
}

#pragma mark- 点击读取状态，查看读取状态的代理方法
- (void)searchReadeStatusTapAction{
    if([self.readeStatusDelegate respondsToSelector:@selector(searchReadeStatus:)]){
        ZFZMessageFrame *messageFrame = (ZFZMessageFrame *)self.data;
        //消息
        ZFZMessageModel *message = messageFrame.message;
        [self.readeStatusDelegate searchReadeStatus:message.readerMemberArray];
    }
}

- (void)loadContent{
    if (self.data) {
        ZFZMessageFrame *messageFrame = (ZFZMessageFrame *)self.data;
        //消息
        ZFZMessageModel *message = messageFrame.message;
        if (message.timeHiden == NO) {
            self.timeLabel.hidden = NO;
            self.timeLabel.text = message.time;
            self.timeLabel.frame = messageFrame.timeF;
        } else {
            self.timeLabel.hidden = YES;
        }
        if (!isEmptyString(message.name)) {
            self.nameLabel.hidden = NO;
            self.nameLabel.textAlignment = NSTextAlignmentLeft;
            self.nameLabel.text = message.name;
            self.nameLabel.frame = messageFrame.nameF;
        }else{
            self.nameLabel.hidden = YES;
        }
        if (!isEmptyString(message.readStatus)) {
            self.readStatusLable.hidden = NO;
            if ([message.readStatus isEqualToString:@"已读"]) {
                [self.readStatusLable setBackgroundColor:FlatGreen];
            }else{
                [self.readStatusLable setBackgroundColor:FlatSkyBlue];
            }
            self.readStatusLable.text = message.readStatus;
            self.readStatusLable.frame = messageFrame.statusF;
        }else{
            self.readStatusLable.hidden = YES;
        }
        
        //获取富文本
        NSMutableAttributedString *messageAttributed = message.attributedText;
        if (message.type == ZFZMessageTypeMe) {
            //设置富文本颜色
            //[messageAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, messageAttributed.length)];
            [self setIconWithImage:message.iconImage messageBackNorImage:@"chat_send_nor" backHighImaeg:@"chat_send_press_pic"];
            
        } else {
            
            //[messageAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, messageAttributed.length)];
            [self setIconWithImage:message.iconImage messageBackNorImage:@"chat_recive_nor" backHighImaeg:@"chat_recive_press_pic"];
            
        }
        
        self.iconView.frame = messageFrame.iconF;
        
        //设置富文本
        [self.textButton setAttributedTitle:messageAttributed forState:UIControlStateNormal];
        self.textButton.frame = messageFrame.textF;

        //如果是统计消息添加统计消息点击事件
        if (message.isStatistics) {
            self.readStatusLable.userInteractionEnabled = YES;
        }else{
            self.readStatusLable.userInteractionEnabled = NO;
        }
    }
}

- (void)setIconWithImage:(UIImage *)iconImage messageBackNorImage:(NSString *)backNorImage backHighImaeg:(NSString *)hImage {
    // 设置用户头像
    self.iconView.image = iconImage;
    // 设置聊天内容按钮的背景图片
    [self.textButton setBackgroundImage:[UIImage resizableImageWithName:backNorImage] forState:UIControlStateNormal];
    [self.textButton setBackgroundImage:[UIImage resizableImageWithName:hImage] forState:UIControlStateHighlighted];
    // 设置聊天内容的文字颜色
    //[self.textButton setTitleColor:textColor forState:UIControlStateNormal];
}

@end
