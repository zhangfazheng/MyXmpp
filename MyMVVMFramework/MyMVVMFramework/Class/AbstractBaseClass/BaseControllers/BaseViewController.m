//
//  BaseViewController.m
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "BaseViewController.h"
#import <asl.h>
#import "RealReachability.h"
#import "DoubleTitleView.h"
#import "LoadingTitleView.h"
#import "AppDelegate.h"

typedef enum : NSUInteger {
    
    kEnterControllerType = 1000,
    kLeaveControllerType,
    kDeallocType,
    
} EDebugTag;

#define _Flag_NSLog(fmt,...) {                                        \
do                                                                  \
{                                                                   \
NSString *str = [NSString stringWithFormat:fmt, ##__VA_ARGS__];   \
printf("%s\n",[str UTF8String]);                                  \
asl_log(NULL, NULL, ASL_LEVEL_NOTICE, "%s", [str UTF8String]);    \
}                                                                   \
while (0);                                                          \
}

#ifdef DEBUG
#define ControllerLog(fmt, ...) _Flag_NSLog((@"" fmt), ##__VA_ARGS__)
#else
#define ControllerLog(...)
#endif


@interface BaseViewController ()<UIGestureRecognizerDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong, readwrite) BaseViewModel *viewModel;
@property (assign,nonatomic) CGFloat textFiledBottom;
/** 加载展示控件 */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIImageView *imgLoadingView;
@property (nonatomic, copy) NSArray *customImgs;
/**..*/


/** 无网络展示控件 */
@property (nonatomic, strong) UIImageView *noMesImgView;
@property (nonatomic, strong) UILabel *noMesLabel;
/**..*/


/** 无网络弹出View */
@property (nonatomic, strong) UIView *netAlertView;
/**..*/
@end

@implementation BaseViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BaseViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    
    return viewController;
}

- (BaseViewController *)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)bindViewModel {
    // System title view
    //RAC(self, title) = RACObserve(self.viewModel, title);
    
    UIView *titleView = self.navigationItem.titleView;
    
    // Double title view
    DoubleTitleView *doubleTitleView = [[DoubleTitleView alloc] init];
    
    RAC(doubleTitleView.titleLabel, text)    = RACObserve(self.viewModel, title);
    RAC(doubleTitleView.subtitleLabel, text) = RACObserve(self.viewModel, subtitle);
    
    //@weakify(self)
    WeakSelf
    [[self
      rac_signalForSelector:@selector(viewWillTransitionToSize:withTransitionCoordinator:)]
    	subscribeNext:^(id x) {
            //@strongify(self)
            doubleTitleView.titleLabel.text    = weakSelf.viewModel.title;
            doubleTitleView.subtitleLabel.text = weakSelf.viewModel.subtitle;
        }];
    
    // Loading title view
    LoadingTitleView *loadingTitleView = [[NSBundle mainBundle] loadNibNamed:@"LoadingTitleView" owner:nil options:nil].firstObject;
    loadingTitleView.frame = CGRectMake((ScreenWidth - CGRectGetWidth(loadingTitleView.frame)) / 2.0, 0, CGRectGetWidth(loadingTitleView.frame), CGRectGetHeight(loadingTitleView.frame));
    
    RAC(self.navigationItem, titleView) = [RACObserve(self.viewModel, titleViewType).distinctUntilChanged map:^(NSNumber *value) {
        TitleViewType titleViewType = value.unsignedIntegerValue;
        switch (titleViewType) {
            case TitleViewTypeDefault:
                return titleView;
            case TitleViewTypeDoubleTitle:
                return (UIView *)doubleTitleView;
            case TitleViewTypeLoadingTitle:
                return (UIView *)loadingTitleView;
        }
    }];
    
    [self.viewModel.errors subscribeNext:^(NSError *error) {
        //@strongify(self)
        NSLog(@"%@",error);
        
    }];
}


//- (void)loadView{
//    [super loadView];
//    //让页面完全由自己来布局默认是YES
//    self.automaticallyAdjustsScrollViewInsets = YES;
//}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setup];
    
    //[self registerForKeyboardNotifications];
    
    //[self addTouchDissmissKeybord];
    
    
    if(self.isListenNet){
        [self registNetObserveWithRealReachability];
    }
    
    self.AnimationImgs = [NSMutableArray array];
    
    //默认文字
    self.tag = TextLoadingType;
    //默认不显示
    self.errorTag = ShowText;
}

