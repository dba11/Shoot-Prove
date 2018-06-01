//
//  LTAnnHotspotObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnImageObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnHotspotObject : LTAnnImageObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger defaultPicture;

@end

NS_ASSUME_NONNULL_END