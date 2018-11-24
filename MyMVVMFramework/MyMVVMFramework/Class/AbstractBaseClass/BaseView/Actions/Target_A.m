//
//  Target_A.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/5.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "Target_A.h"
#import "NoneView.h"

typedef void (^CTUrlRouterCallbackBlock)(NSDictionary *info);
@implementation Target_A

- (UIView *)Action_nativeFetchNoneView:(NSDictionary *)params{
    // 因为action是从属于ModuleA的，所以action直接可以使用ModuleA里的所有声明
    //4／5: 创建一个DemoModuleADetailViewController类型的实例(这个实例是Target_A通过DemoModuleADetailViewController类的alloc/init创建的)。
    NoneView *view = [[NoneView alloc] init];
    view.valueLabel.text = params[@"key"];
    //6: Target_A返回创建的实例到CTMediator.m(发起时是通过runtime，步骤3)，返回后CTMediator.m并不知道这个实例的具体类型，也不会对这个类进行任何解析操作，所以CTMediator.m跟返回的实例之间是没有任何引用关系的。
    return view;
}


- (id)Action_showAlert:(NSDictionary *)params
{
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        CTUrlRouterCallbackBlock callback = params[@"cancelAction"];
        if (callback) {
            callback(@{@"alertAction":action});
        }
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CTUrlRouterCallbackBlock callback = params[@"confirmAction"];
        if (callback) {
            callback(@{@"alertAction":action});
        }
    }];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"alert from Module A" message:params[@"message"] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    return nil;
}


@end
