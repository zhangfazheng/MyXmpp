//
//  LaunchViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/2.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "LaunchViewController.h"
#import <YYKit/YYWebImageManager.h>
#import "ZFZHelper.h"
#import "NetWorkManager.h"
#import "Interface.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startAnimations
{
    UIImage *lauchImage = [ZFZHelper getLauchImage];
    self.maskView.image = lauchImage;
    [self requestNet];
    self.view.backgroundColor = [UIColor clearColor];
    _imageView.transform = CGAffineTransformMakeScale(1, 1);
    WeakSelf
    [UIView animateWithDuration:1.0 animations:^{
        weakSelf.maskView.alpha = 0.0f;
    }];
    
    [UIView animateWithDuration:4 delay:0.4 options:0 animations:^{
        weakSelf.imageView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    } completion:nil];
    [UIView animateWithDuration:1 delay:4 options:0 animations:^{
        weakSelf.imageView.alpha = 0.0f;
        weakSelf.t1.alpha = 0.0f;
        weakSelf.t2.alpha = 0.0f;
        weakSelf.companyNameLable.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void)requestNet
{
    typeof(self) __weak weakSelf = self;
    [[NetWorkManager shareManager]requestWithType:HttpRequestTypeGet withUrlString:startPage withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        [weakSelf AnalysisAtJson:object];
    } withFailureBlock:^(NSError *error) {
        
    } progress:^(float progress) {
        
    }];
}

- (void)AnalysisAtJson:(id)json
{
    NSDictionary *startPageAd = [json objectForKey:@"startPage"];
    [self downloadLaumchImageAtUrl:[startPageAd objectForKey:@"imageUrl"]];
}

- (void)downloadLaumchImageAtUrl:(NSString *)url
{
    typeof(self) __weak weakSelf = self;
    YYWebImageManager *__block downloadImageManager = [YYWebImageManager sharedManager];
    [downloadImageManager requestImageWithURL:[NSURL URLWithString:url] options:YYWebImageOptionShowNetworkActivity progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        [weakSelf sevaImage:image];
        downloadImageManager = nil;
    }];
}

- (void)sevaImage:(UIImage *)image
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"launchImage.png"]];   // 保存文件的名称
    [UIImagePNGRepresentation(image)writeToFile:filePath    atomically:YES];
}

@end
