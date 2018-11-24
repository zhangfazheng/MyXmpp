//
//  ReviewUserDetailsViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/28.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"

@class CellDataAdapter;
@class ReviewUserModel;
@interface ReviewUserViewModel : BaseViewModel
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * items;
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * curUserItems;
@property (nonatomic, strong) ReviewUserModel *curUser;

@end
