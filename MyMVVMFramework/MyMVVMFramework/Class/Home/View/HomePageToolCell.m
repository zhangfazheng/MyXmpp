//
//  HomePageToolCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "HomePageToolCell.h"
#import <Masonry/Masonry.h>
#import "HomePageToolCellModel.h"

@interface HomePageToolCell ()
@property (assign, nonatomic) CGFloat toolHeight;
@property (nonatomic,strong) UILabel *toolTitleLable;
@property (nonatomic,strong) UILabel *toolSubTitleLable;
@property (nonatomic,strong) UIButton *moreButton;
@property (nonatomic,strong) UIView *toolViews;
@end

@implementation HomePageToolCell

- (void)loadContent{
    if (self.data) {
        HomePageToolCellModel *toolModel = (HomePageToolCellModel *)self.data;
        
        NSMutableArray *tools = [NSMutableArray arrayWithCapacity:toolModel.homeToolArry .count];
        [self.toolTitleLable setText:toolModel.toolTitle];
        [self.toolSubTitleLable setText:toolModel.toolSubtitle];
        
        [self setUpToolHeadView];
        
        [self setupToolView:toolModel];
        
    }
}

//设置工具栏头部视图
- (void)setUpToolHeadView{
    UIView *toolHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [toolHeadView addSubview:self.toolTitleLable];
    [toolHeadView addSubview:self.toolSubTitleLable];
    [toolHeadView addSubview:self.moreButton];
    
    WeakSelf
    [_toolTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolHeadView);
        make.left.equalTo(toolHeadView).offset(8);
    }];
    
    [_toolSubTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolHeadView);
        make.left.equalTo(weakSelf.toolTitleLable.mas_right).offset(8);
    }];
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(toolHeadView).offset(-8);
        make.centerY.equalTo(toolHeadView);
    }];
    
    [self.contentView addSubview:toolHeadView];
    
}

//设置工具格
- (void)setupToolView:(HomePageToolCellModel *)tools{
    if (_toolViews) {
        [_toolViews removeFromSuperview];
    }
    UIView *toolViews = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, tools.toolHeight)];
    
    
    CGFloat topButtonInset      = tools.topBottomSpace;
    CGFloat leftRightInset      = ScreenWidth>=320?15:5;
    CGFloat lineSpace           = tools.lineSpace;
    // 格子的宽高70
    CGFloat appViewWH = tools.toolViewWH;
    // 每列有三个格子
    NSInteger column = tools.rowCount;
    
    //    CGFloat topButtonInset      = 15;
    //    CGFloat leftRightInset      = ScreenWidth>=320?15:5;
    //    CGFloat lineSpace           = 20;
    //    // 格子的宽高
    //    CGFloat appViewWH = 70;
    //    // 每列有三个格子
    //    NSInteger column = 4;
    
    CGFloat spacing             = (ScreenWidth - leftRightInset*2 - appViewWH*column)/(column-1);
    
//    _toolHeight = ((tools.homeToolArry.count+3)/4)*appViewWH+((tools.homeToolArry.count+3)/4-1)*lineSpace+topButtonInset*2;
    
//    int showCount = tools.showCount<tools.homeToolArry.count?tools.showCount:(int)tools.homeToolArry.count;
    
    
    
    for (int i = 0; i < tools.homeToolArry.count ; i++) {
        // 计算列号"表示当前是当前行中的第几个格子"
        NSInteger col = i % column;
        // 计算行号"表示当前是当前列中的第几个格子"
        NSInteger row = i / column;
        // 格子的X = 左边间距 + (格子的宽 + 格子间间距) * 列号
        CGFloat appViewX = leftRightInset + (appViewWH + spacing) * col;
        // 格子的Y = 顶部间距 + (格子的高 + 格子间间距) * 行号
        CGFloat appViewY = topButtonInset + (appViewWH + lineSpace) * row;
        
        // 设置格子的frame
        HomeToolView *toolView = [[HomeToolView alloc]initWithFrame:CGRectMake(appViewX, appViewY, appViewWH, appViewWH)];
        toolView.tool = tools.homeToolArry[i];
        toolView.tag  = (self.indexPath.section+1)*100+i+1;

        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toolClickAction:)];
        [toolView addGestureRecognizer:tap];
        // 把格子添加到父控件中"控制器的view"
        [toolViews addSubview:toolView];
        
    }
    _toolViews = toolViews;
    [self.contentView addSubview:_toolViews];
}

- (void)toolClickAction:(UITapGestureRecognizer *) gesture {
    UIView *view = gesture.view;
    if ([self.toolCelldelegate respondsToSelector:@selector(toolClickAction:)]) {
        [self.toolCelldelegate toolClickAction:view.tag];
    }
}
         
- (UILabel *)toolTitleLable{
    if (!_toolTitleLable) {
        _toolTitleLable = [[UILabel alloc]init];
        [_toolTitleLable setText:@"主标题"];
        [_toolTitleLable setFont:Font_Medium_Title];
    }
    return _toolTitleLable;
}

- (UILabel *)toolSubTitleLable{
    if (!_toolSubTitleLable) {
        _toolSubTitleLable = [[UILabel alloc]init];
        [_toolSubTitleLable setTextColor:[UIColor grayColor]];
        [_toolSubTitleLable setFont:Font_Medium_Text];
        [_toolSubTitleLable setText:@"（子标题）"];
    }
    return _toolSubTitleLable;
}

- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc]init];
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreButton.titleLabel setFont:Font_Medium_Text];
        [_moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _moreButton;
}

@end

#pragma mark- toolCell
@interface HomeToolView ()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *titleLable;
@end

@implementation HomeToolView
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
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(45).priorityHigh();
    }];
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_bottom);
        make.left.right.equalTo(weakSelf);
        //make.bottom.equalTo(weakSelf.mas_bottom);
        make.width.mas_equalTo(weakSelf);
        make.height.mas_equalTo(27).priorityHigh();
    }];
}

- (void)setTool:(HomePageToolModel *)tool{
    _tool = tool;
    if (tool) {
        [self.iconImageView setImage: [UIImage imageNamed:tool.icon]];
        [self.titleLable setText:tool.toolName];
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
//        [self addGestureRecognizer:tap];
    }
}

- (void)tapAction{
    if (self.tool.toolAction) {
        _tool.toolAction(@"fffffff");
    }
}

#pragma mark- 懒加载控件

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *imageView              = [UIImageView new];

        _iconImageView                      = imageView;
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
