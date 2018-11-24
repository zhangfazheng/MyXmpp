//
//  LockInfoView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/7/5.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "LockInfoView.h"
#import "LockItemView.h"

@interface LockInfoView ()
@property(nonatomic,strong) NSMutableArray<LockItemView *> *itemViews;
@end

@implementation LockInfoView

- (instancetype)initWithOptions:(LockOptions *) options frame :(CGRect) frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = options.backgroundColor;
        
        for (int i = 0; i<9; i++) {
            LockItemView *itemView = [[LockItemView alloc]initWithOptions:options];
            [self.itemViews addObject:itemView];
            [self addSubview:itemView];
        }

    }
    return self;
}

- (void)showSelectedItems:(NSString *)passwordStr{
    for (NSInteger i = 0; i<passwordStr.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subStr = [passwordStr substringWithRange:range];
        NSInteger index = [subStr integerValue];
        _itemViews[index].selected = YES;
    }
}

- (NSMutableArray<LockItemView *> *)itemViews{
    if (!_itemViews) {
        _itemViews = [NSMutableArray arrayWithCapacity:9];
    }
    return _itemViews;
}

- (void)resetItems{
    [_itemViews enumerateObjectsUsingBlock:^(LockItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected= NO;
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat marginV = 3;
    CGFloat rectWH = (self.frame.size.width - marginV * 2) / 3;
    
    for (int i = 0; i<self.itemViews.count; i++) {
        CGFloat row = (CGFloat)(i % 3);
        CGFloat col = (CGFloat)(i / 3);
        CGFloat rectX = (rectWH + marginV) * row;
        CGFloat rectY = (rectWH + marginV) * col;
        CGRect rect = CGRectMake(rectX, rectY, rectWH, rectWH);
        self.itemViews[i].tag = i;
        self.itemViews[i].frame = rect;
    }
}

@end
