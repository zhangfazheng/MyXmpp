//
//  FMDBManager.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/17.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface FMDBManager : NSObject
@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (instancetype)shareInstance;

+ (NSString *)dbPath;

- (BOOL)changeDBWithDirectoryName:(NSString *)directoryName;
@end
