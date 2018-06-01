//
//  LTDetectAlphaCommand.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTRasterCommand.h"

/**
 @brief Determines if the image has meaningful alpha channel values.
 */
@interface LTDetectAlphaCommand : LTRasterCommand

/** @brief Specifies whether or not the image contains meaningful alpha channel values. */
@property (nonatomic, assign) BOOL hasMeaningfulAlpha;

@end
