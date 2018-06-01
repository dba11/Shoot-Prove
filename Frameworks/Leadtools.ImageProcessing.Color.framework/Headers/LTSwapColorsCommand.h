//
//  LTSwapColorsCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTSwapColorsCommandType) {
    LTSwapColorsCommandTypeRedGreen        = 0x0001,
    LTSwapColorsCommandTypeRedBlue         = 0x0002,
    LTSwapColorsCommandTypeGreenBlue       = 0x0004,
    LTSwapColorsCommandTypeRedGreenBlueRed = 0x0008,
    LTSwapColorsCommandTypeRedBlueGreenRed = 0x0010
};

NS_ASSUME_NONNULL_BEGIN

@interface LTSwapColorsCommand : LTRasterCommand

@property (nonatomic, assign) LTSwapColorsCommandType type;

- (instancetype)initWithType:(LTSwapColorsCommandType)type NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END