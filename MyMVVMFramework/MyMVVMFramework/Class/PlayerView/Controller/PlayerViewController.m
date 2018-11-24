//
//  PlayerViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/3.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "PlayerViewController.h"
#import "SDImageCache.h"
#import "PlayerView.h"
#import "PlayerOption.h"
#import "AppDelegate.h"

@interface PlayerViewController ()<PlayVideoToolsViewDelegate>

@property(nonatomic,strong)PlayerView *playerShowView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)PlayerOption *playerOptions;//存放视频播放器的一些属性
//@property(nonatomic,strong)ZFZNetNotiView *netShowView;//如果进来界面，没网或者4G网，用这个显示
@property(nonatomic,strong)UIButton *nextBtn;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isOrientationChangeOpt = YES;
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self addNotiFicationEvent];
}



#pragma mark - 懒加载netShowView

-(void)setUpUI
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationController.navigationBarHidden = YES;
    
    ZFZInterfaceOrientationType directionType = [self.playerOptions getCurrentScreenDirection];
    [self createPlayerViewWithScreenDirection:directionType isPlaying:YES currentTime:0.00];
    
}



#pragma mark - 创建播放器的相关操作
-(void)createPlayerViewWithScreenDirection:(ZFZInterfaceOrientationType)screenDirection isPlaying:(BOOL)isPlaying currentTime:(NSTimeInterval)playerCureentTime
{
    
    
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    __weak typeof(self) weakSelf = self;
    
    
    if (screenDirection == ZFZInterfaceOrientationPortrait) {
        double resultWithWToH = ScreenWidth/ScreenHeight> 1? ScreenHeight/ScreenWidth : ScreenWidth/ScreenHeight;
        CGRect frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth * resultWithWToH * 1.3);
        self.playerShowView = [[PlayerView alloc]initWithFrame:frame delegate:self url:self.playUrl placeHolderImg:@"placeHolderbg" playerOption:self.playerOptions];
    }
    else if (screenDirection == ZFZInterfaceOrientationLandscapeLeft) {
        NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        CGRect frame = self.view.bounds;
        self.playerShowView = [[PlayerView alloc]initWithFrame:frame delegate:self url:self.playUrl placeHolderImg:@"placeHolderbg" playerOption:self.playerOptions];
    }
    else if (screenDirection == ZFZInterfaceOrientationLandscapeRight) {
        NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        CGRect frame = self.view.bounds;
        self.playerShowView = [[PlayerView alloc]initWithFrame:frame delegate:self url:self.playUrl placeHolderImg:@"placeHolderbg" playerOption:self.playerOptions];
    }
    else  if ((screenDirection == ZFZInterfaceOrientationPortraitUpsideDown) ||(screenDirection == ZFZInterfaceOrientationUnknown )) {
        double resultWithWToH = ScreenWidth/ScreenHeight> 1? ScreenHeight/ScreenWidth : ScreenWidth/ScreenHeight;
        CGRect frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth * resultWithWToH * 1.3);
        self.playerShowView = [[PlayerView alloc]initWithFrame:frame delegate:self url:self.playUrl placeHolderImg:@"placeHolderbg" playerOption:self.playerOptions];
    }
    
    [self.view addSubview:self.playerShowView];
    if (self.playerOptions.totalTime) {
        self.playerShowView.playerPlaceHolderImg.hidden = YES;
    }
    //配置播放器类的相关代理方法
    
    //如果创建完成之后需要直接播放，就直接执行播放的方法
    if (isPlaying) {
        [self.playerShowView.player prepareToPlay];
        [self.playerShowView.player play];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}



#pragma mark - *******************************相关的通知方法***************************************
-(void)addNotiFicationEvent
{
    //转屏的通知方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
        //失去第一响应者之后的通知方法
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerRegistActiveNotificationEvent:) name:@"applicationWillResignActive"
                                               object:nil];
    //变成第一响应者的时候的通知方法
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerBecomeActiveNotificationEvent:) name:@"applicationDidBecomeActive"
                                               object:nil];
    if (self.isNetWorkChangeOpt) {
        //网络状态发生变化的时候的通知方法
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(playerNetWorkStatesChange:) name:@"netWorkChangeEventNotification"
                                                  object:nil];

    }
    
}






#pragma mark - ********************************播放器的全屏/退出按钮点击的代理方法**************************

#pragma mark - 点击播放器全屏按钮的代理方法
-(void)playVideoToolsViewDismiss
{
    //点击全屏按钮的处理方法
    [self backBtnCLick:nil];
    
}

