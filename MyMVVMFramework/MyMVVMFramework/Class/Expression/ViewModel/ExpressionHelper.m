//
//  ExpressionHelper.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/20.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ExpressionHelper.h"
#import "NSString+Scale.h"
#import "NSBundle+Path.h"
#import "EmotionTextAttachment.h"



#define checkStr @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"

static CGSize                    _emotionSize;
static UIFont                    *_font;
static UIColor                   *_fontColor;
static CGSize                   _maxsize;
static NSArray                   *_matches;
static NSString                  *_string;
//static NSDictionary              *_emojiImages;
static NSMutableArray            *_imageDataArray;
static NSMutableAttributedString *_attStr;
static NSMutableAttributedString *_resultStr;

@implementation ExpressionHelper
+ (NSBundle *)emoticonBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ExpressionKeyboard" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    });
    return bundle;
}

//toolBar资源
+ (NSBundle *)toolBarBundle{
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[[self emoticonBundle].bundlePath stringByAppendingPathComponent:@"toolBar"]];
    });
    return bundle;
}

//"+"资源
+ (NSBundle *)extraBundle{
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[[self emoticonBundle].bundlePath stringByAppendingPathComponent:@"extra"]];
    });
    return bundle;
}

+ (YYMemoryCache *)imageCache {
    static YYMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YYMemoryCache new];
        cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        cache.name = @"WeiboImageCache";
    });
    return cache;
}

+ (UIImage *)imageNamed:(NSString *)name {
    if (!name) return nil;
    UIImage *image = [[self imageCache] objectForKey:name];
    if (image) return image;
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    
    NSString *path = [[self toolBarBundle] pathForScaledResource:name ofType:ext];
    if (!path){
        path = [[self extraBundle] pathForScaledResource:name ofType:ext];
    }
    if (!path) {
        return nil;
    }
    
    image = [UIImage imageWithContentsOfFile:path];
    image = [image imageByDecoded];
    if (!image) return nil;
    [[self imageCache] setObject:image forKey:name];
    return image;
}

+ (UIImage *)imageWithPath:(NSString *)path {
    if (!path) return nil;
    UIImage *image = [[self imageCache] objectForKey:path];
    if (image) return image;
    if (path.pathScale == 1) {
        // 查找 @2x @3x 的图片
        NSArray *scales = [NSBundle preferredScales];
        for (NSNumber *scale in scales) {
            image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathScale:scale.floatValue]];
            if (image) break;
        }
    } else {
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (image) {
        image = [image imageByDecoded];
        [[self imageCache] setObject:image forKey:path];
    }
    return image;
}


+ (NSArray <ExtraModel*>*)extraModels{
    static NSMutableArray *extras;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *plistPath = [[self extraBundle].bundlePath stringByAppendingPathComponent:@"info.plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSArray *more = dict[@"more"];
        NSArray *ret  = [NSArray modelArrayWithClass:[ExtraModel class] json:more];
        extras = [NSMutableArray arrayWithArray:ret];
        
    });
    return extras;
}

+ (NSArray<EmoticonGroup *> *)emoticonGroups {
    static NSMutableArray<EmoticonGroup *> *groups;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"ExpressionKeyboard" ofType:@"bundle"];
        NSString *emoticonPlistPath = [emoticonBundlePath stringByAppendingPathComponent:@"emoticons.plist"];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:emoticonPlistPath];
        NSArray *packages = plist[@"packages"];
        groups = (NSMutableArray *)[NSArray modelArrayWithClass:[EmoticonGroup class] json:packages];
        
        NSMutableDictionary *groupDic = [NSMutableDictionary new];
        for (int i = 0, max = (int)groups.count; i < max; i++) {
            EmoticonGroup *group = groups[i];
            if (group.groupID.length == 0) {
                [groups removeObjectAtIndex:i];
                i--;
                max--;
                continue;
            }
            NSString *path = [emoticonBundlePath stringByAppendingPathComponent:group.groupID];
            NSString *infoPlistPath = [path stringByAppendingPathComponent:@"info.plist"];
            NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:infoPlistPath];
            [group modelSetWithDictionary:info];
            if (group.emoticons.count == 0) {
                i--;
                max--;
                continue;
            }
            groupDic[group.groupID] = group;
        }
        
        NSArray<NSString *> *additionals = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[emoticonBundlePath stringByAppendingPathComponent:@"additional"] error:nil];
        for (NSString *path in additionals) {
            EmoticonGroup *group = groupDic[path];
            if (!group) continue;
            NSString *infoJSONPath = [[[emoticonBundlePath stringByAppendingPathComponent:@"additional"] stringByAppendingPathComponent:path] stringByAppendingPathComponent:@"info.json"];
            NSData *infoJSON = [NSData dataWithContentsOfFile:infoJSONPath];
            EmoticonGroup *addGroup = [EmoticonGroup modelWithJSON:infoJSON];
            if (addGroup.emoticons.count) {
                for (EmoticonModel *emoticon in addGroup.emoticons) {
                    emoticon.group = group;
                }
                [((NSMutableArray *)group.emoticons) insertObjects:addGroup.emoticons atIndex:0];
            }
        }
    });
    return groups;
}

