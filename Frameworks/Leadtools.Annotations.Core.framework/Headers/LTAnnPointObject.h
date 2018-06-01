//
//  LTAnnPointObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnObject.h"
#import "LTAnnPicture.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnPointObject : LTAnnObject <NSCoding, NSCopying>

@property (nonatomic, assign)           BOOL showPicture;

@property (nonatomic, assign)           NSInteger defaultPicture;

@property (nonatomic, assign)           LeadPointD centerPoint;
@property (nonatomic, assign)           LeadLengthD radius;

@property (nonatomic, strong, nullable) LTAnnPicture *picture;

@end

NS_ASSUME_NONNULL_END