#pragma mark - 点击播放器播放按钮的代理方法
-(void)playVideoToolsViewPlay
{
    //点击全屏按钮的处理方法
    [self.playerShowView play];
    
}

#pragma mark - 点击播放器暂停按钮的代理方法
-(void)playVideoToolsViewPause
{
    //点击全屏按钮的处理方法
    [self.playerShowView pause];
    
}

- (void)playVideoToolsViewFullScreen{
    //点击全屏按钮的处理方法
    [self optionsWithFullBtnClick];
}

#pragma mark - 点击全屏按钮所进行的处理逻辑
-(void)optionsWithFullBtnClick
{
    
    ZFZInterfaceOrientationType directionType = [self.playerOptions getCurrentScreenDirection];
    
    if (directionType == ZFZInterfaceOrientationPortrait) {
        directionType = ZFZInterfaceOrientationLandscapeRight;
    }
    else if (directionType == ZFZInterfaceOrientationLandscapeRight) {
        directionType = ZFZInterfaceOrientationPortrait;
    }
    else  if (directionType == ZFZInterfaceOrientationLandscapeLeft) {
        directionType = ZFZInterfaceOrientationPortrait;
    }
    else  if ((directionType == ZFZInterfaceOrientationUnknown)||(directionType == ZFZInterfaceOrientationPortraitUpsideDown)) {
        directionType = ZFZInterfaceOrientationPortrait;
    }
    self.playerOptions.screenDirection = directionType;
    
    if (directionType ==  ZFZInterfaceOrientationLandscapeRight ) {//小屏->全屏
        [UIView animateWithDuration:0.25 animations:^{
            NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
//            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        }completion:^(BOOL finished) {
            CGRect playerFrame = self.playerShowView.frame;
            playerFrame.size.width = ScreenWidth;
            playerFrame.size.height = ScreenHeight;
            self.playerShowView.frame = playerFrame;
//            [self orientationChange:YES];
            
        }];
        
    }else{//全屏->小屏
        [UIView animateWithDuration:0.25 animations:^{
            NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
            //[self orientationChange:NO];
        }];
    }
}





#pragma mark - 视频播放器返回按钮点击的代理方法
-(void)backBtnCLick:(UIButton *)sender
{
    ZFZInterfaceOrientationType directionType = [self.playerOptions getCurrentScreenDirection];
    if (directionType == ZFZInterfaceOrientationPortrait) {
        [self releasePlayerView];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self optionsWithFullBtnClick];
    }
    
    
}

#pragma mark - *********************************player加载状态相关的代理方法******************************
#pragma mark - 缓冲完成状态->一般用缓冲数据到可以播放的状态
-(void)playerMPMovieLoadStatePlaythroughOK
{
    NSLog(@"缓冲完成状态");
}
#pragma mark - 缓存数据足够开始播放状态
-(void)playerMPMovieLoadStatePlayable
{
    NSLog(@"缓存数据足够开始播放状态");
    
    //有时候即使数据缓冲完毕，如果当前不是第一响应者，并且不是在可见的界面里面，当前不是正在播放的状态，也不要进行播放，直接暂停就可以了，等到用户看到的时候再进行播放
    
    if (self.playerOptions.isPlaying && self.playerOptions.isBeingAppearState && self.playerOptions.isBeingActiveState) {
        
        if (fabs(self.playerShowView.player.currentPlaybackTime - self.playerOptions.currenTime) < 5) {
            
            //进度也是记录下来的进度，就可以播放了
            [self.playerShowView play];
            self.playerShowView.playerPlaceHolderImg.hidden = YES;
        }
        else
        {
            //如果不是（一般都是创建播放器之后从开始加载），先把时间校对过来
            self.playerShowView.player.currentPlaybackTime = self.playerOptions.currenTime;
        }
    }
    else
    {
        //目前的处理逻辑是如果达不到可以播放的要求，不论什么情况，都是直接暂停，但是这个暂停的状态不会记录，等到用户看到的时候会继续之前的状态进行播放或者暂停
        [self.playerShowView pauseWithoutRecoder];
    }
    
    
}
#pragma mark - 数据缓冲已经停止状态
-(void)playerMPMovieLoadStateStalled
{
    NSLog(@"缓冲数据已经停止状态");
    //先记录一下视频播放器的状态
    self.playerShowView.playerOption.isPlaying = [self.playerShowView.player isPlaying];
    self.playerOptions = self.playerShowView.playerOption;
    
    //缓冲数据停止的时候需要把当前的视频播放器暂停
    [self.playerShowView pauseWithoutRecoder];
    //如果是没有网络的情况，说明出现异常了，需要显示无网界面
}

