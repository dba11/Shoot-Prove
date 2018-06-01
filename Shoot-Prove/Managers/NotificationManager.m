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

#import "NotificationManager.h"

#import "RestClientManager.h"
#import "StoreManager.h"

#import "NotificationHelper.h"
#import "DeviceHelper.h"
#import "EnumHelper.h"

#import "User.h"
#import "Device.h"
#import "Task.h"

@interface NotificationManager() {
    
    User *_user;
	NSDictionary *_notification;
	BOOL _startNow;
	
}
@end

@implementation NotificationManager
@synthesize delegate;

+ (instancetype)sharedManager {
	
	static id manager = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		manager = [[NotificationManager alloc] init];
	});
	
	return manager;
	
}

- (id)init {
    
    self = [super init];
    if(self) {
        _user = [[StoreManager sharedManager] fetchUser];
    }
    return self;
    
}

- (void)registerAPNS {
	
	UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge |  UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
	UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
	[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
	
}

- (void)registerDeviceToken:(NSData *)token {
	
	Device *device = [DeviceHelper getCurrentDevice];
	
	if(device && [token length]>0) {
		
		const char *data = [token bytes];
		NSMutableString *deviceToken = [NSMutableString string];
		
		for (NSUInteger i=0; i<[token length]; i++) {
			[deviceToken appendFormat:@"%02.2hhX", data[i]];
		}
		
		if(![device.nsToken isEqualToString:deviceToken] && [deviceToken length]>0) {
			
			device.nsToken = deviceToken;
			
			[[RestClientManager sharedManager] putDevice:device block:^(Device *device, NSInteger statusCode, NSError *error) {
				
				if(!error) {
					NSLog(@"New APNS: %@", deviceToken);
                }
				
			}];
			
		} else {
			
			NSLog(@"Current APNS: %@", device.nsToken);
			
		}
		
	} else {
		
		NSLog(@"APNS error: no device");
		
	}
	
}

- (void)resetDeviceToken {
    
    Device *device = [DeviceHelper getCurrentDevice];
    
    if(device) {
        
        device.nsToken = nil;
        
        [[RestClientManager sharedManager] putDevice:device block:^(Device *device, NSInteger statusCode, NSError *error) {
            
            if(!error) {
                NSLog(@"Device APNS has been deactivated");
            }
            
        }];
        
    } else {
        
        NSLog(@"APNS error: no device");
        
    }
    
}

- (BOOL)hasPendingNotification {
	return (_notification != nil);
}

- (void)registerNotification:(NSDictionary *)notification startNow:(BOOL)startNow {
	
	_notification = notification;
	_startNow = startNow;
	
	//NSLog(@"Notification Manager has registered: %@", [_notification description]);
	
}

- (void)processPendingNotification {
	
	if(![self hasPendingNotification])
		return;
	
	//NSLog(@"Notification Manager is processing: %@", _notification);
	
	//get the notification intend
	SPNotificationIntend intend = [NotificationHelper notificationIntend:_notification];
	
	//is notification silent ?
	BOOL isNotificationSilent = [NotificationHelper isNotificationSilent:_notification];
	
	//get the notification identifier (if any)
	NSString *identifier = nil;
	if(!isNotificationSilent) {
		identifier = [NotificationHelper notificationIdentifier:_notification];
	}
	
	switch (intend) {

		case SPNotificationIntendTask: {

			if(identifier) {
				
                //check if task to start is not already registered locally
                Task *task = nil;
                
                NSArray *tasks = [[StoreManager sharedManager] fetchAllTasks:nil];
                
                for(Task *userTask in tasks) {
                    if([userTask.uuid isEqualToString:identifier]) {
                        task = userTask;
                        break;
                    }
                }
                
                if(!task) {
                    
                    [[RestClientManager sharedManager] getNewTask:identifier block:^(Task *task, NSInteger statusCode, NSError *error) {
                        
                        [self handleNotifiedTask:task startNow:_startNow error:error];
                        
                    }];
                    
                } else {
                    
                    [[RestClientManager sharedManager] getUpdatedTask:task block:^(Task *task, NSInteger statusCode, NSError *error) {
                        
                        [self handleNotifiedTask:task startNow:_startNow error:error];
                        
                    }];
                    
                }
				
			} else {
				
				//sync tasks only
				if([self.delegate respondsToSelector:@selector(didNotificationManagerRequestSyncTasks)]) {
					[self.delegate didNotificationManagerRequestSyncTasks];
				}
				
			}
			
		}
			break;
		
		case SPNotificationIntendTemplate: {
			
            //sync templates only
            if([self.delegate respondsToSelector:@selector(didNotificationManagerRequestSyncServices)]) {
                [self.delegate didNotificationManagerRequestSyncServices];
            }
            
		}
			break;
		
		case SPNotificationIntendREM: {
			
			if(!([identifier isEqualToString:@""] || isNotificationSilent)) {
				
				// process rem - not implemented yet (concept not even defined)
				
			} else {
				
				//sync rem only
				
			}
			
		}
			break;
			
	default: //SPNotificationNone for unknown intend
			break;
			
	}
	
	_notification = nil;
	
}

- (void)handleNotifiedTask:(Task *)task startNow:(BOOL)startNow error:(NSError *)error {
    
    NSString *deviceUid = [[DeviceHelper getCurrentDevice] uid];
    
    if(error) {
        
        NSLog(@"NotificationManager.processPendingNotification.error: %@", [error localizedDescription]);
        
    } else if(![task.status isEqualToNumber:[NSNumber numberWithInt:SPStatusInProgress]]) {
        
        NSLog(@"NotificationManager.processPendingNotification.taskStatus: %@", task.status);
        
    } else if([task.sourceDevice isEqualToString:deviceUid]) {
        
        NSLog(@"NotificationManager.processPendingNotification.taskDeviceIsCurrent");
        
    } else if([self.delegate respondsToSelector:@selector(didNotificationManagerRequestStartTask:startNow:)]) {
        
        [self.delegate didNotificationManagerRequestStartTask:task startNow:startNow];
        
    }
    
}

- (void)setNotificationCounterValue:(NSInteger)value {
	[UIApplication sharedApplication].applicationIconBadgeNumber = value;
}

@end
