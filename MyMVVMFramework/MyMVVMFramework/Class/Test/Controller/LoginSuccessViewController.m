//
//  LoginSuccessViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/17.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "LoginSuccessViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "NetWorkManager.h"
#import "LoginUserModel.h"
#import "Interface.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+Verification.h"
#import "ZFZXMPPManager.h"
#import <Masonry/Masonry.h>
#import "NSString+path.h"
#import "CustomTabBarController.h"
#import "ZFZRoomManager.h"
#import "LoginViewController.h"
#import "ReviewUserListViewController.h"
#import "ReviewUserViewModel.h"
#import "HomePageViewController.h"
#import "HomePageViewModel.h"
#import "DepartmentListViewController.h"
#import "DepartmentManageViewModel.h"

@interface LoginSuccessViewController ()<XMPPStreamDelegate>
@property (nonatomic,strong) UILabel *tipLable;
@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UIButton *registerButton;
@end

@implementation LoginSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup{
    [super setup];
    [[ZFZXMPPManager sharedManager].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self setUpUI];
    
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//    [self launchAnimation];
//}

#pragma mark - Private Methods
- (void)launchAnimation {
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    
    UIView *launchView = viewController.view;
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    launchView.frame = [UIApplication sharedApplication].keyWindow.frame;
    [mainWindow addSubview:launchView];
    
    [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        launchView.alpha = 0.0f;
        launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0f, 2.0f, 1.0f);
    } completion:^(BOOL finished) {
        [launchView removeFromSuperview];
    }];
}


- (void)setUpUI{
    //发送登录请求，获取账号信息
    
    [self.view addSubview:self.tipLable];
    [self.view addSubview:self.loginButton];
    //[self.view addSubview:self.registerButton];
    [self.loginButton addTarget:self action:@selector(loginWithDeviceID:) forControlEvents:UIControlEventTouchUpInside];
    
    WeakSelf
    [_tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(70);
        make.left.equalTo(weakSelf.view).offset(18);
        make.right.equalTo(weakSelf.view).offset(-18);
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(-150);
        make.left.equalTo(weakSelf.view).offset(18);
        make.right.equalTo(weakSelf.view).offset(-18);
        make.height.mas_equalTo(44).priorityHigh();
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loginWithDeviceID:self.deviceID];
    //[[ZFZXMPPManager sharedManager] xmppManagerLoginWithUserName:@"lisi" password:@"abc123"];
}

- (void)registerAction{
    LoginViewController *registerVc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:registerVc animated:YES];
}

- (void)loginWithDeviceID:(id)sender{
    NSString * deviceId;
    if ([sender isKindOfClass:[NSString class]]) {
        deviceId = sender;
    }
    if (isEmptyString(deviceId)) {
         deviceId = [[NSUserDefaults standardUserDefaults]objectForKey:@"UUID"];
    }
    NSDictionary *loginParats=@{
                                @"deviceId":deviceId,
                                @"deviceType":@"ios",
                                @"loginType":@"deviceLogin"
                                };
    
    WeakSelf
    [[NetWorkManager shareManager]requestWithType:HttpRequestTypePost withUrlString:PhoneLogin withParaments:loginParats withSuccessBlock:^(NSDictionary *object) {
        if ([object[@"stateCode"][@"code"] intValue] == 9) {
            //[MBProgressHUD showNoImageMessage:@"登录成功"];
            [MBProgressHUD showMessage:@"数据加载中"];
            //保存用户信息
            LoginUserModel *curUser     = [LoginUserModel getUserModelInstance];
            curUser.realName            = object[@"data"][@"realName"];
            curUser.userName            = object[@"data"][@"pinName"];
            curUser.sessionId           = object[@"data"][@"sessionId"];
            curUser.login               = YES;
            
            // 拼接文件路径
            NSString *filePath = [@"person.plist" appendDocuments];
            // 归档"保存"
            [NSKeyedArchiver archiveRootObject:curUser toFile:filePath];
            NSUserDefaults   *defaults = [ NSUserDefaults standardUserDefaults ];
            [defaults setObject:curUser.realName  forKey: @"userNickName"];

//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];

//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter]postNotificationName:LoginSuccessReloadData object:nil];
//            });
            
            [[ZFZXMPPManager sharedManager] xmppManagerLoginWithUserName:curUser.userName password:curUser.userName];
//            [[ZFZXMPPManager sharedManager] xmppManagerLoginWithUserName:@"t1" password:@"123456"];
            
            
        }else if ([object[@"stateCode"][@"code"] intValue] == 12 || [object[@"stateCode"][@"code"] intValue] == 3){
            weakSelf.loginButton.enabled = NO;
            [weakSelf.tipLable setText:object[@"stateCode"][@"msg"]];
            
            [weakSelf.view addSubview:weakSelf.registerButton];
            
            [weakSelf.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.loginButton.mas_bottom).offset(20);
                make.leading.equalTo(weakSelf.loginButton);
                make.trailing.equalTo(weakSelf.loginButton);
                make.height.mas_equalTo(44).priorityHigh();
            }];
            
        }else{
            [MBProgressHUD hideHUD];
            if (isEmptyString(object[@"stateCode"][@"msg"])) {
                [MBProgressHUD showNoImageMessage:@"登录失败"];
            }else{
                [weakSelf.tipLable setText:object[@"stateCode"][@"msg"]];
            }
            
        }
        
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"登录失败");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showNoImageMessage:@"登录失败"];
    } progress:^(float progress) {
        
    }];
}

