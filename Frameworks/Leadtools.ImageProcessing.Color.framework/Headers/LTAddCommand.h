//
//  LTAddCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTAddCommandType) {
    LTAddCommandTypeAverage = 0x0001,
    LTAddCommandTypeAdd     = 0x0002
};

NS_ASSUME_NONNULL_BEGIN

@interface LTAddCommand : LTRasterCommand

@property (nonatomic, assign)                     LTAddCommandType type;
@property (nonatomic, strong, readonly, nullable) LTRasterImage *destinationImage;

- (instancetype)initWithType:(LTAddCommandType)type NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END