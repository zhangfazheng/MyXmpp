//
//  UITextField+Icon.m
//  OperationEquipment
//
//  Created by 张发政 on 2017/2/16.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "UITextField+Icon.h"

@implementation UITextField (Icon)
#pragma mark 为UITextFiled的左边添加图片
- (void)uitextFieldWithIconName:(NSString *)iconName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.frame = CGRectMake(0, 0, 40, 44);
    self.leftView = imageView;
    
    // 设置左边的view永远显示
    self.leftViewMode = UITextFieldViewModeAlways;
    
    // 内容垂直居中
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // 设置字体
    //textField.font = [UIFont systemFontOfSize:14];
}

@end
