//
//  ExpressionHelper.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/20.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"
#import "EmoticonGroup.h"
#import "ExtraModel.h"

@interface ExpressionHelper : NSObject
/// 表情资源 bundle
+ (NSBundle *)emoticonBundle;

/// 表情 Array<YHEmoticonGroup> (实际应该做成动态更新的)
+ (NSArray<EmoticonGroup *> *)emoticonGroups;

/// 图片 cache
+ (YYMemoryCache *)imageCache;

/// 从 toolBarBundle / extraBundle 里获取图片 (有缓存)
+ (UIImage *)imageNamed:(NSString *)name;

/// 从path创建图片 (有缓存)
+ (UIImage *)imageWithPath:(NSString *)path;

/// 获取“+” models
+ (NSArray <ExtraModel*>*)extraModels;

+ (NSRegularExpression *)regexEmoticon;

+ (NSDictionary *)emoticonDic;

///转码方法，会返回一个富文本！需要传入文本，字体，或者字体颜色，不给默认为黑色！可以根据需求改这个方法！
+ (NSMutableAttributedString *)changeStrWithStr:(NSString *)string Font:(UIFont *)font maxSize:(CGSize)maxSize TextColor:(UIColor *)textColor;

///这个是研究新方式加载，目前还有问题！
+ (NSString *)changeTextToHtmlStrWithText:(NSString *)text;
@end
