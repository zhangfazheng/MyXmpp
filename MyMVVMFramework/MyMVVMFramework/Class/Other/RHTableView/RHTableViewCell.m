//
//  RHTableViewCell.m
//  RHToolkit
//
//  Created by zhuruhong on 15/6/27.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHTableViewCell.h"
#import "RHTableViewCellModel.h"

@implementation RHTableViewCell

static NSMutableDictionary *_cellMap = nil;

+ (NSMutableDictionary *)cellMapOfRegistered
{
    return _cellMap;
}

+ (void)registerRenderCell:(Class)cellClass type:(NSInteger)type
{
    if (!_cellMap) {
        _cellMap = [[NSMutableDictionary alloc] init];
    }
    
    NSString *className = NSStringFromClass(cellClass);
    _cellMap[@(type)] = className;
}

+ (Class)cellClassWithType:(NSInteger)type
{
    NSString *className = _cellMap[@(type)];
    if (!className) {
        className = @"RHTableViewCell";
    }
    return NSClassFromString(className);
}

+ (instancetype)tableView:(UITableView *)tableView reusedCellOfClass:(Class)cellClass
{
    NSString *cellIdentifier = NSStringFromClass(cellClass);
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

+ (instancetype)tableView:(UITableView *)tableView reusedCellOfType:(NSInteger)type
{
    Class cellClass = [self cellClassWithType:type];
    return [self tableView:tableView reusedCellOfClass:cellClass];
}

- (void)updateViewWithData:(id)cellData
{
    //这里为简单展示，需要子类重载
    self.textLabel.text = [NSString stringWithFormat:@"%@的updateViewWithData方法需要重载", [self class]];
//    RHTableViewCellModel *cellStr = (RHTableViewCellModel *)cellData;
//
//    self.textLabel.text = cellStr.cellData;
}

@end
