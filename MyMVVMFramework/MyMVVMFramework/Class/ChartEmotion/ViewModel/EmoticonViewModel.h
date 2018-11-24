//
//  EmoticonViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"
#import "EmoticonButton.h"

@interface EmoticonViewModel : BaseViewModel
@property (nonatomic,strong) NSArray *emoticons;
@property (strong,nonatomic) RACCommand *deleteEmoticonCommand;
@property (strong,nonatomic) RACCommand *emoticonCommand;
@property (strong,nonatomic) RACCommand *emoticonTabCommand;
@property (strong, nonatomic) RACCommand *itemsDataCommand;

+ (NSArray<EmoticonModel *> *)getEmoticonWithPackage:(NSString*)package;
+ (NSArray<NSArray *>*)pageEmoticon:(NSArray *) emoticons;



@end
