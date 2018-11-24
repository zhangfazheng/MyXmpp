//
//  SlideView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/2.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "SlideView.h"
#import "ZFZHelper.h"


//#define thumbImageViewH self.slideHeight self.height
#define thumbImageViewH self.height
#define thumbImageViewW self.width
#define progressH 5.0f

@interface SlideView ()
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) BOOL isPan;
@end

@implementation SlideView
+ (instancetype)rangeValueViewWithFrame:(CGRect)frame
                                   name:(NSString *)name
                               minValue:(CGFloat)minValue
                               maxValue:(CGFloat)maxValue
                           defaultValue:(CGFloat)defaultValue
{
    return nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self commonInit];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self commonInit];
    return self;
}

- (instancetype) initWithWidth:(CGFloat)witdth height:(CGFloat)height
{
    self = [super init];
    self.slideWidth = witdth;
    self.slideHeight = height;
    [self commonInit];
    return self;
}


- (instancetype) init
{
    self = [super init];
    [self commonInit];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadUI];
    });
}

- (void)commonInit
{
    _bufferValue    = 0.0f;
    _minValue       = 0.0f;
    _maxValue       = 0.0f;
    _currentValue   = 0.0f;
    _defaultValue   = 0.0f;
    
    
    UIView      *backgroundView =       [ZFZHelper newObjectsClass:[UIView class] AtaddView:self WithTag:4];
    UIView      *bufferProgressView   = [ZFZHelper newObjectsClass:[UIView class] AtaddView:self WithTag:3];
    UIView      *progressView   =       [ZFZHelper newObjectsClass:[UIView class] AtaddView:self WithTag:2];
    UIImageView *thumbImageView =       [ZFZHelper newObjectsClass:[UIImageView class] AtaddView:self WithTag:1];
    
    
    thumbImageView.image = ZFZIMAGE(@"PlayerImage.bundle/ic_slider_thumb");
    thumbImageView.layer.masksToBounds = YES;
    thumbImageView.frame = CGRectMake(0, 0, thumbImageViewH, thumbImageViewH);
    thumbImageView.userInteractionEnabled = true;
    
    backgroundView.frame = CGRectMake(thumbImageViewH/4, thumbImageViewH/2 - progressH/2, thumbImageViewW - thumbImageViewH/2, progressH);
    backgroundView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.5f];
    
    bufferProgressView.backgroundColor  =[UIColor colorWithWhite:0.7 alpha:0.5];
    bufferProgressView.frame = CGRectMake(thumbImageViewH/4, thumbImageViewH/2 - progressH/2, 0, progressH);
    
    progressView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    if (_pan) return;
    @weakify(self)
    _pan = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self)
        self.isPan = YES;
        CGPoint location = [self.pan locationInView:self];
        if (self.pan.state == UIGestureRecognizerStateCancelled) {
            
            self.isPan = NO;
            
        } else if (self.pan.state == UIGestureRecognizerStateBegan) {
            
            if (location.x >= 0 && (location.x + thumbImageViewH/2) <= thumbImageViewW) {
                thumbImageView.left = (location.x - (thumbImageViewH/2));
                progressView.width = location.x;
                //progressView.frame = CGRectMake(0, thumbImageViewH/2 - progressH/2, location.x, progressH);
            }
            
        } else if (self.pan.state == UIGestureRecognizerStateChanged) {
            //NSLog(@"%@",NSStringFromCGPoint(location));
            if (location.x >= 0 && (location.x + thumbImageViewH/2) <= thumbImageViewW) {
                thumbImageView.left = (location.x - (thumbImageViewH/2));
                progressView.width = location.x;
                //progressView.frame = CGRectMake(0, thumbImageViewH/2 - progressH/2, location.x, progressH);
            }
        }else if (self.pan.state == UIGestureRecognizerStateEnded) {
            //self.currentValue = (progressView.width/backgroundView.width) * self.maxValue;
            self.isPan = NO;
        }
        self.currentValue = (progressView.width/backgroundView.width) * self.maxValue;
        if (self.dragSliderSubject && self.maxValue > 0) {
            [self.dragSliderSubject sendNext:@(self.currentValue)];
        }
        
        //_block(self,self.pan.state);
    }];
    [thumbImageView addGestureRecognizer:_pan];
    
    
    //转屏的通知方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void) reloadUI
{
    UIView      *backgroundView =       [ZFZHelper newObjectsClass:[UIView class] AtaddView:self WithTag:4];
    backgroundView.frame = CGRectMake(thumbImageViewH/4, thumbImageViewH/2 - progressH/2, thumbImageViewW - thumbImageViewH/2, progressH);
}



