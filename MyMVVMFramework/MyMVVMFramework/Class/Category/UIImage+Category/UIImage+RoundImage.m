//
//  UIImage+RoundImage.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/26.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "UIImage+RoundImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>

@implementation UIImage (RoundImage)
- (UIImage *)setRadius:(CGFloat)radius size:(CGSize)size {
    return [UIImage setRadius:RadiusMake(radius, radius, radius, radius) image:self size:size borderColor:nil borderWidth:0 backgroundColor:nil withContentMode:UIViewContentModeScaleAspectFill];
}

- (UIImage *)setRadius:(CGFloat)radius size:(CGSize)size contentMode:(UIViewContentMode)contentMode {
    return [UIImage setRadius:RadiusMake(radius, radius, radius, radius) image:self size:size borderColor:nil borderWidth:0 backgroundColor:nil withContentMode:contentMode];
}

+ (UIImage *)setRadius:(CGFloat)radius size:(CGSize)size borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor {
    return [UIImage setRadius:RadiusMake(radius, radius, radius, radius) image:nil size:size borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:UIViewContentModeScaleToFill];
}

+ (UIImage *)setRadius:(ImageRadius)radius image:(UIImage *)image size:(CGSize)size borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor withContentMode:(UIViewContentMode)contentMode {
    
    if (!backgroundColor) {
        backgroundColor = [UIColor whiteColor];
    }
    if (image) {
        image = [image scaleToSize:CGSizeMake(size.width, size.height) withContentMode:contentMode backgroundColor:backgroundColor];
    } else {
        image = [UIImage imageWithColor:backgroundColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    CGFloat height = size.height;
    CGFloat width = size.width;
    radius = [UIImage transformationRadius:radius size:size borderWidth:borderWidth];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:CGPointMake(width - radius.bottomRightRadius, height - radius.bottomRightRadius) radius:radius.bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addArcWithCenter:CGPointMake(radius.bottomLeftRadius, height - radius.bottomLeftRadius) radius:radius.bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addArcWithCenter:CGPointMake(radius.topLeftRadius, radius.topLeftRadius) radius:radius.topLeftRadius startAngle:M_PI endAngle:3.0 * M_PI_2 clockwise:YES];
    [path addArcWithCenter:CGPointMake(width - radius.topRightRadius, radius.topRightRadius) radius:radius.topRightRadius startAngle:3.0 * M_PI_2 endAngle:2.0 * M_PI clockwise:YES];
    [path closePath];
    
    [path addClip];
    CGContextDrawImage(context, rect, image.CGImage);
    path.lineWidth = borderWidth;
    [borderColor setStroke];
    [path stroke];
    
    UIImage *currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return currentImage;
}

+ (UIImage *)drawImageRadius:(ImageRadius)radius size:(CGSize)size backgroundColor:(UIColor *)backgroundColor text:(NSString *)text{
    UIImage *drawImage;
    //先从缓存中获取
    NSString *drawImageKey = [NSString stringWithFormat:@"%@-%@", text, @"drawImageRadius"];
    drawImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:drawImageKey];
    
    if (!drawImage) {
        UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        //    CGContextScaleCTM(context, 1, -1);
        //    CGContextTranslateCTM(context, 0, -rect.size.height);
        CGFloat height = size.height;
        CGFloat width = size.width;
        //radius = [UIImage transformationRadius:radius size:size borderWidth:borderWidth];
        
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path addArcWithCenter:CGPointMake(width - radius.bottomRightRadius, height - radius.bottomRightRadius) radius:radius.bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [path addArcWithCenter:CGPointMake(radius.bottomLeftRadius, height - radius.bottomLeftRadius) radius:radius.bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [path addArcWithCenter:CGPointMake(radius.topLeftRadius, radius.topLeftRadius) radius:radius.topLeftRadius startAngle:M_PI endAngle:3.0 * M_PI_2 clockwise:YES];
        [path addArcWithCenter:CGPointMake(width - radius.topRightRadius, radius.topRightRadius) radius:radius.topRightRadius startAngle:3.0 * M_PI_2 endAngle:2.0 * M_PI clockwise:YES];
        [path closePath];
        
        [path addClip];
        [backgroundColor set];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        //设置文本参数（行间距，文本颜色，字体大小）
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        
        //[paragraphStyle setLineSpacing:4.0f];
        
        //设置段落样式
        paragraphStyle.alignment = NSTextAlignmentCenter;//（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:Font_Large_Text,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil];
        CGSize textSize = [text sizeWithAttributes:dict];
        
        [text drawAtPoint:CGPointMake((size.width-textSize.width)/2,(size.height-textSize.height)/2) withAttributes:dict];
        
        drawImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [[SDImageCache sharedImageCache] storeImage:drawImage forKey:drawImageKey completion:nil];
        
    }
    
    return drawImage;
}

+ (ImageRadius)transformationRadius:(ImageRadius)radius size:(CGSize)size borderWidth:(CGFloat)borderWidth {
    radius.topLeftRadius = minimum(size.width, size.height, radius.topLeftRadius);
    radius.topRightRadius = minimum(size.width - radius.topLeftRadius, size.height, radius.topRightRadius);
    radius.bottomLeftRadius = minimum(size.width, size.height - radius.topLeftRadius, radius.bottomLeftRadius);
    radius.bottomRightRadius = minimum(size.width - radius.bottomLeftRadius, size.height - radius.topRightRadius, radius.bottomRightRadius);
    return radius;
}

static inline CGFloat minimum(CGFloat a, CGFloat b, CGFloat c) {
    CGFloat minimum = MIN(MIN(a, b), c);
    return MAX(minimum, 0);
}

- (UIImage *)scaleToSize:(CGSize)size withContentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor *)backgroundColor {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFill);
    [self drawInRect:[self convertRect:rect withContentMode:contentMode]];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode {
    CGSize size = self.size;
    rect = CGRectStandardize(rect);
    size.width = size.width < 0 ? -size.width : size.width;
    size.height = size.height < 0 ? -size.height : size.height;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    switch (contentMode) {
        case UIViewContentModeRedraw:
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill: {
            if (rect.size.width < 0.01 || rect.size.height < 0.01 ||
                size.width < 0.01 || size.height < 0.01) {
                rect.origin = center;
                rect.size = CGSizeZero;
            } else {
                CGFloat scale;
                if (contentMode == UIViewContentModeScaleAspectFill) {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.width / size.width;
                    } else {
                        scale = rect.size.height / size.height;
                    }
                } else {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.height / size.height;
                    } else {
                        scale = rect.size.width / size.width;
                    }
                }
                size.width *= scale;
                size.height *= scale;
                rect.size = size;
                rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
            }
        } break;
        case UIViewContentModeCenter: {
            rect.size = size;
            rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
        } break;
        case UIViewContentModeTop: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeBottom: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeLeft: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeRight: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeTopLeft: {
            rect.size = size;
        } break;
        case UIViewContentModeTopRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeBottomLeft: {
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeBottomRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeScaleToFill:
        default: {
            rect = rect;
        }
    }
    return rect;
}
@end
