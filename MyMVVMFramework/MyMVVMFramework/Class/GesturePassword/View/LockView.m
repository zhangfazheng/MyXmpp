//
//  LockView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/7/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "LockView.h"
#import "LockOptions.h"
#import "LockItemView.h"

@interface LockView ()
@property (nonatomic,copy)NSMutableString *passwordContainer;
@property (nonatomic,copy)NSString *firstPassword;
@property (nonatomic,strong) NSMutableArray<LockItemView *> *itemViews;
@property (nonatomic,strong) LockOptions *options;


@end

@implementation LockView

- (instancetype)initWithFrame:(CGRect)frame options:(LockOptions *)option{
    if (self = [super initWithFrame:frame]) {
        self.options = option;
        self.backgroundColor =option.backgroundColor;

        self.passwordTooShortSubject        = [[RACSubject alloc]init];
        self.verifyHandleSubject            = [[RACSubject alloc]init];
        self.passwordTwiceDifferentSubject  = [[RACSubject alloc]init];
        self.passwordFirstRightSubject      = [[RACSubject alloc]init];
        self.modifySubject                  = [[RACSubject alloc]init];
        
        
        for (int i=0; i<9; i++) {
            LockItemView *itemView = [[LockItemView alloc]initWithOptions: option];
            [self addSubview:itemView];
        }
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    if(self.itemViews.count == 0){
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddRect(context, rect);
    
    for (LockItemView *itemView in self.itemViews) {
        CGContextAddEllipseInRect(context, itemView.frame);
    }
    
    CGContextClip(context);
    
    
    //新建路径：管理线条
    CGMutablePathRef path = CGPathCreateMutable();
    
    [_options.lockLineColor setStroke];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 1);
    
    [self.itemViews enumerateObjectsUsingBlock:^(LockItemView * _Nonnull itemView, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint directPoint = itemView.center;
        if( idx == 0 ){
            CGPathMoveToPoint(path, NULL, directPoint.x, directPoint.y);
        } else {
            CGPathAddLineToPoint(path, NULL, directPoint.x, directPoint.y);

        }

    }];
   
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat itemViewWH = (self.frame.size.width - 4 * ITEM_MARGIN) / 3;
    for (int i = 0; i<self.subviews.count ;i++) {
        int row = i % 3;
        int col = i / 3;
        CGFloat x = ITEM_MARGIN * (row + 1) + row * itemViewWH;
        CGFloat y = ITEM_MARGIN * (col + 1) + col * itemViewWH;
        CGRect rect = CGRectMake(x, y, itemViewWH, itemViewWH);
        self.subviews[i].tag = i;
        self.subviews[i].frame = rect;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self lockHandle:touches];
    //[self handleBack];
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self lockHandle:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self gestureEnd];
}

// 电话等打断触摸过程时，会调用这个方法。
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self gestureEnd];
}

- (void)handleBack{
    switch (self.type) {
        case set:{
            if (isEmptyString(self.firstPassword)) {
                //设置密码
                
            }else{
                //配置密码
            }
            
            break;
        }
         
        case verify:{
           break;
        }
        case modify:{
            break;
        }
    }
    
}

//页面重绘
- (void)lockHandle:(NSSet<UITouch *> *)touches{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    LockItemView *itemView =[self itemViewWithTouchLocation:location];
    if (!itemView || [self.itemViews containsObject:itemView]) {
        return;
    }
    [self.itemViews addObject:itemView];
    
    [self.passwordContainer appendFormat:@"%zd",itemView.tag];
    [self calDirect];
    itemView.selected = YES;
    [self setNeedsDisplay];
}

- (LockItemView *)itemViewWithTouchLocation:(CGPoint)location{
    LockItemView *item;
    for(LockItemView *subView in self.subviews){
        if (!CGRectContainsPoint(subView.frame, location)) {
            continue;
        }
        item = subView;
        break;
    }
return item;
}

