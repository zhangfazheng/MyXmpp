//
//  ChatViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ChatView1Controller.h"
#import "ChtaDetailViewController.h"

@interface ChatView1Controller ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;

@end

@implementation ChatView1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setup{
    [self creatTableview];
}

-(void)creatTableview
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.imageView.image = [UIImage imageNamed:@"headerImage"];
    cell.textLabel.text = @"点击开始聊天";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChtaDetailViewController *chatVC = [[ChtaDetailViewController alloc]init];
    [self.navigationController pushViewController:chatVC animated:YES];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

@end
