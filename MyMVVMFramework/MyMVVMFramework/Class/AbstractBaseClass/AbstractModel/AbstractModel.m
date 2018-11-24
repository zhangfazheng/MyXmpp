//
//  AbstractModel.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/16.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "AbstractModel.h"
#import <YYKit/YYKit.h>


@implementation AbstractModel
// 直接添加以下代码即可自动完成
- (void)encodeWithCoder:(NSCoder *)aCoder {
    //[self yy_modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    //self = [super init];
    //return [self yy_modelInitWithCoder:aDecoder];
    return nil;
}
- (id)copyWithZone:(NSZone *)zone {
    //return [self yy_modelCopy];
    return nil;
}
- (NSUInteger)hash {
    //return [self yy_modelHash];
    return 0;
}
- (BOOL)isEqual:(id)object {
    ////return [self yy_modelIsEqual:object];
    return NO;
}
- (NSString *)description {
    //return [self yy_modelDescription];
    return nil;
}
@end
