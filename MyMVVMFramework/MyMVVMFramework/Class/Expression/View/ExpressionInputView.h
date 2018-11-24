//
//  ExpressionInputView.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/20.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressionViewModel.h"

@interface ExpressionInputView : UIView
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) ExpressionViewModel *viewMode;
@property (strong,nonatomic) RACCommand *emoticonCommand;
@property (strong,nonatomic) RACSignal *sendMessageSignal;

+ (instancetype)sharedExpressionInputView;
@end