- (void)setup {
    
    
    self.width                                = [UIScreen mainScreen].bounds.size.width;
    self.height                               = [UIScreen mainScreen].bounds.size.height;
    self.view.backgroundColor                 = FlatWhite;
    
}

//- (void)registerEditBeignNotifications{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldOrViewBeginInput:) name:UITextFieldTextDidBeginEditingNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldOrViewBeginInput:) name:UITextViewTextDidBeginEditingNotification object:nil];
//}
//
//
//- (void)registerForKeyboardNotifications {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
//}

- (void)useInteractivePopGestureRecognizer {
    
    //在NavigationController堆栈内的UIViewController可以支持右滑手势，也就是不用点击右上角的返回按钮
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)popViewControllerAnimated:(BOOL)animated {
    
    [self.navigationController popViewControllerAnimated:animated];
}


- (void)textFieldOrViewBeginInput:(NSNotification *)sender{
    if (sender != nil && [sender.object isKindOfClass:[UITextField class]]) {
        UITextField *textFile = (UITextField *)sender.object;
        
        CGRect curTextFieldFrame=[[textFile superview] convertRect:textFile.frame toView:[UIApplication sharedApplication].keyWindow];
        self.textFiledBottom = CGRectGetMaxY(curTextFieldFrame);
        
    }else if ([sender.object isKindOfClass:[UITextView class]]){
        UITextView *textView = (UITextView *)sender.object;
        
        CGRect curTextFieldFrame=[[textView superview] convertRect:textView.frame toView:[UIApplication sharedApplication].keyWindow];
        self.textFiledBottom = CGRectGetMaxY(curTextFieldFrame);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    CGRect curTextFieldFrame=[self.view convertRect:textView.frame toView:self.view];
    self.textFiledBottom=CGRectGetMaxY(curTextFieldFrame);
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect curTextFieldFrame=[self.view convertRect:textView.frame toView:self.view];
    self.textFiledBottom=CGRectGetMaxY(curTextFieldFrame);

}

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    CGRect curTextFieldFrame=[self.view convertRect:textView.frame toView:self.view];
//    self.textFiledBottom = curTextFieldFrame.origin.y + curTextFieldFrame.size.height;
//    return YES;
//}
//
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    CGRect curTextFieldFrame=[self.view convertRect:textField.frame toView:self.view];
//    self.textFiledBottom= curTextFieldFrame.origin.y + curTextFieldFrame.size.height;
//    
//    return YES;
//}

////处理键盘消失
//-(BOOL)textFieldShouldReturn:(UITextField*)textField {
//    
//    [textField resignFirstResponder];
//    
//    return YES;
//    
//}
//
////添加点击空白处键盘消失
//- (void)addTouchDissmissKeybord{
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDissmisKebordAction)];
//    
//    tap.numberOfTapsRequired=1;
//    tap.numberOfTouchesRequired=1;
//    
//    [self.view addGestureRecognizer:tap];
//}

//- (void)touchDissmisKebordAction{
//    [self.view endEditing:YES];
//}

#pragma mark-键盘弹出时的通知
//- (void)keyboardWasShown:(NSNotification *)aNotification {
//    NSDictionary * info = [aNotification userInfo];
//    CGPoint kbOrigin = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
//    
//    //保证键盘弹出的事件在点击输入事件框之后处理
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        CGFloat aFloat = kbOrigin.y - self.textFiledBottom;
//        if (aFloat<0) {
//            [UIView animateWithDuration:0.25 animations:^{
//                //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
//                self.view.transform = CGAffineTransformMakeTranslation(0, aFloat);
//                //self.view.frame = CGRectMake(0.0f, aFloat, self.view.frame.size.width, self.view.frame.size.height);
//            }];
//        }
//
//    });
//    
//}

//#pragma mark-键盘消失时的通知
//- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
//    //使视图还原
//    [UIView animateWithDuration:0.25 animations:^{
//        
//        //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
//        self.view.transform = CGAffineTransformIdentity;
//        
//    }];
//}

- (UIImageView *)noMesImgView {
    if (!_noMesImgView) {
        
        _noMesImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _noMesImgView.userInteractionEnabled = YES;
        _noMesImgView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
        _noMesImgView.image = [UIImage imageNamed:@"noMessage"];
        _noMesImgView.hidden = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshNet)];
        [_noMesImgView addGestureRecognizer:tapGes];
        [self.view addSubview:_noMesImgView];
    }
    return _noMesImgView;
}

