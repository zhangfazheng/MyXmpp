//
//  ExpressionViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/21.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ExpressionViewModel.h"
#import "UIColor+YYAdd.h"
#import "ExpressionHelper.h"
#import "EmoticonScrollView.h"
#import "EmoticonToolBar.h"


@implementation ExpressionViewModel


-(void)initialize{
    
}

- (instancetype)init{
    if (self = [super init]) {
        [self initGroups];
    }
    
    return self;
}


- (void)initGroups {
    _emoticonGroups = [ExpressionHelper emoticonGroups];
    
    //获取各表情组起始页下标数组
    NSMutableArray *indexs = [NSMutableArray new];
    NSUInteger index = 0;
    for (EmoticonGroup *group in _emoticonGroups) {
        [indexs addObject:@(index)];
        NSUInteger count = ceil(group.emoticons.count / (float)kOnePageCount);
        if (count == 0) count = 1;
        index += count;
    }
    _emoticonGroupPageIndexs = indexs;
    
    //_curGroupIndex = NSNotFound;
    
    //表情组总页数
    NSMutableArray *pageCounts = [NSMutableArray new];
    _emoticonGroupTotalPageCount = 0;
    for (EmoticonGroup *group in _emoticonGroups) {
        NSUInteger pageCount = ceil(group.emoticons.count / (float)kOnePageCount);
        if (pageCount == 0) pageCount = 1;
        [pageCounts addObject:@(pageCount)];
        _emoticonGroupTotalPageCount += pageCount;
    }
    _emoticonGroupPageCounts = pageCounts;
}



@end
