//
//  HomePageToolCellModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"
#import "HomePageToolModel.h"

@interface HomePageToolCellModel : BaseModel
@property (nonatomic,strong) NSMutableArray<HomePageToolModel *> *homeToolArry;
// 工具格子的宽高
@property (nonatomic,assign)CGFloat toolViewWH;
// 顶部与底部间距
@property (nonatomic,assign)CGFloat topBottomSpace;
//行间距
@property (nonatomic,assign)CGFloat lineSpace;

//工具栏高度
@property (nonatomic,assign)CGFloat toolHeight;

//每行展示个数
@property (nonatomic,assign)int rowCount;
//显示个数
@property (nonatomic,assign)int showCount;

//工具栏标题
@property (nonatomic,copy) NSString *toolTitle;

//工具栏子标题
@property (nonatomic,copy) NSString *toolSubtitle;

//工具组ID
@property (nonatomic,copy) NSString *toolGroupId;
@end
