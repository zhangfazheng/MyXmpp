//
//  PlayerView.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/3.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "PlayerOption.h"
#import "PlayVideoToolsView.h"

NS_ASSUME_NONNULL_BEGIN
@interface PlayerView : UIView
#pragma mark -  参数
/*
 全屏/退出代理方法
 */
@property(nonatomic,strong)RACCommand * fullBtnOrBackBtnClickDelegate;
/*
 播放器播放状态发生变化的代理方法
 */
@property(nonatomic,strong)RACCommand *playBackStateDidChangeDelgate;
/*
 播放器加载状态发生变化的代理方法
 */
@property(nonatomic,strong)RACCommand *playLoadStatesDelegate;
/*
 播放器状态发生变化的代理方法
 */
@property(nonatomic,strong)RACCommand *playStatesDelegate;
/*
 网络发生变化的代理方法
 */

/*
 player视图的基视图
 */
@property(nonatomic,strong)UIView *playerBaseView;
/*
 IJKplayer播放器
 */
@property(nonatomic,strong)IJKFFMoviePlayerController *player;
/*
 播放器的远程播放URL
 */
@property(nonatomic,copy)NSString *url;
/*
 蒙版,上面放一些时间label，播放按钮之类的
 */
@property(nonatomic,strong)PlayVideoToolsView *coverView;
/*
 网络切换的时候需要显示的提示界面
 */
//@property(nonatomic,strong)ZFTNetNotiView *netShowView;

/*
 播放器加载界面
 */
//@property(nonatomic,strong)ZFTLoadingView *loadingView;
/*
 锁定按钮
 */
//@property(nonatomic,strong)ZFTButton *btnLock;


/*
 定时器
 */
@property(nonatomic,strong)NSTimer *timer;

/*
 播放器的一些相关参数
 */
@property(nonatomic,strong)PlayerOption *playerOption;

/*
 占位图片
 */
@property(nonatomic,strong)UIImageView *playerPlaceHolderImg;//刚开始播放视频的时候占位图片

/*
 控制器
 */
@property(nonatomic,strong)UIViewController<PlayVideoToolsViewDelegate> *playerViewConctroller;

#pragma mark - 方法名
/*
 初始化视频播放器
 */
-(instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate url:(NSString *)url placeHolderImg:(NSString * __nullable)placeHolderImgName playerOption:(PlayerOption * __nullable)playerOption;






/*
 设置视频播放器SuperView
 */
-(void)setUpPlayerBaseView;


/*
 播放器的播放方法
 */
-(void)play;


/*
 播放器的暂停方法
 */
-(void)pause;


/*
 触发播放器的暂停方法，但是不会记录当前的暂停状态
 */
-(void)pauseWithoutRecoder;

/*
 播放器将要进行播放
 */
- (void)prepareToPlay;


/*
 停止播放
 */
- (void)stop;


/*
 释放视频播放器
 */
-(void)releasePlayer;


/*
 记录当前视频播放器的属性
 */
-(void)RecordThePropertiesOfThePlayer;


NS_ASSUME_NONNULL_END
@end
