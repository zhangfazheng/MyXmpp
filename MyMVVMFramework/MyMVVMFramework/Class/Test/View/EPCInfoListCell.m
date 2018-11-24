//
//  EPCInfoListCell.m
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/17.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "EPCInfoListCell.h"
#import "RHTableViewCellModel.h"
#import "EquipmentsModel.h"

@implementation EPCInfoListCell

+ (void)load
{
    [self registerRenderCell:[self class] type:0];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

//重写cell的创建方法
+ (instancetype)tableView:(UITableView *)tableView reusedCellOfClass:(Class)cellClass
{
    NSString *cellIdentifier = NSStringFromClass(cellClass);
    EPCInfoListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}


- (void)updateViewWithData:(id)cellData
{
    RHTableViewCellModel *model         = (RHTableViewCellModel *)cellData;
    EquipmentsModel *cellModel          = (EquipmentsModel *)model.cellData;
    
    self.textLabel.text                 = cellModel.epcId;
    self.detailTextLabel.text           = cellModel.name;
    
}

@end

@implementation EPCInfoListCellModel


@end
