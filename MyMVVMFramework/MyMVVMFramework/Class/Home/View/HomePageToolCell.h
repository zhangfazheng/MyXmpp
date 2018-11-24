//
//  HomePageToolCell.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseCell.h"
#import "HomePageToolModel.h"

@protocol HomePageToolCellDelegate <NSObject>
- (void)toolClickAction:(NSInteger)tag;

@end

@interface HomePageToolCell : BaseCell
@property(weak ,nonatomic) id<HomePageToolCellDelegate> toolCelldelegate;
@end


@interface HomeToolView : UIView
@property (nonatomic,strong) HomePageToolModel *tool;
@end
