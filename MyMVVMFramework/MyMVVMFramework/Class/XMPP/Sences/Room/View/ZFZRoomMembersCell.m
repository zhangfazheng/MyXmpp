//
//  ZFZRoomMembersCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/14.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRoomMembersCell.h"
#import "UIImage+RoundImage.h"
#import <Masonry/Masonry.h>
#import <ChameleonFramework/Chameleon.h>


@interface ZFZRoomMembersCell ()
@property (nonatomic,strong)UILabel *countLable;
@end

@implementation ZFZRoomMembersCell

- (void)loadContent{
    if (self.data) {
        ZFZRoomMemberCellModel *roomMember = (ZFZRoomMemberCellModel *)self.data;
        
//        NSArray *toolArry   = @[@{@"toolName":@"百科全书",@"icon":@"icon-library"},
//                                @{@"toolName":@"日程表",@"icon":@"icon-curriculum"},
//                                @{@"toolName":@"工作计划",@"icon":@"icon-exam"},
//                                @{@"toolName":@"消息查询",@"icon":@"icon-score"},
//                                @{@"toolName":@"工作",@"icon":@"icon-homework-inline"},
//                                @{@"toolName":@"市场",@"icon":@"icon-second-hand"},
//                                @{@"toolName":@"说说",@"icon":@"icon-social"},
//                                @{@"toolName":@"使用手册",@"icon":@"icon-elec"},
//                                @{@"toolName":@"日程课表",@"icon":@"icon-lab"},
//                                @{@"toolName":@"日历",@"icon":@"icon-calendar"},
//                                @{@"toolName":@"其他",@"icon":@"icon-lost"}];
//        NSMutableArray *members = [NSMutableArray arrayWithCapacity:toolArry.count];
//        
//        for (NSDictionary *dic in toolArry) {
//            ZFZFriendModel * member = [ZFZFriendModel initWithInfoDic:dic];
//            [members addObject:member];
//        }
        [self setupIconView:roomMember];
        //设置图标
        if (!isEmptyString(roomMember.iconPath)) {
            [self.imageView setImage:[UIImage imageNamed:roomMember.iconPath]];
        }
        

    }
}



- (void)setMembersCount:(NSInteger)membersCount{
    _membersCount = membersCount;
    [self.countLable setText:[NSString stringWithFormat:@"%zd名成员",membersCount]];
    [self.contentView addSubview:_countLable];
    
    WeakSelf
    [_countLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-40);
        make.centerY.equalTo(weakSelf);
    }];
}

- (void)buildSubview{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setupIconView:(ZFZRoomMemberCellModel *)members{
    //文字预留宽度
    CGFloat titleWidth          = members.titleWidth;
    CGFloat leftInset           = members.leftInset;
    CGFloat rightInset           = members.rightInset;
    CGFloat topButtonInset      = members.topBottomSpace;
//    CGFloat leftRightInset      = ScreenWidth>=320?15:5;
    //CGFloat spacing             = 1;
    
    
    // 格子的宽高
    CGFloat appViewWH           = members.memberViewWH;
    
//    //文字预留宽度
//    CGFloat titleWidth          = 150;
//    CGFloat leftInset           = 56;
//    CGFloat topButtonInset      = 8;
//    //    CGFloat leftRightInset      = ScreenWidth>=320?15:5;
//    //CGFloat spacing             = 1;
//    
//    
//    // 格子的宽高
//    CGFloat appViewWH           = 60;
    
    int showCount               = (ScreenWidth-leftInset-rightInset-titleWidth)/appViewWH;
    
    int counts = members.membersArry.count + 1 > showCount?showCount:(int)(members.membersArry.count);
    
    for (int i = 0; i < counts ; i++) {
        CGFloat appViewX = leftInset + appViewWH * i;
        // 格子的Y = 顶部间距 + (格子的高 + 格子间间距) * 行号
        CGFloat appViewY = 8;
        
        // 设置格子的frame
        UIImageView *photonView = [[UIImageView alloc]initWithFrame:CGRectMake(appViewX, appViewY, appViewWH, appViewWH)];
        
        NSString *iconText = [NSString string];
        XMPPJID *memberJid = [XMPPJID jidWithString:members.membersArry[i].jid];
        NSString *memberName = isEmptyString(members.membersArry[i].name)? memberJid.user:members.membersArry[i].name;
        if (memberName.length > 2) {
            iconText= [memberName substringWithRange:NSMakeRange((memberName.length-2), 2)];
        }else{
            iconText = memberName;
        }
        
        UIImage *iconImage = [UIImage drawImageRadius:RadiusMake(appViewWH/2, appViewWH/2, appViewWH/2, appViewWH/2) size:CGSizeMake(appViewWH, appViewWH) backgroundColor:RandomFlatColor text:iconText];
        
        [photonView setImage:iconImage];
        
        // 把格子添加到父控件中"控制器的view"
        [self.contentView addSubview:photonView];
        
        
    }
    
    //添加圆形图片
    UIImage * image = [self draImageWithSize:CGSizeMake(appViewWH, appViewWH)];
    UIButton * addbutton = [[UIButton alloc]initWithFrame:CGRectMake(leftInset + appViewWH * counts, topButtonInset, appViewWH, appViewWH)];
    //将添加成员按钮的图片设为虚线圆
    [addbutton setImage:image forState:UIControlStateNormal];
    
    //添加好友信号
    self.addMemberSignal = [[addbutton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_prepareForReuseSignal];
    
    [self.contentView addSubview:addbutton];
    
    
    

    //成员人数lable
    [self.countLable setText:[NSString stringWithFormat:@"%zd名成员",members.membersArry.count]];
    [self.contentView addSubview:_countLable];
    
    WeakSelf
    [_countLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-rightInset);
        make.centerY.equalTo(weakSelf);
    }];
    
}

//绘制虚线圆
- (UIImage *)draImageWithSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGRect rect = CGRectMake(0, 0, size.width, size.height);
//    CGContextScaleCTM(context, 1, -1);
//    CGContextTranslateCTM(context, 0, -rect.size.height);
    CGFloat height = size.height;
    CGFloat width = size.width;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:CGPointMake(width/2, height/2) radius:width/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    [path closePath];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];//段落样式
    
    style.alignment = NSTextAlignmentCenter;
    
    NSDictionary *dictAttributesCN = @{NSFontAttributeName:Font_Large_Title,NSForegroundColorAttributeName:[UIColor redColor],NSParagraphStyleAttributeName:style};
    
    [@"+" drawInRect:CGRectMake(15, 15, 30, 30) withAttributes:dictAttributesCN];
//    CGContextDrawImage(context, rect, image.CGImage);
    
    path.lineWidth = 1;
    CGFloat dashPattern[] = {3,1};// 3实线，1空白
    [path setLineDash:dashPattern count:1 phase:1];
    [[UIColor grayColor] setStroke];
    [path stroke];
    
    UIImage *currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    return currentImage;
}

- (UILabel *)countLable{
    if (!_countLable) {
        _countLable = [[UILabel alloc]init];
        [_countLable setFont:Font_Medium_Text];
        [_countLable setTextColor:[UIColor grayColor]];
    }
    return _countLable;
}

@end
