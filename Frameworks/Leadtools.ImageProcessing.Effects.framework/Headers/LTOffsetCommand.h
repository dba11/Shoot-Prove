//
//  LTOffsetCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTOffsetCommandType) {
    LTOffsetCommandTypeColor      = 0x0000,
    LTOffsetCommandTypeRepeat     = 0x0001,
    LTOffsetCommandTypeNoChange   = 0x0002,
    LTOffsetCommandTypeWrapAround = 0x0003
};

NS_ASSUME_NONNULL_BEGIN

@interface LTOffsetCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger horizontalShift;
@property (nonatomic, assign) NSInteger verticalShift;
@property (nonatomic, copy)   LTRasterColor *backColor;
@property (nonatomic, assign) LTOffsetCommandType type;

- (instancetype)initWithHorizontalShift:(NSInteger)horizontalShift verticalShift:(NSInteger)verticalShift backColor:(LTRasterColor *)backColor type:(LTOffsetCommandType)type NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END