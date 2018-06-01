//
//  LTConvertToImageData.h
//  Leadtools.Converters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTConvertersDefines.h"

@interface LTConvertToImageData : NSObject

@property (nonatomic, assign) BOOL resample;

@property (nonatomic, assign) NSUInteger maximumWidth;
@property (nonatomic, assign) NSUInteger maximumHeight;

@property (nonatomic, assign) LTConvertToImageOptions options;
@property (nonatomic, assign) LTRasterPaintSizeMode sizeMode;

@end
