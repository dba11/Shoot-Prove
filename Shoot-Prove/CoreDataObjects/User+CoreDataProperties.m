/*************************************************************************
 *
 * SHOOT&PROVE CONFIDENTIAL
 * __________________
 *
 *  [2016]-[2018] Shoot&Prove SA/NV
 *  www.shootandprove.com
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains the property
 * of Shoot&Prove SA/NV. The intellectual and technical concepts contained
 * herein are proprietary to Shoot&Prove SA/NV.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Shoot&Prove SA/NV.
 */

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic avatar;
@dynamic avatar_email;
@dynamic avatar_data;
@dynamic betaUser;
@dynamic creationDate;
@dynamic credits;
@dynamic devUser;
@dynamic displayName;
@dynamic eulaAcceptDate;
@dynamic eulaAcceptVersion;
@dynamic firstName;
@dynamic lastName;
@dynamic lastUsageDate;
@dynamic locale;
@dynamic timeZone;
@dynamic uuid;
@dynamic devices;
@dynamic idents;
@dynamic remoteServices;
@dynamic remoteTasks;
@dynamic activeSubscription;

@end
