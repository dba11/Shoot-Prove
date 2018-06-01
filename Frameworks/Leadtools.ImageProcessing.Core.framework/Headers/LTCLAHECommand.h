//
//  LTCLAHECommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, LTCLAHECommandFlags) {
    LTCLAHECommandFlagsApplyNormalDistribution      = 0x00004,
    LTCLAHECommandFlagsApplyExponentialDistribution = 0x00002,
    LTCLAHECommandFlagsApplyRayliehDistribution     = 0x00001,
    LTCLAHECommandFlagsApplySigmoidDistribution     = 0x00008,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTCLAHECommand : LTRasterCommand

@property (nonatomic, assign) NSInteger tilesNumber;
@property (nonatomic, assign) NSInteger binNumber;
@property (nonatomic, assign) float alphaFactor;
@property (nonatomic, assign) float tileHistClipLimit;
@property (nonatomic, assign) LTCLAHECommandFlags flags;

- (instancetype)initWithAlpha:(float)alpha tilesNumber:(NSInteger)tilesNumber tileHistClipLimit:(float)tileHistClipLimit binNumber:(NSInteger)binNumber flags:(LTCLAHECommandFlags)flags NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END