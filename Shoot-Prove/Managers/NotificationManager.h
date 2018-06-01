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

#import <Foundation/Foundation.h>

@class Task;

@protocol NotificationManagerDelegate <NSObject>
- (void)didNotificationManagerRequestStartTask:(Task *)task startNow:(BOOL)startNow;
- (void)didNotificationManagerRequestSyncTasks;
- (void)didNotificationManagerRequestSyncServices;
@end

@interface NotificationManager : NSObject

@property (nonatomic, weak) id<NotificationManagerDelegate> delegate;
@property (nonatomic, readonly) BOOL hasPendingNotification;

+ (instancetype)sharedManager;

- (void)registerAPNS;
- (void)registerDeviceToken:(NSData *)token;
- (void)resetDeviceToken;

- (void)registerNotification:(NSDictionary *)notification startNow:(BOOL)startNow;
- (void)processPendingNotification;

- (void)setNotificationCounterValue:(NSInteger)value;

@end
