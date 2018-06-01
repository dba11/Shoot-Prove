//
//  LTHighPassCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTHighPassCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger radius;
@property (nonatomic, assign) NSUInteger opacity;

- (instancetype)initWithRadius:(NSUInteger)radius opacity:(NSUInteger)opacity NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END