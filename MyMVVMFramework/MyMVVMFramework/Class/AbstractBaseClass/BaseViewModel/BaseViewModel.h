//
//  BaseViewModel.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/5/27.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"


@protocol ViewModelServices;

/// The type of the title view.
typedef NS_ENUM(NSUInteger, TitleViewType) {
    /// System title view
    TitleViewTypeDefault,
    /// Double title view
    TitleViewTypeDoubleTitle,
    /// Loading title view
    TitleViewTypeLoadingTitle
};


@interface BaseViewModel : NSObject

/// Initialization method. This is the preferred way to create a new view model.
///
/// services - The service bus of the `Model` layer.
/// params   - The parameters to be passed to view model.
///
/// Returns a new view model.
- (instancetype)initWithServices:(id<ViewModelServices>)services params:(NSDictionary *)params;

/// The `services` parameter in `-initWithServices:params:` method.
@property (nonatomic, strong, readonly) id<ViewModelServices> services;

/// The `params` parameter in `-initWithServices:params:` method.
@property (nonatomic, copy, readonly) NSDictionary *params;

@property (nonatomic, assign) TitleViewType titleViewType;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

/// The callback block.
@property (nonatomic, copy) VoidBlock_id callback;

/// A RACSubject object, which representing all errors occurred in view model.
@property (nonatomic, strong, readonly) RACSubject *errors;

@property (nonatomic, assign) BOOL shouldFetchLocalDataOnViewModelInitialize;
@property (nonatomic, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;

@property (nonatomic, strong, readonly) RACSubject *willDisappearSignal;

/**
 *  数据请求
 */
@property (strong, nonatomic, readonly) RACCommand *requestDataCommand;
/// An additional method, in which you can initialize data, RACCommand etc.
///
/// This method will be execute after the execution of `-initWithServices:params:` method. But
/// the premise is that you need to inherit `ViewModel`.
- (void)initialize;

- (RACSignal *)executeRequestDataSignal:(id)input;

@end
