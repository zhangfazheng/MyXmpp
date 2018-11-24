//
//  BaseHeaderFooterView.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseHeaderFooterView.h"

@implementation BaseHeaderFooterView

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BaseHeaderFooterView *footerView = [super allocWithZone:zone];
    
    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，只要调用这个方法，就会发送信号。
    // 这里表示只要viewModel调用initWithServices:,就会发出信号
    @weakify(footerView)
    [[footerView
      rac_signalForSelector:@selector(initWithReuseIdentifier:)]
    	subscribeNext:^(id x) {
            @strongify(footerView)
            
            [footerView initialize];
        }];
    
    return footerView;
}

- (void)initialize{
    
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setupHeaderFooterView];
        [self buildSubview];
    }
    
    return self;
}


- (void)setHeaderFooterViewBackgroundColor:(UIColor *)color {
    
    self.contentView.backgroundColor = color;
}

- (void)setupHeaderFooterView {
    
}

- (void)buildSubview {
    
}

- (void)loadContent {
    
}
@end
