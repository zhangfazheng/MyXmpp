//
//  BaseViewController.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chameleon.h"
#import "BaseViewModel.h"

typedef NS_ENUM(NSInteger, YPLodingKind) {
    AnimationLoadingType = 0,//动画
    TextLoadingType,//文字
    AnimationAndTextType,//动画＋文字
};

typedef NS_ENUM(NSInteger, NetWorkType) {
    NoNetWork = 0,
    WiFi,
    WWAN,//手机网
    WWAN2G,
    WWAN3G,
    WWAN4G
};

typedef NS_ENUM(NSInteger, ErrorType) {
    NotShowError = 0,//无网不展示任何
    ShowImg,
    ShowText,
    ShowImgAndText
};

@interface BaseViewController : UIViewController


/**
 *  viewModel
 */
@property (strong, nonatomic, readonly) BaseViewModel *viewModel;
/**
 *  Screen's width.
 */
@property (nonatomic) CGFloat  width;

/**
 *  Screen's height.
 */
@property (nonatomic) CGFloat  height;


/**
 * 加载状态Label
 */
@property (nonatomic, strong) UILabel *statusLabel;

/**
 * 自定义loading动画图片组
 */
@property (nonatomic,strong) NSMutableArray *AnimationImgs;

/**
 * loading的种类 (默认是Animation动画)
 */
@property (nonatomic,assign) YPLodingKind tag;

/**
 * ErrorType 判断无网显示类型
 */
@property (nonatomic,assign) ErrorType errorTag;

/**
 * 判断网络情况
 */
@property (nonatomic,assign) NetWorkType netType;
/**
 * 是否监测网络
 */
@property (nonatomic,assign) BOOL isListenNet;



/// Returns a new view.
- (instancetype)initWithViewModel:(BaseViewModel *)viewModel;


/// Binds the corresponding view model to the view.
- (void)bindViewModel;

/**
 * 开始动画loading
 */
- (void)showLoading;

/**
 * 结束动画loading
 */
- (void)hideLoading;


/**
 * 隐藏网络错误提示
 */
- (void)hideNetError;

/**
 * 展示网络错误提示
 */
- (void)showNetError;

/**
 * 点击无网络提示图片触发方法
 */
- (void)refreshNet;


/**
 *  Base config.
 */
- (void)setup;

/**
 *  You can only use this method when the current controller is an UINavigationController's rootViewController.
 */
- (void)useInteractivePopGestureRecognizer;

/**
 *  You can use this property when this controller is pushed by an UINavigationController.
 */
@property (nonatomic)  BOOL  enableInteractivePopGestureRecognizer;

/**
 *  If this controller is managed by an UINavigationController, you can use this method to pop.
 *
 *  @param animated Animated or not.
 */
- (void)popViewControllerAnimated:(BOOL)animated;

/**
 *  If this controller is managed by an UINavigationController, you can use this method to pop to the rootViewController.
 *
 *  @param animated Animated or not.
 */
- (void)popToRootViewControllerAnimated:(BOOL)animated;




@end
