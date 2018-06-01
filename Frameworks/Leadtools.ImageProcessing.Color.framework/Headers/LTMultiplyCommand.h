//
//  LTMultiplyCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTMultiplyCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger factor;

- (instancetype)initWithFactor:(NSUInteger)factor NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END