//
//  LTOtsuThresholdCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTOtsuThresholdCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger clusters;

- (instancetype)initWithClusters:(NSInteger)clusters NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END