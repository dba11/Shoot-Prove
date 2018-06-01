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

#import "DeviceHelper.h"
#import "StoreManager.h"
#import "Device.h"
#import "User.h"
#import "SSKeychain.h"
#import "NSString+SHA256.h"
#import <sys/utsname.h>

struct utsname systemInfo;

#define MB (1024*1024)
#define GB (MB*1024)

@implementation DeviceProperties
@synthesize buildNumber, type, name, token, uid, preferredLanguage;
@end

@implementation DeviceHelper
+ (NSString *)getDeviceUUID {
	NSString *account = @"com.shootandprove";
	NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
	NSString *appUUID = [SSKeychain passwordForService:appName account:account];
	if (appUUID == nil) {
		appUUID  = [[NSUUID UUID] UUIDString];
		[SSKeychain setPassword:appUUID forService:appName account:account];
	}
	return appUUID;
}

+ (DeviceProperties *)getDeviceProperties {
	DeviceProperties *props = [[DeviceProperties alloc] init];
	props.name = [[UIDevice currentDevice] name];
	props.uid = [DeviceHelper getDeviceUUID];
	uname(&systemInfo);
	props.type = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
	props.token = [props.uid SHA256];
	props.buildNumber = [NSString stringWithFormat:@"%@.%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
	props.preferredLanguage = [[NSLocale preferredLanguages] firstObject];
	return props;
}

+ (Device *)getCurrentDevice {
	DeviceProperties *deviceProperties = [DeviceHelper getDeviceProperties];
	NSArray *devices = [StoreManager.sharedManager fetchDevices];
	for(Device *device in devices) {
		if([device.uid isEqualToString:deviceProperties.uid]) {
			return device;
			break;
		}
	}
	return nil;
}

+ (void)openDeviceSettings {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]];
}

+ (void)checkCameraGranted:(void (^)(BOOL granted))block {
	AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
	if(status != AVAuthorizationStatusAuthorized) {
		[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
			dispatch_async(dispatch_get_main_queue(), ^{
				block(granted);
			});
		}];
	} else {
		block(YES);
	}
}

+ (NSString *)memoryFormatter:(long long)diskSpace {
	NSString *formatted;
	double bytes = 1.0 * diskSpace;
	double megabytes = bytes / MB;
	double gigabytes = bytes / GB;
	if (gigabytes >= 1.0)
		formatted = [NSString stringWithFormat:@"%.2f GB", gigabytes];
	else if (megabytes >= 1.0)
		formatted = [NSString stringWithFormat:@"%.2f MB", megabytes];
	else
		formatted = [NSString stringWithFormat:@"%.2f bytes", bytes];
	return formatted;
}

#pragma mark - Methods
+ (NSString *)totalDiskSpace {
	long long space = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemSize] longLongValue];
	return [self memoryFormatter:space];
}

+ (NSString *)freeDiskSpace {
	long long freeSpace = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemFreeSize] longLongValue];
	return [self memoryFormatter:freeSpace];
}

+ (NSString *)usedDiskSpace {
	return [self memoryFormatter:[self usedDiskSpaceInBytes]];
}

+ (CGFloat)totalDiskSpaceInBytes {
	long long space = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemSize] longLongValue];
	return space;
}

+ (CGFloat)freeDiskSpaceInBytes {
	long long freeSpace = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemFreeSize] longLongValue];
	return freeSpace;
}

+ (CGFloat)usedDiskSpaceInBytes {
	long long usedSpace = [self totalDiskSpaceInBytes] - [self freeDiskSpaceInBytes];
	return usedSpace;
}
@end
