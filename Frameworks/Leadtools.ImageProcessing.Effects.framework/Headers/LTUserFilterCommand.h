//
//  LTUserFilterCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTUserFilterCommandType) {
    LTUserFilterCommandTypeSum     = 0x0000,
    LTUserFilterCommandTypeMaximum = 0x0001,
    LTUserFilterCommandTypeMinimum = 0x0002
};

NS_ASSUME_NONNULL_BEGIN

@interface LTUserFilterCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger filterWidth;
@property (nonatomic, assign) NSUInteger filterHeight;
@property (nonatomic, assign) NSUInteger divisor;
@property (nonatomic, assign) NSInteger  offset;

@property (nonatomic, assign) LeadPoint centerPoint;
@property (nonatomic, assign) LTUserFilterCommandType type;

@property (nonatomic, assign, nullable) const int *matrix;
@property (nonatomic, assign)           NSUInteger matrixLength;

- (instancetype)initWithFilterWidth:(NSUInteger)filterWidth filterHeight:(NSUInteger)filterHeight centerPoint:(LeadPoint)centerPoint divisor:(NSUInteger)divisor offset:(NSInteger)offset type:(LTUserFilterCommandType)type matrix:(nullable const int *)matrix matrixLength:(NSUInteger)matrixLength NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END