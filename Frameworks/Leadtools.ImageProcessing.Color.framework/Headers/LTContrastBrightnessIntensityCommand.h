//
//  LTContrastBrightnessIntensityCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTContrastBrightnessIntensityCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger contrast;
@property (nonatomic, assign) NSInteger brightness;
@property (nonatomic, assign) NSInteger intensity;

- (instancetype)initWithContrast:(NSInteger)contrast brightness:(NSInteger)brightness intensity:(NSInteger)intensity NS_DESIGNATED_INITIALIZER ;

@end

NS_ASSUME_NONNULL_END