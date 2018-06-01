//
//  LTFillCommand.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTRasterCommand.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Fills the specified image with the specified color.
 */
@interface LTFillCommand : LTRasterCommand

/** The fill color. */
@property (nonatomic, copy, nonnull) LTRasterColor *color;


/**
 @brief Initializes a new LTFillCommand with explicit parameters.
 
 @param color The fill color.
 
 @returns A LTFillCommand object initialized with specific values.
 */
- (instancetype)initWithColor:(LTRasterColor *)color NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END