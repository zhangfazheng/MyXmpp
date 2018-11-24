//
//  RHTableViewCellModel.m
//  RHCommonFoundation
//
//  Created by zhuruhong on 16/4/9.
//  Copyright © 2016年 zhuruhong. All rights reserved.
//

#import "RHTableViewCellModel.h"
#import "RHTableViewCell.h"

@implementation RHTableViewCellModel

- (void)setHeightForRowBlock:(CGFloat (^)(UITableView *tableView, NSIndexPath *indexPath, id cellData))heightForRowBlock
{
    _heightForRowBlock = heightForRowBlock;
}

- (void)setCellForRowBlock:(RHTableViewCell *(^)(UITableView *tableView, NSIndexPath *indexPath, id cellData))cellForRowBlock
{
    _cellForRowBlock = cellForRowBlock;
}

- (void)setCellForSelectBlock:(void (^)(UITableView *tableView, NSIndexPath *indexPath, id cellData))cellForSelectBlock
{
    _cellForSelectBlock = cellForSelectBlock;
}

- (void)setWillDisplayBlock:(void(^)(UITableView *tableView, NSIndexPath *indexPath, id cellData))willDisplayBlock
{
    _willDisplayBlock = willDisplayBlock;
}

- (void)setCommitEditingBlock:(void (^)(UITableView *tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath, id cellData))commitEditingBlock
{
    _commitEditingBlock = commitEditingBlock;
}

@end