- (void)calDirect{
    NSInteger count = self.itemViews.count;
    if (count > 1) {
        LockItemView *last_1_ItemView = [_itemViews lastObject];
        LockItemView *last_2_ItemView = _itemViews[count - 2];
        
        CGFloat last_1_x = CGRectGetMinX(last_1_ItemView.frame);
        CGFloat last_1_y = CGRectGetMinY(last_1_ItemView.frame);
        CGFloat last_2_x = CGRectGetMinX(last_2_ItemView.frame);
        CGFloat last_2_y = CGRectGetMinY(last_2_ItemView.frame);
        
        if (last_2_x == last_1_x && last_2_y > last_1_y) {
            last_2_ItemView.direct = DirectTop;
        }
        if (last_2_y == last_1_y && last_2_x > last_1_x) {
            last_2_ItemView.direct = DirectLeft;
        }
        if (last_2_x == last_1_x && last_2_y < last_1_y) {
            last_2_ItemView.direct = DirectBottom;
        }
        if (last_2_y == last_1_y && last_2_x < last_1_x) {
            last_2_ItemView.direct = DirectRight;
        }
        if (last_2_x > last_1_x && last_2_y > last_1_y) {
            last_2_ItemView.direct = DirectLeftTop;
        }
        if (last_2_x < last_1_x && last_2_y > last_1_y) {
            last_2_ItemView.direct = DirectRightTop;
        }
        if (last_2_x > last_1_x && last_2_y < last_1_y) {
            last_2_ItemView.direct = DirectLeftBottom;
        }
        if (last_2_x < last_1_x && last_2_y < last_1_y) {
            last_2_ItemView.direct = DirectRightBottom;
        }
    }
}

- (void)gestureEnd{
    if (!isEmptyString(_passwordContainer)) {
        NSInteger count = _itemViews.count;
        if (count < _options.passwordMinCount) {
            //密码操作
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self resetItem];
            });
        }
        switch (_type) {
            case set:{
                [self setPassword];
                break;
            }
            case verify:{
                BOOL result;
                NSString *pwdLocal=[[NSUserDefaults standardUserDefaults]stringForKey:self.options.passwordKeySuffix];
                result = ([pwdLocal isEqualToString: self.passwordContainer]);
                [self.verifyHandleSubject sendNext:@(result)];
                
                break;
            }
            case modify:{
                
                [self.modifySubject sendNext:self.passwordContainer];
                
                break;
            }
               
        }
    }
    [self resetItem];
}

//设置密码，处理密码设置中可能产生的各种事件
- (void)setPassword{
    //第一次密码为空时让第一次密码等于该密码
    if (isEmptyString(self.firstPassword)) {
        self.firstPassword = self.passwordContainer;
        [self.passwordFirstRightSubject sendNext:self.firstPassword];
    }else if (![self.firstPassword isEqualToString:self.passwordContainer]){//如果两次输入密码不一致
        [self.passwordTwiceDifferentSubject sendNext:nil];
    }else{//如果验证通过进行密码设置
        [self.passwordTwiceDifferentSubject sendNext:self.firstPassword];
    }
}


- (void)resetItem{
    for (LockItemView *item in self.itemViews) {
        item.selected = NO;
        item.direct = 0;
    }
    [_itemViews removeAllObjects];
    [self setNeedsDisplay];
    [_passwordContainer deleteCharactersInRange:NSMakeRange(0, _passwordContainer.length)] ;
}

- (void)resetPassword{
    _firstPassword = @"";
}

- (NSMutableArray<LockItemView *> *)itemViews{
    if (!_itemViews) {
        _itemViews = [NSMutableArray arrayWithCapacity:9];
    }
    return _itemViews;
}

- (NSMutableString *)passwordContainer{
    if (!_passwordContainer) {
        _passwordContainer = [NSMutableString string];
    }
    return _passwordContainer;
}

@end