- (UILabel *)noMesLabel {
    if (!_noMesLabel) {
        
        _noMesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _noMesLabel.userInteractionEnabled = YES;
        _noMesLabel.text = @"暂无网络，请点击重新加载";
        _noMesLabel.textAlignment = NSTextAlignmentCenter;
        _noMesLabel.textColor = [UIColor grayColor];
        _noMesLabel.font = [UIFont systemFontOfSize:15.f];
        [_noMesLabel sizeToFit];
        _noMesLabel.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
        _noMesLabel.hidden = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshNet)];
        [_noMesLabel addGestureRecognizer:tapGes];
        [self.view addSubview:_noMesLabel];
    }
    return _noMesLabel;
}

- (UIView *)netAlertView {
    if (!_netAlertView) {
        
//        float originY = 20.f;
//        if (self.navigationController) {
//            originY = 64.f;
//        }
        _netAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44.f)];
        _netAlertView.backgroundColor = [UIColor colorWithHue:204/360.f saturation:78/100.f brightness:73/100.f alpha:0.2];
//        _netAlertView.backgroundColor = [UIColor colorWithHue:255/255.f saturation:223/255.f brightness:223/255.f alpha:0.2];
//        [FlatSkyBlue]204, 76, 86
//        FlatSkyBlueDark (204, 78, 73)
        _netAlertView.hidden = YES;
        
        UIImageView *alert = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        alert.center = CGPointMake(32.f, _netAlertView.frame.size.height/2);
        alert.image = [UIImage imageNamed:@"icon_alert"];
        
        UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+alert.frame.origin.x+alert.frame.size.width, 0, ScreenWidth -16 -alert.frame.origin.x - alert.frame.size.width, 15.f)];
        alertLabel.center = CGPointMake(alertLabel.center.x, _netAlertView.frame.size.height/2);
        alertLabel.text = @"当前网络不可用，请检查你的网络设置";
        alertLabel.font = [UIFont systemFontOfSize:15.f];
        alertLabel.textColor = [UIColor blackColor];
        [alertLabel sizeToFit];
        
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAlertView)];
        [_netAlertView addGestureRecognizer:tapgesture];
        [_netAlertView addSubview:alert];
        [_netAlertView addSubview:alertLabel];
        [self.view addSubview:_netAlertView];
    }
    return _netAlertView;
}


- (UIImageView *)imgLoadingView {
    if (!_imgLoadingView) {
        _imgLoadingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imgLoadingView.animationImages = self.customImgs;
        _imgLoadingView.animationDuration = 0.5*(self.customImgs.count/3.0);
        _imgLoadingView.center = CGPointMake(ScreenWidth/2, ScreenWidth/2);
        _imgLoadingView.hidden = YES;
        [self.view addSubview:_imgLoadingView];
    }
    return  _imgLoadingView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _statusLabel.font = [UIFont systemFontOfSize:13.f];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.center = CGPointMake(ScreenWidth/2, ScreenWidth/2);
        _statusLabel.text = @"正在加载...";
        _statusLabel.textColor = [UIColor lightGrayColor];
        _statusLabel.hidden = YES;
        [self.view addSubview:_statusLabel];
    }
    return  _statusLabel;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _indicatorView.center = CGPointMake(ScreenWidth/2+10+self.statusLabel.bounds.size.width/2, ScreenWidth/2);
        _indicatorView.hidden = YES;
        [self.view addSubview:_indicatorView];
    }
    
    return _indicatorView;
}


//触发刷新网络 模仿网络加载
- (void)refreshNet {
    NSLog(@"触发刷新网络 模仿网络加载");
}

//显示无网错误
- (void)showNetError {
    
    switch (self.errorTag) {
        case NotShowError:
            self.noMesImgView.hidden = YES;
            self.noMesLabel.hidden = YES;
            break;
        case ShowImg:
            self.noMesImgView.center = CGPointMake(ScreenWidth/2, ScreenWidth/2);
            // 让提示在控制器view的最顶层
            //[self.view bringSubviewToFront:self.noMesImgView];
            self.noMesImgView.hidden = NO;
            break;
        case ShowText:
            self.noMesLabel.center = CGPointMake(ScreenWidth/2, ScreenWidth/2);

            self.noMesLabel.hidden = NO;
            break;
        case ShowImgAndText:
            self.noMesImgView.center = CGPointMake(ScreenWidth/2, ScreenWidth/2);
            self.noMesLabel.center = CGPointMake(ScreenWidth/2, 10+self.noMesImgView.frame.origin.y+self.noMesImgView.frame.size.height);
            
            self.noMesImgView.hidden = NO;
            self.noMesLabel.hidden = NO;
            break;
        default:
            break;
    }
}

