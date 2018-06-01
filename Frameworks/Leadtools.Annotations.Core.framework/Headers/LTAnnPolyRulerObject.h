//
//  LTAnnPolyRulerObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnPolylineObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnPolyRulerObject : LTAnnPolylineObject <NSCoding, NSCopying>

@property (nonatomic, assign)           BOOL showTickMarks;
@property (nonatomic, assign)           BOOL showGauge;

@property (nonatomic, assign)           LeadLengthD tickMarksLength;
@property (nonatomic, assign)           LeadLengthD gaugeLength;

@property (nonatomic, assign)           NSInteger precision;

@property (nonatomic, assign)           LTAnnUnit measurementUnit;
@property (nonatomic, strong, nullable) LTAnnStroke *tickMarksStroke;

@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, NSString *> *unitsAbbreviation;

- (LeadLengthD)rulerLength:(double)calibrationScale;
- (NSString *)rulerLengthAsString:(double)calibrationScale;

@end

@interface LTAnnPolyRulerObject (Deprecated)

- (LeadLengthD)getRulerLength:(double)calibrationScale LT_DEPRECATED_USENEW(19_0, "rulerLength:");
- (nullable NSString *)getRulerLengthAsString:(double)calibrationScale LT_DEPRECATED_USENEW(19_0, "rulerLengthAsString:");

@end

NS_ASSUME_NONNULL_END