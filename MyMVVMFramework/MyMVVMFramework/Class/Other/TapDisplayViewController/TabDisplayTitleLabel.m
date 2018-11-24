//
//  TapDisplayTitleLabel.m
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/20.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "TabDisplayTitleLabel.h"

@implementation TabDisplayTitleLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    [_fillColor set];
    
    rect.size.width = rect.size.width * _progress;
    
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}


@end
