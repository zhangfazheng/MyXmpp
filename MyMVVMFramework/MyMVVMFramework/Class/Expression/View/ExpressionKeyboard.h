//
//  ExpressionKeyboard.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/22.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kNaviBarH       64   //导航栏高度
#define kTopToolbarH    46   //顶部工具栏高度
#define kToolbarBtnH    35   //顶部工具栏的按钮高度
#define kBotContainerH  216  //底部表情高度
#define DURTAION  0.25f      //键盘显示/收起动画时间
#define kTextVTopMargin 8


@interface ExpressionKeyboard : UIView

@property (nonatomic, assign) int maxNumberOfRowsToShow;//最大显示行
@property (strong,nonatomic) RACSignal *sendMessageSignal;
@property (strong,nonatomic) RACSubject *returnSendMessageSubject;//return建发送信息信号
@property (copy,nonatomic) NSString *sendMessageString;
/**
 初始化方式
 
 @param viewController YHExpressionKeyboard所在的控制器
 @param aboveView 在viewController的view中,位于YHExpressionKeyboard上方的视图,（用于设置aboveView的滚动）
 @return YHExpressionKeyboard
 */
- (instancetype)initWithViewController:( UIViewController *)viewController aboveView:( UIView *)aboveView;

+ (instancetype)shardExpressionKeyboardWithViewController:( UIViewController *)viewController aboveView:(UIView *)aboveView;

//清除输入框中的信息
- (void)clearMessage;
/**
 结束编辑
 */
- (void)endEditing;
@end
