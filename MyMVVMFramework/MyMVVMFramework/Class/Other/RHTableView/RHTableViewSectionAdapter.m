//
//  RHTableViewSectionAdapter.m
//  RHTableViewDemo
//
//  Created by zhuruhong on 16/5/10.
//  Copyright © 2016年 zhuruhong. All rights reserved.
//

#import "RHTableViewSectionAdapter.h"
#import "RHTableViewCell.h"
#import "RHTableViewCellModel.h"

@implementation RHTableViewSectionAdapter

#pragma mark -
#pragma mark UITableViewDataSource method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rowDataArray = self.dataArray[section];
    return rowDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return [RHTableViewCell tableView:tableView reusedCellOfClass:[RHTableViewCell class]];
    }
    NSArray *rowDataArray = self.dataArray[indexPath.section];
    if (rowDataArray.count == 0) {
        return [RHTableViewCell tableView:tableView reusedCellOfClass:[RHTableViewCell class]];
    }
    RHTableViewCellModel *model = rowDataArray[indexPath.row];
    return model.cellForRowBlock(tableView, indexPath, model);
}

#pragma mark -
#pragma mark UITableViewDelegate method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return 0;
    }
    NSArray *rowDataArray = self.dataArray[indexPath.section];
    if (rowDataArray.count == 0) {
        return 0;
    }
    RHTableViewCellModel *model = rowDataArray[indexPath.row];
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
    NSArray *rowDataArray = self.dataArray[indexPath.section];
    if (rowDataArray.count == 0) {
        return;
    }
    RHTableViewCellModel *model = rowDataArray[indexPath.row];
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
    NSArray *rowDataArray = self.dataArray[indexPath.section];
    if (rowDataArray.count == 0) {
        return;
    }
    RHTableViewCellModel *model = rowDataArray[indexPath.row];
    if (model.cellForSelectBlock) {
        model.cellForSelectBlock(tableView, indexPath, model);
    }
}

@end
