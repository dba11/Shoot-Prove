//
//  LTCopyDataCommand.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTRasterCommand.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Copied image data from one image to another.
 */
@interface LTCopyDataCommand : LTRasterCommand

/** @brief The destination image. */
@property (nonatomic, strong, nullable) LTRasterImage *destinationImage;


/**
 @brief Initializes a new LTCopyDataCommand with explicit parameters.
 
 @param destinationImage The destination image for the command.
 
 @returns A LTCopyDataCommand object initialized with specific values.
 */
- (instancetype)initWithDestinationImage:(LTRasterImage *)destinationImage NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END