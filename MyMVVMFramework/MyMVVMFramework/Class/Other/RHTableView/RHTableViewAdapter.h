//
//  RHTableViewAdapter.h
//  RHToolkit
//
//  Created by zhuruhong on 15/6/27.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RHTableViewCellModel;

@protocol RHTableViewAdapterDelegate <NSObject>

@optional

- (void)didTableViewSelectIndexPath:(NSIndexPath *)indexPath;
- (void)didTableViewCellSelect:(id)cellData;

@end

@interface RHTableViewAdapter : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readonly) NSMutableArray *dataArray;
@property (nonatomic, weak) id<RHTableViewAdapterDelegate> delegate;

- (void)addCellData:(RHTableViewCellModel *)cellData;
- (void)removeAllCellData;

@end
