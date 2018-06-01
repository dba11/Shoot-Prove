//
//  LTAnnRectangleObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnRectangleObject : LTAnnObject <NSCoding, NSCopying>

@property (nonatomic, assign, readonly) BOOL isFlipped;
@property (nonatomic, assign, readonly) BOOL isReversed;

@property (nonatomic, assign, readonly) double angle;

@property (nonatomic, assign)           LeadRectD rect;

@end

NS_ASSUME_NONNULL_END