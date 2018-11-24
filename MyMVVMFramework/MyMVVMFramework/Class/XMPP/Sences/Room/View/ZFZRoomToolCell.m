//
//  ZFZRoomToolCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/14.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZRoomToolCell.h"
#import <Masonry/Masonry.h>

@interface ZFZRoomToolCell ()
@property (assign, nonatomic) CGFloat toolHeight;
@end

@implementation ZFZRoomToolCell

- (void)loadContent{
    if (self.data) {
        ZFZRoomToolCellModel *toolModel = (ZFZRoomToolCellModel *)self.data;
        
        NSMutableArray *tools = [NSMutableArray arrayWithCapacity:toolModel.roomToolArry .count];
//        NSArray *toolArry   = @[@{@"toolName":@"百科全书",@"icon":@"icon-library"},
//                                @{@"toolName":@"日程表",@"icon":@"icon-curriculum"},
//                                @{@"toolName":@"工作计划",@"icon":@"icon-exam"},
//                                @{@"toolName":@"消息查询",@"icon":@"icon-score"},
//                                @{@"toolName":@"工作",@"icon":@"icon-homework-inline"},
//                                @{@"toolName":@"市场",@"icon":@"icon-second-hand"},
//                                @{@"toolName":@"说说",@"icon":@"icon-social"},
//                                @{@"toolName":@"使用手册",@"icon":@"icon-elec"},
//                                @{@"toolName":@"日程课表",@"icon":@"icon-lab"},
//                                @{@"toolName":@"日历",@"icon":@"icon-calendar"},
//                                @{@"toolName":@"其他",@"icon":@"icon-lost"}];
//        NSMutableArray *tools = [NSMutableArray arrayWithCapacity:toolArry.count];
//        
//        for (NSDictionary *dic in toolArry) {
//            ZFZRoomToolModel * tool = [ZFZRoomToolModel initWithInfoDic:dic];
//            [tools addObject:tool];
//        }
        [self setupToolView:toolModel];
        
        
    }
}

- (void)setupToolView:(ZFZRoomToolCellModel *)tools{
    CGFloat topButtonInset      = tools.topBottomSpace;
    CGFloat leftRightInset      = ScreenWidth>=320?15:5;
    CGFloat lineSpace           = tools.lineSpace;
    // 格子的宽高
    CGFloat appViewWH = tools.toolViewWH;
    // 每列有三个格子
    NSInteger column = tools.showCount;
    
//    CGFloat topButtonInset      = 15;
//    CGFloat leftRightInset      = ScreenWidth>=320?15:5;
//    CGFloat lineSpace           = 20;
//    // 格子的宽高
//    CGFloat appViewWH = 70;
//    // 每列有三个格子
//    NSInteger column = 4;
    
    CGFloat spacing             = (ScreenWidth - leftRightInset*2 - appViewWH*column)/(column-1);

    _toolHeight = ((tools.roomToolArry.count+3)/4)*appViewWH+((tools.roomToolArry.count+3)/4-1)*lineSpace+topButtonInset*2;
    
    for (int i = 0; i < tools.roomToolArry.count ; i++) {
        // 计算列号"表示当前是当前行中的第几个格子"
        NSInteger col = i % column;
        // 计算行号"表示当前是当前列中的第几个格子"
        NSInteger row = i / column;
        // 格子的X = 左边间距 + (格子的宽 + 格子间间距) * 列号
        CGFloat appViewX = leftRightInset + (appViewWH + spacing) * col;
        // 格子的Y = 顶部间距 + (格子的高 + 格子间间距) * 行号
        CGFloat appViewY = topButtonInset + (appViewWH + lineSpace) * row;
        
        // 设置格子的frame
        ZFZToolView *toolView = [[ZFZToolView alloc]initWithFrame:CGRectMake(appViewX, appViewY, appViewWH, appViewWH)];
        toolView.tool = tools.roomToolArry[i];
        
        
        // 把格子添加到父控件中"控制器的view"
        [self addSubview:toolView];

    }

}

@end

#pragma mark- toolCell
@interface ZFZToolView ()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *titleLable;
@end

@implementation ZFZToolView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI{
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLable];
    
    WeakSelf
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.centerX.mas_equalTo(weakSelf);
        make.width.mas_equalTo(47);
        make.height.mas_equalTo(35).priorityHigh();
    }];
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_bottom).offset(8);
        make.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.width.mas_equalTo(70).priorityHigh();
        make.height.mas_equalTo(27).priorityHigh();
    }];
}

- (void)setTool:(ZFZRoomToolModel *)tool{
    _tool = tool;
    if (tool) {
        [self.iconImageView setImage: [UIImage imageNamed:tool.icon]];
        [self.titleLable setText:tool.toolName];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
}

- (void)tapAction{
    if (self.tool.toolAction) {
        _tool.toolAction(@"");
    }
}

#pragma mark- 懒加载控件

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *imageView      = [UIImageView new];
        
        _iconImageView              = imageView;
    }
    return _iconImageView;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        UILabel *lable              = [UILabel new];
        lable.textAlignment         = NSTextAlignmentCenter;
        lable.font                  = Font_Medium_Text;
        
        _titleLable                 = lable;
    }
    return _titleLable;
}


@end
