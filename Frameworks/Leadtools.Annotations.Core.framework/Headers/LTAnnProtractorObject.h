//
//  LTAnnProtractorObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnPolyRulerObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnProtractorObject : LTAnnPolyRulerObject <NSCoding, NSCopying>

@property (nonatomic, assign)           BOOL acute;

@property (nonatomic, assign)           LeadPointD firstPoint;
@property (nonatomic, assign)           LeadPointD centerPoint;
@property (nonatomic, assign)           LeadPointD secondPoint;

@property (nonatomic, assign)           LeadLengthD arcRadius;

@property (nonatomic, assign)           LTAnnAngularUnit angularUnit;

@property (nonatomic, assign)           NSInteger anglePrecision;

@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, NSString *> *angularUnitsAbbreviation;

- (instancetype)initWithFirst:(LeadPointD)firstPoint center:(LeadPointD)centerPoint second:(LeadPointD)secondPoint NS_DESIGNATED_INITIALIZER;

- (double)rulerLengthFrom:(LeadPointD)startPoint to:(LeadPointD)endPoint scale:(double)calibrationScale;
- (NSString *)rulerLengthAsStringFrom:(LeadPointD)startPoint to:(LeadPointD)endPoint scale:(double)calibrationScale;


@end

@interface LTAnnProtractorObject (Deprecated)

- (double)getRulerLengthFrom:(LeadPointD)startPoint to:(LeadPointD)endPoint scale:(double)calibrationScale LT_DEPRECATED_USENEW(19_0, "rulerLengthFrom:to:scale:");
- (NSString *)getRulerLengthAsStringFrom:(LeadPointD)startPoint to:(LeadPointD)endPoint scale:(double)calibrationScale LT_DEPRECATED_USENEW(19_0, "rulerLengthAsStringFrom:to:scale:");

@end

NS_ASSUME_NONNULL_END