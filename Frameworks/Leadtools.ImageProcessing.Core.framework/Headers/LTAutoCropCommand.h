//
//  LTAutoCropCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTAutoCropCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger threshold;

- (instancetype)initWithThreshold:(NSUInteger)threshold NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END