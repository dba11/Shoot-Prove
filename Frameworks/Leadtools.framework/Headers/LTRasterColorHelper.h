//
//  LTRasterColorHelper.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

/**
 @brief Helper methods for the RasterColor class
 */
@interface LTRasterColorHelper : NSObject

/**
 @brief Converts an instance of UIColor to a LTRasterColor instance
 
 @param color The UIColor to convert
 
 @returns The converted LTRasterColor instance
 */
+ (nonnull LTRasterColor *)toRasterColor:(nonnull UIColor *)color;

/**
 @brief Converts an instance of LTRasterColor to a UIColor instance
 
 @param rasterColor The LTRasterColor to convert
 
 @returns The converted UIColor instance
 */
+ (nonnull UIColor *)fromRasterColor:(nonnull LTRasterColor *)rasterColor;

@end