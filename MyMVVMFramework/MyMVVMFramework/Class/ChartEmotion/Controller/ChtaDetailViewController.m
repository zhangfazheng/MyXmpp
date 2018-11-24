//
//  ChtaDetailViewController.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/6/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "ChtaDetailViewController.h"
#import "Masonry.h"
#import "EmoticonView.h"
#import "EmoticonViewModel.h"
#import "UIView+Frame.h"

@interface ChtaDetailViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView * inputTextView;
@property (nonatomic, strong) EmoticonView * emoticonView;
@property (nonatomic, strong) UIToolbar *toolBar;
@end

@implementation ChtaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setup{
    [self.view addSubview:self.inputTextView];
    
    WeakSelf
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    _inputTextView.delegate = self;
    
    [self.view addSubview:self.toolBar];
    
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        
        make.height.equalTo(@44);
    }];

}


- (void)inputEmoticon{
    _inputTextView.inputView == nil ? (_inputTextView.inputView = self.emoticonView):(_inputTextView.inputView = nil);
    
    // 调用一下这个方法,来实现 inputView的更新
    [_inputTextView reloadInputViews];
    
    // 变成第一响应者
    [_inputTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark-懒加载控件
- (UITextView *)inputTextView{
    if (!_inputTextView) {
        UITextView *textView = [UITextView new];
        textView.font = [UIFont systemFontOfSize:16];
        // 设置textView的滚动消失
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        // 只设置 消失还不行,还需要设置textView的滚动方向,让textView垂直
        textView.alwaysBounceVertical = YES;
        
        _inputTextView = textView;
    }
    return  _inputTextView;
}


- (EmoticonView *)emoticonView{
    if (!_emoticonView) {
        EmoticonViewModel *viewModel = [[EmoticonViewModel alloc]initWithServices:nil params:nil];
        
        EmoticonView *emoticon = [EmoticonView EmoticonViewViewModel:viewModel];
        
        // 设置frame
        emoticon.frame = CGRectMake(0, 0, ScreenWidth, 216);
        _emoticonView = emoticon;
       
    }
    return _emoticonView;
}

- (UIToolbar *)toolBar{
    if (!_toolBar) {
        UIToolbar *toolBar = [UIToolbar new];
        
        toolBar.backgroundColor = [UIColor darkGrayColor];
        
        NSArray *itemSettings = @[@{@"imageName": @"compose_toolbar_picture", @"action": @"choosePicture"},
                                  @{@"imageName": @"compose_mentionbutton_background"},
                                  @{@"imageName": @"compose_trendbutton_background"},
                                  @{@"imageName": @"compose_emoticonbutton_background", @"action": @"inputEmoticon"},
                                  @{@"imageName": @"compose_addbutton_background"}];
        
        // toolBar 添加控件
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:itemSettings.count];
        
        // 循环遍历
        for (NSDictionary *itemSetting in itemSettings) {
            NSString *imageName             = itemSetting[@"imageName"];
            NSString *highlightedImage      = [NSString stringWithFormat:@"%@_highlighted",imageName];
            
            UIButton *button                = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
            
            /*
            添加视图的时候,什么都没有展示
            1. 有没有添加进来
            2. 有没有frame
            3. 看图层
            */
            
            [button sizeToFit];
            // 添加点击事件
            @weakify(self)
            if(!isEmptyString(itemSetting[@"action"])){
                
                [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton * x) {
                    @strongify(self)
                    [self inputEmoticon];
                }];

            }
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
            
            // 把item添加到数组里
            [items addObject:item];
            
            // 添加弹簧
            UIBarButtonItem *flexiItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
            [items addObject:flexiItem];
        }

        // 遍历完成之后,删除最后一个弹簧
        [items removeLastObject];
        
        toolBar.items = items;
        
        _toolBar = toolBar;
    }
    
    return _toolBar;
}

@end
