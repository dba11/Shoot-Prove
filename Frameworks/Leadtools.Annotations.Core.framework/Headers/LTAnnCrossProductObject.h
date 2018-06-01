//
//  LTAnnCrossProductObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnPolyRulerObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnCrossProductObject : LTAnnPolyRulerObject <NSCopying, NSCoding>

@property (nonatomic, assign)                   LeadPointD firstStartPoint;
@property (nonatomic, assign)                   LeadPointD firstEndPoint;
@property (nonatomic, assign)                   LeadPointD secondStartPoint;
@property (nonatomic, assign)                   LeadPointD secondEndPoint;
@property (nonatomic, assign)                   LeadPointD intersectionPoint;

@property (nonatomic, copy, readonly, nullable) NSString *hitTestedRuler;

+ (NSString *)firstRulerHitTestObject;
+ (NSString *)secondRulerHitTestObject;

- (void)updateSecondPoints;

@end

NS_ASSUME_NONNULL_END