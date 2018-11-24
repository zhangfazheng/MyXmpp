//
//  EmoticonViewCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "EmoticonViewCell.h"
#import "EmoticonModel.h"
#import "EmoticonButton.h"
#import <UIKit/UIKit.h>
#import "UIView+Frame.h"
#import "NSTimer+Add.h"


@interface EmoticonViewCell (){
    BOOL _touchMoved;
    NSTimer *_backspaceTimer;
    __weak EmoticonButton *_currentMagnifierCell;
    CGFloat childW;
    CGFloat childH;
}
@property (strong,nonatomic) NSMutableArray<EmoticonButton *> *emoticonsArray;
@property (strong,nonatomic) UIButton *deleteButton;
@property (strong,nonatomic) UIImageView *magnifier;
@property (strong,nonatomic) UIImageView *magnifierContent;
@end

@implementation EmoticonViewCell

- (void)setupCell{
    [super setupCell];
    
    _magnifier = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Emoticons.bundle/toolBar/emoticon_keyboard_magnifier"]];
    _magnifierContent = [UIImageView new];
    _magnifierContent.size = CGSizeMake(40, 40);
    _magnifierContent.centerX = _magnifier.width / 2;
    [_magnifier addSubview:_magnifierContent];
    _magnifier.hidden = YES;
    [self addSubview:_magnifier];
    
    [self addChildButtons];
    
}


- (void)setEmoticons:(NSArray<EmoticonModel *> *)emoticons{
    if (emoticons) {
        _emoticons = emoticons;
        // 在这里给20个表情赋值
        //subviews
        //            emoticonsArray
        
        // 针对于现象提出改善的方案,再用另外一个方法解决这个问题

        for (EmoticonButton *button in self.emoticonsArray) {
            button.hidden = YES;
        }
        
        for (int i = 0; i<self.emoticons.count; i++) {
            EmoticonButton *button  = self.emoticonsArray[i];
            button.rac_command      = self.viewModel.emoticonCommand;
            button.emoticon         = emoticons[i];
            button.hidden           = NO;
        }
        
    }
}





- (void)addChildButtons{
    childW = self.bounds.size.width/7;
    childH = self.bounds.size.height/3;
    
    for (int i=0; i<20; i++) {
        int col     = i % 7; // 列
        int row     = i / 7; // 行
        
        CGFloat x   = childW * col;
        CGFloat y   = childH * row;
        

        EmoticonButton *button =[EmoticonButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:32];
        
        button.frame = CGRectMake(x, y, childW, childH);
        
        [self.contentView addSubview:button];
        
        [self.emoticonsArray addObject:button];
    }
    
    // 单独添加删除按钮
    
    self.deleteButton.frame = CGRectMake(childW * 6, childH * 2, childW, childH);
    
    [self.contentView addSubview:_deleteButton];
    
}

- (NSMutableArray<EmoticonButton *> *)emoticonsArray{
    if (!_emoticonsArray) {
        _emoticonsArray = [NSMutableArray arrayWithCapacity:21];
    }
    return  _emoticonsArray;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        UIButton *button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        
        _deleteButton = button;
        
    }
    return  _deleteButton;
}

@end
