//
//  LTAnnImageObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnRectangleObject.h"
#import "LTAnnPicture.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnImageObject : LTAnnRectangleObject <NSCoding, NSCopying>

@property (nonatomic, strong, nullable) LTAnnPicture *picture;

@end

NS_ASSUME_NONNULL_END