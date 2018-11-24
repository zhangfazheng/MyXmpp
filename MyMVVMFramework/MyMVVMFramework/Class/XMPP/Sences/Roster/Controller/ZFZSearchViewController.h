//
//  ZFZSeacherViewController.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/6.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewController.h"
#import "ZFZSearchBar.h"

@class ZFZSearchViewController;

@protocol ZFZSearchViewControllerDelegate <NSObject>

@optional
- (void)willPresentSearchController:(ZFZSearchViewController *)searchController;
- (void)didPresentSearchController:(ZFZSearchViewController *)searchController;
- (void)willDismissSearchController:(ZFZSearchViewController *)searchController;
- (void)didDismissSearchController:(ZFZSearchViewController *)searchController;

@end

@protocol ZFZSearchViewControllerResultsUpdating <NSObject>

@required
- (void)updateSearchResultsForSearchController:(ZFZSearchViewController *)searchController;

@end


@interface ZFZSearchViewController : BaseViewController
@property (nonatomic, strong) ZFZSearchBar *mySearchBar;
@property (nonatomic, weak) id<ZFZSearchViewControllerDelegate> delegate;
@property (nonatomic, weak) id<ZFZSearchViewControllerResultsUpdating> searchResultsUpdater;
@property (nonatomic, assign) BOOL hidesNavigationBarDuringPresentation;
@property (nonatomic, strong) UIViewController *searchResultsController;

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController;
@end
