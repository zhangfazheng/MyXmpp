//
//  EmoticonCell.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/20.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseCollectionCell.h"
#import "EmoticonModel.h"

@interface EmoticonCell : BaseCollectionCell
@property (nonatomic, strong) EmoticonModel *emoticon;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, strong) UIImageView *imageView;
@end
