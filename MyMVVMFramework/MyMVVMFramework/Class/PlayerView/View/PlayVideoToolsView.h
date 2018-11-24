//
//  PlayVideoToolsView.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/8.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideView.h"
#import "ZFZHelper.h"
#import "VolumeManager.h"
@class PlayVideoToolsView;

typedef enum : NSUInteger {
    PlayVideoToolsViewClickTypeDismiss,
    PlayVideoToolsViewClickTypeAction_VolumePlus,
    PlayVideoToolsViewClickTypeAction_VolumeMinus,
    PlayVideoToolsViewClickTypePlay,
    PlayVideoToolsViewClickTypePause,
    PlayVideoToolsViewClickFullScreen,
    //PlayVideoToolsViewClickSmallScreen,
} PlayVideoToolsViewClickType;

@protocol PlayVideoToolsViewDelegate <NSObject>
@optional
- (void)playVideoToolsView:(PlayVideoToolsView *)toolsView clickType:(PlayVideoToolsViewClickType)type;

- (void)playVideoToolsViewDismiss;

- (void)playVideoToolsViewAction_VolumePlus;

- (void)playVideoToolsViewAction_VolumeMinus;

- (void)playVideoToolsViewPlay;

- (void)playVideoToolsViewPause;

- (void)playVideoToolsViewFullScreen;

@end

@interface PlayVideoToolsView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet SlideView *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) id<PlayVideoToolsViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *frontOrRearImageView;
@property (weak, nonatomic) IBOutlet UILabel *fastLable;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenButon;
@property (assign, nonatomic ,readonly)        PlayVideoToolsViewClickType type;
+ (instancetype) loadView;

- (void)showToolsView;

- (void)disappearToolsView;

- (void)setVolumeValue:(float)value;

@end
