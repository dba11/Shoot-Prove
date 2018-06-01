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

#import "AppDelegate.h"
#import "RootViewController.h"
#import "StoreManager.h"
#import "DeviceHelper.h"
#import "NotificationManager.h"
#import "RestClientManager.h"
#import "SyncManager.h"
#import "RequestManager.h"
#import "UIColor+HexString.h"
#import "StyleHelper.h"
#import "Device.h"

@interface AppDelegate()
{
	RootViewController *_rootViewController;
    BOOL _appIsAlreadyRunning;
}
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _appIsAlreadyRunning = NO;
    [StyleHelper setDefaultStyleOnViewController:nil];

	_rootViewController = [[RootViewController alloc] init];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_rootViewController];
	[navigationController setNavigationBarHidden:YES];
	[navigationController setToolbarHidden:YES];
	
	NSDictionary *notification = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
	[NotificationManager.sharedManager setDelegate:_rootViewController];
	if(notification)
		[NotificationManager.sharedManager registerNotification:notification startNow:YES];
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.window setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[self.window setRootViewController:navigationController];
    
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	[SyncManager.sharedManager syncTasks:YES andServices:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    _appIsAlreadyRunning = YES;
	[StoreManager.sharedManager saveContext:nil];
    [SyncManager.sharedManager syncTasks:YES andServices:YES];
}

#pragma - push notification registration methods.
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings {
	if(notificationSettings.types != UIUserNotificationTypeNone) {
		[UIApplication.sharedApplication registerForRemoteNotifications];
	}
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	[NotificationManager.sharedManager registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [NotificationManager.sharedManager resetDeviceToken];
}

#pragma - application is runnning while receiving a push notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[NotificationManager.sharedManager registerNotification:userInfo startNow:NO];
    [NotificationManager.sharedManager setDelegate:_rootViewController];
    [NotificationManager.sharedManager processPendingNotification];
}

#pragma - delegate to catch app started via URL and parameters. ex: ShootAndProve://?task=1234...;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [url.query componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        [queryStringDictionary setObject:value forKey:key];
    }
    NSString *request = [queryStringDictionary valueForKey:@"request"];
    if(request.length>0) {
        [RequestManager.sharedManager registerRequest:request];
        if(_appIsAlreadyRunning) {
            [RequestManager.sharedManager setDelegate:_rootViewController];
            [RequestManager.sharedManager processPendingRequest];
        }
    }
    return YES;
}
@end
