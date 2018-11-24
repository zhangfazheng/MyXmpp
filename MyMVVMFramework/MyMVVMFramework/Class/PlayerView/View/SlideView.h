//
//  SlideView.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/2.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideView : UIView
/**
 *  一些值的设置
 */
@property (nonatomic)           CGFloat    bufferValue;
@property (nonatomic)           CGFloat    minValue;
@property (nonatomic)           CGFloat    maxValue;
@property (nonatomic)           CGFloat    currentValue;
@property (nonatomic)           CGFloat    defaultValue;
@property (nonatomic)           CGFloat    slideHeight;
@property (nonatomic)           CGFloat    slideWidth;
@property (nonatomic, strong)   RACSubject * dragSliderSubject;

/**
 *  便利构造器创建出视图
 *
 *  @param frame        控件的尺寸
 *  @param name         控件名字
 *  @param minValue     最小值
 *  @param maxValue     最大值
 *  @param defaultValue 默认值
 *
 *  @return 视图对象
 */
+ (instancetype)rangeValueViewWithFrame:(CGRect)frame
                                   name:(NSString *)name
                               minValue:(CGFloat)minValue
                               maxValue:(CGFloat)maxValue
                           defaultValue:(CGFloat)defaultValue;

- (void)dragSliderCompleteWithSubject:(RACSubject *)dragSliderSubject;

- (instancetype) initWithWidth:(CGFloat)witdth height:(CGFloat)height;

- (void)setBufferValue:(CGFloat)bufferValue;

- (void)setCurrentValue:(CGFloat)currentValue;

@end
