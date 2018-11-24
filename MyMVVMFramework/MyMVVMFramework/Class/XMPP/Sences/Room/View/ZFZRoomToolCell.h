//
//  ZFZRoomToolCell.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/14.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseCell.h"
#import "ZFZRoomToolCellModel.h"

@interface ZFZRoomToolCell : BaseCell

@end


@interface ZFZToolView : UIView
@property (nonatomic,strong) ZFZRoomToolModel *tool;
@end
