//
//  LTAddWeightedCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTAddWeightedCommandType) {
    LTAddWeightedCommandTypeAverage         = 0x0001,
    LTAddWeightedCommandTypeAdd             = 0x0002,
    LTAddWeightedCommandTypeAverageWeighted = 0x0003,
    LTAddWeightedCommandTypeAddWeighted     = 0x0004
};

NS_ASSUME_NONNULL_BEGIN

@interface LTAddWeightedCommand : LTRasterCommand

@property (nonatomic, assign) LTAddWeightedCommandType type;

@property (nonatomic, strong, readonly, nullable) LTRasterImage *destinationImage;

@property (nonatomic, assign, nullable) const unsigned int *factor;
@property (nonatomic, assign)           NSUInteger factorLength;

- (instancetype)initWithType:(LTAddWeightedCommandType)type factor:(nullable const unsigned int *)factor factorLength:(NSUInteger)factorLength NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END