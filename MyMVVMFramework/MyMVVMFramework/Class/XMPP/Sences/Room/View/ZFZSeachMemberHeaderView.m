//
//  ZFZSeachMemberHeaderView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/19.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZSeachMemberHeaderView.h"
#import "ZFZAddMemberCollectionViewCell.h"
#import "UIView+Frame.h"

@interface ZFZSeachMemberHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *memberListCollectionView;
//maxWidth
@property (nonatomic,assign)CGFloat maxWidth;
@property (nonatomic,assign)CGFloat memberSpace;
// 格子的宽高
@property (nonatomic,assign)CGFloat memberViewWH;

@end

@implementation ZFZSeachMemberHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _maxWidth               = ScreenWidth/2;
        _memberSpace            = 5;
        // 格子的宽高
        _memberViewWH           = 50;
        [self setUpUI];
    }
    return  self;
}

- (void)setUpUI{
    [self addSubview: self.memberListCollectionView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, ScreenWidth, 1)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [self addSubview:lineView];
}

//重新加载数据
- (void)reloadMembersList{
    if (!_addMembersList) {
        return;
    }
    //根据成员的个数据来设置memberListCollectionView宽度
    CGFloat memberListCollectionViewWidth = _addMembersList.count*_memberViewWH+_memberSpace*(_addMembersList.count>1?_addMembersList.count:0);
    
    self.memberListCollectionView.width = memberListCollectionViewWidth >_maxWidth?_maxWidth:memberListCollectionViewWidth;
    
    [self.memberListCollectionView reloadData];
    
    //[self.memberListCollectionView reloadItemsAtIndexPaths:<#(nonnull NSArray<NSIndexPath *> *)#>]
}

//移动支尾部
- (void)moveToTranin{
    //滚动到尾部
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:self.addMembersList.count-1 inSection:0];
    [self.memberListCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

//移除成员
- (void)reMoveMember:(ZFZFriendModel *)member{
    int i;
    for (i = 0; i<self.addMembersList.count; i++) {
        if (self.addMembersList [i] == member) {
            //修改状态
            member.friendSelectType = ZFZEnable;
            [self.addMembersList removeObjectAtIndex:i];
            break;
        }
    }
//    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:i inSection:0];

    [self reloadMembersList];
    
}


#pragma mark - CollectionView数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.addMembersList.count;
    
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    ZFZAddMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZFZAddMemberCollectionViewCell" forIndexPath:indexPath];
    cell.icon = self.addMembersList[indexPath.row].phton;
    return cell;
}


#pragma mark - CollectionView代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.addMembersList[indexPath.row].friendSelectType = ZFZEnable;
    [self.addMembersList removeObjectAtIndex:indexPath.row];
    [self reloadMembersList];
    
    NSNumber *value = [NSNumber numberWithInteger:self.addMembersList.count];
    [self.removeMemberSubject sendNext:value];
    
}

- (void)addMember:(ZFZFriendModel *)member{
    [self.addMembersList addObject:member];
    [self reloadMembersList];
    [self moveToTranin];
}

- (UICollectionView *)memberListCollectionView{
    if (!_memberListCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = _memberSpace;
        layout.itemSize =CGSizeMake(50, 50);

        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
        
        UICollectionView * collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 60) collectionViewLayout:layout];
        
        collectionView.backgroundColor = [UIColor whiteColor];
        
        [collectionView registerClass:[ZFZAddMemberCollectionViewCell class] forCellWithReuseIdentifier:@"ZFZAddMemberCollectionViewCell"];
        
        collectionView.delegate=self;
        collectionView.dataSource=self;
        _memberListCollectionView = collectionView;
    }
    return _memberListCollectionView;
}

- (NSMutableArray<ZFZFriendModel *> *)addMembersList{
    if (!_addMembersList) {
        _addMembersList = [NSMutableArray array];
    }
    return _addMembersList;
}

- (RACSubject *)removeMemberSubject{
    if (!_removeMemberSubject) {
        _removeMemberSubject = [RACSubject subject];
    }
    return _removeMemberSubject;
}

@end
