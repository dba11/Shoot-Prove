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

#import "CleanAndRepairHelper.h"
#import "StoreManager.h"
#import "SettingsManager.h"
#import "NetworkManager.h"
#import "DeviceHelper.h"
#import "ImageHelper.h"
#import "User.h"
#import "Subscription.h"
#import "Task.h"
#import "AbstractSubTask.h"
#import "AbstractSubTaskCapture.h"
#import "Rendition.h"
#import "CaptureImage.h"
#import "Service.h"

@implementation CleanAndRepairHelper
+ (void)cleanAndRepair:(NSError **)error {
	BOOL needSave = NO;
	needSave = needSave || [self recoverMissingTaskIconData];
	needSave = needSave || [self cleanInactiveTasks];
    needSave = needSave || [self setTasksAndServicesStyle];
    [StoreManager.sharedManager removeTempImages];
	if(needSave) {
		[StoreManager.sharedManager saveContext:error];
		[StoreManager.sharedManager cleanSharedDirectoy];
		[StoreManager.sharedManager syncSharedDirectory];
	}
}

+ (BOOL)recoverMissingTaskIconData {
	BOOL needSave = NO;
	NSString *currentBuildVersion = [[DeviceHelper getDeviceProperties] buildNumber];
	NSString *lastBuildVersion = [[SettingsManager sharedManager] lastBuildVersion];
	BOOL recoverRequired = ![currentBuildVersion isEqualToString:lastBuildVersion];
	if(recoverRequired) {
		NSArray *tasks = [StoreManager.sharedManager fetchAllTasks:nil];
		for(Task *task in tasks) {
			if(!task.icon_data || !task.icon_mime) {
				CaptureImage *firstImage = task.firstCaptureImage;
				if(firstImage) {
					task.icon_data = firstImage.data;
                    task.icon_mime = firstImage.mimetype;
					needSave = YES;
				}
			}
		}
	}
	[SettingsManager.sharedManager setLastBuildVersion:currentBuildVersion];
	return needSave;
}

+ (BOOL)cleanInactiveTasks {
	BOOL needSave = NO;
	NSArray *tasks = [StoreManager.sharedManager fetchInactiveTasks:nil];
    for(Task *task in tasks) {
        NSError *error = [StoreManager.sharedManager deleteTask:task];
        needSave = !error;
    }
	return needSave;
}

+ (BOOL)migrateFreeToSubscriptionUser:(User *)user {
    if(!user.activeSubscription)
        return NO;
    BOOL needSave = NO;
    NSArray *tasks = [StoreManager.sharedManager fetchAllTasks:nil];
    for(Task *task in tasks) {
        if(!task.uuid && !task.serviceId && [task.status isEqualToNumber:[NSNumber numberWithInt:SPStatusCompleted]]) {
            for(Rendition *rendition in task.renditions) {
                [StoreManager.sharedManager deleteRendition:rendition];
            }
            task.finished = @0;
            needSave = YES;
        }
    }
    return needSave;
}

+ (BOOL)setTasksAndServicesStyle {
    BOOL needSave = NO;
    NSArray *services = [StoreManager.sharedManager fetchActiveServices:nil];
    for(Service *service in services) {
        if(!service.uiStyle) {
            service.uiStyle = [StoreManager.sharedManager createNewStyle];
            needSave = YES;
        }
    }
    NSArray *tasks = [StoreManager.sharedManager fetchAllTasks:nil];
    for(Task *task in tasks) {
        if(!task.uiStyle) {
            task.uiStyle = [StoreManager.sharedManager createNewStyle];
            needSave = YES;
        }
    }
    return needSave;
}
@end
