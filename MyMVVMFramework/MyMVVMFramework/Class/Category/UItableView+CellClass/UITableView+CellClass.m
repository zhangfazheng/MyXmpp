//
//  UITableView+CellClass.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/11.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "UITableView+CellClass.h"
#import "CellDataAdapter.h"
#import "BaseCell.h"

@implementation UITableView (CellClass)
- (void)registerCellsClass:(NSArray <CellClassType *> *)cellClasses {
    
    for (int i = 0; i < cellClasses.count; i++) {
        
        CellClassType *cellClass = cellClasses[i];
        [self registerClass:NSClassFromString(cellClass.classString) forCellReuseIdentifier:cellClass.reuseIdentifier];
    }
}

- (BaseCell *)dequeueAndLoadContentReusableCellFromAdapter:(CellDataAdapter *)adapter indexPath:(NSIndexPath *)indexPath {
    
    BaseCell *cell = [self dequeueReusableCellWithIdentifier:adapter.cellReuseIdentifier];
    [cell setWeakReferenceWithCellDataAdapter:adapter data:adapter.data indexPath:indexPath tableView:self];
    [cell loadContent];
    
    return cell;
}

- (BaseCell *)dequeueAndLoadContentReusableCellFromAdapter:(CellDataAdapter *)adapter indexPath:(NSIndexPath *)indexPath
                                                  controller:(UIViewController *)controller {
    
    BaseCell *cell = [self dequeueReusableCellWithIdentifier:adapter.cellReuseIdentifier];
    cell.controller  = controller;
    [cell setWeakReferenceWithCellDataAdapter:adapter data:adapter.data indexPath:indexPath tableView:self];
    [cell loadContent];
    
    return cell;
}

@end

@implementation CellClassType

+ (instancetype)cellClassTypeWithClassString:(NSString *)classString reuseIdentifier:(NSString *)reuseIdentifier {
    
    NSParameterAssert(NSClassFromString(classString));
    
    CellClassType *type  = [[[self class] alloc] init];
    type.classString     = classString;
    type.reuseIdentifier = reuseIdentifier;
    
    return type;
}

+ (instancetype)cellClassTypeWithClassString:(NSString *)classString {
    
    NSParameterAssert(NSClassFromString(classString));
    
    CellClassType *type  = [[[self class] alloc] init];
    type.classString     = classString;
    type.reuseIdentifier = classString;
    
    return type;
}

@end
