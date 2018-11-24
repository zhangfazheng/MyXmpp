//
//  BaseCollectionCell.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDataAdapter.h"
@class BaseCollectionCell;

@protocol BaseCollectionCellDelegate <NSObject>

@optional

/**
 *  BaseCollectionCell's event.
 *
 *  @param cell  BaseCollectionCell
 *  @param event Event.
 */
- (void)customCollectionCell:(BaseCollectionCell *)cell event:(id)event;

@end

@interface BaseCollectionCell : UICollectionViewCell
/**
 *  CustomCollectionCell's delegate.
 */
@property (nonatomic, weak) id <BaseCollectionCellDelegate> delegate;

/**
 *  CustomCell's data.
 */
@property (nonatomic, weak) CellDataAdapter         *dataAdapter;

/**
 *  CustomCell's data.
 */
@property (nonatomic, weak) id                       data;

/**
 *  CustomCell's indexPath.
 */
@property (nonatomic, weak) NSIndexPath             *indexPath;

/**
 *  TableView.
 */
@property (nonatomic, weak) UICollectionView        *collectionView;

/**
 *  Controller.
 */
@property (nonatomic, weak) UIViewController        *controller;

/**
 *  Cell is showed or not, you can set this property in UICollectionView's method 'collectionView:willDisplayCell:forItemAtIndexPath:' at runtime.
 */
@property (nonatomic)       BOOL                     display;

#pragma mark - Method you should overwrite.

/**
 *  Setup cell, override by subclass.
 */
- (void)setupCell;

/**
 *  Build subview, override by subclass.
 */
- (void)buildSubview;

/**
 *  Load content, override by subclass.
 */
- (void)loadContent;

#pragma mark - Useful method.

/**
 *  Selected event, override by subclass.
 */
- (void)selectedEvent;

#pragma mark - Constructor method.

/**
 *  Create the cell's dataAdapter.
 *
 *  @param reuseIdentifier Cell reuseIdentifier, can be nil.
 *  @param data            Cell's data, can be nil.
 *  @param type            Cell's type.
 *
 *  @return Cell's dataAdapter.
 */
+ (CellDataAdapter *)dataAdapterWithCellReuseIdentifier:(NSString *)reuseIdentifier data:(id)data type:(NSInteger)type;

/**
 *  Create the cell's dataAdapter, the reuseIdentifier is the cell's class string.
 *
 *  @param data            Cell's data, can be nil.
 *  @param type            Cell's type.
 *
 *  @return Cell's dataAdapter.
 */
+ (CellDataAdapter *)dataAdapterWithData:(id)data type:(NSInteger)type;

@end
