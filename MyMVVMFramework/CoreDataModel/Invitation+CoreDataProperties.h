//
//  Invitation+CoreDataProperties.h
//  
//
//  Created by 张发政 on 2017/9/21.
//
//

#import "Invitation+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Invitation (CoreDataProperties)

+ (NSFetchRequest<Invitation *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *inviteMessage;
@property (nullable, nonatomic, copy) NSString *inviterJid;
@property (nullable, nonatomic, copy) NSString *inviteTime;
@property (nullable, nonatomic, copy) NSString *inviteType;
@property (nullable, nonatomic, copy) NSString *status;

@end

NS_ASSUME_NONNULL_END
