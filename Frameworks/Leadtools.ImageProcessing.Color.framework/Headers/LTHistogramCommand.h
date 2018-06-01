//
//  LTHistogramCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, LTHistogramCommandFlags) {
    LTHistogramCommandFlagsMaster      = 0x0000,
    LTHistogramCommandFlagsRed         = 0x0001,
    LTHistogramCommandFlagsGreen       = 0x0002,
    LTHistogramCommandFlagsBlue        = 0x0003,
    LTHistogramCommandFlagsLowHighBits = 0x0000,
    LTHistogramCommandFlagsAllBits     = 0x0010,
    LTHistogramCommandFlagsForce256    = 0x0100
};

NS_ASSUME_NONNULL_BEGIN

@interface LTHistogramCommand : LTRasterCommand

@property (nonatomic, assign, readonly, nullable) unsigned long long *histogram;
@property (nonatomic, assign, readonly) NSUInteger                    histogramLength;

@property (nonatomic, assign) LTHistogramCommandFlags channel;

- (instancetype)initWithChannel:(LTHistogramCommandFlags)channel NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END