+ (NSRegularExpression *)regexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSDictionary *)emoticonDic {
    static NSMutableDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
        dic = [self _emoticonDicFromPath:emoticonBundlePath];
    });
    return dic;
}

+ (NSMutableDictionary *)_emoticonDicFromPath:(NSString *)path {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    EmoticonGroup *group = nil;
    NSString *jsonPath = [path stringByAppendingPathComponent:@"info.json"];
    NSData *json = [NSData dataWithContentsOfFile:jsonPath];
    if (json.length) {
        group = [EmoticonGroup modelWithJSON:json];
    }
    if (!group) {
        NSString *plistPath = [path stringByAppendingPathComponent:@"info.plist"];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        if (plist.count) {
            group = [EmoticonGroup modelWithJSON:plist];
        }
    }
    for (EmoticonModel *emoticon in group.emoticons) {
        if (emoticon.png.length == 0) continue;
        NSString *pngPath = [path stringByAppendingPathComponent:emoticon.png];
        if (emoticon.chs) dic[emoticon.chs] = pngPath;
        if (emoticon.cht) dic[emoticon.cht] = pngPath;
    }
    
    NSArray *folders = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *folder in folders) {
        if (folder.length == 0) continue;
        NSDictionary *subDic = [self _emoticonDicFromPath:[path stringByAppendingPathComponent:folder]];
        if (subDic) {
            [dic addEntriesFromDictionary:subDic];
        }
    }
    return dic;
}

#pragma mark- 文字转图片
+ (NSMutableAttributedString *)changeStrWithStr:(NSString *)string Font:(UIFont *)font maxSize:(CGSize)maxSize TextColor:(UIColor *)textColor{
    if (!isEmptyString(string)) {
        _font       = font;
        _string     = string;
        _maxsize    = maxSize;
        _fontColor  = textColor;
        [self initProperty];
        [self executeMatch];
        [self setImageDataArray];
        [self setResultStrUseReplace];
    }
    return _resultStr;
    
}

+ (void)initProperty {
    
    // 读取并加载对照表
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"LiuqsEmoji" ofType:@"plist"];
//
//    _emojiImages = [NSDictionary dictionaryWithContentsOfFile:path];
    
    //设置文本参数（行间距，文本颜色，字体大小）
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    //[paragraphStyle setLineSpacing:4.0f];
    
    //设置段落样式
    paragraphStyle.alignment = NSTextAlignmentLeft;//（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName,_fontColor,NSForegroundColorAttributeName,nil];
    
    //计算表情的大小
    _emotionSize = [@"/" boundingRectWithSize:_maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    //保存当前富文本
    _attStr = [[NSMutableAttributedString alloc]initWithString:_string attributes:dict];
    
}


+ (void)executeMatch {
    
    //比对结果（正则验证的过程）
    NSString *regexString = checkStr;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSRange totalRange = NSMakeRange(0, [_string length]);
    //保存验证结果，结果是一个数组，存放的是NSTextCheckingResult类
    _matches = [regex matchesInString:_string options:0 range:totalRange];
}

