//
//  LTColorHalftoneCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTColorHalftoneCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger maximumRadius;

@property (nonatomic, assign) NSInteger cyanAngle;
@property (nonatomic, assign) NSInteger magentaAngle;
@property (nonatomic, assign) NSInteger yellowAngle;
@property (nonatomic, assign) NSInteger blackAngle;

- (instancetype)initWithMaximumRadius:(NSUInteger)maximumRadius cyanAngle:(NSInteger)cyanAngle magentaAngle:(NSInteger)magentaAngle yellowAngle:(NSInteger)yellowAngle blackAngle:(NSInteger)blackAngle NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END