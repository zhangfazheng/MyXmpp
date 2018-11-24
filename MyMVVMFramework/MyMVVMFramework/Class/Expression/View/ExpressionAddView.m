//
//  ExpressionAddView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/22.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ExpressionAddView.h"
#import "ExpressionAddCell.h"
#import "ExpressionHelper.h"
#import "YYKit.h"

#define kOneItemHeight 90
#define kOnePageCount  8

@interface ExpressionAddView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *pageControl;
@property (nonatomic, strong) NSArray *dataArray;

@end
@implementation ExpressionAddView

- (instancetype)init {
    self = [super init];
    
    self.backgroundColor = UIColorHex(f9f9f9);
    self.dataArray = [ExpressionHelper extraModels];
    
    
    [self _initCollectionView];
    
    
    return self;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray new];
    }
    return _dataArray;
}


- (void)_initCollectionView {
    
    
    CGFloat itemWidth = (kScreenWidth - 10 * 2) / 4.0;
    itemWidth = CGFloatPixelRound(itemWidth);
    CGFloat padding = (kScreenWidth - 4 * itemWidth) / 2.0;
    CGFloat paddingLeft = CGFloatPixelRound(padding);
    CGFloat paddingRight = kScreenWidth - paddingLeft - itemWidth * 4;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemWidth, kOneItemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kOneItemHeight * 2) collectionViewLayout:layout];
    _collectionView.backgroundColor = UIColorHex(F9F9F9);
    [_collectionView registerClass:[ExpressionAddCell class] forCellWithReuseIdentifier:@"cell1"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFloatFromPixel(1))];
    line.backgroundColor = UIColorHex(BFBFBF);
    [_collectionView addSubview:line];
    
    _pageControl = [UIView new];
    _pageControl.size = CGSizeMake(kScreenWidth, 20);
    _pageControl.top = _collectionView.bottom - 5;
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
    
    //kun调试
    //    _collectionView.backgroundColor = [UIColor orangeColor];
    //    _pageControl.backgroundColor = [UIColor purpleColor];
    
}



#pragma mark - @protocol UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ExtraModel *model = [self _modelForIndexPath:indexPath];
//    if (model && _delegate && [_delegate respondsToSelector:@selector(extraItemDidTap:)]) {
//        NSLog(@"%@",model.name);
//        [_delegate extraItemDidTap:model];
//    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark - @protocol UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return kOnePageCount;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ExpressionAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
    cell.model = [self _modelForIndexPath:indexPath];
    return cell;
}

- (ExtraModel *)_modelForIndexPath:(NSIndexPath *)indexPath {
    
    
    NSUInteger page  = 0;
    NSUInteger index = page * kOnePageCount + indexPath.row;
    
    // transpose line/row
    NSUInteger ip = index / kOnePageCount;
    NSUInteger ii = index % kOnePageCount;
    NSUInteger reIndex = (ii % 2) * 4 + (ii / 2);
    index = reIndex + ip * kOnePageCount;
    
    if (index < self.dataArray.count) {
        return self.dataArray[index];
    } else {
        return nil;
    }
    return nil;
}

@end
