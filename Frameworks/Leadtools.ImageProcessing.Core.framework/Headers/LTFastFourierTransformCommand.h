//
//  LTFastFourierTransformCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTFourierTransformInformation.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTFastFourierTransformCommand : LTRasterCommand

@property (nonatomic, assign) LTFastFourierTransformCommandFlags flags;

@property (nonatomic, strong) LTFourierTransformInformation *fourierTransformInformation;

- (instancetype)initWithInformation:(LTFourierTransformInformation *)information flags:(LTFastFourierTransformCommandFlags)flags NS_DESIGNATED_INITIALIZER;
- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END