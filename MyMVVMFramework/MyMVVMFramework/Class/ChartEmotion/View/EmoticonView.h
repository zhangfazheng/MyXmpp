//
//  EmoticonView.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmoticonViewModel.h"

@interface EmoticonView : UIView
@property (strong, nonatomic) EmoticonViewModel *viewModel;

- (instancetype)initWithViewModel:(EmoticonViewModel *)viewModel;
+ (instancetype)EmoticonViewViewModel:(EmoticonViewModel *)viewModel;
@end
