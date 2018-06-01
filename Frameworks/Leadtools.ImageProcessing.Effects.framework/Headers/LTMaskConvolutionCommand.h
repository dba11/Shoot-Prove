//
//  LTMaskConvolutionCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTMaskConvolutionCommandType) {
    LTMaskConvolutionCommandTypeEmboss        = 0x0000,
    LTMaskConvolutionCommandTypeEdgeDetection = 0x0001,
    LTMaskConvolutionCommandTypeEmbossSplotch = 0x0002,
    LTMaskConvolutionCommandTypeSplotch       = 0x0003
};

NS_ASSUME_NONNULL_BEGIN

@interface LTMaskConvolutionCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger angle;
@property (nonatomic, assign) NSUInteger depth;
@property (nonatomic, assign) NSUInteger height;
@property (nonatomic, assign) LTMaskConvolutionCommandType type;

- (instancetype)initWithAngle:(NSInteger)angle depth:(NSUInteger)depth height:(NSUInteger)height type:(LTMaskConvolutionCommandType)type NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END