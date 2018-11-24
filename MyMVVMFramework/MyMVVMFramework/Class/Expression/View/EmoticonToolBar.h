//
//  EmoticonToolBar.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/21.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressionViewModel.h"
#import "EmoticonScrollView.h"

@interface EmoticonToolBar : UIView
@property (nonatomic, strong) NSArray<EmoticonGroup *> *emoticonGroups;
@property (nonatomic, strong) ExpressionViewModel *viewMode;
@property (strong,nonatomic) RACCommand *toolbarBtnDidTapCommand;
@property (strong,nonatomic) RACSignal *sendMessageSignal;


+ (instancetype)createToolBarWithViewModel:(ExpressionViewModel *)viewMode andFrame:(CGRect)frame;

@end
