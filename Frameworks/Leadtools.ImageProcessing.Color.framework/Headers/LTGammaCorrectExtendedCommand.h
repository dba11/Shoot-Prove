//
//  LTGammaCorrectExtendedCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTGammaCorrectExtendedCommandType) {
    LTGammaCorrectExtendedCommandTypeRgbSpace = 0x0001,
    LTGammaCorrectExtendedCommandTypeYuvSpace = 0x0002
};

NS_ASSUME_NONNULL_BEGIN

@interface LTGammaCorrectExtendedCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger gamma;
@property (nonatomic, assign) LTGammaCorrectExtendedCommandType type;

- (instancetype)initWithGamma:(NSUInteger)gamma type:(LTGammaCorrectExtendedCommandType)type NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END