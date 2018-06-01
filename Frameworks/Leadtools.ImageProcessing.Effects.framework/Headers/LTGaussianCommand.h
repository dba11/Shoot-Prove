//
//  LTGaussianCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTGaussianCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger radius;

- (instancetype)initWithRadius:(NSInteger)radius NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END