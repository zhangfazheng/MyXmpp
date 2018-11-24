//
//  BaseBuildOutsideViewCell.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseBuildOutsideViewCell.h"


@interface BaseBuildOutsideViewCell () {
    
    NSLock  *_lock;
    BOOL     _haveRun;
}

@end
@implementation BaseBuildOutsideViewCell

- (void)setupCell {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _haveRun            = NO;
    _lock               = [[NSLock alloc] init];
}

- (void)loadContent {
    
    if (_haveRun == NO && [_lock tryLock]) {
        
        _haveRun = YES;
        [_lock unlock];
        
        if (self.buildOutsideViewCellDelegate && [self.buildOutsideViewCellDelegate respondsToSelector:@selector(BaseBuildOutsideViewCell:cellIdentifier:)]) {
            
            [self.buildOutsideViewCellDelegate BaseBuildOutsideViewCell:self cellIdentifier:self.dataAdapter.cellReuseIdentifier];
        }
    }
}

@end
