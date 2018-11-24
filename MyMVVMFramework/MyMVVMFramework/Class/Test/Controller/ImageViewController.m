//
//  ImageViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/7/24.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ImageViewController.h"
#import "UIImage+RoundImage.h"
#import "PlayerViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setup{
    [super setup];
    
    
    ImageRadius raduis = RadiusMake(50, 50, 50, 50);
    UIImage *ArrmyImage =[UIImage setRadius:raduis image:[UIImage imageNamed:@"army6"] size:CGSizeMake(120, 100) borderColor:[UIColor greenColor] borderWidth:2 backgroundColor:[UIColor whiteColor] withContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *imafj = [[UIImageView alloc]initWithFrame:CGRectMake(20, 200, 120, 100)];
    imafj.image = ArrmyImage;
    
    imafj.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushNewView)];
    
    [imafj addGestureRecognizer:tap];
    
    [self.view addSubview:imafj];
}

- (void)pushNewView{
    PlayerViewController *playervc =[[PlayerViewController alloc]init];
    playervc.playUrl = @"http://fastwebcache.yod.cn/yanglan/2013suoluosi/2013suoluosi_850/2013suoluosi_850.m3u8";
    //playervc.playUrl = @"http://hls.quanmin.tv/live/35743/playlist.m3u8";
    //playervc.playUrl = @"http://hls.quanmin.tv/live/2029969506/playlist.m3u8";
    playervc.videoName = @"杨澜采访索罗斯";
    [self.navigationController pushViewController:playervc animated:NO];
}


@end
