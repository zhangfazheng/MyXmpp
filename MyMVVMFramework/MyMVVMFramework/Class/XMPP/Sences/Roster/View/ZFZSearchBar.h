//
//  ZFZSearchBar.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/7.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFZSearchBar;

@protocol ZFZSearchBarDelegate <NSObject>

@optional
- (void)searchBarTextDidBeginEditing:(ZFZSearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(ZFZSearchBar *)searchBar;
- (void)searchBar:(ZFZSearchBar *)searchBar textDidChange:(NSString *)searchText;

@end


@interface ZFZSearchBar : UIView
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, weak) id<ZFZSearchBarDelegate> delegate;
@end
