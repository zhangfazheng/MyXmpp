//
//  UIImageView+RoundImage.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/26.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "UIImageView+RoundImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>

@implementation UIImageView (RoundImage)
- (void)setImageWithCornerRadius:(CGFloat)radius imageURL:(NSURL *)imageURL placeholder:(NSString *)placeholder size:(CGSize)size
{
    [self setImageWithHTRadius:RadiusMake(radius, radius, radius, radius) imageURL:imageURL placeholder:placeholder borderColor:nil borderWidth:0 backgroundColor:nil contentMode:UIViewContentModeScaleAspectFill size:size];
}
- (void)setImageWithCornerRadius:(CGFloat)radius imageURL:(NSURL *)imageURL placeholder:(NSString *)placeholder contentMode:(UIViewContentMode)contentMode size:(CGSize)size
{
    [self setImageWithHTRadius:RadiusMake(radius, radius, radius, radius) imageURL:imageURL placeholder:placeholder borderColor:nil borderWidth:0 backgroundColor:nil contentMode:contentMode size:size];
}
- (void)setImageWithHTRadius:(ImageRadius)radius imageURL:(NSURL *)imageURL placeholder:(NSString *)placeholder contentMode:(UIViewContentMode)contentMode size:(CGSize)size
{
    [self setImageWithHTRadius:radius imageURL:imageURL placeholder:placeholder borderColor:nil borderWidth:0 backgroundColor:nil contentMode:contentMode size:size];
}
-(void)setImageWithHTRadius:(ImageRadius)radius imageURL:(NSURL *)imageURL placeholder:(NSString *)placeholder borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor contentMode:(UIViewContentMode)contentMode size:(CGSize)size
{
    NSString *cacheurlStr = [NSString stringWithFormat:@"%@%@",imageURL,@"radiusCache"];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheurlStr];
    
    if (cacheImage) {
        self.image =  [UIImage setRadius:radius image:cacheImage size:size borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
        return;
        
    }
    
    UIImage *placeholderImage;
    if (placeholder || borderWidth > 0 || backgroundColor) {
        NSString *placeholderKey = [NSString stringWithFormat:@"%@-%@", placeholder, placeholder];
        placeholderImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:placeholderKey];
        
        if (!placeholderImage) {
            if (placeholder) {
                placeholderImage = [UIImage setRadius:radius image:[UIImage imageNamed:placeholder] size:size borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
                [[SDImageCache sharedImageCache] storeImage:placeholderImage forKey:placeholderKey completion:nil];
            }
            
        }else{
            
            placeholderImage = [UIImage setRadius:radius image:placeholderImage size:size borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
        }
        
    }
    self.image = placeholderImage;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager loadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        // 处理下载进度
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image) {
            UIImage *currentImage = [UIImage setRadius:radius image:image size:size borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
            self.image = currentImage;
            [[SDImageCache sharedImageCache] storeImage:currentImage forKey:cacheurlStr toDisk:YES completion:nil];
            //清除原有非圆角图片缓存
            [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%@",imageURL] withCompletion:nil];
        }
    }];
    
}
@end
