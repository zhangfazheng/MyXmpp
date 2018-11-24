//
//  AbsAlertMessageView.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "AbsAlertMessageView.h"

@interface AbsAlertMessageView ()

@property (nonatomic, strong) NSMapTable  *mapTable;

@end
@implementation AbsAlertMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.delayAutoHidenDuration = 2.f;
        self.autoHiden              = NO;
        self.mapTable               = [NSMapTable strongToWeakObjectsMapTable];
    }
    
    return self;
}

- (void)show {
    
    [NSException raise:NSStringFromClass([self class])
                format:@"Use show method from subclass."];
}

- (void)hide {
    
    [NSException raise:NSStringFromClass([self class])
                format:@"Use hide method from subclass."];
}

- (void)setView:(UIView *)view withKey:(NSString *)key {
    
    [self.mapTable setObject:view forKey:key];
}

- (UIView *)viewWithKey:(NSString *)key {
    
    return [self.mapTable objectForKey:key];
}

@end
