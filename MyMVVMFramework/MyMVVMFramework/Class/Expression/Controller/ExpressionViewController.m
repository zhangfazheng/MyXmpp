//
//  ExpressionViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/22.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ExpressionViewController.h"
#import "ExpressionKeyboard.h"
#import "YYKit.h"

@interface ExpressionViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) ExpressionKeyboard *keyboard;
@end

@implementation ExpressionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setup{
    [super setup];
    
    [self _initNavigation];
    
    

    
    UIScrollView *scrV      = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scrV.backgroundColor    = [UIColor orangeColor];
    scrV.contentSize        = CGSizeMake(kScreenWidth, kScreenHeight+64);
    scrV.delegate           = self;
    [self.view addSubview:scrV];
    
    //表情键盘
    ExpressionKeyboard *board = [[ExpressionKeyboard alloc] initWithViewController:self aboveView:scrV];
    [board.sendMessageSignal subscribeNext:^(id  _Nullable x) {
        
        if (isEmptyString(board.sendMessageString)) {
            return ;
        }
        NSLog(@"发送信号:%@",board.sendMessageString);
        
    }];
    _keyboard = board;
    [self.view addSubview:board];
    
    

}

- (void)_initNavigation{
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"ExpressionKeyBoard";
    
    //设置导航栏背景颜色
    UIColor * color = UIColorHex(0e92dd);
    self.navigationController.navigationBar.barTintColor = color;
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor colorWithWhite:0.871 alpha:1.000];
    shadow.shadowOffset = CGSizeMake(0.5, 0.5);
    //    shadow.shadowBlurRadius = 20;
    
    
    //设置导航栏标题颜色
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18],NSShadowAttributeName:shadow};
    
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    
    //设置返回按钮的颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    //右barButtonItem
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setTitle:@">" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onRight:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Life
- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - Action
- (void)onRight:(UIButton*)sender{
    ExpressionViewController *vc = [ExpressionViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - @protocol UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_keyboard endEditing];
    //[self.keyboard.expressionKeyboardDismisSubject sendNext:nil];
}


#pragma mark - @protocol YHExpressionKeyboardDelegate
- (void)didSelectExtraItem:(NSString *)itemName{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:itemName message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)sendBtnDidTap:(NSString *)text{
    NSLog(@"最新的发送信息");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
