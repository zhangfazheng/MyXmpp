//
//  ZFZMessageCell.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/23.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseCell.h"
#import "ZFZMessageFrame.h"

@protocol ZFZMessageCellReadeStatusDelegate <NSObject>
- (void)searchReadeStatus:(NSArray *)readerMemberArray;
@end

@interface ZFZMessageCell : BaseCell
@property (nonatomic,strong) ZFZMessageFrame *messageFrame;
@property (nonatomic,weak) id<ZFZMessageCellReadeStatusDelegate> readeStatusDelegate;
@end