//隐藏无网错误
- (void)hideNetError {
    
    switch (self.errorTag) {
        case NotShowError:
            self.noMesImgView.hidden = YES;
            self.noMesLabel.hidden = YES;
            break;
        case ShowImg:
            self.noMesImgView.hidden = YES;
            break;
        case ShowText:
            self.noMesLabel.hidden = YES;
            break;
        case ShowImgAndText:
            self.noMesImgView.hidden = YES;
            self.noMesLabel.hidden = YES;
            break;
        default:
            break;
    }
    //刷新页面
    [self refreshNet];
}

//显示加载Loading
- (void)showLoading {
    
    switch (self.tag) {
        case AnimationLoadingType:
            if (self.AnimationImgs.count < 1) {
                NSLog(@"没有图片数组");
                break;
            }
            //customImgs赋值
            self.customImgs = [self.AnimationImgs copy];
            self.imgLoadingView.hidden = NO;
            [self.imgLoadingView startAnimating];
            self.imgLoadingView.center = CGPointMake(ScreenWidth/2, ScreenWidth/2);
            break;
        case TextLoadingType:
            self.statusLabel.hidden = NO;
            [self.statusLabel sizeToFit];
            self.indicatorView.hidden = NO;
            [self.indicatorView startAnimating];
            
            self.statusLabel.center = CGPointMake(ScreenWidth/2, ScreenWidth/2);
            self.indicatorView.center = CGPointMake(ScreenWidth/2+10+self.statusLabel.bounds.size.width/2, ScreenWidth/2);
            break;
        case AnimationAndTextType:
            if (self.AnimationImgs.count < 1) {
                NSLog(@"没有图片数组");
                break;
            }
            //customImgs赋值
            self.customImgs = [self.AnimationImgs copy];
            self.imgLoadingView.hidden = NO;
            [self.imgLoadingView startAnimating];
            self.imgLoadingView.center = CGPointMake(ScreenWidth/2, ScreenWidth/2);
            
            self.statusLabel.hidden = NO;
            [self.statusLabel sizeToFit];
            self.statusLabel.center = CGPointMake(ScreenWidth/2, 5+self.imgLoadingView.frame.origin.y+self.imgLoadingView.frame.size.height);
            
            break;
        default:
            break;
    }
}

//隐藏加载Loading
- (void)hideLoading {
    
    switch (self.tag) {
        case AnimationLoadingType:
            [self.imgLoadingView stopAnimating];
            self.imgLoadingView.hidden = YES;
            break;
        case TextLoadingType:
            [self.indicatorView stopAnimating];
            self.statusLabel.hidden = YES;
            self.indicatorView.hidden = YES;
            break;
        case AnimationAndTextType:
            [self.imgLoadingView stopAnimating];
            self.statusLabel.hidden = YES;
            break;
        default:
            break;
    }
}

//注册网络监测通知
- (void)registNetObserveWithRealReachability {
    
//    [RACObserve(SharedAppDelegate , networkStatus) subscribeNext:^(NSNumber *networkStatus) {
//        
//        if (networkStatus.integerValue == RealStatusNotReachable || networkStatus.integerValue == RealStatusUnknown) {
//            
//            [self.viewModel.requestDataCommand execute:@(RealStatusNotReachable)];
//            
//        }else{
//            
//            [self.viewModel.requestDataCommand execute:@1];
//            
//        }
//        [self networkChanged:SharedAppDelegate.networkStatus];
//        
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    if (status == RealStatusNotReachable)
    {
        NSLog(@"Network unreachable!");
        self.netType = NoNetWork;
        [self.view bringSubviewToFront:self.netAlertView];
        [UIView animateWithDuration:0.5f animations:^{
            self.netAlertView.hidden = NO;
        }];
        
        //显示无网提示信息
        [self showNetError];
    }
    
    if (status == RealStatusViaWiFi)
    {
        NSLog(@"Network wifi! Free!");
        self.netType = WiFi;
        self.netAlertView.hidden = YES;
    }
    
    if (status == RealStatusViaWWAN)
    {
        NSLog(@"Network WWAN! In charge!");
        self.netType = WWAN;
        self.netAlertView.hidden = YES;
    }
}