#pragma mark - 屏幕旋转的通知方法。
- (void)statusBarOrientationChange:(NSNotification *)notification
{
    UIView      *backgroundView =       [ZFZHelper newObjectsClass:[UIView class] AtaddView:self WithTag:4];
    UIView      *bufferProgressView   = [ZFZHelper newObjectsClass:[UIView class] AtaddView:self WithTag:3];
    
    //屏幕旋转时更新进度条的长度
    backgroundView.frame = CGRectMake(thumbImageViewH/4, thumbImageViewH/2 - progressH/2, thumbImageViewW - thumbImageViewH/2, progressH);
    
    
    CGFloat rate = _bufferValue/_maxValue;
    if (isnan(rate)) {
        rate = 0.0f;
    }
    //重新设置缓冲进度值
    bufferProgressView.frame = CGRectMake(thumbImageViewH/4, thumbImageViewH/2 - progressH/2, thumbImageViewW * rate, progressH);
}


- (void)setBufferValue:(CGFloat)bufferValue
{
    if (_maxValue == 0) {
        return;
    }
    _bufferValue = bufferValue;
    {
        UIView      *bufferProgressView   = [ZFZHelper newObjectsClass:[UIView class] AtaddView:self WithTag:3];
        //UIView      *progressView   =       [HyHelper newObjectsClass:[UIView class] AtaddView:self WithTag:2];
        
        CGFloat rate = _bufferValue/_maxValue;
        if (isnan(rate)) {
            rate = 0.0f;
        }
        bufferProgressView.width = thumbImageViewW * rate;
    }
}

#pragma mark- 设置当前时间
- (void)setCurrentValue:(CGFloat)currentValue
{
    if (_maxValue == 0) {
        return;
    }
    if (currentValue <= _maxValue) {
        _currentValue = currentValue;
    }else{
        _currentValue = _maxValue;
    }
    if (currentValue >= _minValue) {
        _currentValue = currentValue;
    }else{
        _currentValue = _minValue;
    }
    [self compute];
}

- (void)compute
{
    if (_isPan) return;
    {
        UIView      *progressView   =       [ZFZHelper newObjectsClass:[UIView class] AtaddView:self WithTag:2];
        UIImageView *thumbImageView =       [ZFZHelper newObjectsClass:[UIImageView class] AtaddView:self WithTag:1];
        CGFloat rate = _currentValue/_maxValue;
        if (isnan(rate)) {
            rate = 0.0f;
        }
        thumbImageView.left = thumbImageViewW * rate;
        progressView.width = thumbImageViewW * rate;
        //progressView.frame = CGRectMake(0, thumbImageViewH/2 - progressH/2, thumbImageViewW * rate, progressH);
    }
}

- (void) :(CGRect)frame
{
    [super setFrame:frame];
    [self reloadUI];
}

- (void)dragSliderCompleteWithSubject:(RACSubject *)dragSliderSubject
{
    _dragSliderSubject = dragSliderSubject;
}

#pragma mark- 设置最大时间时如果最大时间为0时，隐藏进度条
- (void)setMaxValue:(CGFloat)maxValue{
    if(maxValue <= 0){
        [ZFZHelper newObjectsClass:[UIView class] AtaddView:self WithTag:4].hidden = YES;
        [ZFZHelper newObjectsClass:[UIView class] AtaddView:self WithTag:3].hidden = YES;
        [ZFZHelper newObjectsClass:[UIView class] AtaddView:self WithTag:2].hidden = YES;
        [ZFZHelper newObjectsClass:[UIImageView class] AtaddView:self WithTag:1].hidden = YES;
    }else{
        [ZFZHelper newObjectsClass:[UIView class] AtaddView:self WithTag:4].hidden = NO;
        [ZFZHelper newObjectsClass:[UIView class] AtaddView:self WithTag:3].hidden = NO;
        [ZFZHelper newObjectsClass:[UIView class] AtaddView:self WithTag:2].hidden = NO;
        [ZFZHelper newObjectsClass:[UIImageView class] AtaddView:self WithTag:1].hidden = NO;
    }
    _maxValue = maxValue;
}


@end
