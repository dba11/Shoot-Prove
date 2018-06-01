//
//  LTOcrZoneManager.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrOmrOptions.h"
#import "LTOcrZoneType.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrZoneManager : NSObject

@property (nonatomic, strong, readonly) LTOcrOmrOptions *omrOptions;

@property (nonatomic, copy, readonly)  NSArray<NSNumber *> *supportedZoneTypes;

- (BOOL)isZoneTypeSupported:(LTOcrZoneType)zoneType;

@end

NS_ASSUME_NONNULL_END