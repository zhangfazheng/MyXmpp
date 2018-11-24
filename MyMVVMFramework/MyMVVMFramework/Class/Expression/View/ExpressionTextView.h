//
//  ExpressionTextView.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/22.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpressionTextView : UITextView
@property (nonatomic,copy)  NSString *emoticon;
@property (nonatomic,strong) NSMutableArray <NSString *>*emoticonArray;
//删除表情
- (void)deleteEmoticon;

@end
