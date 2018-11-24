//
//  BaseViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/5/27.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewModel.h"

@interface BaseViewModel ()

@property (nonatomic, strong, readwrite) id<ViewModelServices> services;
@property (nonatomic, copy, readwrite) NSDictionary *params;
@property (strong, nonatomic, readwrite) RACCommand *requestDataCommand;
//@property (nonatomic, strong, readwrite) RACSubject *errors;
@property (nonatomic, strong, readwrite) RACSubject *willDisappearSignal;

@end

@implementation BaseViewModel
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BaseViewModel *viewModel = [super allocWithZone:zone];
    
    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，只要调用这个方法，就会发送信号。
    // 这里表示只要viewModel调用initWithServices:,就会发出信号
    @weakify(viewModel)
    [[viewModel
      rac_signalForSelector:@selector(initWithServices:params:)]
    	subscribeNext:^(id x) {
            @strongify(viewModel)
    
            [viewModel initialize];
        }];
    
    return viewModel;
}

- (instancetype)initWithServices:(id<ViewModelServices>)services params:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.shouldFetchLocalDataOnViewModelInitialize = YES;
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        self.title    = params[@"title"];
        self.services = services;
        self.params   = params;
        
        WeakSelf
        self.requestDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            //如果页面消灭网络请求的信号将不会再返回值
            return [[weakSelf executeRequestDataSignal:input] takeUntil:weakSelf.rac_willDeallocSignal];
        }];
    }
    return self;
}

//若要实现网络数据请求需实现些方法
- (RACSignal *)executeRequestDataSignal:(id)input
{
    return [RACSignal empty];
}

//- (RACSubject *)errors {
//    if (!_errors) _errors = [RACSubject subject];
//    return _errors;
//}

- (RACSubject *)willDisappearSignal {
    if (!_willDisappearSignal) _willDisappearSignal = [RACSubject subject];
    return _willDisappearSignal;
}

- (void)initialize {}

@end
