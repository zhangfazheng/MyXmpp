//
//  ExpressionViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/21.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"
#import "EmoticonGroup.h"

#define kViewHeight 216
#define kToolbarHeight 37
#define kOneEmoticonHeight 50
#define kOnePageCount 20

@interface ExpressionViewModel : BaseViewModel
@property (nonatomic, strong) NSArray<EmoticonGroup *> *emoticonGroups;
//总表情页数
@property (nonatomic, assign) NSInteger emoticonGroupTotalPageCount;
@property (nonatomic, assign) NSInteger curGroupIndex;
@property (nonatomic, assign) NSInteger currentPageIndex;
//获取各表情组起始页号数组
@property (nonatomic, strong) NSArray<NSNumber *> *emoticonGroupPageIndexs;
//获取各表情组各组表情页数数组
@property (nonatomic, strong) NSArray<NSNumber *> *emoticonGroupPageCounts;
@end
