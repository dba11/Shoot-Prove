//
//  LTFourierTransformDisplayCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTFourierTransformInformation.h"

typedef NS_OPTIONS(NSUInteger, LTFourierTransformDisplayCommandFlags) {
    LTFourierTransformDisplayCommandFlagsNone      = 0x0000,
    LTFourierTransformDisplayCommandFlagsMagnitude = 0x0001,
    LTFourierTransformDisplayCommandFlagsPhase     = 0x0002,
    LTFourierTransformDisplayCommandFlagsNormal    = 0x0010,
    LTFourierTransformDisplayCommandFlagsLog       = 0x0020
};

NS_ASSUME_NONNULL_BEGIN

@interface LTFourierTransformDisplayCommand : LTRasterCommand

@property (nonatomic, assign)                   LTFourierTransformDisplayCommandFlags flags;
@property (nonatomic, strong, null_unspecified) LTFourierTransformInformation *fourierTransformInformation;

- (instancetype)initWithInformation:(null_unspecified LTFourierTransformInformation *)information flags:(LTFourierTransformDisplayCommandFlags)flags NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END