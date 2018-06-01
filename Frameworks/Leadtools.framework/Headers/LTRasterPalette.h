//
//  LTRasterPalette.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTRasterColor.h"

typedef NS_OPTIONS(NSUInteger, LTRasterPaletteWindowLevelFlags) {
    LTRasterPaletteWindowLevelFlagsNone        = 0,
    LTRasterPaletteWindowLevelFlagsInside      = 0x0001,
    LTRasterPaletteWindowLevelFlagsOutside     = 0x0002,
    LTRasterPaletteWindowLevelFlagsLinear      = 0x0010,
    LTRasterPaletteWindowLevelFlagsExponential = 0x0020,
    LTRasterPaletteWindowLevelFlagsLogarithmic = 0x0030,
    LTRasterPaletteWindowLevelFlagsSigmoid     = 0x0040,
    LTRasterPaletteWindowLevelFlagsSigned      = 0x0100,
    LTRasterPaletteWindowLevelFlagsDicomStyle  = 0x1000
};

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Encapsulates and provides support for managing image palettes.
 */
@interface LTRasterPalette : NSObject

/**
 @brief Creates an array of LTRasterColor objects that represent the LEAD fixed palette.
 
 @param count The number of color to add to the fixed palette.
 
 @returns The LEAD fixed palette.
 */
+ (NSArray<LTRasterColor *> *)fixed:(NSUInteger)count;

/**
 @brief Fills the user-allocated 8-bit LUT with values ranging between the startColor and endColor colors according to the selected LUT types.
 
 @param lookupTable An array to be updated with the LTRasterColor values.
 @param startColor Starting color value for the gradient.
 @param endColor Ending color vlaue for the gradient.
 @param low The low value of the window width, in pixels.
 @param high The high value for the window width, in pixles.
 @param lowBit Value indicating the low bit used for leveling. This is normally 0 and should be less than the highBit.
 @param highBit Value indicating the high bit used for leveling. This should be greater than or equal to lowBit and less than 11 for 12-bit grayscale or 15 for 16-bit grayscale.
 @param minValue The image minimum value. This value can be obtained using MinMaxValuesCommand (Leadtools.ImageProcessing.Core).
 @param maxValue The image maximum value. This value can be obtained using MinMaxValuesCommand (Leadtools.ImageProcessing.Core).
 @param factor Value that indicates the factor to be applied in the method operation specified in the flags parameter.
 @param flags Flags that indicate how the range is used to fill and the type of the lookup table and whether it contains signed or unsigned data.
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in nil.
 
 @returns YES is the lookup table was successfully filled with values, otherwise NO.
 */
+ (BOOL)windowLevelFillLookupTable:(NSArray<LTRasterColor *> *)lookupTable startColor:(LTRasterColor *)startColor endColor:(LTRasterColor *)endColor low:(NSInteger)low high:(NSInteger)high lowBit:(NSUInteger)lowBit highBit:(NSUInteger)highBit minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue factor:(NSInteger)factor flags:(LTRasterPaletteWindowLevelFlags)flags error:(NSError **)error;

/**
 @brief Fills the user-allocated 16-bit LUT with values ranging between the startColor and endColor colors according to the selected LUT types.
 
 @param lookupTable An array to be updated with the LTRasterColor values.
 @param startColor Starting color value for the gradient.
 @param endColor Ending color vlaue for the gradient.
 @param low The low value of the window width, in pixels.
 @param high The high value for the window width, in pixles.
 @param lowBit Value indicating the low bit used for leveling. This is normally 0 and should be less than the highBit.
 @param highBit Value indicating the high bit used for leveling. This should be greater than or equal to lowBit and less than 11 for 12-bit grayscale or 15 for 16-bit grayscale.
 @param minValue The image minimum value. This value can be obtained using MinMaxValuesCommand (Leadtools.ImageProcessing.Core).
 @param maxValue The image maximum value. This value can be obtained using MinMaxValuesCommand (Leadtools.ImageProcessing.Core).
 @param factor Value that indicates the factor to be applied in the method operation specified in the flags parameter.
 @param flags Flags that indicate how the range is used to fill and the type of the lookup table and whether it contains signed or unsigned data.
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in nil.
 
 @returns YES is the lookup table was successfully filled with values, otherwise NO.
 */
+ (BOOL)windowLevelFillLookupTableExt:(NSArray<LTRasterColor16 *> *)lookupTable startColor:(LTRasterColor16 *)startColor endColor:(LTRasterColor16 *)endColor low:(NSInteger)low high:(NSInteger)high lowBit:(NSUInteger)lowBit highBit:(NSUInteger)highBit minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue factor:(NSInteger)factor flags:(LTRasterPaletteWindowLevelFlags)flags error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END