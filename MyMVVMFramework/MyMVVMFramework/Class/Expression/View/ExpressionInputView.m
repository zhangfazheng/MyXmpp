//
//  ExpressionInputView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/20.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ExpressionInputView.h"
#import "EmoticonGroup.h"
#import "UIColor+YYAdd.h"
#import "ExpressionHelper.h"
#import "EmoticonScrollView.h"
#import "EmoticonToolBar.h"

#define kViewHeight 216
#define kToolbarHeight 37
#define kOneEmoticonHeight 50
#define kOnePageCount 20

@interface ExpressionInputView ()<UIInputViewAudioFeedback>
@property (nonatomic, strong) UIView *viewTopline;
@property (nonatomic, strong) EmoticonToolBar *viewBotToolBar;
@property (nonatomic, strong) NSArray<UIButton *> *toolbarButtons;
@property (nonatomic, strong) EmoticonScrollView *collectionView;
@property (nonatomic, strong) UIView *pageControl;

@end

static ExpressionInputView *expressionInputViewInstance;
@implementation ExpressionInputView

+ (instancetype)sharedExpressionInputView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        expressionInputViewInstance = [[ExpressionInputView alloc]init];
    });
    return expressionInputViewInstance;
}

- (instancetype)init {
    self = [super init];
    
    self.frame = CGRectMake(0, 0, ScreenWidth, kViewHeight);
    self.backgroundColor = UIColorHex(f9f9f9);
    self.viewMode = [[ExpressionViewModel alloc]init];
    
    [self _initUI];
    

    
    return self;
}

- (void)_initUI{
    [self _initTopLine];
    [self _initCollectionView];
    [self _initBottomToolbar];
    
    //信号号连接，传递
    self.viewBotToolBar.toolbarBtnDidTapCommand = self.collectionView.toolbarBtnDidTapCommand;
    self.emoticonCommand = self.collectionView.emoticonCommand;
    self.sendMessageSignal= self.viewBotToolBar.sendMessageSignal;
}


- (void)_initTopLine {
    _viewTopline = [UIView new];
    _viewTopline.width = self.width;
    _viewTopline.height = 1/[UIScreen mainScreen].scale;
    _viewTopline.backgroundColor = UIColorHex(bfbfbf);
    _viewTopline.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_viewTopline];
    
}

- (void)_initCollectionView {
    CGFloat itemWidth = (ScreenWidth - 10 * 2) / 7.0;
    itemWidth = CGFloatPixelRound(itemWidth);
    CGFloat padding = (ScreenWidth - 7 * itemWidth) / 2.0;
    CGFloat paddingLeft  = CGFloatPixelRound(padding);
    CGFloat paddingRight = ScreenWidth - paddingLeft - itemWidth * 7;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemWidth, kOneEmoticonHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight);
    
    _collectionView = [EmoticonScrollView createScrollViewWithViewModel:self.viewMode andFrame:CGRectMake(0, 0, ScreenWidth, kOneEmoticonHeight * 3) collectionViewLayout:layout];
    
    [self addSubview:_collectionView];
    
    _pageControl = [UIView new];
    _pageControl.size = CGSizeMake(ScreenWidth, 20);
    _pageControl.top = _collectionView.bottom - 5;
    _pageControl.userInteractionEnabled = NO;
    _collectionView.pageControl = _pageControl;
    [self addSubview:_pageControl];
    
}


- (void)_initBottomToolbar {
    _viewBotToolBar = [EmoticonToolBar createToolBarWithViewModel:self.viewMode andFrame:CGRectMake(0, self.height-kToolbarHeight, ScreenWidth, kToolbarHeight)];
    
    [self addSubview:_viewBotToolBar];
}



#pragma mark - Action
//发送消息
- (void)onBtnSend:(UIButton *)sender{
    
//    if (_delegate && [_delegate respondsToSelector:@selector(sendBtnDidTap)]) {
//        [_delegate sendBtnDidTap];
//    }
    
}


#pragma mark @protocol UITextViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_textView resignFirstResponder];
}

#pragma mark - UIInputViewAudioFeedback

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}


@end
