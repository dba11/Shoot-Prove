//
//  LTConvertersDefines.h
//  Leadtools.Converters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#if !defined(LTCONVERTERSDEFINES_H)
#define LTCONVERTERSDEFINES_H

#include <CoreGraphics/CGImage.h>

#if defined(NS_OPTIONS)
typedef NS_OPTIONS(NSUInteger, LTConvertToImageOptions) {
    // No options
    LTConvertToImageOptionsNone = 0,
    
    // If the source raster image has alpha (is 32/64 bit), use them, otherwise, initialize to 0xFF if dest image has alpha
    LTConvertToImageOptionsKeepAlphaValues = 1 << 0,
    
    // Do not rotate the destination image. e.g. if source image is BottomLeft, the result image is flipped
    LTConvertToImageOptionsKeepViewPerspective = 1 << 1,
    
    // If source image is gray 12/16. Do not use the low/high bit values when converting scanlines
    LTConvertToImageOptionsIgnoreLowHighBitsOnGrayImages = 1 << 2,
    
    // With this option LTImage and LTRasterImage could share same memory.
    // Note LTImage will not be valid anymore if LTRasterImage changed or released
    // Cannot be used if the destination image is to be resized
    LTConvertToImageOptionsLinkImage = 1 << 3
};

typedef NS_OPTIONS(NSUInteger, LTConvertFromImageOptions) {
    // No options
    LTConvertFromImageOptionsNone = 0,
};

#else

typedef enum LTConvertToImageOptions {
    // No options
    LTConvertToImageOptionsNone = 0,
    
    // If the source raster image has alpha (is 32/64 bit), use them, otherwise, initialize to 0xFF if dest image has alpha
    LTConvertToImageOptionsKeepAlphaValues = 1 << 0,
    
    // Do not rotate the destination image. e.g. if source image is BottomLeft, the result image is flipped
    LTConvertToImageOptionsKeepViewPerspective = 1 << 1,
    
    // If source image is gray 12/16. Do not use the low/high bit values when converting scanlines
    LTConvertToImageOptionsIgnoreLowHighBitsOnGrayImages = 1 << 2,
    
    // With this option LTImage and LTRasterImage could share same memory.
    // Note LTImage will not be valid anymore if LTRasterImage changed or released
    // Cannot be used if the destination image is to be resized
    LTConvertToImageOptionsLinkImage = 1 << 3
} LTConvertToImageOptions;

typedef enum LTConvertFromImageOptions {
    // No options
    LTConvertFromImageOptionsNone = 0,
} LTConvertFromImageOptions;

#endif // #if defined(NS_OPTIONS)

#endif // #if !defined(LTCONVERTERSDEFINES_H)