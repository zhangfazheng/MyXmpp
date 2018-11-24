//
//  RHTableViewAdapter.m
//  RHToolkit
//
//  Created by zhuruhong on 15/6/27.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHTableViewAdapter.h"
#import "RHTableViewCell.h"
#import "RHTableViewCellModel.h"

@implementation RHTableViewAdapter

- (instancetype)init
{
    if (self = [super init]) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addCellData:(RHTableViewCellModel *)cellData
{
    if (nil == cellData) {
        return;
    }
    [_dataArray addObject:cellData];
}

- (void)removeAllCellData
{
    [_dataArray removeAllObjects];
}

#pragma mark -
#pragma mark UITableViewDataSource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return [RHTableViewCell tableView:tableView reusedCellOfClass:[RHTableViewCell class]];
    }
    RHTableViewCellModel *model = self.dataArray[indexPath.row];
    return model.cellForRowBlock(tableView, indexPath, model);
}

#pragma mark -
#pragma mark UITableViewDelegate method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return 0;
    }
    RHTableViewCellModel *model = self.dataArray[indexPath.row];
    if (model.heightForRowBlock) {
        return model.heightForRowBlock(tableView, indexPath, model);
    }
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return;
    }
    RHTableViewCellModel *model = self.dataArray[indexPath.row];
    if (model.willDisplayBlock) {
        model.willDisplayBlock(tableView, indexPath, model);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.dataArray.count == 0) {
        return;
    }
    RHTableViewCellModel *model = self.dataArray[indexPath.row];
    if (model.cellForSelectBlock) {
        model.cellForSelectBlock(tableView, indexPath, model);
    }
    
    if ([self.delegate respondsToSelector:@selector(didTableViewSelectIndexPath:)]) {
        [self.delegate didTableViewSelectIndexPath:indexPath];
    }
}

@end
