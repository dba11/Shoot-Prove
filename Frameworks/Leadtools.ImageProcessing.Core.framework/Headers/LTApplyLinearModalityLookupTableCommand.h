//
//  LTApplyLinearModalityLookupTableCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTApplyLinearModalityLookupTableCommand : LTRasterCommand

@property (nonatomic, assign) double intercept;
@property (nonatomic, assign) double slope;
@property (nonatomic, assign) LTModalityLookupTableCommandFlags flags;

- (instancetype)initWithIntercept:(double)intercept slope:(double)slope flags:(LTModalityLookupTableCommandFlags)flags NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END