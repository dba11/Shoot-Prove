//
//  LTFlipCommand.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTRasterCommand.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Flips a LTRasterImage from top to bottom or from left to right.
 */
@interface LTFlipCommand : LTRasterCommand

/** @brief Specifies whether the image is to be flipped horizontally or vertically. */
@property (nonatomic, assign) BOOL horizontal;


/**
 @brief Initializes a new LTFlipCommand with explicit parameters.
 
 @param horizontal YES to flip horizontally (left to right), NO to flip vertically (top to bottom).
 
 @returns A LTFlipCommand object initialized with specific values.
 */
- (instancetype)initWithHorizontal:(BOOL)horizontal NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END