//网络情况
- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(previousStatus));
    
    if (status == RealStatusNotReachable)
    {
        NSLog(@"Network unreachable!");
        self.netType = NoNetWork;
        [self.view bringSubviewToFront:self.netAlertView];
        [UIView animateWithDuration:0.5f animations:^{
            self.netAlertView.hidden = NO;
        }];
        //显示无网提示信息
        [self showNetError];
    }
    
    if (status == RealStatusViaWiFi)
    {
        NSLog(@"Network wifi! Free!");
        self.netType = WiFi;
        self.netAlertView.hidden = YES;
        [self hideNetError];
        
    }
    
    if (status == RealStatusViaWWAN)
    {
        NSLog(@"Network WWAN! In charge!");
        self.netAlertView.hidden = YES;
        [self hideNetError];
    }
    
    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
    
    if (status == RealStatusViaWWAN)
    {
        if (accessType == WWANType2G)
        {
            NSLog(@"RealReachabilityStatus2G");
            self.netType = WWAN2G;
            self.netAlertView.hidden = YES;
            [self hideNetError];
        }
        else if (accessType == WWANType3G)
        {
            NSLog(@"RealReachabilityStatus3G");
            self.netType = WWAN3G;
            self.netAlertView.hidden = YES;
            [self hideNetError];
        }
        else if (accessType == WWANType4G)
        {
            NSLog(@"RealReachabilityStatus4G");
            self.netType = WWAN4G;
            self.netAlertView.hidden = YES;
            [self hideNetError];
        }
        else
        {
            NSLog(@"Unknown RealReachability WWAN Status, might be iOS6");
        }
    }
}

- (void)tapAlertView {
    NSLog(@"点击AlertView跳转到设置的WiFi界面");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
}



- (void)popToRootViewControllerAnimated:(BOOL)animated {
    
    [self.navigationController popToRootViewControllerAnimated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
#ifdef DEBUG
    
    [self debugWithString:@"[➡️] Did entered to" debugTag:kEnterControllerType];
    
#endif
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
#ifdef DEBUG
    
    [self debugWithString:@"[⛔️] Did left from" debugTag:kLeaveControllerType];
    
#endif
}

- (void)dealloc {
    
#ifdef DEBUG
    
    [self debugWithString:@"[❌] Did released the" debugTag:kDeallocType];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#endif
}

#pragma mark - Overwrite setter & getter.

@synthesize enableInteractivePopGestureRecognizer = _enableInteractivePopGestureRecognizer;

- (void)setEnableInteractivePopGestureRecognizer:(BOOL)enableInteractivePopGestureRecognizer {
    
    _enableInteractivePopGestureRecognizer                            = enableInteractivePopGestureRecognizer;
    self.navigationController.interactivePopGestureRecognizer.enabled = enableInteractivePopGestureRecognizer;
}

- (BOOL)enableInteractivePopGestureRecognizer {
    
    return _enableInteractivePopGestureRecognizer;
}

#pragma mark - Debug message.

- (void)debugWithString:(NSString *)string debugTag:(EDebugTag)tag {
    
    NSDateFormatter *outputFormatter  = [[NSDateFormatter alloc] init] ;
    outputFormatter.dateFormat        = @"HH:mm:ss.SSS";
    
    NSString        *classString = [NSString stringWithFormat:@" %@ %@ [%@] ", [outputFormatter stringFromDate:[NSDate date]], string, [self class]];
    NSMutableString *flagString  = [NSMutableString string];
    
    
    
    for (int i = 0; i < classString.length; i++) {
        
        if (i == 0 || i == classString.length - 1) {
            if (tag == kLeaveControllerType && i == 0) {
                long count = CFGetRetainCount((__bridge CFTypeRef)(self));
                [flagString appendString:[NSString stringWithFormat:@"retain count:%zd",count]];
            }
            [flagString appendString:@"+"];
            continue;
        }
        
        switch (tag) {
                
            case kEnterControllerType:
                [flagString appendString:@">"];
                break;
                
            case kLeaveControllerType:
                [flagString appendString:@"<"];
                break;
                
            case kDeallocType:
                [flagString appendString:@" "];
                break;
                
            default:
                break;
        }
    }
    
    NSString *showSting = [NSString stringWithFormat:@"\n%@\n%@\n%@\n", flagString, classString, flagString];
    NSLog(@"%@", showSting);
}

@end
