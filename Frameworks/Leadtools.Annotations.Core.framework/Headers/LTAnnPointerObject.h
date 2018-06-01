//
//  LTAnnPointerObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnPolylineObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnPointerObject : LTAnnPolylineObject <NSCoding, NSCopying>

@property (nonatomic, assign)           LeadLengthD arrowLength;
@property (nonatomic, assign)           LTAnnPointerPosition pointerPosition;

@property (nonatomic, strong, nullable) LTLeadPointCollection *arrowPoints;

@end

@interface LTAnnPointerObject (Deprecated)

- (nullable LTLeadPointCollection *)getArrowPoints LT_DEPRECATED_USENEW(19_0, "arrowPoints");

@end

NS_ASSUME_NONNULL_END