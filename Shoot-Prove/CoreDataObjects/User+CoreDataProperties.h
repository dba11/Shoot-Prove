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

#import "User.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *avatar;
@property (nullable, nonatomic, copy) NSString *avatar_email;
@property (nullable, nonatomic, retain) NSData *avatar_data;
@property (nullable, nonatomic, copy) NSNumber *betaUser;
@property (nullable, nonatomic, copy) NSDate *creationDate;
@property (nullable, nonatomic, copy) NSNumber *credits;
@property (nullable, nonatomic, copy) NSNumber *devUser;
@property (nullable, nonatomic, copy) NSString *displayName;
@property (nullable, nonatomic, copy) NSDate *eulaAcceptDate;
@property (nullable, nonatomic, copy) NSNumber *eulaAcceptVersion;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSDate *lastUsageDate;
@property (nullable, nonatomic, copy) NSString *locale;
@property (nullable, nonatomic, copy) NSString *timeZone;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, retain) NSSet<Device *> *devices;
@property (nullable, nonatomic, retain) NSSet<Ident *> *idents;
@property (nullable, nonatomic, retain) NSSet<RemoteService *> *remoteServices;
@property (nullable, nonatomic, retain) NSSet<RemoteTask *> *remoteTasks;
@property (nullable, nonatomic, retain) Subscription *activeSubscription;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addDevicesObject:(Device *)value;
- (void)removeDevicesObject:(Device *)value;
- (void)addDevices:(NSSet<Device *> *)values;
- (void)removeDevices:(NSSet<Device *> *)values;

- (void)addIdentsObject:(Ident *)value;
- (void)removeIdentsObject:(Ident *)value;
- (void)addIdents:(NSSet<Ident *> *)values;
- (void)removeIdents:(NSSet<Ident *> *)values;

- (void)addRemoteServicesObject:(RemoteService *)value;
- (void)removeRemoteServicesObject:(RemoteService *)value;
- (void)addRemoteServices:(NSSet<RemoteService *> *)values;
- (void)removeRemoteServices:(NSSet<RemoteService *> *)values;

- (void)addRemoteTasksObject:(RemoteTask *)value;
- (void)removeRemoteTasksObject:(RemoteTask *)value;
- (void)addRemoteTasks:(NSSet<RemoteTask *> *)values;
- (void)removeRemoteTasks:(NSSet<RemoteTask *> *)values;

@end

NS_ASSUME_NONNULL_END
