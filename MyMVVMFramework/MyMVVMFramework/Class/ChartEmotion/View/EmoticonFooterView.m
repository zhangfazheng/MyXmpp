//
//  EmoticonFooterView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "EmoticonFooterView.h"



@implementation EmoticonFooterView

- (instancetype)initWithCommand:(RACCommand *)command;
{
    if (self = [super init]) {
        //注意!!!!!!!!!
        // 设置方向
        self.axis = UILayoutConstraintAxisHorizontal;
        
        // 设置填充模式
        self.distribution = UIStackViewDistributionFillEqually;
        self.emoticonTabCommand = command;
        [self setupUI];
    }
    return self;
}

+ (instancetype)EmoticonFooterViewWithCommand:(RACCommand *)command;{
    EmoticonFooterView * footerView = [[EmoticonFooterView alloc]initWithCommand:command];
    
    return footerView;
}


- (void)setupUI{
    // 我们的tag需要添加枚举所对应的值
    
    /*
     如果非要填写10000也是可以的,不用纠结
     */
    [self addChildButtonWithTitle:@"最近" tag:recent];
    [self addChildButtonWithTitle:@"默认" tag:defalut];
    [self addChildButtonWithTitle:@"emoji" tag:emoji];
    [self addChildButtonWithTitle:@"浪小花" tag:lxh];
}

- (void)addChildButtonWithTitle:(NSString *)title tag:(EmoticonType) tag{
    UIButton *button = [UIButton new];
    
    [button setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_selected"] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    
    button.tag = tag;
    
    if (tag == 1) {
        button.selected = YES;
    }
    button.rac_command = self.emoticonTabCommand;
    
    [self addArrangedSubview:button];
    @weakify(self)
    [[[self.emoticonTabCommand executionSignals]switchToLatest]subscribeNext:^(NSNumber *x) {
        @strongify(self)
        NSInteger tag = [x integerValue];
        
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (tag == obj.tag) {
                obj.selected = YES;
            }else{
                obj.selected = NO;
            }
        }];
    }];
}

@end
