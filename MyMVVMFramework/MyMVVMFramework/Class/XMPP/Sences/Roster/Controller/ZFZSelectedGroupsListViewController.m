//
//  ZFZSelectedGroupsListViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/28.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZSelectedGroupsListViewController.h"

@interface ZFZSelectedGroupsListViewController ()
@property (nonatomic, strong) UIBarButtonItem *composeBont;
@property (nonatomic, strong) UIView * addHeadView;
@end

@implementation ZFZSelectedGroupsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setup{
    [super setup];
    self.tableview.tableHeaderView = [self addHeadView];
}

//添加编辑/查看切换右按钮
- (void)addrightButton{
    _composeBont    = [[UIBarButtonItem alloc]initWithTitle:@"新建群组" style:UIBarButtonItemStyleDone target:self action:nil];
    _composeBont.tintColor           =        [UIColor blackColor];
    
    [self.navigationItem setRightBarButtonItem:_composeBont];
    
}
- (UIView *)addHeadView {
    if(_addHeadView == nil) {
        _addHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        _addHeadView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 32, 32)];
        imageView.image = [UIImage imageNamed:@"add.png"];
        [_addHeadView addSubview:imageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(52, 0, 100, 60)];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = @"添加分组";
        [_addHeadView addSubview:label];
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60 - 0.5, ScreenWidth, 0.5)];
        view1.backgroundColor = HexRGB(0xC8C7CC);
        [_addHeadView addSubview:view1];
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        addBtn.frame = CGRectMake(0, 0, ScreenWidth, 60);
        [addBtn addTarget:self action:@selector(addGroupAlert) forControlEvents:UIControlEventTouchUpInside];
        [_addHeadView addSubview:addBtn];
        [self.tableview.tableHeaderView addSubview:_addHeadView];
    }
    return _addHeadView;
}

/** 弹出框 */
- (void)addGroupAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加分组" message:@"请输入新的分组名称" preferredStyle:UIAlertControllerStyleAlert];
    //添加有文本输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入分组名";
        //设置文本清空按钮
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 读取文本框的值显示出来
        UITextField *addGroupTF = alert.textFields.firstObject;
        NSLog(@"新添加的分组名：%@", addGroupTF.text);
        // 发送添加请求
        [self.groupsListArry addObject:addGroupTF.text];
        [self.tableview reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.groupsListArry.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZFZGroupListArryCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZFZGroupListArryCell"];
    }
    [cell.textLabel setText:self.groupsListArry[indexPath.row]];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.groupNameSubject sendNext:self.groupsListArry[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (RACSubject *)groupNameSubject{
    if (!_groupNameSubject) {
        _groupNameSubject = [[RACSubject alloc]init];
    }
    return _groupNameSubject;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
