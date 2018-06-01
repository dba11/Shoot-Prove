//
//  LTHalftoneCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTHalfToneCommandType) {
    LTHalfToneCommandTypePrint       = 0x0000,
    LTHalfToneCommandTypeView        = 0x0001,
    LTHalfToneCommandTypeRectangular = 0x0002,
    LTHalfToneCommandTypeCircular    = 0x0003,
    LTHalfToneCommandTypeElliptical  = 0x0004,
    LTHalfToneCommandTypeRandom      = 0x0005,
    LTHalfToneCommandTypeLinear      = 0x0006,
    LTHalfToneCommandTypeUserDefined = 0x0007
};

NS_ASSUME_NONNULL_BEGIN

@interface LTHalftoneCommand : LTRasterCommand

@property (nonatomic, assign)           LTHalfToneCommandType type;
@property (nonatomic, assign)           NSInteger angle;
@property (nonatomic, assign)           NSUInteger dimension;
@property (nonatomic, strong, nullable) LTRasterImage *userDefinedImage;

- (instancetype)initWithType:(LTHalfToneCommandType)type angle:(NSInteger)angle dimension:(NSUInteger)dimension userDefinedImage:(nullable LTRasterImage *)userDefinedImage NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END