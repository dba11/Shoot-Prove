//
//  LTEdgeDetectStatisticalCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTEdgeDetectStatisticalCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger dimension;
@property (nonatomic, assign) NSInteger threshold;
@property (nonatomic, copy)   LTRasterColor *edgeColor;
@property (nonatomic, copy)   LTRasterColor *backgroundColor;

- (instancetype)initWithDimension:(NSUInteger)dimension threshold:(NSInteger)threshold edgeColor:(LTRasterColor*)edgeColor backgroundColor:(LTRasterColor *)backgroundColor NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END