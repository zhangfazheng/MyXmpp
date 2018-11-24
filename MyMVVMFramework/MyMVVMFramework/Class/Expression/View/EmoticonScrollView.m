//
//  EmoticonScrollView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/21.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "EmoticonScrollView.h"
#import "EmoticonCell.h"
#import "UIView+Frame.h"
#import "ExpressionHelper.h"

@interface EmoticonScrollView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation EmoticonScrollView{
    NSTimeInterval *_touchBeganTime;
    BOOL _touchMoved;
    UIImageView *_magnifier;
    UIImageView *_magnifierContent;
    __weak EmoticonCell *_currentMagnifierCell;
    NSTimer *_backspaceTimer;
}
NSInteger curGroupPageIndex = 0, curGroupPageCount = 0;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout viewModel:(ExpressionViewModel *)viewMode {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.viewMode = viewMode;
    [self buildSubview];
    [self setUp];
    
    [self scrollViewDidScroll:self];
    return self;
}

+ (instancetype)createScrollViewWithViewModel:(ExpressionViewModel *)viewMode andFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    return [[EmoticonScrollView alloc]initWithFrame:frame collectionViewLayout:layout viewModel:viewMode];
}


- (void)setUp{
    [self registerClass:[EmoticonCell class] forCellWithReuseIdentifier:@"cell"];
    self.delegate = self;
    self.dataSource = self;
    self.top = 5;
    //@weakify(self)
//    self.scrollViewCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *curGroupIndex) {
//        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            [subscriber sendNext:curGroupIndex];
//            [subscriber sendCompleted];
//            
//            return nil;
//        }];
//    }];
    //表情页切换
    self.toolbarBtnDidTapCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(UIButton *sender) {
        NSInteger groupIndex = sender.tag;
        NSInteger page = ((NSNumber *)self.viewMode.emoticonGroupPageIndexs[groupIndex]).integerValue;
        CGRect rect = CGRectMake(page * self.width, 0, self.width, self.height);
        [self scrollRectToVisible:rect animated:NO];
        [self scrollViewDidScroll:self];
        
            return [RACSignal empty];
        }];
    
    //表情点击的信号
    self.emoticonCommand        = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(EmoticonCell * cell) {
        
        if (!cell) return [RACSignal empty];
        if (cell.isDelete) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [subscriber sendNext:@"deleted"];
                [subscriber sendCompleted];
                
                return nil;
            }];
        } else if (cell.emoticon) {
            NSString *text = nil;
            switch (cell.emoticon.type) {
                case EmoticonTypeImage: {
                    text = cell.emoticon.chs;
                } break;
                case EmoticonTypeEmoji: {
                    NSNumber *num = [NSNumber numberWithString:cell.emoticon.code];
                    text = [NSString stringWithUTF32Char:num.unsignedIntValue];
                } break;
                default:break;
            }
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [subscriber sendNext:text];
                [subscriber sendCompleted];
                
                return nil;
            }];
        }
        
        return [RACSignal empty];
        
    }];
}

- (void)buildSubview{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = [UIView new];
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.clipsToBounds = NO;
    self.canCancelContentTouches = NO;
    self.multipleTouchEnabled = NO;
    _magnifier = [[UIImageView alloc] initWithImage:[ExpressionHelper imageNamed:@"emoticon_keyboard_magnifier"]];
    _magnifierContent = [UIImageView new];
    _magnifierContent.size = CGSizeMake(40, 40);
    _magnifierContent.centerX = _magnifier.width / 2;
    [_magnifier addSubview:_magnifierContent];
    _magnifier.hidden = YES;
    [self addSubview:_magnifier];
}

- (void)dealloc {
    [self endBackspaceTimer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchMoved = NO;
    EmoticonCell *cell = [self cellForTouches:touches];
    _currentMagnifierCell = cell;
    [self showMagnifierForCell:_currentMagnifierCell];
    
    if (cell.imageView.image && !cell.isDelete) {
        [[UIDevice currentDevice] playInputClick];
    }
    
    if (cell.isDelete) {
        [self endBackspaceTimer];
        [self performSelector:@selector(startBackspaceTimer) afterDelay:0.5];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchMoved = YES;
    if (_currentMagnifierCell && _currentMagnifierCell.isDelete) return;
    
    EmoticonCell *cell = [self cellForTouches:touches];
    if (cell != _currentMagnifierCell) {
        if (!_currentMagnifierCell.isDelete && !cell.isDelete) {
            _currentMagnifierCell = cell;
        }
        [self showMagnifierForCell:cell];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    EmoticonCell *cell = [self cellForTouches:touches];
    if ((!_currentMagnifierCell.isDelete && cell.emoticon) || (!_touchMoved && cell.isDelete)) {
//        if ([self.delegate respondsToSelector:@selector(emoticonScrollViewDidTapCell:)]) {
//            [((id<YHEmoticonScrollViewDelegate>) self.delegate) emoticonScrollViewDidTapCell:cell];
//        }
        [self.emoticonCommand execute:cell];
    }
    [self hideMagnifier];
    [self endBackspaceTimer];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideMagnifier];
    [self endBackspaceTimer];
}

- (EmoticonCell *)cellForTouches:(NSSet<UITouch *> *)touches {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    if (indexPath) {
        EmoticonCell *cell = (id)[self cellForItemAtIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void)showMagnifierForCell:(EmoticonCell *)cell {
    if (cell.isDelete || !cell.imageView.image) {
        [self hideMagnifier];
        return;
    }
    CGRect rect = [cell convertRect:cell.bounds toView:self];
    _magnifier.centerX = CGRectGetMidX(rect);
    _magnifier.bottom = CGRectGetMaxY(rect) - 9;
    _magnifier.hidden = NO;
    
    _magnifierContent.image = cell.imageView.image;
    _magnifierContent.top = 20;
    
    [_magnifierContent.layer removeAllAnimations];
    NSTimeInterval dur = 0.1;
    @weakify(self)
    [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        @strongify(self)
        self->_magnifierContent.top = 3;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->_magnifierContent.top = 6;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->_magnifierContent.top = 5;
            } completion:^(BOOL finished) {
            }];
        }];
    }];
}

