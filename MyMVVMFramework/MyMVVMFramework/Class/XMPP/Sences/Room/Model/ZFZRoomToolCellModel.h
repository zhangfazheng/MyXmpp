//
//  ZFZRoomToolCellModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/14.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"
#import "ZFZRoomToolModel.h"

@interface ZFZRoomToolCellModel : BaseModel
@property (nonatomic,strong) NSArray<ZFZRoomToolModel *> *roomToolArry;
// 工具格子的宽高
@property (nonatomic,assign)CGFloat toolViewWH;
// 顶部与底部间距
@property (nonatomic,assign)CGFloat topBottomSpace;
//行间距
@property (nonatomic,assign)CGFloat lineSpace;

//每行展示个数
@property (nonatomic,assign)int showCount;

@end
