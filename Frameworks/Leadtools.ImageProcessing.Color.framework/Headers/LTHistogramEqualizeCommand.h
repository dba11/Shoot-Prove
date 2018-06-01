//
//  LTHistogramEqualizeCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTHistogramEqualizeCommand : LTRasterCommand

@property (nonatomic, assign) LTHistogramEqualizeType type;

- (instancetype)initWithType:(LTHistogramEqualizeType)type NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END