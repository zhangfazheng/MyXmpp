//
//  VCardInfoViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/11/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "VCardInfoViewController.h"
#import "UITableView+CellClass.h"
#import "VCardBaseInfoCell.h"
#import "VCardHeadInfoCell.h"
#import "ComposeButton.h"
#import "ZFZXMPPManager.h"
#import "CustomTabBarController.h"
#import "CustomNavigationController.h"
#import "ZFZChatViewModel.h"
#import "ZFZChatTableViewController.h"

@interface VCardInfoViewController ()
@property (nonatomic,strong) NSMutableArray <CellDataAdapter *> * items;
/*底部快捷按钮栏*/
@property (nonatomic,strong) UIView *bottomButtonsView;
@property (nonatomic,strong) ComposeButton *sendMessageButton;
@property (nonatomic,strong) ComposeButton *callButton;
@property (nonatomic,strong) ComposeButton *addRosterButton;
@property (nonatomic,strong) ComposeButton *sendPhoneMessageButton;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,assign) BOOL isMyRoster;
@end

@implementation VCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView{
    self.showSeparator = NO;
    [super loadView];
}

- (void)setup{
    [super setup];

    
    //设置好友名字
    _userName = self.userInfo.realName;
    XMPPRosterCoreDataStorage *storage = [ZFZXMPPManager sharedManager].xmppRosterCoreDataStorage;
    
    //判断是否已经是好友
    _isMyRoster = [storage userExistsWithJID:self.userInfo.jid xmppStream: [ZFZXMPPManager sharedManager].stream];
    
    if (isEmptyString(_userName) && _isMyRoster) {
        XMPPUserCoreDataStorageObject * user = [storage userForJID:self.userInfo.jid xmppStream:[ZFZXMPPManager sharedManager].stream managedObjectContext:storage.managedObjectContext];
        _userName = user.nickname;
    }else if (isEmptyString(_userName)){
        _userName = self.userInfo.jid.user;
    }
    
    [self.tableview registerCellsClass:@[cellClass(@"VCardBaseInfoCell", @"VCardBaseInfoCell"),cellClass(@"VCardHeadInfoCell", @"VCardHeadInfoCell")]];
    if (!isEmptyString(self.userInfo.realName)) {
        NSDictionary *vCardBaseInfoDic1     =@{@"titleName":@"姓名",@"titleValue":self.userInfo.realName};
        [self.items addObject:[VCardBaseInfoCell dataAdapterWithCellReuseIdentifier:nil data:vCardBaseInfoDic1 cellHeight:100 type:0]];
    }
    if (!isEmptyString(self.userInfo.mobile)) {
        NSDictionary *vCardBaseInfoDic2     =@{@"titleName":@"电话",@"titleValue":self.userInfo.mobile};
        [self.items addObject:[VCardBaseInfoCell dataAdapterWithCellReuseIdentifier:nil data:vCardBaseInfoDic2 cellHeight:100 type:0]];
    }
    if (!isEmptyString(self.userInfo.mail)) {
        NSDictionary *vCardBaseInfoDic3     =@{@"titleName":@"邮箱",@"titleValue":self.userInfo.mail};
        [self.items addObject:[VCardBaseInfoCell dataAdapterWithCellReuseIdentifier:nil data:vCardBaseInfoDic3 cellHeight:100 type:0]];
    }
    

    
    [self.view addSubview:self.bottomButtonsView];
    //设置底部工具栏渐变透明背景
    UIColor *colorOne = [UIColor colorWithWhite:1 alpha:0];
    UIColor *colorTwo = [UIColor colorWithWhite:1 alpha:1];
    UIColor *bckColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:_bottomButtonsView.frame andColors:@[colorOne,colorTwo]];
    [_bottomButtonsView setBackgroundColor:bckColor];
}

#pragma mark ----------UITabelViewDataSource----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return  self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        BaseCell *cell = [tableView dequeueAndLoadContentReusableCellFromAdapter:self.items[indexPath.row] indexPath:indexPath controller:self];
        return cell;
    }else{
        
        CellDataAdapter *adapter = [VCardHeadInfoCell dataAdapterWithCellReuseIdentifier:nil data:@{@"titleName":self.userName} cellHeight:100 type:0];
        BaseCell *cell = [tableView dequeueAndLoadContentReusableCellFromAdapter:adapter indexPath:indexPath controller:self];
        return cell;
    }
    
}

