//
//  ZFZRoomTitleCell.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/14.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseCell.h"

typedef enum {
    ZFZRightButtonTypeEdit = 0,    // 编辑
    ZFZMessageTypeSwitch  // 开关
} ZFZRightButtonType;


@interface ZFZRoomTitleCell : BaseCell
@property(nonatomic,copy) NSString *nameString;
@property(nonatomic,assign) ZFZRightButtonType type;
@end
