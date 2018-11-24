//
//  PlayerOption.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/3.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "PlayerOption.h"

@implementation PlayerOption
-(ZFZInterfaceOrientationType)getCurrentScreenDirection
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight) // home键靠右
    {
        return ZFZInterfaceOrientationLandscapeRight;
    }
    
    if (orientation ==UIInterfaceOrientationLandscapeLeft) // home键靠左
    {
        return ZFZInterfaceOrientationLandscapeLeft;
    }
    if (orientation == UIInterfaceOrientationPortrait)
    {
        
        return ZFZInterfaceOrientationPortrait;
    }
    if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        return ZFZInterfaceOrientationPortraitUpsideDown;
    }
    return ZFZInterfaceOrientationUnknown;
    
}
@end
