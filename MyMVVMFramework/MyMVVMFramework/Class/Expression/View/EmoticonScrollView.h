//
//  EmoticonScrollView.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/21.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressionViewModel.h"

@interface EmoticonScrollView : UICollectionView
@property (nonatomic, strong) UIView *pageControl;
@property (nonatomic, strong) ExpressionViewModel *viewMode;
@property (strong,nonatomic) RACCommand *toolbarBtnDidTapCommand;
@property (strong,nonatomic) RACCommand *emoticonCommand;

+ (instancetype)createScrollViewWithViewModel:(ExpressionViewModel *)viewMode andFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;

@end
