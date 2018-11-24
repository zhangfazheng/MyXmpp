//
//  HomePageViewModel.m
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/10/9.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import "HomePageViewModel.h"
#import "NetWorkManager.h"
#import "MBProgressHUD+MJ.h"
#import "Interface.h"
#import "HomePageViewModel.m"
#import "HomePageToolCellModel.h"
#import "HomePageToolCell.h"


@interface HomePageViewModel ()
@property (assign,nonatomic) CGFloat topButtonInset;
@property (assign,nonatomic) CGFloat lineSpace;
// 格子的宽高
@property (assign,nonatomic) CGFloat appViewWH;
@property (assign,nonatomic) CGFloat toolTileHeight;
// 每列有三个格子
@property (assign,nonatomic) NSInteger column;
@end

@implementation HomePageViewModel

- (void)initialize{
    //获取本地数据
    NSArray *localUserAuthorityArry = [self getLocalUserAuthorityData];
    if (localUserAuthorityArry) {
        self.apps = [[self configAppData:localUserAuthorityArry] mutableCopy];
    }
}


- (instancetype)initWithServices:(id<ViewModelServices>)services params:(NSDictionary *)params{
    if(self = [super initWithServices:services params:params]){
        _topButtonInset         = 8;
        _lineSpace              = 20;
        // 格子的宽高
        _appViewWH              = 75;
        _toolTileHeight         = 44;
        // 每列有三个格子
        _column                 = 4;
        
    }

    return self;
}

//若要实现网络数据请求需实现些方法
- (RACSignal *)executeRequestDataSignal:(id)input
{
    WeakSelf
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        //获取用户权限更新时间请求
        [[NetWorkManager shareManager]requestWithType:HttpRequestTypePost withUrlString:GetUserAuthorityUpdateTime withParaments:nil withSuccessBlock:^(NSDictionary *object) {
            //获取本地保存的上次更新时间
            NSTimeInterval authorityUpdateTime = [[NSUserDefaults standardUserDefaults]doubleForKey:@"authorityUpdateTime"];
            NSTimeInterval getAuthorityUpdateTime = [object[@"data"] doubleValue];
            //如果上次更新时间为不空，并且上次更新时间与本次时间对比不变，并且本场缓存不为空时路过请求获取权限数据
            if (authorityUpdateTime && getAuthorityUpdateTime == authorityUpdateTime && weakSelf.apps) {
                [subscriber sendCompleted];
            }else{
                //重新设置权限更新时间
                [[NSUserDefaults standardUserDefaults]setDouble:getAuthorityUpdateTime forKey:@"authorityUpdateTime"];
                //获取用户权限请求
                [[NetWorkManager shareManager]requestWithType:HttpRequestTypePost withUrlString:GetOnlineUserApp withParaments:nil withSuccessBlock:^(NSDictionary *object) {
                    //对请数据进行格式化
                    if ([object[@"success"] boolValue]) {
                        //数据本地保存
                        if (object[@"data"]) {
                            [weakSelf saveLocalUserAuthorityData:object[@"data"]];
                            NSArray<NSArray<CellDataAdapter *>*> *apps = [self configAppData: object[@"data"]];
                            
                            [subscriber sendNext:apps];
                        }
                        
                        
                        
                        [subscriber sendCompleted];
                    }else{
                        
                        //提示错误信息
                        if (!isEmptyString(object[@"stateCode"][@"msg"])) {
                            [MBProgressHUD showNoImageMessage:object[@"stateCode"][@"msg"]];
                        }
                        [subscriber sendCompleted];
                        [MBProgressHUD hideHUD];
                    }
                    
                } withFailureBlock:^(NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showNoImageMessage:@"数据加载失败"];
                } progress:nil];
            }
            
            
        } withFailureBlock:^(NSError *error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
            [MBProgressHUD hideHUD];
            [MBProgressHUD showNoImageMessage:@"数据加载失败"];
        } progress:^(float progress) {
            
        }];
        
        
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"查询用户信息的请求信号已经被销毁");
        }];
    }];
    
    return signal;
}




#pragma mark - 数据比较
- (NSArray *)getLocalUserAuthorityData{
    //2.获取documents路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //3.拼接文件名
    
    NSString * filePath = [path stringByAppendingPathComponent:@"LocalUserAuthorityData.plist"];
    
    
    //3.读取
    NSArray * localUserAuthorityArry = [NSArray arrayWithContentsOfFile:filePath];
    
    return localUserAuthorityArry;
   
}

#pragma mark - 更新用户权限数据
- (void)saveLocalUserAuthorityData:(NSArray *)data{
    //2.获取documents路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //3.拼接文件名
    NSString * filePath = [path stringByAppendingPathComponent:@"LocalUserAuthorityData.plist"];
    //4.存储 参数2:是否允许原子型写入
    [data writeToFile:filePath atomically:YES];
}


#pragma mark- 解析app应用数据
- (NSArray<NSArray<CellDataAdapter *>*> *)configAppData:(NSArray *)data{
    //获取应用图标配置文件
    // 1.获取plist文件的全路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HomeIconPathSetting" ofType:@"plist"];
    // 2.读取plist
    NSDictionary *iconDict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSMutableArray<NSArray<CellDataAdapter *>*> *appGroupArray = [NSMutableArray arrayWithCapacity:data.count];
    
    for (NSDictionary *group in data) {
        HomePageToolCellModel *groupModel = [[HomePageToolCellModel alloc]init];
        
        groupModel.toolGroupId = group[@"id"];
        groupModel.toolTitle   = group[@"groupName"];
        NSArray *appsData = group[@"appList"];
        
        //app数据的加工
        NSMutableArray *homeToolArry = [NSMutableArray arrayWithCapacity:appsData.count];
        for (NSDictionary *app in appsData) {
            HomePageToolModel *appModel = [[HomePageToolModel alloc]init];
            appModel.toolName = app[@"name"];
            appModel.icon = isEmptyString(iconDict[app[@"code"]])?@"gz_icon_crm_khgl":iconDict[app[@"code"]];
            [homeToolArry addObject:appModel];
        }
        groupModel.homeToolArry = homeToolArry;
        
        groupModel.toolViewWH        = self.appViewWH;
        groupModel.showCount         = 4;
        groupModel.rowCount          = (int)self.column;
        groupModel.lineSpace         = self.lineSpace;
        groupModel.topBottomSpace    = self.topButtonInset;
        
        CGFloat toolHeight = ((groupModel.homeToolArry.count+3)/self.column)*self.appViewWH+((groupModel.homeToolArry.count+3)/self.column-1)*self.lineSpace+self.topButtonInset*2+self.toolTileHeight;
        groupModel.toolHeight =toolHeight-self.toolTileHeight;
        
        CellDataAdapter *adapter=[HomePageToolCell dataAdapterWithCellReuseIdentifier:nil data:groupModel cellHeight:toolHeight type:0];
        NSArray * ToolCellData = @[adapter];
        
        [appGroupArray addObject:ToolCellData];
        
    }

    return appGroupArray;
}


@end
