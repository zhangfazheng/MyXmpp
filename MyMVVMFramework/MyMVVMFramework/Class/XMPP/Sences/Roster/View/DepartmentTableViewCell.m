//
//  DepartmentTableViewCell.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/25.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "DepartmentTableViewCell.h"
#import "DepartmentModel.h"

@implementation DepartmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadContent{
    if (self.data) {
        DepartmentModel *dept = (DepartmentModel *)self.data;
        NSString *deptTitle;
        if (dept.childCount>0) {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            deptTitle = [NSString stringWithFormat:@"%@(%zd)",dept.deptName,dept.childCount];
        }else{
            self.accessoryType = UITableViewCellAccessoryNone;
            deptTitle = dept.deptName;
        }
        [self.textLabel setText:deptTitle];
    }
}

@end
