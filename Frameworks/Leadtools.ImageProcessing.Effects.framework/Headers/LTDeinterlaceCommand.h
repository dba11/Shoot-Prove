//
//  LTDeinterlaceCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, LTDeinterlaceCommandFlags) {
    LTDeinterlaceCommandFlagsNone   = 0x0000,
    LTDeinterlaceCommandFlagsNormal = 0x0001,
    LTDeinterlaceCommandFlagsSmooth = 0x0002,
    LTDeinterlaceCommandFlagsOdd    = 0x0010,
    LTDeinterlaceCommandFlagsEven   = 0x0020
};

NS_ASSUME_NONNULL_BEGIN

@interface LTDeinterlaceCommand : LTRasterCommand

@property (nonatomic, assign) LTDeinterlaceCommandFlags flags;

- (instancetype)initWithFlags:(LTDeinterlaceCommandFlags)flags NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END