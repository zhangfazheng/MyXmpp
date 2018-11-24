//
//  EmoticonModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseModel.h"

@interface EmoticonModel : BaseModel
//系统自带表情16进制编码
@property (copy,nonatomic) NSString *code;
@property (copy,nonatomic) NSString *emoji;
///图片的名字
@property (copy,nonatomic) NSString *png;
// 发送给服务器的表情文字
@property (copy,nonatomic) NSString *chs;
// 添加一个路径的属性 -- 注意: 这个需要在一个合适的时机赋值
@property (copy,nonatomic) NSString *path;
@end
