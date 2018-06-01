//
//  LTChangeIntensityCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTChangeIntensityCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger brightness;

- (instancetype)initWithBrightness:(NSInteger)brightness NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END