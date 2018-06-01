//
//  LTSmoothEdgesCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTSmoothEdgesCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger amount;
@property (nonatomic, assign) NSUInteger threshold;

- (instancetype)initWithAmount:(NSUInteger)amount threshold:(NSUInteger)threshold NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END