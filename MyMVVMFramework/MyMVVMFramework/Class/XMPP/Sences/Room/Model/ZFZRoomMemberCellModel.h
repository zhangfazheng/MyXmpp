//
//  ZFZRoomMemberCellModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/14.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"
#import "ZFZFriendModel.h"

@interface ZFZRoomMemberCellModel : BaseModel
@property (nonatomic,strong) NSArray<ZFZFriendModel *> *membersArry;
// 工具格子的宽高
@property (nonatomic,assign)CGFloat memberViewWH;
// 顶部与底部间距
@property (nonatomic,assign)CGFloat topBottomSpace;

// 图标
@property (nonatomic,copy)NSString *iconPath;

//文字预留宽度
@property (nonatomic,assign)CGFloat titleWidth;
//icon图片预留宽度
@property (nonatomic,assign)CGFloat leftInset;
//辅助视图预留宽度
@property (nonatomic,assign)CGFloat rightInset;

@end
