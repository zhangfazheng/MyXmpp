//
//  BaseBuildOutsideViewCell.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseCell.h"
@class BaseBuildOutsideViewCell;

@protocol CustomBuildOutsideViewCellDelegate <NSObject>

@optional

/**
 *  You should use this method to add subview.
 *
 *  @param cell           The CustomBuildOutsideViewCell type cell.
 *  @param cellIdentifier The CustomBuildOutsideViewCell's identifier.
 */
- (void)BaseBuildOutsideViewCell:(BaseBuildOutsideViewCell *)cell cellIdentifier:(NSString *)cellIdentifier;

@end

/**
 *  [IMPORTANT] Not reusable, and loadContent method is the last step.
 */
@interface BaseBuildOutsideViewCell : BaseCell
/**
 *  The CustomBuildOutsideViewCell's delegate.
 */
@property (nonatomic, weak) id <CustomBuildOutsideViewCellDelegate> buildOutsideViewCellDelegate;
@end
