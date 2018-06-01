//
//  LTGammaCorrectCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTGammaCorrectCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger gamma;

- (instancetype)initWithGamma:(NSUInteger)gamma NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END