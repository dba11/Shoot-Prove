//
//  LTLineProfileCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTLineProfileCommand : LTRasterCommand

@property (nonatomic, assign) LeadPoint firstPoint;
@property (nonatomic, assign) LeadPoint secondPoint;

@property (nonatomic, assign, readonly)           NSUInteger length;
@property (nonatomic, assign, readonly, nullable) int *redBuffer;
@property (nonatomic, assign, readonly, nullable) int *greenBuffer;
@property (nonatomic, assign, readonly, nullable) int *blueBuffer;

- (instancetype)initWithFirstPoint:(LeadPoint)firstPoint secondPoint:(LeadPoint)secondPoint NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END