#pragma mark - 数据缓冲变成了未知状态
-(void)playerMPMovieLoadStateUnknown
{
    NSLog(@"数据缓冲变成了未知状态");
}
#pragma mark - **************************播放器播放状态变化相关代理方法********************************
#pragma mark - 播放器当前的播放状态是停止状态（如果这里面不作任何处理，其实视频播放器还在，并没有被释放掉，在视频播放完毕的时候会执行这个方法，但是这里面没有做任何处理，而是在视频播放完毕的时候做的处理）
-(void)playerMPMoviePlaybackStateStopped
{
    NSLog(@"视频播放器当前的播放状态时停止播放状态");
}
#pragma mark - 播放器当前的播放状态是正在播放状态
-(void)playerMPMoviePlaybackStatePlaying
{
    NSLog(@"视频播放器当前的状态是正在播放状态");
}
#pragma mark - 播放器当前的播放状态是暂停状态
-(void)playerMPMoviePlaybackStatePaused
{
    NSLog(@"视频播放器当前的播放状态是暂停状态");
}
#pragma mark - 播放器当前的播放状态是中断状态
-(void)playerMPMoviePlaybackStateInterrupted
{
    NSLog(@"视频播放器当前的状态时中断状态");
}
#pragma mark - 播放器当前的播放状态是向前拖动状态
-(void)playerMPMoviePlaybackStateSeekingForward
{
    NSLog(@"视频播放器当前的状态是向前拖动状态");
    
}
#pragma mark - 播放器当前的播放状态是向后拖动状态
-(void)playerMPMoviePlaybackStateSeekingBackward
{
    NSLog(@"视频播放器当前的状态时向后拖动状态");
}
#pragma mark - 播放器当前的播放状态是未知状态
-(void)playerMPMoviePlaybackStateUnKnown
{
    NSLog(@"视频播放器当前的状态是未知状态");
}
#pragma mark - ******************************播放器发生变化的时候需要执行的代理方法*********************
#pragma mark - 播放器播放完毕的原因是视频播放完毕
-(void)playerMPMovieFinishReasonPlaybackEnded
{
    NSLog(@"播放器播放完毕的原因是视频正常播放，播放完了");
    //目前在播放完毕之后是直接暂停，按照目前的模式，再继续播放就会从头开始播，如果有了新的需求可以再做修改
    [self.playerShowView pause];
    
    self.playerShowView.playerOption.currenTime = 0.00;
    self.playerOptions.currenTime = 0.00;
    self.playerOptions.isPlaying = NO;
}
#pragma mark - 播放器播放完毕的原因是用户退出
-(void)playerMPMovieFinishReasonUserExited
{
    NSLog(@"播放器播放完毕的原因是用户退出");
}
#pragma mark - 播放器播放完毕的原因是播放器错误
-(void)playerMPMovieFinishReasonPlaybackError
{
    NSLog(@"播放器播放完毕的原因是播放器错误");
    //目前已知的引起视频播放器错误的原因是没有网了，所以需要显示无网界面，
    ZFZInterfaceOrientationType directionType = [self.playerOptions getCurrentScreenDirection];
    
    
    self.playerShowView.playerOption.isPlaying = YES;
    self.playerShowView.playerOption.screenDirection = directionType;
    self.playerOptions = self.playerShowView.playerOption;
    
    
    [self releasePlayerView];
    
    
//    AppDelegate *delegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if (delegate.netWorkStatesCode == AFNetworkReachabilityStatusNotReachable) {
//        [self setUpNetShowViewWithNetWorkNotiViewType:ZFZNetNotiViewTypeOfNoNetWork];
//        
//    }
//    if (delegate.netWorkStatesCode == AFNetworkReachabilityStatusReachableViaWWAN) {
//        [self setUpNetShowViewWithNetWorkNotiViewType:ZFZNetNotiViewTypeOfBecomeWWAN];
//    }
//    if (delegate.netWorkStatesCode == AFNetworkReachabilityStatusReachableViaWiFi) {
//        if (self.playerOptions.totalTime) {
//            [self createPlayerViewWithScreenDirection:self.playerOptions.screenDirection isPlaying:self.playerOptions.isPlaying currentTime:self.playerOptions.currenTime];
//        }
//    }
    
}
#pragma mark - *************************************网络切换处理代理方法***********************************
#pragma mark - 网络状态发生变化通知方法
-(void)playerNetWorkStatesChange:(NSNotification *)sender
{
    
    int networkState = [[sender object] intValue];
    switch (networkState) {
        case -1:
            //未知网络状态
            [self playerNetworkReachabilityStatusUnknown];
            break;
            
        case 0:
            //没有网络
            //代理方法
            [self playerNetworkReachabilityStatusNotReachable];
            break;
            
        case 1:
            //3G或者4G，反正用的是流量
            //代理方法
            [self playerNetworkReachabilityStatusReachableViaWWAN];
            break;
            
        case 2:
            //WIFI网络
            //Wifi网络情况下，不需要记录视频播放器状态
            [self playerNetworkReachabilityStatusReachableViaWiFi];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 网络切换成了WIFI状态：如果不是在可见界面，或者不是第一响应者，就不需要做任何处理
-(void)playerNetworkReachabilityStatusReachableViaWiFi
{
    NSLog(@"网络切换成了wifi状态");
    
    if (self.playerOptions.isBeingActiveState && self.playerOptions.isBeingAppearState) {
        if (!self.playerShowView) {
//            [self.netShowView removeFromSuperview];
//            self.netShowView = nil;
            if (self.playerOptions.totalTime) {
                [self createPlayerViewWithScreenDirection:self.playerOptions.screenDirection isPlaying:self.playerOptions.isPlaying currentTime:self.playerOptions.currenTime];
            }
            
            else
            {
                
                ZFZInterfaceOrientationType directionType = [self.playerOptions getCurrentScreenDirection];
                [self createPlayerViewWithScreenDirection:directionType isPlaying:YES currentTime:0.00];
                self.playerOptions.screenDirection = directionType;
                self.playerOptions.isPlaying = YES;
                self.playerOptions.currenTime = 0.00;
                self.playerShowView.playerOption.screenDirection  = directionType;
                self.playerShowView.playerOption.isPlaying = YES;
                self.playerShowView.playerOption.currenTime = 0.00;
            }
            
        }
        else
        {
            //隐藏网络提示框
//            [self.playerShowView.netShowView hideNetNotiView];
            //恢复视频播放器的状态
            [self RestoreTheAtatusOfPlayer];
        }
        
    }
}



#pragma mark - 网络切换成了流量状态
-(void)playerNetworkReachabilityStatusReachableViaWWAN
{
    NSLog(@"网络切换成了流量状态");
    if (!self.playerShowView) {
//        [self setUpNetShowViewWithNetWorkNotiViewType:ZFZNetNotiViewTypeOfBecomeWWAN];
    }
    else
    {
        //使用的时候，需要记录一下视频播放器的属性，这个已经在ZFZPlayerView里面做好了
        //先把视频暂停，虽然暂停了，但是这个时候要是有缓冲的
        [self.playerShowView pauseWithoutRecoder];
        
        
        //显示流量提醒界面
//        self.playerShowView.netShowView.netWorkNotiViewType = ZFZNetNotiViewTypeOfBecomeWWAN;
//        [self.playerShowView.netShowView showNetNotiViewWithType:ZFZNetNotiViewTypeOfBecomeWWAN];
    }
    
}
#pragma mark - 网络切换成了无网状态

-(void)playerNetworkReachabilityStatusNotReachable
{
    NSLog(@"网络切换成了无网状态");
    if (self.playerOptions.isBeingAppearState) {
        if (!self.playerShowView) {
//            [self setUpNetShowViewWithNetWorkNotiViewType:ZFZNetNotiViewTypeOfNoNetWork];
        }
        else
        {
            //没网的时候，需要记录一下视频播放器的属性，这个已经在ZFZPlayerView里面做好了
            if (self.playerShowView.player) {
                [self.playerShowView RecordThePropertiesOfThePlayer];
                self.playerOptions = self.playerShowView.playerOption;
            }
            
            //把视频暂停
            [self.playerShowView pauseWithoutRecoder];
            //显示无网界面
//            self.playerShowView.netShowView.netWorkNotiViewType = ZFZNetNotiViewTypeOfNoNetWork;
//            [self.playerShowView.netShowView showNetNotiViewWithType:ZFZNetNotiViewTypeOfNoNetWork];
        }
        
    }
//    [self stopNextVideo];
}
#pragma mark - 网络切换成了未知状态
-(void)playerNetworkReachabilityStatusUnknown
{
    NSLog(@"网络切换成了其他状态");
}


#pragma mark - 屏幕旋转的通知方法。
- (void)statusBarOrientationChange:(NSNotification *)notification
{
    
    
    if (!(self.playerOptions.isBeingActiveState && self.playerOptions.isBeingAppearState)) {
        
        return;
    }
    
    //没有视频播放器，这个时候需要显示对应的网络提醒框，反正不能空着
    if (!self.playerShowView) {
        //这个里面有屏幕方向的处理逻辑
//        [self setUpNetShowViewWithNetWorkNotiViewType:999];
    }
    else
    {
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeRight) // home键靠右
        {
            
            self.playerShowView.playerOption.screenDirection = ZFZInterfaceOrientationLandscapeRight;
            
            [UIView animateWithDuration:0.01 animations:^{
                self.playerShowView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                self.playerShowView.player.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            }];
        }
        
        else if (orientation ==UIInterfaceOrientationLandscapeLeft) // home键靠左
        {
            self.playerShowView.playerOption.screenDirection = ZFZInterfaceOrientationLandscapeLeft ;
            
            [UIView animateWithDuration:0.01 animations:^{
                self.playerShowView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                self.playerShowView.player.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            }];
        }
        else if (orientation == UIInterfaceOrientationPortrait)
        {
            
            self.playerShowView.playerOption.screenDirection = ZFZInterfaceOrientationPortrait;
            
            [UIView animateWithDuration:0.01 animations:^{
                self.playerShowView.transform= CGAffineTransformMakeRotation(0);
                self.playerShowView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth*(ScreenWidth/ScreenHeight)*1.3);
                self.playerShowView.player.view.frame = self.playerShowView.frame;
            }];
            
        }
        else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            self.playerShowView.playerOption.screenDirection = ZFZInterfaceOrientationPortraitUpsideDown;
        }
        else if (orientation == UIInterfaceOrientationUnknown) {
            self.playerShowView.playerOption.screenDirection = ZFZInterfaceOrientationUnknown;
        }
        self.playerOptions = self.playerShowView.playerOption;
    }
}
#pragma mark - *******************************播放器前后台切换处理逻辑***********************************
#pragma mark - 当播放器失去第一响应者的时候触发的通知方法
-(void)playerRegistActiveNotificationEvent:(NSNotification *)sender
{
    
    
    
    NSLog(@"播放器失去了第一响应者");
    if (!self.playerShowView) {
        self.playerOptions.isBeingActiveState = NO;
    }
    else
    {
        
        //先把有关播放器的一些状态记录一下
        self.playerShowView.playerOption.isBeingActiveState = NO;
        
        
        //出现了无网界面，这个时候视频播放器是暂停的，但是这个不一定是之前的真实状态，所以不要记录状态
//        if (((!self.netShowView.hidden) && self.netShowView)||(!self.playerShowView.netShowView.hidden)) {
//            NSLog(@"%d",self.netShowView.hidden);
//            NSLog(@"%d",self.playerShowView.netShowView.hidden);
//            return;
//        }
        
        
        
        
        //记录一下当前着各视频播放器的属性
        
        [self.playerShowView RecordThePropertiesOfThePlayer];
        if (self.playerShowView.playerOption) {
            self.playerOptions = self.playerShowView.playerOption;
        }
        //在这个代理方法执行出来之前，ZFZPlayerView已经记录了视频播放器的一些属性
        //把视频播放器进行暂停
        [self.playerShowView pauseWithoutRecoder];
    }
    
}
#pragma mark - 当播放器成为第一响应者的时候触发的通知方法
-(void)playerBecomeActiveNotificationEvent:(NSNotification *)sender
{
    
    NSLog(@"方向：%ld",(long)self.playerOptions.screenDirection);
    NSLog(@"播放器成为了第一响应者");
    self.playerOptions.isBeingActiveState = YES;
    
    if (self.playerShowView) {
        self.playerShowView.playerOption.isBeingActiveState = YES;
        self.playerOptions = self.playerShowView.playerOption;
    }
    
    
    
    //成为了第一响应者之后，需要和变成可见界面的时候需要执行的方法是一样的,这个方法里面会有线管的处理和判断逻辑
    [self eventWithBecomeASctiveStateOrBecomeAppearState];
    
}
#pragma mark - 当视频成为了第一响应者或者成为可见界面的时候需要通过该方法进行相关逻辑的处理（主要是播放器的创建和释放业务）能走到这个方法，说明一定是变成了第一响应者或者成为了可见页面。
-(void)eventWithBecomeASctiveStateOrBecomeAppearState
{
    
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //大前提就是处于可见界面，而且是第一响应者,能到这一步，说明不需要显示创建网络提醒框，
//    if (self.playerOptions.isBeingActiveState && self.playerOptions.isBeingAppearState && delegate.netWorkStatesCode == AFNetworkReachabilityStatusReachableViaWiFi) {
//        
//        //如果这个时候连基本的playerBaseView都没有，需要重头创建视频播放器
//        if (!self.playerShowView) {
//            [self.netShowView removeFromSuperview];
//            self.netShowView = nil;
//            //如果这个时候已经没有视频播放器了,就需要创建视频播放器
//            if (self.playerOptions.totalTime) {
//                [self createPlayerViewWithScreenDirection:self.playerOptions.screenDirection isPlaying:self.playerOptions.isPlaying currentTime:self.playerOptions.currenTime];
//            }
//            else
//            {
//                ZFZInterfaceOrientationType directionType = [self.playerOptions getCurrentScreenDirection];
//                [self createPlayerViewWithScreenDirection:directionType isPlaying:YES currentTime:0.00];
//            }
//            
//        }
//        
//        else
//        {
//            [self.playerShowView.netShowView hideNetNotiView];
//            
//            //恢复视频播放器的状态（播放暂停，全屏小屏）
//            [self RestoreTheAtatusOfPlayer];
//        }
//    }
}
#pragma mark - 恢复视频播放器的播放暂停状态以及全屏小屏状态
-(void)RestoreTheAtatusOfPlayer
{
    //如果这个时候视频播放器还在，只需要恢复之前的播放器状态就可以了,进度条估计没啥问题，需要重新设置的就是播放还是暂停的属性，以及是不是全屏这个属性
    if (self.playerOptions.isPlaying) {
        //之前如果是播放，回来之后还需要继续播放
        [self.playerShowView play];
    }
    ZFZInterfaceOrientationType directionType = self.playerOptions.screenDirection;
    
    
    if (directionType == ZFZInterfaceOrientationPortrait) {
        
        NSNumber * value  = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        double resultWithWToH = ScreenWidth/ScreenHeight> 1? ScreenHeight/ScreenWidth : ScreenWidth/ScreenHeight;
        CGRect frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth * resultWithWToH * 1.3);
        self.playerShowView.frame = frame;
    }
    else if (directionType == ZFZInterfaceOrientationLandscapeLeft) {
        NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        CGRect frame = self.view.bounds;
        self.playerShowView.frame = frame;
    }
    else if (directionType == ZFZInterfaceOrientationLandscapeRight) {
        NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        CGRect frame = self.view.bounds;
        self.playerShowView.frame = frame;
    }
    else if ((directionType == ZFZInterfaceOrientationPortraitUpsideDown) ||(directionType == ZFZInterfaceOrientationUnknown )) {
        NSNumber * value  = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        double resultWithWToH = ScreenWidth/ScreenHeight> 1? ScreenHeight/ScreenWidth : ScreenWidth/ScreenHeight;
        CGRect frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth * resultWithWToH * 1.3);
        self.playerShowView.frame = frame;
    }
    
    
    
    
    
    if (self.playerShowView.player.currentPlaybackTime != self.playerShowView.playerOption.currenTime) {
        self.playerShowView.player.currentPlaybackTime = self.playerShowView.playerOption.currenTime;
    }
}

#pragma mark - 把视频播放器以及子控件全部释放掉
-(void)releasePlayerView{
    [self.playerShowView releasePlayer];
    [self.playerShowView removeFromSuperview];
    self.playerShowView = nil;
    
}

#pragma mark - *************************************Other***********************************
#pragma mark - 移除通知方法
-(void)removeNotificationEvent
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"applicationDidBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"applicationWillResignActive" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"netWorkChangeEventNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
}


#pragma mark - 懒加载控件
- (PlayerOption *)playerOptions{
    if (!_playerOptions) {
        _playerOptions = [[PlayerOption alloc]init];
        ZFZInterfaceOrientationType directionType = [self.playerOptions getCurrentScreenDirection];
        _playerOptions.isPlaying = YES;
        _playerOptions.isBeingActiveState = YES;
        _playerOptions.isBeingAppearState = YES;
        _playerOptions.screenDirection = directionType;
    }
    return _playerOptions;
}

@end
