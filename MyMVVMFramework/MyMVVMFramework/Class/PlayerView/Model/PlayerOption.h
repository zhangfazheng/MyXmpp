//
//  PlayerOption.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/3.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ZFZInterfaceOrientationType) {
    
    ZFZInterfaceOrientationPortrait           = 0,//home键在下面
    ZFZInterfaceOrientationLandscapeLeft      = 1,//home键在左边
    ZFZInterfaceOrientationLandscapeRight     = 2,//home键在右边
    ZFZInterfaceOrientationUnknown            = 3,//未知方向
    ZFZInterfaceOrientationPortraitUpsideDown = 4,//home键在上面
};
@interface PlayerOption : NSObject
/*
 屏幕方向
 */
@property(nonatomic,assign)ZFZInterfaceOrientationType screenDirection;

/*
 是否是正在播放状态
 */
@property(nonatomic,assign)BOOL isPlaying;

/*
 当前播放时间
 */
@property(nonatomic,assign) NSTimeInterval currenTime;
/*
 视频的总时长
 */
@property(nonatomic,assign) NSTimeInterval totalTime;
/*
 当前播放器处于被显示状态
 */
@property(nonatomic,assign)BOOL isBeingAppearState;

/*
 当前视频播放器是不是第一响应者状态
 */
@property(nonatomic,assign)BOOL isBeingActiveState;

/*
 获取当前的屏幕方向
 */
-(ZFZInterfaceOrientationType)getCurrentScreenDirection;
@end
