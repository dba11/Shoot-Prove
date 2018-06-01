//
//  LTAnnMediaObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnObject.h"
#import "LTAnnHotspotObject.h"
#import "LTAnnMedia.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnMediaObject : LTAnnHotspotObject <NSCoding, NSCopying>

@property (nonatomic, strong) LTAnnMedia *media;

@end

NS_ASSUME_NONNULL_END