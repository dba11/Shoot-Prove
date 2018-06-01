//
//  LTAnnHiliteObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnRectangleObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnHiliteObject : LTAnnRectangleObject <NSCoding,NSCopying>

@property (nonatomic, copy) NSString *hiliteColor;

@end

NS_ASSUME_NONNULL_END