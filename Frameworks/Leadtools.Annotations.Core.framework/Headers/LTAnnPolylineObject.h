//
//  LTAnnPolylineObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnPolylineObject : LTAnnObject <NSCoding, NSCopying>

@property (nonatomic, assign, getter=isClosed) BOOL closed;
@property (nonatomic, assign)                  LTAnnFillRule fillRule;

@end

NS_ASSUME_NONNULL_END