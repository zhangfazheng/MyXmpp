//
//  ZFZChatTableViewController.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/8/15.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ZFZXMPPManager.h"



@class ZFZChatViewModel;
@interface ZFZChatTableViewController : BaseTableViewController
@property (nonatomic, strong) XMPPJID * userJid;


//+ (instancetype)sharedChatTableViewControllerWithServices:(id)services params:(NSDictionary *)patern;
@end
