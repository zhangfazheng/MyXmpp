//
//  ReadeStatusViewController.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/20.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ZFZRoomModel.h"


@interface ReadeStatusViewController : BaseTableViewController
//上一页面传过来的已读状态的成员列表
@property (nonatomic,strong) NSArray *readerStatusArray;
//当前房间
@property (nonatomic, strong) ZFZRoomModel *curRoom;
@end
