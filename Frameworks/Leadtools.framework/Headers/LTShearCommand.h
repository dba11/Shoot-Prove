//
//  LTShearCommand.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTRasterCommand.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Moves the corners of an image in the fashion of a parallelogram.
 */
@interface LTShearCommand : LTRasterCommand

/** @brief The angle of the slant. */
@property (nonatomic, assign) NSInteger angle;

/** @brief The direction of the slant. */
@property (nonatomic, assign) BOOL horizontal;

/** @brief The background fill color. */
@property (nonatomic, copy)   LTRasterColor *fillColor;


/**
 @brief Initializes a new LTShearCommand with explicit parameters.
 
 @param angle The angle of slant in hundredths of degrees.
 @param horizontal The direction of the slant.
 @param fillColor The fill color.
 
 @returns A LTShearCommand object initialized with specific values.
 */
- (instancetype)initWithAngle:(NSInteger)angle horizontal:(BOOL)horizontal fillColor:(LTRasterColor *)fillColor NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END