+ (void)setImageDataArray {
    
    NSMutableArray *imageDataArray = [NSMutableArray array];
    //遍历_matches
    for (int i = (int)_matches.count - 1; i >= 0; i --) {
        
        NSMutableDictionary *record = [NSMutableDictionary dictionary];
        //创建附件
        EmotionTextAttachment *attachMent = [[EmotionTextAttachment alloc]init];
        //        设置尺寸
        attachMent.emojiSize = CGSizeMake(_emotionSize.height, _emotionSize.height);
        //        取到当前的表情
        NSTextCheckingResult *match = [_matches objectAtIndex:i];
        //        取出表情字符串在文本中的位置
        NSRange matchRange = [match range];
        
        NSString *tagString = [_string substringWithRange:matchRange];
        //        拿出表情对应的图片名字
        EmoticonModel *emoticonImage = [self searchEmoticon:tagString];
        
        //NSString *imageName = [_emojiImages objectForKey:tagString];
        //        判断是否有这个图，有就继续没有就跳出当次循环
        if (emoticonImage == nil) continue;
        //这里有个问题，需要先判断是否有图片，没有图片的话应该不操作，因为现在换用html处理，先不改！
        // 不用管这个判断，操作就是要取出图片，给附件设置图片
        NSString *pngPath = [[ExpressionHelper emoticonBundle] pathForScaledResource:emoticonImage.png ofType:nil inDirectory:emoticonImage.group.groupID];
        if (emoticonImage.type == EmotionTypeEmojiGif) {
            
            //如是是gif图片
            if (!pngPath) {
                NSString *addBundlePath = [[ExpressionHelper emoticonBundle].bundlePath stringByAppendingPathComponent:@"additional"];
                NSBundle *addBundle = [NSBundle bundleWithPath:addBundlePath];
                
                pngPath = [addBundle pathForScaledResource:emoticonImage.gif ofType:nil inDirectory:emoticonImage.group.groupID];
            }
            //根据路径找图片
            NSData *gifData = [NSData dataWithContentsOfFile:pngPath];
            
            attachMent.contents = gifData;
            
            attachMent.fileType = @"gif";
        }else{
            if (!pngPath) {
                NSString *addBundlePath = [[ExpressionHelper emoticonBundle].bundlePath stringByAppendingPathComponent:@"additional"];
                NSBundle *addBundle = [NSBundle bundleWithPath:addBundlePath];
                
                pngPath = [addBundle pathForScaledResource:emoticonImage.png ofType:nil inDirectory:emoticonImage.group.groupID];
            }
            
            if (pngPath) {
                attachMent.image = [self imageWithPath:pngPath];
            }
        }
        //        然后把表情富文本和对应的位置存到字典中，再把字典存到数组中，这样就得到一个字典数组。
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attachMent];
        
        [record setObject:[NSValue valueWithRange:matchRange] forKey:@"range"];
        
        [record setObject:imageStr forKey:@"image"];
        
        [imageDataArray addObject:record];
        }
    //保存字典数组
    _imageDataArray = imageDataArray;
        
}


//声明一个返回一个表情对象的一个方法
+ (EmoticonModel *)searchEmoticon:(NSString *)emoticonString{
    //先遍历表情
    for (EmoticonGroup *group in [self emoticonGroups]) {
        for (EmoticonModel *emotion in group.emoticons) {
            if ([emotion.chs isEqualToString:emoticonString]) {
                return emotion;
            }
        }
    }
    return nil;
}


//遍历上一步的字典数组，执行替换并返回一个富文本
+ (void)setResultStrUseReplace{
    
    NSMutableAttributedString *result = _attStr;
    
    for (int i = 0; i < _imageDataArray.count ; i ++) {
        
        NSRange range = [_imageDataArray[i][@"range"] rangeValue];
        
        NSDictionary *imageDic = [_imageDataArray objectAtIndex:i];
        
        NSMutableAttributedString *imageStr = [imageDic objectForKey:@"image"];
        
        [result replaceCharactersInRange:range withAttributedString:imageStr];
    }
    _resultStr = result;
}


#pragma mark - 以下是我用来优化性能方案的代码，暂时不用，只是一个思路现在还有一些问题，不能完美实现！（用网页加载gif，解决大量gif时列表滑动卡顿的问题，目前还无法完美的计算文本内容在网页中所占的尺寸）

+ (NSString *)changeTextToHtmlStrWithText:(NSString *)text {
    
    _string = text;
    // 读取并加载对照表
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"LiuqsEmoji" ofType:@"plist"];
//
//    _emojiImages = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return [self getHtmlStrimg];
}

+ (NSString *)getHtmlStrimg {
    
    [self executeMatch];
    
    __block NSMutableString *htmlStr = [NSMutableString stringWithString:_string];
    
    __weak __typeof__(self) weakSelf = self;
    
    for (NSUInteger i = _matches.count; i > 0; i --) {
        
        NSTextCheckingResult *match = [_matches objectAtIndex:i - 1];
        
        NSRange currentRange = [match range];
        
        NSString *tagString = [_string substringWithRange:currentRange];
        
        EmoticonModel *imageName = [self searchEmoticon:tagString];
        
        NSString *imageStr = [weakSelf createEmotionShortStrWithImageName:imageName.png];
        
        [htmlStr replaceCharactersInRange:currentRange withString:imageStr];
    }
    
    return htmlStr;
}

+ (NSString *)createEmotionShortStrWithImageName:(NSString *)imageName {
    
    NSString *cheakStr = [imageName substringWithRange:NSMakeRange(1, 2)];
    
    NSString *type;
    
    if ([cheakStr intValue] > 60) {type = @"gif";}else{type = @"png";}
    
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:type];
    
    NSURL *imageUrl = [NSURL fileURLWithPath:path];
    
    NSString *result = [NSString stringWithFormat:@"<img src='%@' height='%f' width='%f'>",imageUrl.absoluteString,_emotionSize.height,_emotionSize.height];
    
    return result;
}

@end