#pragma mark- 发送消息按钮点击事件
- (void)sendMessageButtonClickAction{
        [self.navigationController popToRootViewControllerAnimated:NO];
        CustomTabBarController *tabBarVC = (CustomTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        CustomNavigationController *vc =[tabBarVC.childViewControllers firstObject];
        [tabBarVC setSelectedIndex:0];

        //创建一个聊天控制器
        NSDictionary *patern = @{@"userJid":self.userInfo.jid};
        ZFZChatViewModel * viewModel = [[ZFZChatViewModel alloc]initWithServices:nil params:patern];
        viewModel.chatType = ZFZChatSignal;
        ZFZChatTableViewController *chatVc = [[ZFZChatTableViewController alloc]initWithViewModel:viewModel];

        chatVc.userJid = self.userInfo.jid;
        chatVc.title = self.userInfo.realName;
        [vc pushViewController:chatVc animated:YES];
}

#pragma mark- 打电话按钮点击事件
- (void)callButtonClickAction{
    
}

#pragma mark- 发送短信按钮点击事件
- (void)sendPhoneMessageButtonClickAction{
    
}

#pragma mark- 添加好友钮点击事件
- (void)addRosterButtonClickAction{
    
}

#pragma mark- 懒加载
- (NSMutableArray<CellDataAdapter *> *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (UIView *)bottomButtonsView{
    if (!_bottomButtonsView) {
        _bottomButtonsView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-NAVIGATION_BAR_HEIGHT-70, self.width, 70)];
        CGFloat magiacl = (self.width-45*4)/5;
        
        self.sendMessageButton.frame =  CGRectMake(magiacl, 0 , 45 , 66);
        [_bottomButtonsView addSubview:_sendMessageButton];
        
        self.callButton.frame = CGRectMake(CGRectGetMaxX(_sendMessageButton.frame) + magiacl, 0,45, 66);
        [_bottomButtonsView addSubview:_callButton];
        
        self.sendPhoneMessageButton.frame = CGRectMake(CGRectGetMaxX(_callButton.frame) + magiacl, 0,45, 66);
        [_bottomButtonsView addSubview:_sendPhoneMessageButton];
        
        self.addRosterButton.frame = CGRectMake(CGRectGetMaxX(_sendPhoneMessageButton.frame) + magiacl, 0, 45, 66);
        [_bottomButtonsView addSubview:_addRosterButton];
        
        //如果是本人不让其发消息给自己和添加自己为好友
        if ([self.userInfo.jid isEqualToJID:[[ZFZXMPPManager sharedManager].stream myJID] options:XMPPJIDCompareBare]) {
            _sendMessageButton.enabled = NO;
            _addRosterButton.enabled =NO;
        }else if (_isMyRoster) {
            //是否已经是好友,如果是不让其添加好友
            _addRosterButton.enabled = NO;
        }
        
    }
    return _bottomButtonsView;
}

- (ComposeButton *)sendMessageButton{
    if (!_sendMessageButton) {
        _sendMessageButton = [[ComposeButton alloc] init];
        [_sendMessageButton setTitle:@"发消息" forState:UIControlStateNormal];
        [_sendMessageButton setImage:[UIImage imageNamed:@"icon_me_luntan"] forState:UIControlStateNormal];
        
        [_sendMessageButton addTarget:self action:@selector(sendMessageButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendMessageButton;
}

- (ComposeButton *)callButton{
    if (!_callButton) {
        _callButton = [[ComposeButton alloc] init];
        [_callButton setTitle:@"打电话" forState:UIControlStateNormal];
        [_callButton setImage:[UIImage imageNamed:@"icon_set_kfrx"] forState:UIControlStateNormal];
        
        [_sendMessageButton addTarget:self action:@selector(callButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callButton;
}

- (ComposeButton *)sendPhoneMessageButton{
    if (!_sendPhoneMessageButton) {
        _sendPhoneMessageButton = [[ComposeButton alloc] init];
        [_sendPhoneMessageButton setTitle:@"发短信" forState:UIControlStateNormal];
        [_sendPhoneMessageButton setImage:[UIImage imageNamed:@"icon_invate_phoneleft"] forState:UIControlStateNormal];
        
        [_sendMessageButton addTarget:self action:@selector(sendPhoneMessageButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendPhoneMessageButton;
}

- (ComposeButton *)addRosterButton{
    if (!_addRosterButton) {
        _addRosterButton = [[ComposeButton alloc] init];
        [_addRosterButton setTitle:@"加为好友" forState:UIControlStateNormal];
        [_addRosterButton setImage:[UIImage imageNamed:@"icon_company_qiehuan"] forState:UIControlStateNormal];
        
        [_sendMessageButton addTarget:self action:@selector(addRosterButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addRosterButton;
}

@end
