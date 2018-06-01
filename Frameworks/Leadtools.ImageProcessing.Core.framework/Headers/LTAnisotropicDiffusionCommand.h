//
//  LTAnisotropicDiffusionCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, LTTADAnisotropicDiffusionFlags) {
    LTTADAnisotropicDiffusionFlagsExponentialFlux  = 0x0001,
    LTTADAnisotropicDiffusionFlagsQuadraticFlux    = 0x0002
};

NS_ASSUME_NONNULL_BEGIN

@interface LTTADAnisotropicDiffusionCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger iterations;
@property (nonatomic, assign) NSInteger kappa;
@property (nonatomic, assign) NSInteger lambda;
@property (nonatomic, assign) LTTADAnisotropicDiffusionFlags flags;

- (instancetype)initWithIterations:(NSInteger)iterations lambda:(NSInteger)lambda kappa:(NSInteger)kappa flags:(LTTADAnisotropicDiffusionFlags)flags NS_DESIGNATED_INITIALIZER;

@end


@interface LTSRADAnisotropicDiffusionCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger iterations;
@property (nonatomic, assign) NSInteger lambda;
@property (nonatomic, assign) LeadRect rect;

- (instancetype)initWithIterations:(NSInteger)iterations lambda:(NSInteger)lambda rect:(LeadRect)rect NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END