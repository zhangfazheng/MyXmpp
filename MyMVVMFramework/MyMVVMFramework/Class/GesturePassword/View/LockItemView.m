//
//  LockItemView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/30.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockItemView.h"


@interface LockItemView ()
@property(nonatomic,assign) CGFloat angle;
@property(nonatomic,assign) CGRect storeCalRect;
@property(nonatomic,assign) CGRect selectedRect;
@property(nonatomic,strong) LockOptions *options;
@end

@implementation LockItemView

- (instancetype)initWithOptions:(LockOptions *)options{
    if (self = [super initWithFrame:CGRectZero]) {
        self.options = options;
        self.backgroundColor = options.backgroundColor;
    }
    
    return self;
}


-(void)setDirect:(LockItemViewDirect)direct{
    _direct = direct;
    self.angle = M_PI_4 * (direct - 1);
    
    [self setNeedsDisplay];
}


- (void)setSelected:(BOOL)selected{
    _selected = selected;
    [self setNeedsDisplay];
}

- (CGRect)storeCalRect{
    if (CGRectEqualToRect(_storeCalRect, CGRectZero)) {
        CGFloat sizeWH      = self.bounds.size.width - self.options.arcLineWidth;
        CGFloat originXY    = self.options.arcLineWidth * 0.5;
        self.storeCalRect   = CGRectMake(originXY, originXY, sizeWH, sizeWH);
    }
    return _storeCalRect;
}

#pragma  mark- 绘图
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();

        //上下文旋转
    [self transForm:context rect:rect];
        //上下文属性设置
    [self propertySetting:context];
        //外环：普通
    [self circleNormal:context rect:rect];
        //选中情况下，绘制背景色
    if (_selected) {
        [self circleSelected:context rect:rect];
        [self direct:context rect:rect];
    }
}

//上下文旋转
- (void)transForm:(CGContextRef)context rect:(CGRect)rect{
    CGFloat translateXY = rect.size.width * 0.5;
    
    //平移
    CGContextTranslateCTM(context, translateXY, translateXY);
    
    /**
     1. 旋转上下文绘图坐标系，注意，必须在将路径添加至上下文之前对坐标系进行旋转，
     否则没有效果。
     */
    CGContextRotateCTM(context, self.angle);
    
    //再平移回来
    CGContextTranslateCTM(context, -translateXY, -translateXY);
}

//上下文属性设置
- (void)propertySetting:(CGContextRef)context{
    //设置线宽
    CGContextSetLineWidth(context, _options.arcLineWidth);
    
    if (_selected) {
        [_options.circleLineSelectedColor setStroke];
    } else{
        [_options.circleLineNormalColor setStroke];
    }

}

//外环：普通
- (void)circleNormal:(CGContextRef)context rect:(CGRect)rect{
    //新建路径：外环
    CGMutablePathRef loopPath = CGPathCreateMutable();
    
    //添加一个圆环路径
    CGPathAddEllipseInRect(loopPath, NULL, CGRectMake(rect.origin.x+1, rect.origin.y+1, rect.size.width-2, rect.size.height-2));
    
    //将路径添加到上下文中
    CGContextAddPath(context, loopPath);
    
    //绘制圆环
    CGContextStrokePath(context);
}

- (void)circleSelected:(CGContextRef)context rect:(CGRect)selectedRect{
    //新建路径：外环
    CGMutablePathRef circlePath = CGPathCreateMutable();
    
    //绘制一个圆形
    CGPathAddEllipseInRect(circlePath, NULL, self.selectedRect);
    
    [_options.circleLineSelectedCircleColor  setFill];
    
    //将路径添加到上下文中
    CGContextAddPath(context, circlePath);
    
    //绘制圆环
    CGContextFillPath(context);
}

////三角形：方向标识
- (void)direct:(CGContextRef)context rect:(CGRect)rect{
    if (self.direct == 0) {
        return;
    }
    //新建路径：三角形
    CGMutablePathRef trianglePathM = CGPathCreateMutable();
    CGFloat marginSelectedCirclev = 4;
    CGFloat w = 8;
    CGFloat h = 5;
    CGFloat topX = CGRectGetMinX(rect) + rect.size.width * 0.5;
    CGFloat topY = CGRectGetMinY(rect) + (rect.size.width * 0.5 - h - marginSelectedCirclev - _selectedRect.size.height * 0.5);
    
    CGPathMoveToPoint(trianglePathM, NULL, topX, topY);
    
    //添加左边点
    CGFloat leftPointX = topX - w * 0.5;
    CGFloat leftPointY = topY + h;
    
    CGPathAddLineToPoint(trianglePathM, NULL, leftPointX, leftPointY);
    
    //右边的点
    CGFloat rightPointX = topX + w * 0.5;
    CGPathAddLineToPoint(trianglePathM, NULL, rightPointX, leftPointY);
    
    //将路径添加到上下文中
    CGContextAddPath(context, trianglePathM);
    
    //绘制圆环
    CGContextFillPath(context);
}

- (CGRect)selectedRect{
    if (CGRectEqualToRect(_selectedRect, CGRectZero)) {
        CGFloat selectRectWH = self.bounds.size.width * _options.scale;
        CGFloat selectRectXY = self.bounds.size.width * (1 - _options.scale) * 0.5;
        
        _selectedRect = CGRectMake(selectRectXY, selectRectXY, selectRectWH, selectRectWH);
    }
    return _selectedRect;
}


@end
