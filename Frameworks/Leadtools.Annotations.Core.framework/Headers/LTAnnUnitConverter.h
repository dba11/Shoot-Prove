//
//  LTAnnUnitConverter.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"

@interface LTAnnUnitConverter : NSObject

+ (NSDictionary<NSNumber *, NSString *> *)getUnits;

+ (double)convert:(double)value sourceUnit:(LTAnnUnit)sourceUnit destinationUnit:(LTAnnUnit)destinationUnit;
+ (double)convertToPixels:(double)value sourceUnit:(LTAnnUnit)sourceUnit dpi:(double)dpi;
+ (double)convertFromPixels:(double)value destinationUnit:(LTAnnUnit)destinationUnit dpi:(double)dpi;
+ (double)convertAngularUnit:(double)value sourceUnit:(LTAnnAngularUnit)sourceUnit destinationUnit:(LTAnnAngularUnit)destinationUnit;

+ (NSString *)getUnitAbbreviation:(LTAnnUnit)unit;
+ (NSString *)getAngularUnitAbbreviation:(LTAnnAngularUnit)unit;

+ (void)setUnitAbbreviation:(LTAnnUnit)unit value:(NSString *)newValue;

@end
