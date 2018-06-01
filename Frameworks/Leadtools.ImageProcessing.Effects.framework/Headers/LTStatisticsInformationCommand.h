//
//  LTStatisticsInformationCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTStatisticsInformationCommand : LTRasterCommand

@property (nonatomic, assign)           LTRasterColorChannel channel;
@property (nonatomic, assign)           NSInteger start;
@property (nonatomic, assign)           NSInteger end;

@property (nonatomic, assign, readonly) NSInteger minimum;
@property (nonatomic, assign, readonly) NSInteger median;
@property (nonatomic, assign, readonly) NSInteger maximum;

@property (nonatomic, assign, readonly) unsigned long pixelCount;
@property (nonatomic, assign, readonly) unsigned long totalPixelCount;

@property (nonatomic, assign, readonly) double standardDeviation;
@property (nonatomic, assign, readonly) double mean;
@property (nonatomic, assign, readonly) double percent;

- (instancetype)initWithChannel:(LTRasterColorChannel)channel start:(NSInteger)start end:(NSInteger)end NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END