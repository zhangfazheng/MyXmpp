//
//  RHTableViewCellModel.h
//  RHCommonFoundation
//
//  Created by zhuruhong on 16/4/9.
//  Copyright © 2016年 zhuruhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RHTableViewCell;

typedef CGFloat(^HeightForRowBlock)(UITableView *tableView, NSIndexPath *indexPath, id cellData);
typedef RHTableViewCell *(^CellForRowBlock)(UITableView *tableView, NSIndexPath *indexPath, id cellData);
typedef void(^CellForSelectBlock)(UITableView *tableView, NSIndexPath *indexPath, id cellData);
typedef void(^WillDisplayBlock)(UITableView *tableView, NSIndexPath *indexPath, id cellData);
typedef void(^CommitEditingBlock)(UITableView *tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath, id cellData);

@interface RHTableViewCellModel : NSObject

@property (nonatomic, strong) id cellData;
@property (nonatomic, copy, readonly) HeightForRowBlock heightForRowBlock;
@property (nonatomic, copy, readonly) CellForRowBlock cellForRowBlock;
@property (nonatomic, copy, readonly) CellForSelectBlock cellForSelectBlock;
@property (nonatomic, copy, readonly) WillDisplayBlock willDisplayBlock;
@property (nonatomic, copy, readonly) CommitEditingBlock commitEditingBlock;

- (void)setHeightForRowBlock:(CGFloat(^)(UITableView *tableView, NSIndexPath *indexPath, id cellData))heightForRowBlock;
- (void)setCellForRowBlock:(RHTableViewCell *(^)(UITableView *tableView, NSIndexPath *indexPath, id cellData))cellForRowBlock;
- (void)setCellForSelectBlock:(void(^)(UITableView *tableView, NSIndexPath *indexPath, id cellData))cellForSelectBlock;
- (void)setWillDisplayBlock:(void(^)(UITableView *tableView, NSIndexPath *indexPath, id cellData))willDisplayBlock;
- (void)setCommitEditingBlock:(void(^)(UITableView *tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath, id cellData))commitEditingBlock;

@end
