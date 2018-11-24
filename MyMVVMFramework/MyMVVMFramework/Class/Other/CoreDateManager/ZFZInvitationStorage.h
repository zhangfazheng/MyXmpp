//
//  ZFZInvitationStorage.h
//  MyMVVMFramework
//
//  Created by 张发政 on 2017/9/21.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFZInvitationStorage : NSObject
@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic,strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)insertCoreData:(NSMutableArray*)dataArray;
- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage;
-(void)deleteData;
@end
