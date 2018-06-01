//
//  LTBinaryFilterCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTBinaryFilterCommandPredefined) {
    LTBinaryFilterCommandPredefinedErosionOmniDirectional,
    LTBinaryFilterCommandPredefinedErosionHorizontal,
    LTBinaryFilterCommandPredefinedErosionVertical,
    LTBinaryFilterCommandPredefinedErosionDiagonal,
    LTBinaryFilterCommandPredefinedDilationOmniDirectional,
    LTBinaryFilterCommandPredefinedDilationHorizontal,
    LTBinaryFilterCommandPredefinedDilationVertical,
    LTBinaryFilterCommandPredefinedDilationDiagonal,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTBinaryFilterCommand : LTRasterCommand

@property (nonatomic, assign)           BOOL maximum;
@property (nonatomic, assign, readonly) NSUInteger dimension;
@property (nonatomic, assign)           NSUInteger matrixLength;
@property (nonatomic, assign, nullable) const int *matrix;

- (instancetype)initWithPredefinedBinaryFilter:(LTBinaryFilterCommandPredefined)predefined;
- (instancetype)initWithMaximum:(BOOL)maximum matrix:(nullable const int *)matrix matrixLength:(NSUInteger)matrixLength;

@end

NS_ASSUME_NONNULL_END