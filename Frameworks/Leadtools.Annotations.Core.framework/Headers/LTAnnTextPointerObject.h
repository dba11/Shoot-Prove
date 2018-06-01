//
//  LTAnnTextPointerObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnTextObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnTextPointerObject : LTAnnTextObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL fixedPointer;

@property (nonatomic, assign) LeadPointD pointerPosition;

@end

NS_ASSUME_NONNULL_END