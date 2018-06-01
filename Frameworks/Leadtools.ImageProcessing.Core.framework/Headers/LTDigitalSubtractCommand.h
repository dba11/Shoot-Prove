//
//  LTDigitalSubtractCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, LTDigitalSubtractCommandFlags) {
    LTDigitalSubtractCommandFlagsNone                 = 0x0000,
    LTDigitalSubtractCommandFlagsContrastEnhancement  = 0x0001,
    LTDigitalSubtractCommandFlagsOptimizeRange        = 0x0002,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTDigitalSubtractCommand : LTRasterCommand

@property (nonatomic, strong, nullable) LTRasterImage *maskImage;
@property (nonatomic, assign)           LTDigitalSubtractCommandFlags flags;

- (instancetype)initWithMaskImage:(LTRasterImage *)maskImage flags:(LTDigitalSubtractCommandFlags)flags NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END