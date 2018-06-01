//
//  LTSizeCommand.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTRasterCommand.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Resizes an image to a new width and height.
 */
@interface LTSizeCommand : LTRasterCommand

/** @brief The new image width in pixels. */
@property (nonatomic, assign) NSInteger width;

/** @brief The new image height in pixels. */
@property (nonatomic, assign) NSInteger height;

/** @brief The flags that control the behavior when resizing the image. */
@property (nonatomic, assign) LTRasterSizeFlags flags;


/**
 @brief Initializes a new LTSizeCommand with explicit parameters.
 
 @param width The new image width in pixels.
 @param height The new image height in pixels.
 @param flags The flags that control the behavior when resizing the image.
 
 @returns A LTSizeCommand object initialized with specific values.
 */
- (instancetype)initWithWidth:(NSInteger)width height:(NSInteger)height flags:(LTRasterSizeFlags)flags NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END