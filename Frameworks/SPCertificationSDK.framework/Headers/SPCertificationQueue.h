//
//  SPCertificationQueue.h
//  SPCertificationSDK
//
//  Created by Wallerand Réquillart on 28/03/2015.
//  Copyright (c) 2015 Erynnis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SPCertificationErrorDomain @"com.shootandprove.error"
#define SPCertificationWarningDomain @"com.shootandprove.warning"

enum {
	SPCertificationCriticalError = 0,
	SPCertificationWarningMissingGeolocation = 1,
	SPCertificationWarningDeniedGeolocation = 2,
	SPCertificationWarningLargerAccuracy = 3,
	SPCertificationWarningMissingTimestamp = 4,
	SPCertificationWarningMissingWatermark = 5,
	SPCertificationWarningMissingExif = 6
};
typedef NSInteger SPCertificationError;

@class SPCertificationItem;

@interface SPCertificationQueue : NSObject
- (NSString *)queue:(SPCertificationItem *)item;
@end
