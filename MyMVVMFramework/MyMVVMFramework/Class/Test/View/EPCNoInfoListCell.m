//
//  EPCNoInfoList.m
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/17.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "EPCNoInfoListCell.h"
#import "RHTableViewCellModel.h"

@implementation EPCNoInfoListCell

+ (void)load
{
    [self registerRenderCell:[self class] type:1];
}

//重写cell的创建方法
+ (instancetype)tableView:(UITableView *)tableView reusedCellOfClass:(Class)cellClass
{
    NSString *cellIdentifier = NSStringFromClass(cellClass);
    EPCNoInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}


- (void)updateViewWithData:(id)cellData
{
    RHTableViewCellModel *model         = (RHTableViewCellModel *)cellData;
    NSString *epcid                     = (NSString *)model.cellData;
    
    self.textLabel.text                 = epcid;
    self.detailTextLabel.text           = @"尚未绑定设备";
}

@end
