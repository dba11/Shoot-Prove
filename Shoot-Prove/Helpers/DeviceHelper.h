//
//  DeviceHelper.h
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
#import <AVFoundation/AVFoundation.h>

@interface DeviceProperties : NSObject
@property (nonatomic, strong) NSString *buildNumber;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *preferredLanguage;
@end
@class User;
@class Device;
@interface DeviceHelper : NSObject
+ (DeviceProperties *)getDeviceProperties;
+ (Device *)getCurrentDevice;
+ (void)checkCameraGranted:(void (^)(BOOL granted))block;
+ (void)openDeviceSettings;
+ (NSString *)totalDiskSpace;
+ (NSString *)freeDiskSpace;
+ (NSString *)usedDiskSpace;
+ (CGFloat)totalDiskSpaceInBytes;
+ (CGFloat)freeDiskSpaceInBytes;
+ (CGFloat)usedDiskSpaceInBytes;
@end
