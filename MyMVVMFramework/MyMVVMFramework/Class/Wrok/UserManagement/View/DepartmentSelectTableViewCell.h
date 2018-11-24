//
//  DepartmentSelectTableViewCell.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/12/18.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseCell.h"

@interface DepartmentSelectTableViewCell : BaseCell
@property (strong, nonatomic) RACSignal *openDataSignal;
@end
