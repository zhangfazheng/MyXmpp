//
//  ZFZSearchResultViewController.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/6.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseTableViewController.h"

@class ZFZFriendModel;
@interface ZFZSearchResultViewController : BaseTableViewController
@property (nonatomic, strong) NSArray<ZFZFriendModel *> *filterDataArray;
@end
