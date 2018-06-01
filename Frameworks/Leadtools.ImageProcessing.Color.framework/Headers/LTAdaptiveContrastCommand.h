//
//  LTAdaptiveContrastCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTAdaptiveContrastCommandType) {
    LTAdaptiveContrastCommandTypeExponential = 0x0001,
    LTAdaptiveContrastCommandTypeLinear      = 0x0002
};

NS_ASSUME_NONNULL_BEGIN

@interface LTAdaptiveContrastCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger dimension;
@property (nonatomic, assign) NSUInteger amount;
@property (nonatomic, assign) LTAdaptiveContrastCommandType type;

- (instancetype)initWithDimension:(NSUInteger)dimension amount:(NSUInteger)amount type:(LTAdaptiveContrastCommandType)type NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END