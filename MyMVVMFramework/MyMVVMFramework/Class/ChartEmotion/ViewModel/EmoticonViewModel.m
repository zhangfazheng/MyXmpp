//
//  EmoticonViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "EmoticonViewModel.h"

// 管理我们的表情包
// static 类可以直接访问; 编译之后就分配好了地址空间; 常驻内存,对于一下经常使用的东西来说,性能要快一点

/// 定义了一个最近表情包的数组
static NSMutableArray<EmoticonModel *> *recentEmoticon;

/// 定义一个默认表情包数组
static NSArray<EmoticonModel *> * defaultEmoticon;

/// 定义一个emoji表情包数组
static NSArray<EmoticonModel *> * emojiEmoticon;

/// 定义一个浪小花表情包数组
static NSArray<EmoticonModel *> * lxhEmoticon;

@implementation EmoticonViewModel

- (void)initialize{
    [super initialize];
    
    @weakify(self)
    self.emoticonCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(EmoticonButton *input) {
        EmoticonModel *emoticon = input.emoticon;
        
        NSLog(@"%@",emoticon.emoji);

//        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            [subscriber sendNext:emoticon];
//            [subscriber sendCompleted];
//            
//            return nil;
//        }];
        return [RACSignal empty];
        
    }];
    
//    [[[self.emoticonCommand executionSignals] switchToLatest]subscribeNext:^(EmoticonModel *emoticon) {
//        NSLog(@"%@",emoticon.emoji);
//    }];
    
    //初始化表情包
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recentEmoticon  = [NSMutableArray array];
        
        defaultEmoticon = [EmoticonViewModel getEmoticonWithPackage:@"com.sina.default"];
        
        emojiEmoticon   = [EmoticonViewModel getEmoticonWithPackage:@"com.apple.emoji"];
        
        lxhEmoticon     = [EmoticonViewModel getEmoticonWithPackage:@"com.sina.lxh"];
        
        
    });
    
    self.emoticons = [EmoticonViewModel getAllEmoticons];
    
    self.itemsDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self)
            //self.emoticons = [EmoticonViewModel getAllEmoticons];
            [subscriber sendNext:self.emoticons];
            [subscriber sendCompleted];
            
            return [RACDisposable disposableWithBlock:^{
                
            }];
            
        }];
        
    }];
    
}




//  创建一个读取表情的方法
+ (NSArray<EmoticonModel *> *)getEmoticonWithPackage:(NSString*)package{
    // 1. 先拿到Emoticons.Bundle
    // 2. 根据包名,来获取info.plist
    // 3. 获取info.plist 里的 emoticons数组
    // 4. 对数组进行遍历,来转换成模型
    
    
    // 1. 获取Emoticons.bundle
    NSString * path = [[NSBundle mainBundle]pathForResource:@"Emoticons.bundle" ofType:nil];
    // 2.  拼接包的路径
    NSString *packagePath = [path stringByAppendingPathComponent:package];
    // 2.1 拼接info.plist
    NSString *infoPath = [packagePath stringByAppendingPathComponent:@"info.plist"];
    // 2.2 读取plist
    NSDictionary *infoDict = [NSDictionary dictionaryWithContentsOfFile:infoPath];
    
    
    // 3. 获取info.plist 里的 emoticons数组
    //确定emoticons里边肯定有数组,所以 as!
    NSArray *emoticons = infoDict[@"emoticons"];

    // 4 对数组进行遍历,来转换成模型
    
    // 4.1 初始化一个数组
    NSMutableArray * temp = [NSMutableArray arrayWithCapacity:emoticons.count];
    
    for (NSDictionary *emoticon in emoticons) {
        EmoticonModel *emo = [EmoticonModel initWithInfoDic:emoticon];
        
        emo.path = packagePath;
        
        [temp addObject:emo];
    }
    
    return [temp copy];
}

// 创建一个方法,来对一维数组进行分页
+ (NSArray<NSArray *>*)pageEmoticon:(NSArray *) emoticons{
    // 分页的逻辑/步骤
    // 100 为例子 99 / 20 + 1
    
    // 1. 需要知道多少页
    NSInteger page = (emoticons.count +19) / 20 ;
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:page];
    // 2.  通过循环来切割数组
    
    
    for (int i = 0; i<page; i++) {
        NSInteger len = 20;
        
        NSInteger loc = i * len;
        
        // 判断
        if (len + loc > emoticons.count) {
            len = emoticons.count - loc;
        }
        
        NSArray *subArray = [emoticons subarrayWithRange:NSMakeRange(loc, len)];
        
        [temp addObject:subArray];
    }
    
    return [temp copy];
}

+ (NSArray *)getAllEmoticons{
    NSArray * array = @[[EmoticonViewModel pageEmoticon:recentEmoticon],[EmoticonViewModel pageEmoticon:defaultEmoticon],[EmoticonViewModel pageEmoticon:emojiEmoticon] ,[EmoticonViewModel pageEmoticon:lxhEmoticon]];
    
    return array;
}


- (NSArray *)emoticons{
    if (!_emoticons) {
        _emoticons = [EmoticonViewModel getAllEmoticons];
    }
    return _emoticons;
}

@end
