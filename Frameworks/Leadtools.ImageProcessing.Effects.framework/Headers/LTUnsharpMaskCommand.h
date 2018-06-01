//
//  LTUnsharpMaskCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTUnsharpMaskCommandColorType) {
    LTUnsharpMaskCommandColorTypeNone = 0x0000,
    LTUnsharpMaskCommandColorTypeRgb  = 0x0001,
    LTUnsharpMaskCommandColorTypeYuv  = 0x0002,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTUnsharpMaskCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger radius;
@property (nonatomic, assign) NSInteger threshold;
@property (nonatomic, assign) LTUnsharpMaskCommandColorType colorType;

- (instancetype)initWithAmount:(NSInteger)amount radius:(NSInteger)radius threshold:(NSInteger)threshold colorType:(LTUnsharpMaskCommandColorType)colorType NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END