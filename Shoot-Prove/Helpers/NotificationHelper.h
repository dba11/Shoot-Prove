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

enum {
	SPNotificationIntendNone = 0,
	SPNotificationIntendTask = 1,
	SPNotificationIntendTemplate = 2,
	SPNotificationIntendREM = 3,
};
typedef int SPNotificationIntend;

@interface NotificationHelper : NSObject
+ (SPNotificationIntend)notificationIntend:(NSDictionary *)notification;
+ (NSString *)notificationIdentifier:(NSDictionary *)notification;
+ (BOOL)isNotificationSilent:(NSDictionary *)notification;
@end
