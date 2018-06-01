//
//  LTAnnCurveObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnPolylineObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnCurveObject : LTAnnPolylineObject <NSCoding, NSCopying>

@property (nonatomic, assign) double tension;

@end

NS_ASSUME_NONNULL_END