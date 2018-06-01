//
//  LTSubtractBackgroundCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTSubtractBackgroundCommandType) {
    LTSubtractBackgroundCommandTypeDependOnRollingBallSize = 0,
    LTSubtractBackgroundCommandTypeNoShrinking             = 1,
    LTSubtractBackgroundCommandTypeOneToTwo                = 2,
    LTSubtractBackgroundCommandTypeOneToFour               = 3,
    LTSubtractBackgroundCommandTypeOneToEight              = 4
};

typedef NS_OPTIONS(NSUInteger, LTSubtractBackgroundCommandFlags) {
    LTSubtractBackgroundCommandFlagsBackgroundIsDarker   = 0x00000000,
    LTSubtractBackgroundCommandFlagsBackgroundIsBrighter = 0x00000001,
    
    LTSubtractBackgroundCommandFlagsSubtractedImage      = 0x00000000,
    LTSubtractBackgroundCommandFlagsTheBackground        = 0x00000010,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTSubtractBackgroundCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger rollingBall;
@property (nonatomic, assign) NSUInteger brightnessFactor;

@property (nonatomic, assign) LTSubtractBackgroundCommandType shrinkingSize;
@property (nonatomic, assign) LTSubtractBackgroundCommandFlags flags;

- (instancetype)initWithRollingBall:(NSUInteger)rollingBall shrinkingSize:(LTSubtractBackgroundCommandType)shrinkingSize brightnessFactor:(NSUInteger)brightnessFactor flags:(LTSubtractBackgroundCommandFlags)flags NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END