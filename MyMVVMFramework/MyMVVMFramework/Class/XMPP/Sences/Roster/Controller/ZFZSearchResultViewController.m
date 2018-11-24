//
//  ZFZSearchResultViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/6.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZSearchResultViewController.h"
#import "ZFZFriendModel.h"
#import <ChameleonFramework/Chameleon.h>
#import "UIImage+RoundImage.h"

@interface ZFZSearchResultViewController ()

@end

@implementation ZFZSearchResultViewController
static NSString *const cellID = @"RESULT_CELL_ID";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setup{
    [super setup];
    self.view.backgroundColor                 = [UIColor clearColor];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filterDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSString *name = self.filterDataArray[indexPath.row].name;
    cell.textLabel.text = name;
    NSString *iconText = [name substringWithRange:NSMakeRange((name.length-2), 2)];
    UIImage *image = [UIImage drawImageRadius:RadiusMake(25, 25, 25, 25) size:CGSizeMake(50, 50) backgroundColor:RandomFlatColor text:iconText];
    [cell.imageView setImage:image];
    //[cell.imageView setImage:[UIImage imageNamed:@"army6"]];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFilterDataArray:(NSArray<ZFZFriendModel *> *)filterDataArray{
    _filterDataArray = filterDataArray;
    [self.tableview reloadData];
}

@end