#pragma mark- 流代理方法
//登陆成功的回调事件
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    //    NSLog(@"登陆成功");
//    [MBProgressHUD showNoImageMessage:@"登录成功"];
//    CustomTabBarController *mainTapVc = [[CustomTabBarController alloc]init];
    
    
//        HomePageViewModel *viewModel = [[HomePageViewModel alloc]initWithServices:nil params:nil];
//        HomePageViewController *HomePageVc = [[HomePageViewController alloc]initWithViewModel:viewModel];

    DepartmentManageViewModel *viewModel = [[DepartmentManageViewModel alloc]initWithServices:nil params:nil];
    DepartmentListViewController *depVc = [[DepartmentListViewController alloc]initWithViewModel:viewModel];
    
    
    //    ZFZRecentlyTableViewController *viewController =[[ZFZRecentlyTableViewController alloc]initWithViewModel: [[ZFZRecentlyViewModel alloc]initWithServices:nil params:nil]];
    //ZFZFriendsListViewModel *friendViewModel = [[ZFZFriendsListViewModel alloc]initWithServices:nil params:nil];
    //ZFZRoomAddMemberViewController *mainTapVc = [[ZFZRoomAddMemberViewController alloc]initWithViewModel:friendViewModel];
    
    
    //登录成功后保存用户信息
    NSUserDefaults      *defaults = [ NSUserDefaults standardUserDefaults ];
    NSString            *userName = sender.myJID.user;
    [defaults setObject:userName forKey:@"userName"];
    
    //登录群聊
    [[ZFZRoomManager shareInstance] loadRooms];
    
    //让系统准备一段时间，获取信息
    [NSThread sleepForTimeInterval:3];
    [MBProgressHUD hideHUD];
    
//    SharedAppDelegate.window.rootViewController = mainTapVc;
//    ReviewUserViewModel *viewModel = [[ReviewUserViewModel alloc]initWithServices:nil params:nil];
//    ReviewUserListViewController *reviewVc = [[ReviewUserListViewController alloc]initWithViewModel:viewModel];
    SharedAppDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:depVc];
}
//登陆失败的回调事件
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"登陆失败 : %@",error);
}


- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    //NSLog(@"iq:%@",iq);
    // 以下两个判断其实只需要有一个就够了
    NSString *elementID = iq.elementID;
    if (![elementID isEqualToString:@"getMyRooms"]) {
        return YES;
    }
    
    NSArray *results = [iq elementsForXmlns:@"http://jabber.org/protocol/disco#items"];
    if (results.count < 1) {
        return YES;
    }
    [[ZFZRoomManager shareInstance] analyticDiscussionMemberWithIq:iq];
    
    
    return YES;
}

#pragma mark- 懒加载控件
- (UILabel *)tipLable{
    if (!_tipLable) {
        UILabel *lable= [UILabel new];
        [lable setFont:Font_Large_Text];
        [lable setTextColor:fontHightColor];
        lable.textAlignment =NSTextAlignmentCenter;
        _tipLable = lable;
    }
    return _tipLable;
}

- (UIButton *)loginButton{
    if (!_loginButton) {
        UIButton *button = [UIButton new];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [button setBackgroundColor:FlatGreenDark];
        button.layer.cornerRadius = 5;
        
        _loginButton = button;
    }
    return _loginButton;
}


- (UIButton *)registerButton{
    if (!_registerButton) {
        UIButton *button = [UIButton new];
        [button setTitle:@"注册审核" forState:UIControlStateNormal];
        [button setBackgroundColor:FlatSkyBlueDark];
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
        
        _registerButton = button;
    }
    return _registerButton;
}

@end
