//
//  LTCorrelationListCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTCorrelationListCommand : LTRasterCommand

@property (nonatomic, strong, nullable) LTRasterImage *correlationImage;
@property (nonatomic, strong, nullable) NSArray<NSValue *> *points;
@property (nonatomic, assign, nullable) NSUInteger *listIndex;
@property (nonatomic, assign, readonly) NSUInteger numberOfPoints;
@property (nonatomic, assign)           NSUInteger xStep;
@property (nonatomic, assign)           NSUInteger yStep;
@property (nonatomic, assign)           NSUInteger threshold;

- (instancetype)initWithCorrelationImage:(null_unspecified LTRasterImage *)correlationImage points:(nullable NSArray<NSValue *> *)points listIndex:(NSUInteger *)listIndex xStep:(NSUInteger)xStep yStep:(NSUInteger)yStep threshold:(NSUInteger)threshold NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithPoints:(nullable NSArray<NSValue *> *)points listIndex:(NSUInteger *)listIndex xStep:(NSUInteger)xStep yStep:(NSUInteger)yStep threshold:(NSUInteger)threshold;

@end

NS_ASSUME_NONNULL_END