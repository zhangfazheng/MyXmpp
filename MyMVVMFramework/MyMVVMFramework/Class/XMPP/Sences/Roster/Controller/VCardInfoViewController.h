//
//  VCardInfoViewController.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UserVCardModel.h"

@interface VCardInfoViewController : BaseTableViewController
@property(nonatomic,strong) UserVCardModel *userInfo;
@end
