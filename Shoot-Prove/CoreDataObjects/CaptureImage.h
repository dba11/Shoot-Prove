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

#import "EnumHelper.h"
@class CertificationError, Task, AbstractSubTaskCapture;

NS_ASSUME_NONNULL_BEGIN

@interface CaptureImage : NSManagedObject
- (NSString *)name;
- (NSString *)privatePath;
- (NSString *)publicPath;
- (UIImage *)image;
- (NSData *)data;
- (NSNumber *)size;
- (NSDictionary *)dictionary;
- (BOOL)isNew;
- (BOOL)isSync;
- (SPFormat)format;
- (SPResolution)resolution;
- (SPColorMode)colorMode;
@end

NS_ASSUME_NONNULL_END

#import "CaptureImage+CoreDataProperties.h"
