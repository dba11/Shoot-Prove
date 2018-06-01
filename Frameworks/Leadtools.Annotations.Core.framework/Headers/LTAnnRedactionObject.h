//
//  LTAnnRedactionObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnRectangleObject.h"
#import "LTAnnContainerMapper.h"

@class LTRasterImage;

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnRedactionObject : LTAnnRectangleObject <NSCoding, NSCopying>

@property (nonatomic, assign, readonly) BOOL isRealized;
@property (nonatomic, assign, readonly) BOOL canRestore;

@property (nonatomic, strong, nullable) LTRasterImage *image;

- (void)realizeImage:(LTRasterImage *)image containerMapper:(LTAnnContainerMapper *)mapper;
- (void)restoreImage:(LTRasterImage *)image containerMapper:(LTAnnContainerMapper *)mapper;

@end

NS_ASSUME_NONNULL_END