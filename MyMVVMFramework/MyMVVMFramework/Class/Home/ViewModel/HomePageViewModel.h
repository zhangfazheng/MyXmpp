//
//  HomePageViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"

@class CellDataAdapter;
@interface HomePageViewModel : BaseViewModel
@property (strong, nonatomic) NSMutableArray<NSArray<CellDataAdapter *>*> *apps;
@end
