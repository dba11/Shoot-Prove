//
//  LTGrayscaleToMultitoneCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"

typedef NS_ENUM(NSInteger, LTGrayScaleToMultitoneCommandToneType) {
    LTGrayScaleToMultitoneCommandToneTypeMonotone = 0x00000000,
    LTGrayScaleToMultitoneCommandToneTypeDuotone  = 0x00000001,
    LTGrayScaleToMultitoneCommandToneTypeTritone  = 0x00000002,
    LTGrayScaleToMultitoneCommandToneTypeQuadtone = 0x00000003
};

typedef NS_ENUM(NSInteger, LTGrayScaleToMultitoneCommandDistributionType) {
    LTGrayScaleToMultitoneCommandDistributionTypeLinear      = 0x00000000,
    LTGrayScaleToMultitoneCommandDistributionTypeUserDefined = 0x00000001
};

NS_ASSUME_NONNULL_BEGIN

@interface LTGrayscaleToMultitoneCommand : LTRasterCommand

@property (nonatomic, assign) LTGrayScaleToMultitoneCommandToneType         tone;
@property (nonatomic, assign) LTGrayScaleToMultitoneCommandDistributionType distribution;
@property (nonatomic, assign) LTGrayScaleToDuotoneCommandMixingType         type;

@property (nonatomic, strong) NSMutableArray<LTRasterColor *> *colors;
@property (nonatomic, strong) NSMutableArray<NSArray<LTRasterColor *> *> *gradient;

@end

NS_ASSUME_NONNULL_END