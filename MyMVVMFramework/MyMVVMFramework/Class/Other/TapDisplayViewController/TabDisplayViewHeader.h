//
//  TabDisplayViewHeader.h
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/20.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#ifndef TabDisplayViewHeader_h
#define TabDisplayViewHeader_h

#import "TabDisplayViewController.h"



// 标题滚动视图的高度
static CGFloat const TabTitleScrollViewH = 44;

// 标题缩放比例
static CGFloat const TabTitleTransformScale = 1.3;

// 下划线默认高度
static CGFloat const TabUnderLineH = 2;


// 默认标题字体
#define TabDisplayTitleFont [UIFont systemFontOfSize:15]

// 默认标题间距
static CGFloat const margin = 20;

static NSString * const ID = @"cell";

// 标题被点击或者内容滚动完成，会发出这个通知，监听这个通知，可以做自己想要做的事情，比如加载数据
static NSString * const TabDisplayViewClickOrScrollDidFinshNote = @"TabDisplayViewClickOrScrollDidFinshNote";

// 重复点击通知
static NSString * const TabDisplayViewRepeatClickTitleNote = @"TabDisplayViewRepeatClickTitleNote";


#endif /* Const_h */
