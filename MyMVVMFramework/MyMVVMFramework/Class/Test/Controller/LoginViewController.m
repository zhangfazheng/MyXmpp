//
//  SVLoginViewController.m
//  SilverValley
//
//  Created by 张发政 on 16/10/5.
//  Copyright © 2016年 Beijing Oriental Silver Valley Investment Management Co.,Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UITextField+Icon.h"
#import "LoginUserModel.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
#import "Interface.h"
#import "NSString+Hash.h"
#import "NSString+path.h"
#import "ZFZXMPPManager.h"
#import "ZFZRecentlyViewModel.h"
#import "ZFZRecentlyTableViewController.h"
#import "CustomTabBarController.h"
#import "ZFZRoomManager.h"
#import "ZFZFriendsListViewModel.h"
#import "ZFZRoomAddMemberViewController.h"
#import "XMPPConfig.h"
#import "NSString+Verification.h"
#import "LoginSuccessViewController.h"

@interface LoginViewController () <UITextFieldDelegate,XMPPStreamDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (assign,nonatomic) BOOL isExister;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong,nonatomic,readwrite) LoginViewModel *viewModel;

@end

@implementation LoginViewController
@dynamic viewModel;


- (void)setup{
    [super setup];
    self.title=@"登录";
    
//    self.mainView.layer.shadowOpacity = 0.5;// 阴影透明度
//
//    self.mainView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
//
//    self.mainView.layer.shadowRadius = 3;// 阴影扩散的范围控制
//
//    self.mainView.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
    
//    self.mainView.backgroundColor= [UIColor whiteColor];
//    self.mainView.layer.cornerRadius=8;
    
    //self.loginButton.backgroundColor= FlatSkyBlue;
    self.loginButton.layer.cornerRadius=5;
    

//    [self.phoneNumberTextField uitextFieldWithIconName:@"login_name"];
//    [self.passWordTextField uitextFieldWithIconName:@"login_password1"];
//
//    self.phoneNumberTextField.layer.borderWidth=1;
//    self.passWordTextField.layer.borderWidth=1;
//    self.phoneNumberTextField.layer.borderColor=[UIColor grayColor].CGColor;
//    self.passWordTextField.layer.borderColor=[UIColor grayColor].CGColor;
    
    //添加隐藏键盘的事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    
    //判断用户名是否存在的监听事件
    //[self.phoneNumberTextField addTarget:self action:@selector(isExsisterPhoneNumber) forControlEvents:UIControlEventEditingDidEnd];
    
//    [self.passWordTextField addTarget:self action:@selector(isEnptyAction) forControlEvents:UIControlEventEditingChanged];
//    
    //设置手机存在的初始状态
    self.isExister=NO;
    
    //登录按钮状态为不可用
    self.loginButton.enabled=YES;
    
    //设置返回按钮
    UIBarButtonItem *registerRightBut=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(homeAction)];
    //[registerRightBut setTintColor:[UIColor whiteColor]];
    
    // 设置当前控制器得导航栏右边按钮
    self.navigationItem.leftBarButtonItem=registerRightBut;
    
    
    //记住手机号
//    NSString *phoneNumber=[LoginUserModel getUserModelInstance].userName;
//    if(!isEmptyString(phoneNumber)){
//        self.phoneNumberTextField.text=phoneNumber;
//        //[self isExsisterPhoneNumber];
//    }
    
}

