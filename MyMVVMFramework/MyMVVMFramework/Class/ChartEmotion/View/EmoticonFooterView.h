//
//  EmoticonFooterView.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmoticonViewModel.h"

typedef enum : NSUInteger {
    recent,
    defalut,
    emoji,
    lxh
} EmoticonType;

@interface EmoticonFooterView : UIStackView
@property (strong, nonatomic) EmoticonViewModel *viewModel;
@property (strong, nonatomic) RACCommand *emoticonTabCommand;

+ (instancetype)EmoticonFooterViewWithCommand:(RACCommand *)command;
- (instancetype)initWithCommand:(RACCommand *)command;
@end
