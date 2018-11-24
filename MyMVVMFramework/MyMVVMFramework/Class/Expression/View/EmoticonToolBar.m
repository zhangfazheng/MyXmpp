//
//  EmoticonToolBar.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/21.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "EmoticonToolBar.h"
#import "UIView+Frame.h"
#import "ExpressionHelper.h"


@interface EmoticonToolBar ()
@property (nonatomic, strong) NSArray<UIButton *> *toolbarButtons;
@end

@implementation EmoticonToolBar

CGFloat btnSendBtnWidth = 50;

- (instancetype)initWithFrame:(CGRect)frame andViewModel:(ExpressionViewModel *)viewMode{
    if (self=[super initWithFrame:frame]) {
        self.viewMode = viewMode;
       
        [self buildSubview];
         [self setUp];
    }
    return self;
}

+ (instancetype)createToolBarWithViewModel:(ExpressionViewModel *)viewMode andFrame:(CGRect)frame{
    return [[EmoticonToolBar alloc]initWithFrame:frame andViewModel:viewMode];
}

- (void)setUp{
//    _currentPageIndex = NSNotFound;
    @weakify(self)
    //当滚动翻页的时候切换按钮选中状态
    [RACObserve(self.viewMode, curGroupIndex) subscribeNext:^(NSNumber *x) {
        @strongify(self)
        [self->_toolbarButtons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
            btn.selected = (idx == x.integerValue);
        }];
    }];
    
}

- (void)buildSubview{
    UIImageView *bg = [[UIImageView alloc] initWithImage:[ExpressionHelper imageNamed:@"compose_emotion_table_right_normal"]];
    bg.size = self.size;
    [self addSubview:bg];
    
    
    UIScrollView *scroll = [UIScrollView new];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.alwaysBounceHorizontal = YES;
    CGSize size = CGSizeMake(ScreenWidth-btnSendBtnWidth, self.size.height);
    scroll.size = size;
    scroll.contentSize = size;
    [self addSubview:scroll];
    
    
    UIButton *btnSend = [UIButton new];
    btnSend.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btnSend setTitle:@"发送" forState:UIControlStateNormal];
    self.sendMessageSignal = [btnSend rac_signalForControlEvents:UIControlEventTouchUpInside];
    btnSend.left = ScreenWidth - btnSendBtnWidth;
    btnSend.size  = CGSizeMake(btnSendBtnWidth, self.height);
    btnSend.backgroundColor = [UIColor colorWithRed:(0)/255.0f green:(201)/255.0f blue:(144)/255.0f alpha:1];
    [self addSubview:btnSend];
    
    NSMutableArray *btns = [NSMutableArray new];
    UIButton *btn;
    _emoticonGroups = self.viewMode.emoticonGroups;
    if (_emoticonGroups && _emoticonGroups.count > 0) {
        NSArray<EmoticonGroup *> *emoticonGroups = self.viewMode.emoticonGroups;
        for (NSUInteger i = 0; i < emoticonGroups.count; i++) {
            EmoticonGroup *group = emoticonGroups[i];
            btn = [self _createToolbarButton];
            [btn setTitle:group.nameCN forState:UIControlStateNormal];
            btn.left = (ScreenWidth-btnSendBtnWidth) / (float)emoticonGroups.count * i;
            btn.tag = i;
            [scroll addSubview:btn];
            [btns addObject:btn];
        }

    }
    _toolbarButtons = btns;
}


- (UIButton *)_createToolbarButton {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = YES;
    btn.size = CGSizeMake((ScreenWidth - btnSendBtnWidth) / _emoticonGroups.count, kToolbarHeight);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:UIColorHex(5D5C5A) forState:UIControlStateSelected];
    
    UIImage *img;
    img = [ExpressionHelper imageNamed:@"compose_emotion_table_left_normal"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, img.size.width - 1) resizingMode:UIImageResizingModeStretch];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    
    img = [ExpressionHelper imageNamed:@"compose_emotion_table_left_selected"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, img.size.width - 1) resizingMode:UIImageResizingModeStretch];
    [btn setBackgroundImage:img forState:UIControlStateSelected];
    
    btn.rac_command = self.toolbarBtnDidTapCommand;
    
    return btn;
}


@end
