//
//  ExpressionTextView.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/22.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ExpressionTextView.h"
#import "ExpressionHelper.h"

@implementation ExpressionTextView

- (NSMutableArray<NSString *> *)emoticonArray{
    if (!_emoticonArray) {
        _emoticonArray = [NSMutableArray new];
    }
    return _emoticonArray;
}


- (void)setEmoticon:(NSString *)emoticon{
    _emoticon = emoticon;
    
    NSMutableString *maStr = [[NSMutableString alloc] initWithString:self.text];
    if (_emoticon) {
        [maStr insertString:_emoticon atIndex:self.selectedRange.location];
        [self.emoticonArray addObject:_emoticon];
    }
    self.text = maStr;
}


- (void)deleteEmoticon{
    
    NSRange range = self.selectedRange;
    NSInteger location = (NSInteger)range.location;
    if (location == 0) {
        if (range.length) {
            self.text = @"";
        }
        return ;
    }
    //判断是否表情
    NSString *subString = [self.text substringToIndex:location];
    if ([subString hasSuffix:@"]"]) {
        
        //查询是否存在表情
        __block NSString *emoticon = nil;
        __block NSRange  emoticonRange;
        [[ExpressionHelper regexEmoticon] enumerateMatchesInString:subString options:kNilOptions range:NSMakeRange(0, subString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            emoticonRange = result.range;
            emoticon = [subString substringWithRange:result.range];
            
            
            
        }];
        NSLog(@"要删除表情是：\n%@",emoticon);
        if (emoticon) {
            //是表情符号,移除
            if ([self.emoticonArray containsObject:emoticon]) {
                
                self.text = [self.text stringByReplacingCharactersInRange:emoticonRange withString:@" "];
                NSLog(@"删除后字符串为:\n%@",self.text);
                
                range.location -= emoticonRange.length;
                range.length = 1;
                self.selectedRange = range;
                
            }
        }else{
            self.text = [self.text stringByReplacingCharactersInRange:range withString:@""];
            range.location -= 1;
            range.length = 1;
            self.selectedRange = range;
        }
        
    }else{
        self.text = [self.text stringByReplacingCharactersInRange:range withString:@""];
        range.location -= 1;
        range.length = 1;
        self.selectedRange = range;
    }
    
}



@end
