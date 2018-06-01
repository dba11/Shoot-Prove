//
//  LTCodecsThumbnailOptions.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsThumbnailOptions : NSObject

@property (nonatomic, assign) BOOL maintainAspect;
@property (nonatomic, assign) BOOL forceSize;
@property (nonatomic, assign) BOOL loadStamp;
@property (nonatomic, assign) BOOL resample;

@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger height;
@property (nonatomic, assign) NSUInteger bits;

@property (nonatomic, assign) LTRasterByteOrder order;
@property (nonatomic, assign) LTRasterDitheringMethod ditheringMethod;
@property (nonatomic, assign) LTColorResolutionCommandPaletteFlags paletteFlags;

@property (nonatomic, copy)   LTRasterColor *backColor;

@end

NS_ASSUME_NONNULL_END