//隐藏键盘
- (void)keyBoardHidden{
    [self.phoneNumberTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
}

#pragma mark - Private Methods
- (void)launchAnimation {
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    
    UIView *launchView = viewController.view;
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    launchView.frame = [UIApplication sharedApplication].keyWindow.frame;
    [mainWindow addSubview:launchView];
    
    [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        launchView.alpha = 0.0f;
        launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2f, 1.2f, 1.0f);
    } completion:^(BOOL finished) {
        [launchView removeFromSuperview];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    }

- (IBAction)forgeterPassword:(id)sender {
//    if (!self.isExister) {
//        
//        return;
//    }
    
//    SVForgotPasswordViewController *forgotPassWordVc=[[SVForgotPasswordViewController alloc]init];
//    forgotPassWordVc.title=@"忘记密码";
//    forgotPassWordVc.phoneNumber=self.phoneNumberTextField.text;
//    [self.navigationController pushViewController:forgotPassWordVc animated:YES];
    NSLog(@"忘记密码");
}

-(void)bindViewModel{
    [super bindViewModel];
    
    self.viewModel.nameSignal         = self.phoneNumberTextField.rac_textSignal;
    self.viewModel.passWordSignal     = self.passWordTextField.rac_textSignal;
}


#pragma mark-记住密码
//- (IBAction)remenble:(id)sender {
//    self.rememberbutton.selected=!self.rememberbutton.selected;
//}

#pragma mark-登录
- (IBAction)loginButtonAction:(id)sender {
    if(isEmptyString(self.phoneNumberTextField.text)){
        [MBProgressHUD showNoImageMessage:@"用户名不能为空"];
        return;
    }else if(isEmptyString(self.passWordTextField.text)){
        [MBProgressHUD showNoImageMessage:@"拼音不能为空"];
        return;
    }
    
    [MBProgressHUD showMessage:@"登录中"];
    
    NSString *deviceId = [NSString createUUID];
    
//    if (isEmptyString(deviceId)) {
//
//    }
//    [[ZFZXMPPManager sharedManager] xmppManagerLoginWithUserName:@"lisi" password:@"abc123"];
//    { userName:"18888888888",password:"123123","deviceId":"qaqwr12345543",deviceType:"android/ios"}
    NSDictionary *loginParats=@{@"realName":self.phoneNumberTextField.text,
                                @"pinName":self.passWordTextField.text,
                                @"deptId":@"0",
                                @"deviceId":deviceId,
                                @"deviceType":@"ios"
                                };

    WeakSelf
    [[NetWorkManager shareManager]requestWithType:HttpRequestTypePost withUrlString:PhoneRegister withParaments:loginParats withSuccessBlock:^(NSDictionary *object) {
        [MBProgressHUD hideHUD];
        if ([object[@"stateCode"][@"code"] intValue] == 23 && [object[@"success"] boolValue]) {
            //[MBProgressHUD showNoImageMessage:@"登录成功"];
            //保存用户信息
            LoginUserModel *curUser     = [LoginUserModel getUserModelInstance];
            curUser.realName            = loginParats[@"realName"];
            curUser.userName            = loginParats[@"pinName"];
            
             //拼接文件路径
            NSString *filePath = [@"person.plist" appendDocuments];
            // 归档"保存"
            [NSKeyedArchiver archiveRootObject:curUser toFile:filePath];
//
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter]postNotificationName:LoginSuccessReloadData object:nil];
//            });
            //如果注册成功保存uuid
            [[NSUserDefaults standardUserDefaults]setObject:deviceId forKey:@"UUID"];
            //并登录xmpp
            //[[ZFZXMPPManager sharedManager] xmppManagerLoginWithUserName:@"lisi" password:@"abc123"];
            LoginSuccessViewController * loginSuccessVc = [[LoginSuccessViewController alloc]init];
            SharedAppDelegate.window.rootViewController = loginSuccessVc;
        }else{
            [MBProgressHUD hideHUD];
            if (isEmptyString(object[@"stateCode"][@"msg"])) {
                [MBProgressHUD showNoImageMessage:@"注册失败"];
            }else{
                [MBProgressHUD showNoImageMessage:object[@"stateCode"][@"msg"]];
            }

        }


    } withFailureBlock:^(NSError *error) {
        NSLog(@"登录失败");
        [MBProgressHUD hideHUD];
        //[MBProgressHUD showNoImageMessage:@"登录失败"];
    } progress:^(float progress) {

    }];

}




#pragma mark-判断验证码是否为空
- (void)isEnptyAction{
    if(self.passWordTextField.text.length>0){
        self.loginButton.enabled=YES;
        
    }else{
        self.loginButton.enabled=NO;
        [MBProgressHUD showNoImageMessage:@"密码不能为空"];
    }
}


- (void)homeAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)isExsisterPhoneNumber{
    if(isEmptyString(self.phoneNumberTextField)){
        [MBProgressHUD showNoImageMessage:@"用户名输入不能为空"];
        self.loginButton.enabled=NO;
    }else{
        self.loginButton.enabled=YES;
    }
        
//    NSString *cellPhone=[[SVRSAHandler sharedDFRSAHandler] encryptWithPublicKey:self.phoneNumberTextField.text];
//    if(cellPhone==nil){
//        return;
//        
//    }
//    NSDictionary *parameters=@{@"cellphoneno":cellPhone};
//    //[MBProgressHUD showMessage:@"验证中..."];
//    [[SVNetWorkRequest sharedNetworkTool]POSTWithURLString:SVCheckUserExists parameters:parameters successBlock:^(id responseObject) {
//        NSDictionary *dic=responseObject;
//        if([dic[@"resultcode"] isEqualToString:@"0"] && [dic[@"message"] boolValue]){
//            self.isExister=YES;
//            if(self.passWordTextField.text.length>0){
//                self.loginButton.enabled=YES;
//            }
//
//        }else{
//            self.isExister=NO;
//            //[MBProgressHUD hideHUD];
//            self.loginButton.enabled=NO;
//            [MBProgressHUD showNoImageMessage:@"该手机号尚未注册"];
//        }
//    } failedBlock:^(NSError *error) {
//    }];
}


@end
