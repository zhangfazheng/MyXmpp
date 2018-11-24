//
//  PlayVideoToolsView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/8.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "PlayVideoToolsView.h"

@interface PlayVideoToolsView ()

@property (weak, nonatomic) IBOutlet UIView *volumeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *volumeViewLayoutX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayoutY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLayoutY;
@property (weak, nonatomic) IBOutlet UIView *superView;
@property (assign, nonatomic) BOOL isShow;

@end

@implementation PlayVideoToolsView

+ (instancetype) loadView
{
    NSArray * ar = [[NSBundle mainBundle] loadNibNamed:@"PlayVideoToolsView" owner:self options:nil];
    return [ar lastObject];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    return  self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _isShow = true;
    
    _volumeView.top = (1-VolumeManager.currentVolume) * _volumeView.height;
    [VolumeManager beginObserveVolumeChange:^(CGFloat volume) {
        self.volumeView.top = (1-VolumeManager.currentVolume) * self.volumeView.height;
    }];
    UIImage *imageName = ZFZIMAGE(@"PlayerImage.bundle/action_player_pause");
    UIImage *selectedImgName = ZFZIMAGE(@"PlayerImage.bundle/action_player_play");
    
    [_playButton setBackgroundImage:imageName forState:UIControlStateNormal];
    [_playButton setBackgroundImage:selectedImgName forState:UIControlStateSelected];
    
}
- (IBAction)changeState:(UIButton *)sender {
    if(sender.selected) {
        //被选择的界面
        _type = PlayVideoToolsViewClickTypePlay;
        if ([_delegate respondsToSelector:@selector(playVideoToolsViewPlay)]) {
            [_delegate playVideoToolsViewPlay];
        }
    }else{
        _type = PlayVideoToolsViewClickTypePause;
        //另一个界面
        if ([_delegate respondsToSelector:@selector(playVideoToolsViewPause)]) {
            [_delegate playVideoToolsViewPause];
        }
    }
//    [self verificationDelegate];
    sender.selected = !sender.selected;
}
- (IBAction)dismissButtonAction:(id)sender {
//    _type = PlayVideoToolsViewClickTypeDismiss;
//    [self verificationDelegate];
    if ([_delegate respondsToSelector:@selector(playVideoToolsViewDismiss)]) {
        [_delegate playVideoToolsViewDismiss];
    }
    
}
- (IBAction)fullScreenAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(playVideoToolsViewFullScreen)]) {
        [_delegate playVideoToolsViewFullScreen];
    }
}

- (void)showToolsView
{
    if (_isShow) return ;
    self.hidden = !self.hidden;
    [self.superView layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.playButton.alpha = 1.0f;
        self.volumeViewLayoutX.constant = 0;
        self.bottomViewLayoutY.constant = 0;
        self.topViewLayoutY.constant    = 0;
        [self.superView layoutIfNeeded];
        [self.superView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    } completion:^(BOOL finished) {
    }];
    _isShow = true;
}

- (void)disappearToolsView
{
    if (!_isShow) return ;
    [self.superView layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.playButton.alpha = 0.0f;
        self.volumeViewLayoutX.constant = -44;
        self.bottomViewLayoutY.constant = -42;
        self.topViewLayoutY.constant    = -44;
        [self.superView layoutIfNeeded];
        [self.superView setBackgroundColor:[UIColor clearColor]];
    } completion:^(BOOL finished) {
        self.hidden = finished;
    }];
    _isShow = false;
}

- (void)verificationDelegate
{
    if ([_delegate respondsToSelector:@selector(playVideoToolsView:clickType:)]) {
        [_delegate playVideoToolsView:self clickType:_type];
    }
}

- (IBAction)volumePlusAction:(id)sender
{
    CGFloat curr = VolumeManager.currentVolume;
    curr += 0.1;
    if (curr >= 1) return ;
    [VolumeManager setVolume:curr];
}

- (IBAction)volumeMinusAction:(id)sender
{
    CGFloat curr = VolumeManager.currentVolume;
    curr -= 0.1;
    if (curr <= 0.0f) return ;
    [VolumeManager setVolume:curr];
}


- (void)setVolumeValue:(float)value
{
    //[[MPMusicPlayerController applicationMusicPlayer] setVolume: newVolume];
    //CGFloat values = _volumeUtil.volumeValue;
    
}

- (void)dealloc
{
    [VolumeManager stopObserveVolumeChange];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    id res = [super hitTest:point withEvent:event];
    if (res == self.superView) {
        return nil;
    }
    return res;
}



@end
