//
//  EmoticonGroup.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/20.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "EmoticonGroup.h"

@implementation EmoticonGroup
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupID" : @"id",
             @"nameCN" : @"group_name_cn",
             @"nameEN" : @"group_name_en",
             @"nameTW" : @"group_name_tw",
             @"displayOnly" : @"display_only",
             @"groupType" : @"group_type"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"emoticons" : [EmoticonModel class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [_emoticons enumerateObjectsUsingBlock:^(EmoticonModel *emoticon, NSUInteger idx, BOOL *stop) {
        emoticon.group = self;
    }];
    return YES;
}
@end
