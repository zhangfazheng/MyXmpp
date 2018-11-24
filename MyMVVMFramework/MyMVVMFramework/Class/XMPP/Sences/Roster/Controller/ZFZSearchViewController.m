//
//  ZFZSeacherViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/6.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ZFZSearchViewController.h"
#import "ZFZSearchResultViewController.h"
#import "UIView+ZFZTouch.h"
#import "UIView+Frame.h"
#import "UIView+ViewController.h"
#import "UIViewController+StatusBarStyle.h"
#import "CustomNavigationController.h"
#import "ZFZFindFriendViewController.h"

NSString *SEARCH_CANCEL_NOTIFICATION_KEY = @"SEARCH_CANCEL_NOTIFICATION_KEY";

@interface ZFZSearchViewController ()
@property (nonatomic, strong) UIView *bgView;

@end

@implementation ZFZSearchViewController

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController {
    self = [super init];
    self.searchResultsController = searchResultsController;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bgView];
    self.view.unTouchRect = CGRectMake(0, 0, self.view.width, 64);
    self.searchResultsController.view.frame = self.bgView.bounds;
    [self.bgView addSubview:self.searchResultsController.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endSearch) name:SEARCH_CANCEL_NOTIFICATION_KEY object:nil];
}


- (void)setup{
    [super setup];
    self.view.backgroundColor                 = [UIColor clearColor];
}

- (void)tapSearchBarAction {
    if ([self.delegate respondsToSelector:@selector(willPresentSearchController:)])
        [self.delegate willPresentSearchController:self];
    self.mySearchBar.zfz_viewController.zfz_lightStatusBar = NO;
    //self.hidesBottomBarWhenPushed = YES;
    [self.mySearchBar addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handGesture)]];
    [self.mySearchBar addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handGesture)]];
    //UIView * myview = self.view;
    //self.view.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.view];
    if ([self.delegate respondsToSelector:@selector(didPresentSearchController:)]) [self.delegate didPresentSearchController:self];
    [self.mySearchBar setValue:@1 forKey:@"isEditing"];
    
    id curVc = self.mySearchBar.zfz_viewController.parentViewController;
    
    CGFloat rectStatusH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (curVc && [curVc isKindOfClass:[CustomNavigationController class]] && self.hidesNavigationBarDuringPresentation) {
        
        [(CustomNavigationController *)curVc setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.bgView.top = 64;
            self.bgView.height = ScreenHeight-64;
            //self.mySearchBar.top = rectStatusH;
        }];
    } else {
        
    }
}

- (void)handGesture {
    
}

#pragma  mark- 键值监听事件处理方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"] && [self.searchResultsUpdater respondsToSelector:@selector(updateSearchResultsForSearchController:)]) {
        [self.searchResultsUpdater updateSearchResultsForSearchController:self];
    }
}

- (void)endSearch {
    if ([self.delegate respondsToSelector:@selector(willDismissSearchController:)]) [self.delegate willDismissSearchController:self];
    [self endSearchTextFieldEditing];
    self.mySearchBar.zfz_viewController.zfz_lightStatusBar = YES;
    NSArray *searchBarGestures = self.mySearchBar.gestureRecognizers;
    if (searchBarGestures.count == 3) {
        [self.mySearchBar removeGestureRecognizer:searchBarGestures.lastObject];
        [self.mySearchBar removeGestureRecognizer:searchBarGestures.lastObject];
    }
    if (searchBarGestures.count == 2) {
        [self.mySearchBar removeGestureRecognizer:searchBarGestures.lastObject];
    }
    
    [self.view removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(didDismissSearchController:)]) [self.delegate didDismissSearchController:self];
    [self.mySearchBar setValue:@0 forKey:@"isEditing"];
    if (self.mySearchBar.zfz_viewController.parentViewController && [self.mySearchBar.zfz_viewController.parentViewController isKindOfClass:[UINavigationController class]] && self.hidesNavigationBarDuringPresentation) {
        
        [(UINavigationController *)self.mySearchBar.zfz_viewController.parentViewController setNavigationBarHidden:NO animated:YES];
        self.bgView.top = CGRectGetMaxY(self.mySearchBar.frame) + 64;
    }
}

- (void)endSearchTextFieldEditing {
    UITextField *searchTextField = [self.mySearchBar valueForKey:@"searchTextField"];
    [searchTextField resignFirstResponder];
}


- (ZFZSearchBar *)mySearchBar{
    if (!_mySearchBar) {
        _mySearchBar = [[ZFZSearchBar alloc] init];
        [_mySearchBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearchBarAction)]];
        //添加键值监听
        //[_mySearchBar addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _mySearchBar;
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.frame = CGRectMake(0, CGRectGetMaxY(self.mySearchBar.frame) + 64, ScreenWidth, self.view.height - self.mySearchBar.frame.size.height);
        _bgView.backgroundColor = [UIColor lightGrayColor];
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endSearchTextFieldEditing)]];
    }
    return _bgView;
}

- (void)dealloc {
    //[self.mySearchBar removeObserver:self forKeyPath:@"text"];
    NSLog(@"SearchController dealloc");
}

@end
