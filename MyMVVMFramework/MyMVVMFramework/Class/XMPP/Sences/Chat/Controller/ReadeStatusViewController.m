//
//  ReadeStatusViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/20.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ReadeStatusViewController.h"
#import "ZFZRoomManager.h"
#import "UIView+Frame.h"
#import "UIImage+RoundImage.h"
#import "LoginUserModel.h"

@interface ReadeStatusViewController ()
@property (nonatomic,strong) UISegmentedControl *readSwitch;
@property (nonatomic,strong) NSMutableArray *readArry;
@property (nonatomic,strong) NSMutableArray *noReadArry;
@property (nonatomic,strong) NSMutableArray<ZFZMemberModel *> *curReadArry;

@end

@implementation ReadeStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setup{
    [super setup];
    [self.view addSubview:self.readSwitch];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"readerStatusCell"];
    //配置数据
    NSArray<ZFZMemberModel*> *roomMeberArry = _curRoom.roomMembers;
    
    //遍历数组参，对成员进行分类
    for (ZFZMemberModel* member in roomMeberArry) {
        NSInteger i;
        NSString *myNiackName = [LoginUserModel getUserModelInstance].realName;
        for (i=0; i < self.readerStatusArray.count; i++) {
            if ([member.jid isEqualToString:self.readerStatusArray[i]]) {
                [self.readArry addObject:member];
                break;
            }else if ([member.name isEqualToString:myNiackName]){
                break;
            }
        }
        if (i>=self.readerStatusArray.count){
            [self.noReadArry addObject:member];
        }
    }
    
    self.curReadArry = _noReadArry;
    
     //重新设置tableView的高度
    self.tableview.top = self.tableview.top +56;
    self.tableview.height = self.tableview.height - 56;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.curReadArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"readerStatusCell"];
    NSString *name = self.curReadArry[indexPath.row].name;
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

- (void)readSwitchSelected:(id)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            self.curReadArry = _noReadArry;
            [self.tableview reloadData];
            break;
        case 1:
            self.curReadArry = _readArry;
            [self.tableview reloadData];
            break;

            
        default:
            NSLog(@"3");
            break;
    }
}

- (UISegmentedControl *)readSwitch{
    if (!_readSwitch) {
        //先创建一个数组用于设置标题
        NSArray *arr = [[NSArray alloc]initWithObjects:@"未读",@"已读", nil];
        
        //初始化UISegmentedControl
        //在没有设置[segment setApportionsSegmentWidthsByContent:YES]时，每个的宽度按segment的宽度平分
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:arr];
        
        //设置frame
        segment.frame = CGRectMake(self.view.frame.size.width/4, 8, self.view.frame.size.width/2, 40);
        [segment addTarget:self action:@selector(readSwitchSelected:) forControlEvents:UIControlEventValueChanged];
        _readSwitch = segment;
    }
    return _readSwitch;
}

#pragma mark- 懒加载
- (NSMutableArray *)readArry{
    if (!_readArry) {
        _readArry = [NSMutableArray array];
    }
    return _readArry;
}

- (NSMutableArray *)noReadArry{
    if (!_noReadArry) {
        _noReadArry = [NSMutableArray array];
    }
    return _noReadArry;
}

@end