- (void)hideMagnifier {
    _magnifier.hidden = YES;
}

- (void)startBackspaceTimer {
    [self endBackspaceTimer];
    @weakify(self);
    _backspaceTimer = [NSTimer timerWithTimeInterval:0.1 block:^(NSTimer *timer) {
        @strongify(self);
        if (!self) return;
        EmoticonCell *cell = self->_currentMagnifierCell;
        if (cell.isDelete) {
            [self.emoticonCommand execute:cell];
        }
    } repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_backspaceTimer forMode:NSRunLoopCommonModes];
}

- (void)endBackspaceTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startBackspaceTimer) object:nil];
    [_backspaceTimer invalidate];
    _backspaceTimer = nil;
}


#pragma mark UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = round(scrollView.contentOffset.x / scrollView.width);
    if (page < 0) page = 0;
    else if (page >= self.viewMode.emoticonGroupTotalPageCount) page = self.viewMode.emoticonGroupTotalPageCount - 1;
    if (page == self.viewMode.currentPageIndex) return;
    self.viewMode.currentPageIndex = page;
    
    for (NSInteger i = self.viewMode.emoticonGroupPageIndexs.count - 1; i >= 0; i--) {
        NSNumber *pageIndex = self.viewMode.emoticonGroupPageIndexs[i];
        if (page >= pageIndex.unsignedIntegerValue) {
            if (self.viewMode.curGroupIndex != i) {
                self.viewMode.curGroupIndex = i;
            }
            curGroupPageIndex = ((NSNumber *)self.viewMode.emoticonGroupPageIndexs[i]).integerValue;
            curGroupPageCount = ((NSNumber *)self.viewMode.emoticonGroupPageCounts[i]).integerValue;
            break;
        }
    }
    [_pageControl.layer removeAllSublayers];
    CGFloat padding = 5, width = 6, height = 2;
    CGFloat pageControlWidth = (width + 2 * padding) * curGroupPageCount;
    for (NSInteger i = 0; i < curGroupPageCount; i++) {
        CALayer *layer = [CALayer layer];
        layer.size = CGSizeMake(width, height);
        layer.cornerRadius = 1;
        if (page - curGroupPageIndex == i) {
            layer.backgroundColor = UIColorHex(fd8225).CGColor;
        } else {
            layer.backgroundColor = UIColorHex(dedede).CGColor;
        }
        layer.centerY = _pageControl.height / 2;
        layer.left = (_pageControl.width - pageControlWidth) / 2 + i * (width + 2 * padding) + padding;
        [_pageControl.layer addSublayer:layer];
    }
    
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewMode.emoticonGroupTotalPageCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kOnePageCount + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EmoticonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == kOnePageCount) {
        cell.isDelete = YES;
        cell.emoticon = nil;
    } else {
        cell.isDelete = NO;
        cell.emoticon = [self _emoticonForIndexPath:indexPath];
    }
    return cell;
}

- (EmoticonModel *)_emoticonForIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    for (NSInteger i = self.viewMode.emoticonGroupPageIndexs.count - 1; i >= 0; i--) {
        NSNumber *pageIndex = self.viewMode.emoticonGroupPageIndexs[i];
        if (section >= pageIndex.unsignedIntegerValue) {
            EmoticonGroup *group = self.viewMode.emoticonGroups[i];
            //当前组第几页
            NSUInteger page = section - pageIndex.unsignedIntegerValue;
            //当前组第几个
            NSUInteger index = page * kOnePageCount + indexPath.row;
            
            // transpose line/row
            //collectionView设置为水平滚动后，cell从上下到布局，为了使显示时任看起来像从左到右布局，需将item转化为数组中对应的序号
            NSUInteger ip = index / kOnePageCount;
            NSUInteger ii = index % kOnePageCount;
            NSUInteger reIndex = (ii % 3) * 7 + (ii / 3);
            index = reIndex + ip * kOnePageCount;
            
            //转化为数组中对应的序号可能会走出每组的表情数，走出说明该位置没有表情
            if (index < group.emoticons.count) {
                return group.emoticons[index];
            } else {
                return nil;
            }
        }
    }
    return nil;
}

//选择表情
//- (void)emoticonScrollViewDidTapCell:(EmoticonCell *)cell {
//    if (!cell) return;
//    if (cell.isDelete) {
//        if ([self.delegate respondsToSelector:@selector(emoticonInputDidTapBackspace)]) {
//            [[UIDevice currentDevice] playInputClick];
//            [self.delegate emoticonInputDidTapBackspace];
//        }
//    } else if (cell.emoticon) {
//        NSString *text = nil;
//        switch (cell.emoticon.type) {
//            case EmoticonTypeImage: {
//                text = cell.emoticon.chs;
//            } break;
//            case EmoticonTypeEmoji: {
//                NSNumber *num = [NSNumber numberWithString:cell.emoticon.code];
//                text = [NSString stringWithUTF32Char:num.unsignedIntValue];
//            } break;
//            default:break;
//        }
//        if (text && [self.delegate respondsToSelector:@selector(emoticonInputDidTapText:)]) {
//            [self.delegate emoticonInputDidTapText:text];
//        }
//    }
//}

@end
