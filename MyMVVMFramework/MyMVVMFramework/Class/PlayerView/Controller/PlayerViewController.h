//
//  PlayerViewController.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/3.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController
/*
 视频播放器的播放地址
 */
@property(nonatomic,copy)NSString *playUrl;
/*
 视频名称
 */
@property(nonatomic,copy)NSString *videoName;

/*
 是否开启屏幕旋转切换功能
 */
@property(nonatomic,assign)BOOL isOrientationChangeOpt;

/*
 是否开启网络状态检测功能
 */
@property(nonatomic,assign)BOOL isNetWorkChangeOpt;

@end
