//
//  BaseCollectionCell.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseCollectionCell.h"

@implementation BaseCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupCell];
        
        [self buildSubview];
    }
    
    return self;
}

- (void)setupCell {
    
}

- (void)buildSubview {
    
}

- (void)loadContent {
    
}

- (void)selectedEvent {
    
}

+ (CellDataAdapter *)dataAdapterWithCellReuseIdentifier:(NSString *)reuseIdentifier data:(id)data type:(NSInteger)type {
    
    NSString *tmpReuseIdentifier = reuseIdentifier.length <= 0 ? NSStringFromClass([self class]) : reuseIdentifier;
    return [CellDataAdapter collectionCellDataAdapterWithCellReuseIdentifier:tmpReuseIdentifier data:data cellType:type];
}

+ (CellDataAdapter *)dataAdapterWithData:(id)data type:(NSInteger)type {
    
    return [CellDataAdapter collectionCellDataAdapterWithCellReuseIdentifier:nil data:data cellType:type];
}
@end
