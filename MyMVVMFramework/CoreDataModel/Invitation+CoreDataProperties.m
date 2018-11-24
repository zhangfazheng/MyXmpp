//
//  Invitation+CoreDataProperties.m
//  
//
//  Created by 张发政 on 2017/9/21.
//
//

#import "Invitation+CoreDataProperties.h"

@implementation Invitation (CoreDataProperties)

+ (NSFetchRequest<Invitation *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Invitation"];
}

@dynamic inviteMessage;
@dynamic inviterJid;
@dynamic inviteTime;
@dynamic inviteType;
@dynamic status;

@end
