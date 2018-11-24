//
//  UITableView+CellClass.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/11.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseCell;
@class CellDataAdapter;

@interface CellClassType : NSObject

@property (nonatomic, strong) NSString *classString;
@property (nonatomic, strong) NSString *reuseIdentifier;

/**
 *  Create a object that contain the classString and the reuseIdentifier.为cell添加自定义的重用标识符
 *
 *  @param classString     Class string.  cell的类名
 *  @param reuseIdentifier Cell reuseIdentifier  重用标识符
 *
 *  @return CellClassType Object.
 */
+ (instancetype)cellClassTypeWithClassString:(NSString *)classString reuseIdentifier:(NSString *)reuseIdentifier;

/**
 *  The classString is the same with the reuseIdentifier.为cell添加一个和类名相同的重用标识符
 *
 *  @param classString Class string.
 *
 *  @return CellClassType Object.
 */

+ (instancetype)cellClassTypeWithClassString:(NSString *)classString;

@end
NS_INLINE CellClassType *cellClass(NSString *classString, NSString *reuseIdentifier) {
    
    return [CellClassType cellClassTypeWithClassString:classString reuseIdentifier:reuseIdentifier.length <= 0 ? classString : reuseIdentifier];
}

@interface UITableView (CellClass)
/**
 *  Register cells class.
 *
 *  @param cellClasses CellClassType object's array.
 */
- (void)registerCellsClass:(NSArray <CellClassType *> *)cellClasses;

/**
 *  用cell模型创建一个cell.
 *
 *  @param adapter CellClassType object's array.
 */
- (BaseCell *)dequeueAndLoadContentReusableCellFromAdapter:(CellDataAdapter *)adapter indexPath:(NSIndexPath *)indexPath;

/**
 *  Register cells class.
 *
 *  @param adapter CellClassType object's array.
 */
- (BaseCell *)dequeueAndLoadContentReusableCellFromAdapter:(CellDataAdapter *)adapter indexPath:(NSIndexPath *)indexPath
                                                  controller:(UIViewController *)controller;
@end
