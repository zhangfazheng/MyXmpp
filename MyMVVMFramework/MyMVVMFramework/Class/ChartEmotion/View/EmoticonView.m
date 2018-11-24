//
//  EmoticonView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "EmoticonView.h"
#import "EmoticonFooterView.h"
#import <Masonry.h>
#import "UITableView+CellClass.h"
#import "EmoticonViewCell.h"

@interface EmoticonView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) EmoticonFooterView *footerView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) NSArray<NSArray *> *emoticons;
@property (strong, nonatomic) RACCommand *emoticonTabCommand;

@end
@implementation EmoticonView

- (instancetype)initWithViewModel:(EmoticonViewModel *)viewModel
{
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        [self setupCollectionView];
        [self bindViewModel];
        [self setupUI];
        
    }
    return self;
}

+ (instancetype)EmoticonViewViewModel:(EmoticonViewModel *)viewModel{
    return [[EmoticonView alloc]initWithViewModel:viewModel];
}

-(void)bindViewModel{
    @weakify(self)
    [[self.viewModel.itemsDataCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.emoticons = (NSArray<NSArray *> *)x;
        [self.collectionView reloadData];
    }];
    
    [self.viewModel.itemsDataCommand execute:@1];
    
    self.emoticonTabCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(UIButton *input) {
        @strongify(self)
        NSIndexPath *indexPath;
        
        NSInteger type =input.tag;
        
        switch (type) {
            case recent:
                indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                break;
            case defalut:
                indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
                break;
            case emoji:
                indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
                break;
            case lxh:
                indexPath = [NSIndexPath indexPathForItem:0 inSection:3];
                break;
                
            default:
                break;
        }
        
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:[NSNumber numberWithInteger:type]];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
}


- (void)setupUI{
    [self addSubview:self.collectionView];
    [self addSubview:self.footerView];
    
    WeakSelf
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.footerView.mas_top);
    }];
    
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(44).priorityHigh();
    }];
    
    // 我们可以让他晚一点滚动
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    });
    
}

//添加手势动画
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"gshdjsjkd");
}



- (void)setupCollectionView{
    self.collectionView.dataSource = self;
    
    // 注册cell
    [self.collectionView registerClass:[EmoticonViewCell class] forCellWithReuseIdentifier:@"EmoticonViewReuseIdentifier"];
    

}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.flowLayout.itemSize = self.collectionView.frame.size;
}

#pragma mark-collectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.emoticons.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *temArray = self.emoticons[section];
    return temArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EmoticonViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmoticonViewReuseIdentifier" forIndexPath:indexPath];
    NSLog(@"section:%zd,item:%zd",indexPath.section,indexPath.item);
    
    cell.viewModel = self.viewModel;
    cell.emoticons = self.emoticons[indexPath.section][indexPath.item];
    
    return cell;
}

#pragma mark-懒加载控件

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        // 设置属性 -- 由于collectionView没有size,所以不能在这里实现设置大小
        //        flowLayout.itemSize = collectionView.frame.size
        
        flowLayout.scrollDirection              = UICollectionViewScrollDirectionHorizontal;
        
        flowLayout.minimumInteritemSpacing      = 0;
        flowLayout.minimumLineSpacing           = 0;
        
        _flowLayout                             = flowLayout;
    }
    
    return _flowLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        
        // 分页
        [collectionView setPagingEnabled:YES];
        collectionView.showsHorizontalScrollIndicator       = NO;
        collectionView.showsVerticalScrollIndicator         = NO;
        collectionView.backgroundColor                      = [UIColor lightGrayColor];
        
        _collectionView                                     = collectionView;
        
    }
    return _collectionView;
}

- (EmoticonFooterView *)footerView{
    if (!_footerView) {
        _footerView = [EmoticonFooterView EmoticonFooterViewWithCommand:self.emoticonTabCommand];
    }
    return _footerView;
}

@end
