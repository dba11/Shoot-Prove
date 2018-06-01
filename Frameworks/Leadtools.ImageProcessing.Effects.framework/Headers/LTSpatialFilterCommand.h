//
//  LTSpatialFilterCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTSpatialFilterCommandPredefined) {
    LTSpatialFilterCommandPredefinedEmbossNorth,
    LTSpatialFilterCommandPredefinedEmbossNorthEast,
    LTSpatialFilterCommandPredefinedEmbossEast,
    LTSpatialFilterCommandPredefinedEmbossSouthEast,
    LTSpatialFilterCommandPredefinedEmbossSouth,
    LTSpatialFilterCommandPredefinedEmbossSouthWest,
    LTSpatialFilterCommandPredefinedEmbossWest,
    LTSpatialFilterCommandPredefinedEmbossNorthWest,
    LTSpatialFilterCommandPredefinedGradientEdgeEnhancementNorth,
    LTSpatialFilterCommandPredefinedGradientEdgeEnhancementNorthEast,
    LTSpatialFilterCommandPredefinedGradientEdgeEnhancementEast,
    LTSpatialFilterCommandPredefinedGradientEdgeEnhancementSouthEast,
    LTSpatialFilterCommandPredefinedGradientEdgeEnhancementSouth,
    LTSpatialFilterCommandPredefinedGradientEdgeEnhancementSouthWest,
    LTSpatialFilterCommandPredefinedGradientEdgeEnhancementWest,
    LTSpatialFilterCommandPredefinedGradientEdgeEnhancementNorthWest,
    LTSpatialFilterCommandPredefinedLaplacianFilter1,
    LTSpatialFilterCommandPredefinedLaplacianFilter2,
    LTSpatialFilterCommandPredefinedLaplacianFilter3,
    LTSpatialFilterCommandPredefinedLaplacianDiagonal,
    LTSpatialFilterCommandPredefinedLaplacianHorizontal,
    LTSpatialFilterCommandPredefinedLaplacianVertical,
    LTSpatialFilterCommandPredefinedSobelHorizontal,
    LTSpatialFilterCommandPredefinedSobelVertical,
    LTSpatialFilterCommandPredefinedPrewittHorizontal,
    LTSpatialFilterCommandPredefinedPrewittVertical,
    LTSpatialFilterCommandPredefinedShiftAndDifferenceDiagonal,
    LTSpatialFilterCommandPredefinedShiftAndDifferenceHorizontal,
    LTSpatialFilterCommandPredefinedShiftAndDifferenceVertical,
    LTSpatialFilterCommandPredefinedLineSegmentHorizontal,
    LTSpatialFilterCommandPredefinedLineSegmentVertical,
    LTSpatialFilterCommandPredefinedLineSegmentLeftToRight,
    LTSpatialFilterCommandPredefinedLineSegmentRightToLeft,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTSpatialFilterCommand : LTRasterCommand

@property (nonatomic, assign)           NSInteger divisor;
@property (nonatomic, assign)           NSInteger bias;
@property (nonatomic, assign, readonly) NSUInteger dimension;
@property (nonatomic, assign, nullable) const int *matrix;
@property (nonatomic, assign)           NSUInteger matrixLength;

- (instancetype)initWithPredefinedSpatialFilter:(LTSpatialFilterCommandPredefined)predefined;
- (instancetype)initWithDivisor:(NSInteger)divisor bias:(NSInteger)bias matrix:(nullable const int *)matrix matrixLength:(NSUInteger)matrixLength;

@end

NS_ASSUME_NONNULL_END