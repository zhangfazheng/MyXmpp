//
//  NSNumber+Add.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/20.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/**
 Provide a method to parse `NSString` for `NSNumber`.
 */
@interface NSNumber (Add)
/**
 Creates and returns an NSNumber object from a string.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  The string described an number.
 
 @return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (nullable NSNumber *)numberWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
