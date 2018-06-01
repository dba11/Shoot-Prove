//
//  LTDisplacementCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, LTDisplacementCommandFlags) {
    LTDisplacementCommandFlagsColor        = 0x0000,
    LTDisplacementCommandFlagsRepeat       = 0x0001,
    LTDisplacementCommandFlagsNoChange     = 0x0002,
    LTDisplacementCommandFlagsWrapAround   = 0x0003,
    
    LTDisplacementCommandFlagsTile         = 0x0000,
    LTDisplacementCommandFlagsStretchToFit = 0x0010,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTDisplacementCommand : LTRasterCommand

@property (nonatomic, strong, nullable) LTRasterImage *displacementMapImage;
@property (nonatomic, assign)           NSUInteger horizontalFactor;
@property (nonatomic, assign)           NSUInteger verticalFactor;
@property (nonatomic, copy)             LTRasterColor *fillColor;
@property (nonatomic, assign)           LTDisplacementCommandFlags flags;

- (instancetype)initWithDisplacementMapImage:(LTRasterImage *)displacementMapImage horizontalFactor:(NSUInteger)horizontalFactor verticalFactor:(NSUInteger)verticalFactor fillColor:(LTRasterColor *)fillColor flags:(LTDisplacementCommandFlags)flags NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END