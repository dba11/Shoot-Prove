//
//  LTDynamicBinaryCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTDynamicBinaryCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger dimension;
@property (nonatomic, assign) NSUInteger localContrast;

- (instancetype)initWithDimension:(NSUInteger)dimension localContrast:(NSUInteger)localContrast NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END