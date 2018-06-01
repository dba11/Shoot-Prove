//
//  LTFourierTransformInformation.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef struct {
    double r;
    double i;
} LTComplex;

LTComplex LTComplexCreate(double r, double i);

extern const LTComplex LTComplexZero;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

typedef NS_OPTIONS(NSUInteger, LTFastFourierTransformCommandFlags) {
    LTFastFourierTransformCommandFlagsNone                        = 0x0000,
    LTFastFourierTransformCommandFlagsFastFourierTransform        = 0x00000001,
    LTFastFourierTransformCommandFlagsInverseFastFourierTransform = 0x00000002,
    LTFastFourierTransformCommandFlagsBlue                        = 0x00000010,
    LTFastFourierTransformCommandFlagsGreen                       = 0x00000020,
    LTFastFourierTransformCommandFlagsRed                         = 0x00000030,
    LTFastFourierTransformCommandFlagsGray                        = 0x00000040,
    LTFastFourierTransformCommandFlagsMagnitude                   = 0x00000100,
    LTFastFourierTransformCommandFlagsPhase                       = 0x00000200,
    LTFastFourierTransformCommandFlagsBoth                        = 0x00000300,
    LTFastFourierTransformCommandFlagsClip                        = 0x00001000,
    LTFastFourierTransformCommandFlagsScale                       = 0x00002000,
    LTFastFourierTransformCommandFlagsPadOptimally                = 0x00010000,
    LTFastFourierTransformCommandFlagsPadSquare                   = 0x00020000,
};

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

NS_ASSUME_NONNULL_BEGIN

@interface LTFourierTransformInformation : NSObject

@property (nonatomic, assign, readonly) NSUInteger dataSize;
@property (nonatomic, assign, readonly) NSUInteger width;
@property (nonatomic, assign, readonly) NSUInteger height;

@property (nonatomic, assign, nullable) const LTComplex *data;

- (nullable instancetype)init:(NSError **)error NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithImage:(LTRasterImage *)image error:(NSError **)error;
- (nullable instancetype)initWithImage:(LTRasterImage *)image flags:(LTFastFourierTransformCommandFlags)flags error:(NSError **)error NS_DESIGNATED_INITIALIZER;
- (instancetype)init __unavailable;

- (LTComplex)dataAtRow:(NSUInteger)x column:(NSUInteger)y;

@end

NS_ASSUME_NONNULL_END