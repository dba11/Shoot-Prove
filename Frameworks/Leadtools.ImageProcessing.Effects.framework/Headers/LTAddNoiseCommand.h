//
//  LTAddNoiseCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTAddNoiseCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger           range;
@property (nonatomic, assign) LTRasterColorChannel channel;

- (instancetype)initWithRange:(NSUInteger)range channel:(LTRasterColorChannel)channel NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END