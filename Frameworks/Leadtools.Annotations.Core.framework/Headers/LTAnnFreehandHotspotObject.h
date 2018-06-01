//
//  LTAnnFreehandHotspotObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnPolylineObject.h"
#import "LTAnnPicture.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnFreehandHotspotObject : LTAnnPolylineObject <NSCoding, NSCopying>

@property (nonatomic, strong, nullable) LTAnnPicture *picture;
@property (nonatomic, assign)           NSInteger defaultPicture;

@end

NS_ASSUME_NONNULL_END