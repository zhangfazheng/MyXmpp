//
//  SingleSelectionTableViewCell.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/27.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseCell.h"

@interface SingleSelectionTableViewCell : BaseCell

@end


@interface SingleSelectionTableViewCellModel:NSObject
@property (nonatomic,strong) NSArray *selectionsArray;
@property (nonatomic,copy) NSString *tilleString;
@property (nonatomic,assign) NSInteger value;
@end
