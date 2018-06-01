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
#import <CoreGraphics/CoreGraphics.h>

enum {
	SPTaskDisplayModeInbox = 0,
	SPTaskDisplayModeTrash = 1,
	SPTaskDisplayModeHistory = 2
};
typedef int SPTaskDisplayMode;

enum {
	SPsize1200x900 = 0,
	SPsize1800x1200 = 1,
	SPsize2400x1800 = 2
};
typedef int SPSize;

enum {
	SPFormatA4 = 0,
	SPFormatA5 = 1,
	SPFormatID1 = 2,
    SPFormatAny = 3,
	SPFormatPicture = 4
};
typedef int SPFormat;

enum {
	SPResolution150 = 0,
	SPResolution200 = 1,
	SPResolution300 = 2
};
typedef int SPResolution;

enum {
	SPSubTaskTypePicture = 0,
	SPSubTaskTypeScan = 1,
	SPSubTaskTypeForm = 2
};
typedef int SPSubTaskType;

enum {
	SPErrorLevelNone = 0,
	SPErrorLevelWarning = 1,
	SPErrorLevelError = 2
};
typedef int SPErrorLevel;

enum {
	SPIdentTypeEmail = 0,
	SPIdentTypePhone = 1,
	SPIdentTypeGoogle = 2,
	SPIdentTypeFacebook = 3
};
typedef int SPIdentType;

enum {
	SPIndexTypeSingleText = 0,
	SPIndexTypeMultiText = 1,
	SPIndexTypeDate = 2,
	SPIndexTypeNumber = 3,
	SPIndexTypeList = 4
};
typedef int SPIndexType;

enum {
	SPColorModeBlackAndWhite = 0,
	SPColorModeGrey = 1,
	SPColorModeColor = 2
};
typedef int SPColorMode;

enum {
	SPStatusNone = -1, /* used to hide new task/service when not yet complete */
	SPStatusInProgress = 0, /* task is in progress and available in the inbox */
	SPStatusCompleted = 1, /* task is finalized and available in the history */
	SPStatusTrash = 2, /* task is in the trash */
	SPStatusActive = 3, /* used to show services only */
	SPStatusQueuedForDelete = 99 /* task is in queue for deletion and not available anymore */
};
typedef int SPStatus;

enum {
    SPSubscriptionFree = 0,
    SPSubscriptionPremium = 1,
    SPSubscriptionPro = 2,
    SPSubscriptionEnterprise = 3
};
typedef int SPSubscription;

@interface EnumHelper : NSObject
+ (CGSize)sizeFromSPsize:(SPSize)size;
+ (SPSize)sizeFromDescription:(NSString *)description;
+ (NSString *)descriptionFromSize:(SPSize)size;
+ (SPIdentType)identTypeFromDescription:(NSString *)description;
+ (NSString *)descriptionFromIdentType:(SPIdentType)type;
+ (NSString *)descriptionFromIndexType:(SPIndexType)type;
+ (SPIndexType)indexTypeFromDescription:(NSString *)description;
+ (NSString *)descriptionFromFormat:(SPFormat)format;
+ (SPFormat)formatFromDescription:(NSString *)description;
+ (int)valueFromResolution:(SPResolution)resolution;
+ (SPResolution)resolutionFromValue:(int)value;
+ (SPSubTaskType)subTaskTypeFromDescription:(NSString *)description;
+ (NSString *)descriptionFromSubTaskType:(SPSubTaskType)type;
+ (SPColorMode)colorModeFromDescription:(NSString *)description;
+ (NSString *)descriptionFromColorMode:(SPColorMode)colorMode;
+ (SPSubscription)subscriptionFromType:(NSString *)type;
@end
