//
//  ZFZMessageFrame.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/23.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZMessageFrame.h"
#import "ZFZMessageModel.h"
#import "NSString+Scale.h"
#import "ExpressionHelper.h"
#import <ChameleonFramework/Chameleon.h>

@implementation ZFZMessageFrame
// 当拿到每行cell的数据之后根据每一行的数据来计算子控件的frame
- (void)setMessage:(ZFZMessageModel *)message{
    _message = message;
    CGFloat margin = 8;
    //CGFloat leftMargin = 8;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 聊天时间
    if (message.timeHiden == NO) {
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeW = screenW;
        CGFloat timeH = 35;
        _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    // 头像
    CGFloat iconW = 55;
    CGFloat iconH = iconW;
    CGFloat iconX = (message.type == ZFZMessageTypeOther) ? margin : (screenW - margin - iconW);
    CGFloat iconY = CGRectGetMaxY(_timeF);
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 昵称
    CGFloat nameMaxHeight = 21;
    CGSize nameMaxSize = CGSizeMake(screenW,nameMaxHeight);
    if (!isEmptyString(message.name)) {
        //设置文本参数（行间距，文本颜色，字体大小）
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        
//        [paragraphStyle setLineSpacing:4.0f];
//        [paragraphStyle setTailIndent:4.0f];
        
        //设置段落样式
        paragraphStyle.alignment = NSTextAlignmentCenter;//（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName,[UIColor lightTextColor],NSForegroundColorAttributeName,nil];
        
        //保存当前富文本
        NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc]initWithString:message.name attributes:dict];
        
        CGSize textSize = [nameText boundingRectWithSize:nameMaxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        CGFloat nameX = CGRectGetMaxX(_iconF);;
        CGFloat nameY = message.timeHiden?0:CGRectGetMaxY(_timeF);
        _nameF = (CGRect){{nameX, nameY}, textSize};
    }
    
    
    // 聊天内容
    CGFloat maxWidth = ScreenWidth - (iconW + margin)*2;
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    NSMutableAttributedString *text;
    if (message.type == ZFZMessageTypeMe) {
        text = [ExpressionHelper changeStrWithStr:message.text Font:[UIFont systemFontOfSize:17] maxSize:maxSize TextColor:[UIColor whiteColor]];
    }else{
        text = [ExpressionHelper changeStrWithStr:message.text Font:[UIFont systemFontOfSize:17] maxSize:maxSize TextColor:[UIColor blackColor]];
    }
    
    
    CGSize textSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    //设置富文本
    message.attributedText = text;
    
//    CGSize textSize = [text sizeForFont:textFont size:maxSize mode:NSLineBreakByWordWrapping];
    textSize = CGSizeMake(textSize.width + 40, textSize.height + 41);
    CGFloat textX = (message.type == ZFZMessageTypeOther) ? CGRectGetMaxX(_iconF) : (iconX - textSize.width);
    CGFloat textY = isEmptyString(message.name)?(message.timeHiden?0:CGRectGetMaxY(_timeF)):CGRectGetMaxY(_nameF);
    _textF = (CGRect){{textX, textY}, textSize};
    
    
    //消息读取状态
    if (!isEmptyString(message.readStatus) && message.type == ZFZMessageTypeMe) {
        //设置文本参数（行间距，文本颜色，字体大小）
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        
        //[paragraphStyle setLineSpacing:4.0f];
        
        //设置段落样式
        paragraphStyle.alignment = NSTextAlignmentRight;//（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:Font_Small_Title,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName,FlatNavyBlue,NSForegroundColorAttributeName,nil];
        
        //保存当前富文本
        NSMutableAttributedString *readStatusText = [[NSMutableAttributedString alloc]initWithString:message.readStatus attributes:dict];
        CGSize readStatusStatusSize = [readStatusText boundingRectWithSize:nameMaxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        CGFloat readStatusX = CGRectGetMaxX(_textF)- readStatusStatusSize.width;
        CGFloat readStatusY = CGRectGetMaxY(_textF);
        _statusF = (CGRect){readStatusX,readStatusY,readStatusStatusSize.width+12,readStatusStatusSize.height+8};
    }
    
    // cell的高度(行高)
    if (!isEmptyString(message.readStatus) && message.type == ZFZMessageTypeMe) {
        _cellHeight = MAX(CGRectGetMaxY(_statusF) + margin, CGRectGetMaxY(_iconF));
        //NSLog(@"cellHeight:%f",_cellHeight);
    }else{
        _cellHeight = MAX(CGRectGetMaxY(_textF) + margin, CGRectGetMaxY(_iconF));
        //NSLog(@"cellHeight:%f",_cellHeight);
    }
    

}

@end
