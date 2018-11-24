//
//  LaunchViewController.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/2.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewController.h"

@interface LaunchViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *maskView;
@property (weak, nonatomic) IBOutlet UILabel *t1;
@property (weak, nonatomic) IBOutlet UILabel *t2;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLable;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutY;
@end
