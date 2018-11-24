//
//  ZFZRecentlyViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/15.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"
#import "UITableView+CellClass.h"

@interface ZFZRecentlyViewModel : BaseViewModel
@property (nonatomic, strong, readwrite) RACSubject *updateArchivingSubject;
//@property (nonatomic, strong, readwrite) RACSignal *startGetRoster;
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * items;

@end
