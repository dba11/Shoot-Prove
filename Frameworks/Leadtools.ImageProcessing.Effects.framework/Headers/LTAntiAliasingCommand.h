//
//  LTAntiAliasingCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef  NS_ENUM(NSInteger, LTAntiAliasingCommandType) {
    LTAntiAliasingCommandTypeType1,
    LTAntiAliasingCommandTypeType2,
    LTAntiAliasingCommandTypeType3,
    LTAntiAliasingCommandTypeDiagonal,
    LTAntiAliasingCommandTypeHorizontal,
    LTAntiAliasingCommandTypeVertical,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTAntiAliasingCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger threshold;
@property (nonatomic, assign) NSUInteger dimension;
@property (nonatomic, assign) LTAntiAliasingCommandType filter;

- (instancetype)initWithThreshold:(NSInteger)threshold dimension:(NSUInteger)dimension filter:(LTAntiAliasingCommandType)filter NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END