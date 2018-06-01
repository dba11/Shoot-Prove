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

@interface FreeCaptureImage : NSObject
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *mimetype;

@property (nonatomic) SPFormat format;
@property (nonatomic) SPResolution resolution;
@property (nonatomic) SPColorMode colorMode;
@property (nonatomic) SPSize size;

@property (strong, nonatomic) NSString *md5;
@property (strong, nonatomic) NSNumber *accuracy;
@property (nonatomic) BOOL certified;
@property (strong, nonatomic) NSDate *creationDate;
@property (strong, nonatomic) NSNumber *errorLevel;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *sha1;
@property (strong, nonatomic) NSDate *timestamp;
@property (strong, nonatomic) NSMutableArray *errors;

- (instancetype)initWithMimeType:(NSString *)mimeType;

@end
