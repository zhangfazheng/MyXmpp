//
//  EmoticonModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "EmoticonModel.h"




#define MAKE_Q(x) @#x
#define MAKE_EM(x,y) MAKE_Q(x##y)
#define MAKE_EMOJI(x) MAKE_EM(\U000,x)
#define EMOJI_METHOD(x,y) + (NSString *)x { return MAKE_EMOJI(y); }
#define EMOJI_HMETHOD(x) + (NSString *)x;
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

@implementation EmoticonModel

+ (instancetype)initWithInfoDic:(NSDictionary *)infoDic{
    return  [[EmoticonModel alloc]initBaseModelDic:infoDic];
}

- (void)setCode:(NSString *)code{
    _code = code;
    // 1. 创建一个扫描
    NSScanner *scanner      = [NSScanner scannerWithString:code];
    
     // 2. 定义一个UInt32类型的变量
    UnicodeScalarValue results1           = 0;
    
    // 3.调用 scanHexInt
    [scanner scanHexInt:&results1];
    
    // 5. 把unicode变成 Character
    NSString *character = [self emojiWithCode:results1];
    
    // 6. 把 字符转换成字符串
    self.emoji = [NSString stringWithFormat:@"%@",character];
    
}

- (NSString *)emojiWithCode:(int)code {
    int sym = EMOJI_CODE_TO_SYMBOL(code);
    return [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
}

@end
