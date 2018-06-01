//
//  LTRasterHsvColor.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTRasterColor.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Describes a color consisting of relative intensities of hue, saturation, and value.
 */
@interface LTRasterHsvColor : NSObject

/** The hue component of the color */
@property (nonatomic, assign) unsigned char h;

/** The saturation component of the color */
@property (nonatomic, assign) unsigned char s;

/** The value component of the color */
@property (nonatomic, assign) unsigned char v;

/** For internal use by LEADTOOLS */
@property (nonatomic, assign) unsigned char reserved;

/**
 @brief Creates a LTRasterHsvColor instance from the specified LTRasterColor instance
 
 @param color The LTRasterColor instance
 
 @returns An initialized LTRasterHsvColor instance.
 */
+ (instancetype)colorFromRasterColor:(LTRasterColor *)color;

/**
 @brief Creates a LTRasterHsvColor instance from the specified h, s, and v color components
 
 @param h The hue color component
 @param s The saturation color component
 @param v the value color component
 
 @returns An initialized LTRasterHsvColor instance.
 */
+ (instancetype)colorWithH:(NSInteger)h s:(NSInteger)s v:(NSInteger)v;

/**
 @brief Initializes a LTRasterHsvColor instance from the specified h, s, and v color components
 
 @param h The hue color component
 @param s The saturation color component
 @param v the value color component
 
 @returns An initialized LTRasterHsvColor instance.
 */
- (instancetype)initWithH:(NSInteger)h s:(NSInteger)s v:(NSInteger)v NS_DESIGNATED_INITIALIZER;

/**
 @brief Creates a LTRasterColor instance from the values of the LTRasterHsvColor instance
 
 @returns An initialized LTRasterColor instance
 */
- (LTRasterColor *)toRasterColor;

@end

NS_ASSUME_NONNULL_END